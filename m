From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] scsi: remove scsi_set_tag_type
Date: Mon, 24 Nov 2014 15:36:21 +0100
Message-ID: <1416839781-26988-5-git-send-email-hch@lst.de>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbaKXOgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 09:36:35 -0500
In-Reply-To: <1416839781-26988-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

There is no benefit over just setting sdev->simple_tags directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/53c700.c   |  2 +-
 drivers/scsi/tmscsim.c  |  2 +-
 include/scsi/scsi_tcq.h | 15 ---------------
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 2c87a7a..82abfce 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -902,8 +902,8 @@ process_message(struct Scsi_Host *host,	struct NCR_700_Host_Parameters *hostdata
 			hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
 
 			SCp->device->tagged_supported = 0;
+			SCp->device->simple_tags = 0;
 			scsi_change_queue_depth(SCp->device, host->cmd_per_lun);
-			scsi_set_tag_type(SCp->device, 0);
 		} else {
 			shost_printk(KERN_WARNING, host,
 				"(%d:%d) Unexpected REJECT Message %s\n",
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 6c3c2ce..14ccc9a 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2190,7 +2190,7 @@ static int dc390_slave_configure(struct scsi_device *sdev)
 	 * XXX: Note that while this driver used to called scsi_activate_tcq,
 	 * it never actually set a tag type, so emulate the old behavior.
 	 */
-	scsi_set_tag_type(sdev, 0);
+	sdev->simple_tags = 0;
 
 	if (sdev->tagged_supported && (dcb->DevMode & TAG_QUEUEING_)) {
 		dcb->SyncMode |= EN_TAG_QUEUEING;
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index 681e010..e624aca 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -15,21 +15,6 @@
 
 
 #ifdef CONFIG_BLOCK
-static inline void scsi_set_tag_type(struct scsi_device *sdev, int tag)
-{
-	switch (tag) {
-	case MSG_ORDERED_TAG:
-	case MSG_SIMPLE_TAG:
-		sdev->simple_tags = 1;
-		break;
-	case 0:
-		/* fall through */
-	default:
-		sdev->simple_tags = 0;
-		break;
-	}
-}
-
 static inline struct scsi_cmnd *scsi_mq_find_tag(struct Scsi_Host *shost,
 						 int unique_tag)
 {
-- 
1.9.1

