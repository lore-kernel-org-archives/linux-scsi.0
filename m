From: ching <ching2048@areca.com.tw>
Subject: [PATCH v1.2 5/16] arcmsr: bugfix of abort command return status
Date: Wed, 14 May 2014 19:18:45 +0800
Message-ID: <1400066325.6957.31.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61301 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaENLSw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2014 07:18:52 -0400
Received: by mail-vc0-f179.google.com with SMTP id im17so2221781vcb.10
        for <linux-scsi@vger.kernel.org>; Wed, 14 May 2014 04:18:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

From: Ching<ching2048@areca.com.tw>

Fix a bug of return status from calling arcmsr_polling_ccbdone.
The original code may return a FAILED if abort command is SUCCESS.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:43:40.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:44:40.000000000 +0800
@@ -2482,7 +2482,7 @@ static int arcmsr_polling_hba_ccbdone(st
 		}
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
 		ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-		poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+		poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
 		if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
 			if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
 				printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
@@ -2546,7 +2546,7 @@ static int arcmsr_polling_hbb_ccbdone(st
 		/* check if command done with no error*/
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
 		ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-		poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+		poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
 		if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
 			if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
 				printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
@@ -2602,7 +2602,7 @@ polling_hbc_ccb_retry:
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);/*frame must be 32 bytes aligned*/
 		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-		poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
+		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
 		/* check ifcommand done with no error*/
 		if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
 			if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
@@ -3204,6 +3204,8 @@ static int arcmsr_abort(struct scsi_cmnd
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;
 	int i = 0;
 	int rtn = FAILED;
+	uint32_t intmask_org;
+
 	printk(KERN_NOTICE
 		"arcmsr%d: abort device command of scsi id = %d lun = %d \n",
 		acb->host->host_no, cmd->device->id, cmd->device->lun);
@@ -3215,9 +3217,12 @@ static int arcmsr_abort(struct scsi_cmnd
 	** we need to handle it as soon as possible and exit
 	************************************************
 	*/
-	if (!atomic_read(&acb->ccboutstandingcount))
+	if (!atomic_read(&acb->ccboutstandingcount)) {
+		acb->acb_flags &= ~ACB_F_ABORT;
 		return rtn;
+	}
 
+	intmask_org = arcmsr_disable_outbound_ints(acb);
 	for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
 		struct CommandControlBlock *ccb = acb->pccb_pool[i];
 		if (ccb->startdone == ARCMSR_CCB_START && ccb->pcmd == cmd) {
@@ -3227,6 +3232,7 @@ static int arcmsr_abort(struct scsi_cmnd
 		}
 	}
 	acb->acb_flags &= ~ACB_F_ABORT;
+	arcmsr_enable_outbound_ints(acb, intmask_org);
 	return rtn;
 }
 


