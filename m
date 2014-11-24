From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] scsi: remove scsi_get_tag_type
Date: Mon, 24 Nov 2014 15:36:20 +0100
Message-ID: <1416839781-26988-4-git-send-email-hch@lst.de>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbaKXOge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 09:36:34 -0500
In-Reply-To: <1416839781-26988-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

Both remaining users are better of just checking sdev->simple_tags
directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/53c700.c   |  4 ++--
 drivers/scsi/ipr.c      |  2 +-
 include/scsi/scsi_tcq.h | 13 -------------
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index e722911..2c87a7a 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1816,8 +1816,8 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 		hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
 	}
 
-	if((hostdata->tag_negotiated &(1<<scmd_id(SCp)))
-	   && scsi_get_tag_type(SCp->device)) {
+	if ((hostdata->tag_negotiated & (1<<scmd_id(SCp))) &&
+	    SCp->device->simple_tags) {
 		slot->tag = SCp->request->tag;
 		CDEBUG(KERN_DEBUG, SCp, "sending out tag %d, slot %p\n",
 		       slot->tag, slot);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index c35ef5f..c91c7c5 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5755,7 +5755,7 @@ static void ipr_erp_cancel_all(struct ipr_cmnd *ipr_cmd)
 
 	ipr_reinit_ipr_cmnd_for_erp(ipr_cmd);
 
-	if (!scsi_get_tag_type(scsi_cmd->device)) {
+	if (!scsi_cmd->device->simple_tags) {
 		ipr_erp_request_sense(ipr_cmd);
 		return;
 	}
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index 59578be..681e010 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -15,19 +15,6 @@
 
 
 #ifdef CONFIG_BLOCK
-/**
- * scsi_get_tag_type - get the type of tag the device supports
- * @sdev:	the scsi device
- */
-static inline int scsi_get_tag_type(struct scsi_device *sdev)
-{
-	if (!sdev->tagged_supported)
-		return 0;
-	if (sdev->simple_tags)
-		return MSG_SIMPLE_TAG;
-	return 0;
-}
-
 static inline void scsi_set_tag_type(struct scsi_device *sdev, int tag)
 {
 	switch (tag) {
-- 
1.9.1

