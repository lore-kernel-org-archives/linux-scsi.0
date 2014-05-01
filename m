From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] scsi_debug: simple short transfer injection
Date: Thu,  1 May 2014 16:51:51 +0200
Message-ID: <1398955911-20688-3-git-send-email-hch@lst.de>
References: <1398955911-20688-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40823 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaEAOth (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2014 10:49:37 -0400
In-Reply-To: <1398955911-20688-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

Add an option to only transfer half the data for every n-th command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f3e9cc0..1328a26 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -130,6 +130,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define SCSI_DEBUG_OPT_DIF_ERR   32
 #define SCSI_DEBUG_OPT_DIX_ERR   64
 #define SCSI_DEBUG_OPT_MAC_TIMEOUT  128
+#define SCSI_DEBUG_OPT_SHORT_TRANSFER	256
 /* When "every_nth" > 0 then modulo "every_nth" commands:
  *   - a no response is simulated if SCSI_DEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
@@ -3583,6 +3584,7 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 	int inj_transport = 0;
 	int inj_dif = 0;
 	int inj_dix = 0;
+	int inj_short = 0;
 	int delay_override = 0;
 	int unmap = 0;
 
@@ -3628,6 +3630,8 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 			inj_dif = 1; /* to reads and writes below */
 		else if (SCSI_DEBUG_OPT_DIX_ERR & scsi_debug_opts)
 			inj_dix = 1; /* to reads and writes below */
+		else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & scsi_debug_opts)
+			inj_short = 1;
 	}
 
 	if (devip->wlun) {
@@ -3744,6 +3748,10 @@ read:
 		if (scsi_debug_fake_rw)
 			break;
 		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
+
+		if (inj_short)
+			num /= 2;
+
 		errsts = resp_read(SCpnt, lba, num, devip, ei_lba);
 		if (inj_recovered && (0 == errsts)) {
 			mk_sense_buffer(devip, RECOVERED_ERROR,
-- 
1.7.10.4

