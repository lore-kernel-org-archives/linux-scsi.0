From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: [PATCH v2] st: Take additional queue ref in st_probe
Date: Tue, 5 Mar 2013 10:57:56 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1303051053040.1736@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com> <5135E780.6040303@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-507730767-1362499076=:1736"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:35184 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab3CEQCD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Mar 2013 11:02:03 -0500
In-Reply-To: <5135E780.6040303@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jan Vesely <jvesely@redhat.com>, "Seymour, Shane M" <shane.seymour@hp.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, =?ISO-8859-15?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>, "Ewan D. Milne" <emilne@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-507730767-1362499076=:1736
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Changes from v1:
  Corrected error paths as noted by Ewan Milne and Jan Vesely.

These changes were applied to scsi.git, branch "misc".  This patch
fixes a reference count bug in the SCSI tape driver which can be
reproduced with the following:

* Boot with slub_debug=FZPU, tape drive attached
* echo 1 > /sys/devices/... tape device pci path .../remove
* Wait for device removal
* echo 1 > /sys/kernel/slab/blkdev_queue/validate
* Slub debug complains about corrupted poison pattern

In commit 523e1d39 (block: make gendisk hold a reference to its queue) 
add_disk() and disk_release() were modified to get/put an additional
reference on a disk queue to fix a reference counting discrepency
between bdev release and SCSI device removal.  The ST driver never
calls add_disk(), so this commit introduced an extra kref put when the
ST driver frees its struct gendisk.

Attempts were made to fix this bug at the block level [1] but later
abandoned due to floppy driver issues [2].

[1] https://lkml.org/lkml/2012/8/27/354
[2] https://lkml.org/lkml/2012/9/22/113

>From a50a6ee28748b7c1620af6f76772164ec0fc4a1d Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Tue, 5 Mar 2013 09:30:14 -0500
Subject: [PATCH v2] st: Take additional queue ref in st_probe
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SCSI tape driver employs a struct gendisk, calling alloc_disk() to
create an instance, but does not register it via add_disk().  When the
gendisk is torn down, disk_release() is called and expects to return a
disk queue reference that add_disk() normally would have taken out. (See
commit 523e1d39.)  Fix the kref accounting by adding a blk_get_queue()
to st_probe().

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Tested-by: Ewan D. Milne <emilne@redhat.com> 
Cc: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: Jan Vesely <jvesely@redhat.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/st.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 98156a9..96f3363 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4112,6 +4112,10 @@ static int st_probe(struct device *dev)
 	tpnt->disk = disk;
 	disk->private_data = &tpnt->driver;
 	disk->queue = SDp->request_queue;
+	/* SCSI tape doesn't register this gendisk via add_disk().  Manually
+	 * take queue reference that release_disk() expects. */
+	if (!blk_get_queue(disk->queue))
+		goto out_put_disk;
 	tpnt->driver = &st_template;
 
 	tpnt->device = SDp;
@@ -4181,7 +4185,7 @@ static int st_probe(struct device *dev)
 	if (!idr_pre_get(&st_index_idr, GFP_KERNEL)) {
 		pr_warn("st: idr expansion failed\n");
 		error = -ENOMEM;
-		goto out_put_disk;
+		goto out_put_queue;
 	}
 
 	spin_lock(&st_index_lock);
@@ -4189,7 +4193,7 @@ static int st_probe(struct device *dev)
 	spin_unlock(&st_index_lock);
 	if (error) {
 		pr_warn("st: idr allocation failed: %d\n", error);
-		goto out_put_disk;
+		goto out_put_queue;
 	}
 
 	if (dev_num > ST_MAX_TAPES) {
@@ -4222,6 +4226,8 @@ out_put_index:
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, dev_num);
 	spin_unlock(&st_index_lock);
+out_put_queue:
+	blk_put_queue(disk->queue);
 out_put_disk:
 	put_disk(disk);
 	kfree(tpnt);
-- 
1.8.1.2

--8323329-507730767-1362499076=:1736--
