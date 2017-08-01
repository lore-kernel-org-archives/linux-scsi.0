From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] st: fix blk_get_queue usage
Date: Tue,  1 Aug 2017 14:42:54 +0200
Message-ID: <1501591374-11229-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57272 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751008AbdHAMm6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Aug 2017 08:42:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>, Hannes Reinecke <hare@suse.com>

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

If blk_queue_get() in st_probe fails, disk->queue must not
be set to SDp->request_queue, as that would result in
put_disk() dropping a not taken reference.

Thus, disk->queue should be set only after a successful
blk_queue_get().

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1ea34d6..f1bcaf6 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4300,11 +4300,11 @@ static int st_probe(struct device *dev)
 	kref_init(&tpnt->kref);
 	tpnt->disk = disk;
 	disk->private_data = &tpnt->driver;
-	disk->queue = SDp->request_queue;
 	/* SCSI tape doesn't register this gendisk via add_disk().  Manually
 	 * take queue reference that release_disk() expects. */
-	if (!blk_get_queue(disk->queue))
+	if (!blk_get_queue(SDp->request_queue))
 		goto out_put_disk;
+	disk->queue = SDp->request_queue;
 	tpnt->driver = &st_template;
 
 	tpnt->device = SDp;
-- 
1.8.5.6
