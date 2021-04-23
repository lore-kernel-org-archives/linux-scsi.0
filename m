Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1419C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3B061461
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbhDWLlK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:41:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:47476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242306AbhDWLks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CD94CB1FB;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 33/39] FlashPoint: Use standard SCSI definitions
Date:   Fri, 23 Apr 2021 13:39:38 +0200
Message-Id: <20210423113944.42672-34-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423113944.42672-1-hare@suse.de>
References: <20210423113944.42672-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No point in having the driver providing its own definitions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/FlashPoint.c | 165 ++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 96 deletions(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 0464e37c806a..ee9e4028c0f3 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -304,40 +304,12 @@ typedef struct SCCBscam_info {
 
 } SCCBSCAM_INFO;
 
-#define  SCSI_REQUEST_SENSE      0x03
-#define  SCSI_READ               0x08
-#define  SCSI_WRITE              0x0A
-#define  SCSI_START_STOP_UNIT    0x1B
-#define  SCSI_READ_EXTENDED      0x28
-#define  SCSI_WRITE_EXTENDED     0x2A
-#define  SCSI_WRITE_AND_VERIFY   0x2E
-
-#define  SSGOOD                  0x00
-#define  SSCHECK                 0x02
-#define  SSQ_FULL                0x28
-
-#define  SMCMD_COMP              0x00
-#define  SMEXT                   0x01
-#define  SMSAVE_DATA_PTR         0x02
-#define  SMREST_DATA_PTR         0x03
-#define  SMDISC                  0x04
-#define  SMABORT                 0x06
-#define  SMREJECT                0x07
-#define  SMNO_OP                 0x08
-#define  SMPARITY                0x09
-#define  SMDEV_RESET             0x0C
-#define	SMABORT_TAG					0x0D
-#define	SMINIT_RECOVERY			0x0F
-#define	SMREL_RECOVERY				0x10
 
 #define  SMIDENT                 0x80
 #define  DISC_PRIV               0x40
 
-#define  SMSYNC                  0x01
-#define  SMWDTR                  0x03
 #define  SM8BIT                  0x00
 #define  SM16BIT                 0x01
-#define  SMIGNORWR               0x23	/* Ignore Wide Residue */
 
 #define  SIX_BYTE_CMD            0x06
 #define  TWELVE_BYTE_CMD         0x0C
@@ -1660,7 +1632,7 @@ static int FlashPoint_AbortCCB(void *pCurrCard, struct sccb *p_Sccb)
 						p_Sccb->Sccb_scsistat =
 						    ABORT_ST;
 						p_Sccb->Sccb_scsimsg =
-						    SMABORT_TAG;
+						    ABORT_TASK;
 
 						if (((struct sccb_card *)
 						     pCurrCard)->currentSCCB ==
@@ -1812,7 +1784,7 @@ static int FlashPoint_HandleInterrupt(void *pcard)
 				FPT_phaseChkFifo(ioport, thisCard);
 
 			if (RD_HARPOON(ioport + hp_gp_reg_1) ==
-					SMSAVE_DATA_PTR) {
+					SAVE_POINTERS) {
 
 				WR_HARPOON(ioport + hp_gp_reg_1, 0x00);
 				currSCCB->Sccb_XferState |= F_NO_DATA_YET;
@@ -1865,7 +1837,7 @@ static int FlashPoint_HandleInterrupt(void *pcard)
 					FPT_phaseChkFifo(ioport, thisCard);
 
 				if (RD_HARPOON(ioport + hp_gp_reg_1) ==
-				    SMSAVE_DATA_PTR) {
+				    SAVE_POINTERS) {
 					WR_HARPOON(ioport + hp_gp_reg_1, 0x00);
 					currSCCB->Sccb_XferState |=
 					    F_NO_DATA_YET;
@@ -2258,7 +2230,7 @@ static unsigned char FPT_sfm(u32 port, struct sccb *pCurrSCCB)
 		WR_HARPOON(port + hp_fiforead, 0);
 		WR_HARPOON(port + hp_fifowrite, 0);
 		if (pCurrSCCB != NULL) {
-			pCurrSCCB->Sccb_scsimsg = SMPARITY;
+			pCurrSCCB->Sccb_scsimsg = MSG_PARITY_ERROR;
 		}
 		message = 0x00;
 		do {
@@ -2411,7 +2383,7 @@ static void FPT_ssel(u32 port, unsigned char p_card)
 
 		WRW_HARPOON((port + ID_MSG_STRT + 2), BRH_OP + ALWAYS + NP);
 
-		currSCCB->Sccb_scsimsg = SMDEV_RESET;
+		currSCCB->Sccb_scsimsg = TARGET_RESET;
 
 		WR_HARPOON(port + hp_autostart_3, (SELECT + SELCHK_STRT));
 		auto_loaded = 1;
@@ -2758,9 +2730,9 @@ static void FPT_sres(u32 port, unsigned char p_card,
 		if (message == 0) {
 			msgRetryCount++;
 			if (msgRetryCount == 1) {
-				FPT_SendMsg(port, SMPARITY);
+				FPT_SendMsg(port, MSG_PARITY_ERROR);
 			} else {
-				FPT_SendMsg(port, SMDEV_RESET);
+				FPT_SendMsg(port, TARGET_RESET);
 
 				FPT_sssyncv(port, our_target, NARROW_SCSI,
 					    currTar_Info);
@@ -2860,8 +2832,8 @@ static void FPT_SendMsg(u32 port, unsigned char message)
 
 		WR_HARPOON(port + hp_portctrl_0, 0x00);
 
-		if ((message == SMABORT) || (message == SMDEV_RESET) ||
-		    (message == SMABORT_TAG)) {
+		if ((message == ABORT_TASK_SET) || (message == TARGET_RESET) ||
+		    (message == ABORT_TASK)) {
 			while (!
 			       (RDW_HARPOON((port + hp_intstat)) &
 				(BUS_FREE | PHASE))) {
@@ -2893,7 +2865,7 @@ static void FPT_sdecm(unsigned char message, u32 port, unsigned char p_card)
 
 	currTar_Info = &FPT_sccbMgrTbl[p_card][currSCCB->TargID];
 
-	if (message == SMREST_DATA_PTR) {
+	if (message == RESTORE_POINTERS) {
 		if (!(currSCCB->Sccb_XferState & F_NO_DATA_YET)) {
 			currSCCB->Sccb_ATC = currSCCB->Sccb_savedATC;
 
@@ -2905,7 +2877,7 @@ static void FPT_sdecm(unsigned char message, u32 port, unsigned char p_card)
 			   (AUTO_IMMED + DISCONNECT_START));
 	}
 
-	else if (message == SMCMD_COMP) {
+	else if (message == COMMAND_COMPLETE) {
 
 		if (currSCCB->Sccb_scsistat == SELECT_Q_ST) {
 			currTar_Info->TarStatus &=
@@ -2917,15 +2889,16 @@ static void FPT_sdecm(unsigned char message, u32 port, unsigned char p_card)
 
 	}
 
-	else if ((message == SMNO_OP) || (message >= SMIDENT)
-		 || (message == SMINIT_RECOVERY) || (message == SMREL_RECOVERY)) {
+	else if ((message == NOP) || (message >= IDENTIFY_BASE) ||
+		 (message == INITIATE_RECOVERY) ||
+		 (message == RELEASE_RECOVERY)) {
 
 		ACCEPT_MSG(port);
 		WR_HARPOON(port + hp_autostart_1,
 			   (AUTO_IMMED + DISCONNECT_START));
 	}
 
-	else if (message == SMREJECT) {
+	else if (message == MESSAGE_REJECT) {
 
 		if ((currSCCB->Sccb_scsistat == SELECT_SN_ST) ||
 		    (currSCCB->Sccb_scsistat == SELECT_WN_ST) ||
@@ -3026,19 +2999,19 @@ static void FPT_sdecm(unsigned char message, u32 port, unsigned char p_card)
 		}
 	}
 
-	else if (message == SMEXT) {
+	else if (message == EXTENDED_MESSAGE) {
 
 		ACCEPT_MSG(port);
 		FPT_shandem(port, p_card, currSCCB);
 	}
 
-	else if (message == SMIGNORWR) {
+	else if (message == IGNORE_WIDE_RESIDUE) {
 
 		ACCEPT_MSG(port);	/* ACK the RESIDUE MSG */
 
 		message = FPT_sfm(port, currSCCB);
 
-		if (currSCCB->Sccb_scsimsg != SMPARITY)
+		if (currSCCB->Sccb_scsimsg != MSG_PARITY_ERROR)
 			ACCEPT_MSG(port);
 		WR_HARPOON(port + hp_autostart_1,
 			   (AUTO_IMMED + DISCONNECT_START));
@@ -3047,7 +3020,7 @@ static void FPT_sdecm(unsigned char message, u32 port, unsigned char p_card)
 	else {
 
 		currSCCB->HostStatus = SCCB_PHASE_SEQUENCE_FAIL;
-		currSCCB->Sccb_scsimsg = SMREJECT;
+		currSCCB->Sccb_scsimsg = MESSAGE_REJECT;
 
 		ACCEPT_MSG_ATN(port);
 		WR_HARPOON(port + hp_autostart_1,
@@ -3073,7 +3046,7 @@ static void FPT_shandem(u32 port, unsigned char p_card, struct sccb *pCurrSCCB)
 		message = FPT_sfm(port, pCurrSCCB);
 		if (message) {
 
-			if (message == SMSYNC) {
+			if (message == EXTENDED_SDTR) {
 
 				if (length == 0x03) {
 
@@ -3081,10 +3054,10 @@ static void FPT_shandem(u32 port, unsigned char p_card, struct sccb *pCurrSCCB)
 					FPT_stsyncn(port, p_card);
 				} else {
 
-					pCurrSCCB->Sccb_scsimsg = SMREJECT;
+					pCurrSCCB->Sccb_scsimsg = MESSAGE_REJECT;
 					ACCEPT_MSG_ATN(port);
 				}
-			} else if (message == SMWDTR) {
+			} else if (message == EXTENDED_WDTR) {
 
 				if (length == 0x02) {
 
@@ -3092,7 +3065,7 @@ static void FPT_shandem(u32 port, unsigned char p_card, struct sccb *pCurrSCCB)
 					FPT_stwidn(port, p_card);
 				} else {
 
-					pCurrSCCB->Sccb_scsimsg = SMREJECT;
+					pCurrSCCB->Sccb_scsimsg = MESSAGE_REJECT;
 					ACCEPT_MSG_ATN(port);
 
 					WR_HARPOON(port + hp_autostart_1,
@@ -3101,20 +3074,20 @@ static void FPT_shandem(u32 port, unsigned char p_card, struct sccb *pCurrSCCB)
 				}
 			} else {
 
-				pCurrSCCB->Sccb_scsimsg = SMREJECT;
+				pCurrSCCB->Sccb_scsimsg = MESSAGE_REJECT;
 				ACCEPT_MSG_ATN(port);
 
 				WR_HARPOON(port + hp_autostart_1,
 					   (AUTO_IMMED + DISCONNECT_START));
 			}
 		} else {
-			if (pCurrSCCB->Sccb_scsimsg != SMPARITY)
+			if (pCurrSCCB->Sccb_scsimsg != MSG_PARITY_ERROR)
 				ACCEPT_MSG(port);
 			WR_HARPOON(port + hp_autostart_1,
 				   (AUTO_IMMED + DISCONNECT_START));
 		}
 	} else {
-		if (pCurrSCCB->Sccb_scsimsg == SMPARITY)
+		if (pCurrSCCB->Sccb_scsimsg == MSG_PARITY_ERROR)
 			WR_HARPOON(port + hp_autostart_1,
 				   (AUTO_IMMED + DISCONNECT_START));
 	}
@@ -3148,10 +3121,10 @@ static unsigned char FPT_sisyncn(u32 port, unsigned char p_card,
 		WRW_HARPOON((port + ID_MSG_STRT + 2), BRH_OP + ALWAYS + CMDPZ);
 
 		WRW_HARPOON((port + SYNC_MSGS + 0),
-			    (MPM_OP + AMSG_OUT + SMEXT));
+			    (MPM_OP + AMSG_OUT + EXTENDED_MESSAGE));
 		WRW_HARPOON((port + SYNC_MSGS + 2), (MPM_OP + AMSG_OUT + 0x03));
 		WRW_HARPOON((port + SYNC_MSGS + 4),
-			    (MPM_OP + AMSG_OUT + SMSYNC));
+			    (MPM_OP + AMSG_OUT + EXTENDED_SDTR));
 
 		if ((currTar_Info->TarEEValue & EE_SYNC_MASK) == EE_SYNC_20MB)
 
@@ -3221,7 +3194,7 @@ static void FPT_stsyncn(u32 port, unsigned char p_card)
 
 	sync_msg = FPT_sfm(port, currSCCB);
 
-	if ((sync_msg == 0x00) && (currSCCB->Sccb_scsimsg == SMPARITY)) {
+	if ((sync_msg == 0x00) && (currSCCB->Sccb_scsimsg == MSG_PARITY_ERROR)) {
 		WR_HARPOON(port + hp_autostart_1,
 			   (AUTO_IMMED + DISCONNECT_START));
 		return;
@@ -3231,7 +3204,7 @@ static void FPT_stsyncn(u32 port, unsigned char p_card)
 
 	offset = FPT_sfm(port, currSCCB);
 
-	if ((offset == 0x00) && (currSCCB->Sccb_scsimsg == SMPARITY)) {
+	if ((offset == 0x00) && (currSCCB->Sccb_scsimsg == MSG_PARITY_ERROR)) {
 		WR_HARPOON(port + hp_autostart_1,
 			   (AUTO_IMMED + DISCONNECT_START));
 		return;
@@ -3343,9 +3316,11 @@ static void FPT_sisyncr(u32 port, unsigned char sync_pulse,
 			unsigned char offset)
 {
 	ARAM_ACCESS(port);
-	WRW_HARPOON((port + SYNC_MSGS + 0), (MPM_OP + AMSG_OUT + SMEXT));
+	WRW_HARPOON((port + SYNC_MSGS + 0),
+		    (MPM_OP + AMSG_OUT + EXTENDED_MESSAGE));
 	WRW_HARPOON((port + SYNC_MSGS + 2), (MPM_OP + AMSG_OUT + 0x03));
-	WRW_HARPOON((port + SYNC_MSGS + 4), (MPM_OP + AMSG_OUT + SMSYNC));
+	WRW_HARPOON((port + SYNC_MSGS + 4),
+		    (MPM_OP + AMSG_OUT + EXTENDED_SDTR));
 	WRW_HARPOON((port + SYNC_MSGS + 6), (MPM_OP + AMSG_OUT + sync_pulse));
 	WRW_HARPOON((port + SYNC_MSGS + 8), (RAT_OP));
 	WRW_HARPOON((port + SYNC_MSGS + 10), (MPM_OP + AMSG_OUT + offset));
@@ -3388,10 +3363,10 @@ static unsigned char FPT_siwidn(u32 port, unsigned char p_card)
 		WRW_HARPOON((port + ID_MSG_STRT + 2), BRH_OP + ALWAYS + CMDPZ);
 
 		WRW_HARPOON((port + SYNC_MSGS + 0),
-			    (MPM_OP + AMSG_OUT + SMEXT));
+			    (MPM_OP + AMSG_OUT + EXTENDED_MESSAGE));
 		WRW_HARPOON((port + SYNC_MSGS + 2), (MPM_OP + AMSG_OUT + 0x02));
 		WRW_HARPOON((port + SYNC_MSGS + 4),
-			    (MPM_OP + AMSG_OUT + SMWDTR));
+			    (MPM_OP + AMSG_OUT + EXTENDED_WDTR));
 		WRW_HARPOON((port + SYNC_MSGS + 6), (RAT_OP));
 		WRW_HARPOON((port + SYNC_MSGS + 8),
 			    (MPM_OP + AMSG_OUT + SM16BIT));
@@ -3436,7 +3411,7 @@ static void FPT_stwidn(u32 port, unsigned char p_card)
 
 	width = FPT_sfm(port, currSCCB);
 
-	if ((width == 0x00) && (currSCCB->Sccb_scsimsg == SMPARITY)) {
+	if ((width == 0x00) && (currSCCB->Sccb_scsimsg == MSG_PARITY_ERROR)) {
 		WR_HARPOON(port + hp_autostart_1,
 			   (AUTO_IMMED + DISCONNECT_START));
 		return;
@@ -3499,9 +3474,11 @@ static void FPT_stwidn(u32 port, unsigned char p_card)
 static void FPT_siwidr(u32 port, unsigned char width)
 {
 	ARAM_ACCESS(port);
-	WRW_HARPOON((port + SYNC_MSGS + 0), (MPM_OP + AMSG_OUT + SMEXT));
+	WRW_HARPOON((port + SYNC_MSGS + 0),
+		    (MPM_OP + AMSG_OUT + EXTENDED_MESSAGE));
 	WRW_HARPOON((port + SYNC_MSGS + 2), (MPM_OP + AMSG_OUT + 0x02));
-	WRW_HARPOON((port + SYNC_MSGS + 4), (MPM_OP + AMSG_OUT + SMWDTR));
+	WRW_HARPOON((port + SYNC_MSGS + 4),
+		    (MPM_OP + AMSG_OUT + EXTENDED_WDTR));
 	WRW_HARPOON((port + SYNC_MSGS + 6), (RAT_OP));
 	WRW_HARPOON((port + SYNC_MSGS + 8), (MPM_OP + AMSG_OUT + width));
 	WRW_HARPOON((port + SYNC_MSGS + 10), (BRH_OP + ALWAYS + NP));
@@ -3682,7 +3659,7 @@ static void FPT_ssenss(struct sccb_card *pCurrCard)
 	}
 
 	currSCCB->CdbLength = SIX_BYTE_CMD;
-	currSCCB->Cdb[0] = SCSI_REQUEST_SENSE;
+	currSCCB->Cdb[0] = REQUEST_SENSE;
 	currSCCB->Cdb[1] = currSCCB->Cdb[1] & (unsigned char)0xE0;	/*Keep LUN. */
 	currSCCB->Cdb[2] = 0x00;
 	currSCCB->Cdb[3] = 0x00;
@@ -3939,13 +3916,9 @@ static void FPT_sinits(struct sccb *p_sccb, unsigned char p_card)
 */
 	if ((currTar_Info->TarStatus & TAR_ALLOW_DISC) ||
 	    (currTar_Info->TarStatus & TAG_Q_TRYING)) {
-		p_sccb->Sccb_idmsg =
-		    (unsigned char)(SMIDENT | DISC_PRIV) | p_sccb->Lun;
-	}
-
-	else {
-
-		p_sccb->Sccb_idmsg = (unsigned char)SMIDENT | p_sccb->Lun;
+		p_sccb->Sccb_idmsg = IDENTIFY(true, p_sccb->Lun);
+	} else {
+		p_sccb->Sccb_idmsg = IDENTIFY(false, p_sccb->Lun);
 	}
 
 	p_sccb->HostStatus = 0x00;
@@ -3962,7 +3935,7 @@ static void FPT_sinits(struct sccb *p_sccb, unsigned char p_card)
  */
 	p_sccb->Sccb_scsistat = BUS_FREE_ST;
 	p_sccb->SccbStatus = SCCB_IN_PROCESS;
-	p_sccb->Sccb_scsimsg = SMNO_OP;
+	p_sccb->Sccb_scsimsg = NOP;
 
 }
 
@@ -4167,7 +4140,7 @@ static void FPT_phaseMsgOut(u32 port, unsigned char p_card)
 		message = currSCCB->Sccb_scsimsg;
 		scsiID = currSCCB->TargID;
 
-		if (message == SMDEV_RESET) {
+		if (message == TARGET_RESET) {
 
 			currTar_Info = &FPT_sccbMgrTbl[p_card][scsiID];
 			currTar_Info->TarSyncCtrl = 0;
@@ -4203,7 +4176,7 @@ static void FPT_phaseMsgOut(u32 port, unsigned char p_card)
 
 		else if (currSCCB->Sccb_scsistat < COMMAND_ST) {
 
-			if (message == SMNO_OP) {
+			if (message == NOP) {
 				currSCCB->Sccb_MGRFlags |= F_DEV_SELECTED;
 
 				FPT_ssel(port, p_card);
@@ -4211,13 +4184,13 @@ static void FPT_phaseMsgOut(u32 port, unsigned char p_card)
 			}
 		} else {
 
-			if (message == SMABORT)
+			if (message == ABORT_TASK_SET)
 
 				FPT_queueFlushSccb(p_card, SCCB_COMPLETE);
 		}
 
 	} else {
-		message = SMABORT;
+		message = ABORT_TASK_SET;
 	}
 
 	WRW_HARPOON((port + hp_intstat), (BUS_FREE | PHASE | XFER_CNT_0));
@@ -4232,8 +4205,8 @@ static void FPT_phaseMsgOut(u32 port, unsigned char p_card)
 
 	WR_HARPOON(port + hp_portctrl_0, 0x00);
 
-	if ((message == SMABORT) || (message == SMDEV_RESET) ||
-	    (message == SMABORT_TAG)) {
+	if ((message == ABORT_TASK_SET) || (message == TARGET_RESET) ||
+	    (message == ABORT_TASK)) {
 
 		while (!(RDW_HARPOON((port + hp_intstat)) & (BUS_FREE | PHASE))) {
 		}
@@ -4275,8 +4248,8 @@ static void FPT_phaseMsgOut(u32 port, unsigned char p_card)
 
 	else {
 
-		if (message == SMPARITY) {
-			currSCCB->Sccb_scsimsg = SMNO_OP;
+		if (message == MSG_PARITY_ERROR) {
+			currSCCB->Sccb_scsimsg = NOP;
 			WR_HARPOON(port + hp_autostart_1,
 				   (AUTO_IMMED + DISCONNECT_START));
 		} else {
@@ -4306,7 +4279,7 @@ static void FPT_phaseMsgIn(u32 port, unsigned char p_card)
 	}
 
 	message = RD_HARPOON(port + hp_scsidata_0);
-	if ((message == SMDISC) || (message == SMSAVE_DATA_PTR)) {
+	if ((message == DISCONNECT) || (message == SAVE_POINTERS)) {
 
 		WR_HARPOON(port + hp_autostart_1,
 			   (AUTO_IMMED + END_DATA_START));
@@ -4321,7 +4294,7 @@ static void FPT_phaseMsgIn(u32 port, unsigned char p_card)
 			FPT_sdecm(message, port, p_card);
 
 		} else {
-			if (currSCCB->Sccb_scsimsg != SMPARITY)
+			if (currSCCB->Sccb_scsimsg != MSG_PARITY_ERROR)
 				ACCEPT_MSG(port);
 			WR_HARPOON(port + hp_autostart_1,
 				   (AUTO_IMMED + DISCONNECT_START));
@@ -4351,7 +4324,7 @@ static void FPT_phaseIllegal(u32 port, unsigned char p_card)
 
 		currSCCB->HostStatus = SCCB_PHASE_SEQUENCE_FAIL;
 		currSCCB->Sccb_scsistat = ABORT_ST;
-		currSCCB->Sccb_scsimsg = SMABORT;
+		currSCCB->Sccb_scsimsg = ABORT_TASK_SET;
 	}
 
 	ACCEPT_MSG_ATN(port);
@@ -4650,9 +4623,9 @@ static void FPT_autoCmdCmplt(u32 p_port, unsigned char p_card)
 
 	FPT_sccbMgrTbl[p_card][currSCCB->TargID].TarLUN_CA = 0;
 
-	if (status_byte != SSGOOD) {
+	if (status_byte != SAM_STAT_GOOD) {
 
-		if (status_byte == SSQ_FULL) {
+		if (status_byte == SAM_STAT_TASK_SET_FULL) {
 
 			if (((FPT_BL_Card[p_card].globalFlags & F_CONLUN_IO) &&
 			     ((FPT_sccbMgrTbl[p_card][currSCCB->TargID].
@@ -4784,7 +4757,7 @@ static void FPT_autoCmdCmplt(u32 p_port, unsigned char p_card)
 
 		}
 
-		if (status_byte == SSCHECK) {
+		if (status_byte == SAM_STAT_CHECK_CONDITION) {
 			if (FPT_BL_Card[p_card].globalFlags & F_DO_RENEGO) {
 				if (FPT_sccbMgrTbl[p_card][currSCCB->TargID].
 				    TarEEValue & EE_SYNC_MASK) {
@@ -4806,7 +4779,7 @@ static void FPT_autoCmdCmplt(u32 p_port, unsigned char p_card)
 			currSCCB->SccbStatus = SCCB_ERROR;
 			currSCCB->TargetStatus = status_byte;
 
-			if (status_byte == SSCHECK) {
+			if (status_byte == SAM_STAT_CHECK_CONDITION) {
 
 				FPT_sccbMgrTbl[p_card][currSCCB->TargID].
 				    TarLUN_CA = 1;
@@ -6868,14 +6841,14 @@ static void FPT_queueCmdComplete(struct sccb_card *pCurrCard,
 		if ((p_sccb->
 		     ControlByte & (SCCB_DATA_XFER_OUT | SCCB_DATA_XFER_IN))
 		    && (p_sccb->HostStatus == SCCB_COMPLETE)
-		    && (p_sccb->TargetStatus != SSCHECK))
-
-			if ((SCSIcmd == SCSI_READ) ||
-			    (SCSIcmd == SCSI_WRITE) ||
-			    (SCSIcmd == SCSI_READ_EXTENDED) ||
-			    (SCSIcmd == SCSI_WRITE_EXTENDED) ||
-			    (SCSIcmd == SCSI_WRITE_AND_VERIFY) ||
-			    (SCSIcmd == SCSI_START_STOP_UNIT) ||
+		    && (p_sccb->TargetStatus != SAM_STAT_CHECK_CONDITION))
+
+			if ((SCSIcmd == READ_6) ||
+			    (SCSIcmd == WRITE_6) ||
+			    (SCSIcmd == READ_10) ||
+			    (SCSIcmd == WRITE_10) ||
+			    (SCSIcmd == WRITE_VERIFY) ||
+			    (SCSIcmd == START_STOP) ||
 			    (pCurrCard->globalFlags & F_NO_FILTER)
 			    )
 				p_sccb->HostStatus = SCCB_DATA_UNDER_RUN;
-- 
2.29.2

