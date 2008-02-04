From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 5/24][RFC] dpt_i2o: Use new scsi_eh_cpy_sense()
Date: Mon,  4 Feb 2008 17:58:42 +0200
Message-ID: <1202140722-4650-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:60408 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbYBDQED (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:04:03 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Abstract away scsi_cmnd->sense_buffer for later removal.

  - Removed a filtering out of a REQUEST_SENSE at .queuecommand
    In the case of sense beeing clean. This is no longer relevant
    since scsi-ml will always send a zero out sense buffer even
    on a resend, so this means outside REQUEST_SENSE would never
    go through. If this is intended then comment and check should
    change.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/dpt_i2o.c |   25 +++++++------------------
 1 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index c9dd839..6ee6fcd 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -71,6 +71,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Driver");
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_eh.h>
 
 #include "dpt/dptsig.h"
 #include "dpti.h"
@@ -385,18 +386,6 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 	struct adpt_device* pDev = NULL;	/* dpt per device information */
 
 	cmd->scsi_done = done;
-	/*
-	 * SCSI REQUEST_SENSE commands will be executed automatically by the 
-	 * Host Adapter for any errors, so they should not be executed 
-	 * explicitly unless the Sense Data is zero indicating that no error 
-	 * occurred.
-	 */
-
-	if ((cmd->cmnd[0] == REQUEST_SENSE) && (cmd->sense_buffer[0] != 0)) {
-		cmd->result = (DID_OK << 16);
-		cmd->scsi_done(cmd);
-		return 0;
-	}
 
 	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
 	if (!pHba) {
@@ -2226,8 +2215,6 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 
 	pHba = (adpt_hba*) cmd->device->host->hostdata[0];
 
-	cmd->sense_buffer[0] = '\0';  // initialize sense valid flag to false
-
 	if(!(reply_flags & MSG_FAIL)) {
 		switch(detailed_status & I2O_SCSI_DSC_MASK) {
 		case I2O_SCSI_DSC_SUCCESS:
@@ -2297,11 +2284,13 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 		// copy over the request sense data if it was a check
 		// condition status
 		if (dev_status == SAM_STAT_CHECK_CONDITION) {
-			u32 len = min(SCSI_SENSE_BUFFERSIZE, 40);
+			u8 sense_buffer[40];
+			u32 len = sizeof(sense_buffer);
 			// Copy over the sense data
-			memcpy_fromio(cmd->sense_buffer, (reply+28) , len);
-			if(cmd->sense_buffer[0] == 0x70 /* class 7 */ && 
-			   cmd->sense_buffer[2] == DATA_PROTECT ){
+			memcpy_fromio(sense_buffer, (reply+28) , len);
+			scsi_eh_cpy_sense(cmd, sense_buffer, len);
+			if (sense_buffer[0] == 0x70 /* class 7 */ &&
+			   sense_buffer[2] == DATA_PROTECT){
 				/* This is to handle an array failed */
 				cmd->result = (DID_TIME_OUT << 16);
 				printk(KERN_WARNING"%s: SCSI Data Protect-Device (%d,%d,%d) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
-- 
1.5.3.3

