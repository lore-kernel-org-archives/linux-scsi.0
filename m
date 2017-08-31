From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Remove Scsi_Host.uspace_req_q
Date: Thu, 31 Aug 2017 16:59:06 -0700
Message-ID: <20170831235906.19451-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:5411 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdHaX76 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 19:59:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>

A patch I wrote myself several years ago removed SCSI target
support from the code under drivers/scsi. That patch removed the
code that sets uspace_req_q to a non-NULL value. Hence also
remove the code that depends on uspace_req_q != NULL.

References: commit 066465251303 ("tgt: removal")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/hosts.c     | 8 --------
 include/scsi/scsi_host.h | 6 ------
 2 files changed, 14 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 831a1c8b9f89..fe3a0da3ec97 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -315,8 +315,6 @@ static void scsi_host_dev_release(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
-	struct request_queue *q;
-	void *queuedata;
 
 	scsi_proc_hostdir_rm(shost->hostt);
 
@@ -326,12 +324,6 @@ static void scsi_host_dev_release(struct device *dev)
 		kthread_stop(shost->ehandler);
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
-	q = shost->uspace_req_q;
-	if (q) {
-		queuedata = q->queuedata;
-		blk_cleanup_queue(q);
-		kfree(queuedata);
-	}
 
 	if (shost->shost_state == SHOST_CREATED) {
 		/*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index afb04811b7b9..0a804b1a4726 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -691,12 +691,6 @@ struct Scsi_Host {
 	unsigned int prot_capabilities;
 	unsigned char prot_guard_type;
 
-	/*
-	 * q used for scsi_tgt msgs, async events or any other requests that
-	 * need to be processed in userspace
-	 */
-	struct request_queue *uspace_req_q;
-
 	/* legacy crap */
 	unsigned long base;
 	unsigned long io_port;
-- 
2.14.1
