From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] sd: revive sd_index_lock
Date: Sat, 21 Feb 2009 11:04:45 +0900
Message-ID: <499F613D.7030603@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:48051 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbZBUCEd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 21:04:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, stable@kernel.org

Commit f27bac2761cab5a2e212dea602d22457a9aa6943 which converted sd to
use ida instead of idr incorrectly removed sd_index_lock around id
allocation and free.  idr/ida do have internal locks but they protect
their free object lists not the allocation itself.  The caller is
responsible for that.  This missing synchronization led to the same id
being assigned to multiple devices leading to oops.

Revive sd_index_lock.

Reported and tracked down by Stuart Hayes of Dell.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <jbottomley@novell.com>
---
 drivers/scsi/sd.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d57566b..55310db 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -107,6 +107,7 @@ static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
+static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
@@ -1914,7 +1915,9 @@ static int sd_probe(struct device *dev)
 		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
 			goto out_put;
 
+		spin_lock(&sd_index_lock);
 		error = ida_get_new(&sd_index_ida, &index);
+		spin_unlock(&sd_index_lock);
 	} while (error == -EAGAIN);
 
 	if (error)
@@ -1936,7 +1939,9 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
+	spin_lock(&sd_index_lock);
 	ida_remove(&sd_index_ida, index);
+	spin_unlock(&sd_index_lock);
  out_put:
 	put_disk(gd);
  out_free:
@@ -1986,7 +1991,9 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
+	spin_lock(&sd_index_lock);
 	ida_remove(&sd_index_ida, sdkp->index);
+	spin_unlock(&sd_index_lock);
 
 	disk->private_data = NULL;
 	put_disk(disk);
