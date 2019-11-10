Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EB3C17443
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 03:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2129A2184C
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 03:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573354836;
	bh=+WbnZZtUjdrNhs68Xqup9ybIDK1452KLAHVBtvaDgSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=C/bFWoj/KKWWf1R4SmUrb2JdYMtOAbdGenb8zQEkE4LmsdItewZ0Rr0NMF9pYtldD
	 y3Kfgvr87t+CgPLHLFHMo+2LpHAdMARpbxpxDw/gNLTBp5TWdcvMa6LKaZD0ph00Uo
	 5Yis36sRy355bUZJ4L3eDbwtxQV0Gnz5eYMQdP/k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfKJDA2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 22:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729195AbfKJC4r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA2C4224ED;
        Sun, 10 Nov 2019 02:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354101;
        bh=+WbnZZtUjdrNhs68Xqup9ybIDK1452KLAHVBtvaDgSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EM2FSakTOiT+3aM33T26EYNPMLAscia0kaPHJy4Cp7aS8TAguhqPadLhwvFf2VdIp
         iR00XN7ahAXEc9pzRp55n7XCW/pDYOcmLGhUP/lWz/XiwFpRH3VcXCX4twh/5whbWS
         /Y6xAhZRJ33TS7DD193+tkaSpDEd9bjjlZEVChRA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 092/109] scsi: NCR5380: Have NCR5380_select() return a bool
Date:   Sat,  9 Nov 2019 21:45:24 -0500
Message-Id: <20191110024541.31567-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit dad8261e643849ea134c7cd5c8e794e31d93b9eb ]

The return value is taken to mean "retry" or "don't retry". Change it to bool
to improve readability. Fix related comments. No functional change.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 46 +++++++++++++++++++-----------------------
 drivers/scsi/NCR5380.h |  2 +-
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 9131d30b2da75..60e051c249a6f 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -904,20 +904,16 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-/*
- * Function : int NCR5380_select(struct Scsi_Host *instance,
- * struct scsi_cmnd *cmd)
- *
- * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
- * including ARBITRATION, SELECTION, and initial message out for
- * IDENTIFY and queue messages.
+/**
+ * NCR5380_select - attempt arbitration and selection for a given command
+ * @instance: the Scsi_Host instance
+ * @cmd: the scsi_cmnd to execute
  *
- * Inputs : instance - instantiation of the 5380 driver on which this
- * target lives, cmd - SCSI command to execute.
+ * This routine establishes an I_T_L nexus for a SCSI command. This involves
+ * ARBITRATION, SELECTION and MESSAGE OUT phases and an IDENTIFY message.
  *
- * Returns cmd if selection failed but should be retried,
- * NULL if selection failed and should not be retried, or
- * NULL if selection succeeded (hostdata->connected == cmd).
+ * Returns true if the operation should be retried.
+ * Returns false if it should not be retried.
  *
  * Side effects :
  * If bus busy, arbitration failed, etc, NCR5380_select() will exit
@@ -925,16 +921,15 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
  * SELECT_ENABLE will be set appropriately, the NCR5380
  * will cease to drive any SCSI bus signals.
  *
- * If successful : I_T_L or I_T_L_Q nexus will be established,
- * instance->connected will be set to cmd.
+ * If successful : the I_T_L nexus will be established, and
+ * hostdata->connected will be set to cmd.
  * SELECT interrupt will be disabled.
  *
  * If failed (no target) : cmd->scsi_done() will be called, and the
  * cmd->result host byte set to DID_BAD_TARGET.
  */
 
-static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
-                                        struct scsi_cmnd *cmd)
+static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	__releases(&hostdata->lock) __acquires(&hostdata->lock)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
@@ -942,6 +937,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	unsigned char *data;
 	int len;
 	int err;
+	bool ret = true;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
@@ -950,7 +946,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	/*
 	 * Arbitration and selection phases are slow and involve dropping the
 	 * lock, so we have to watch out for EH. An exception handler may
-	 * change 'selecting' to NULL. This function will then return NULL
+	 * change 'selecting' to NULL. This function will then return false
 	 * so that the caller will forget about 'cmd'. (During information
 	 * transfer phases, EH may change 'connected' to NULL.)
 	 */
@@ -986,7 +982,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	if (!hostdata->selecting) {
 		/* Command was aborted */
 		NCR5380_write(MODE_REG, MR_BASE);
-		return NULL;
+		return false;
 	}
 	if (err < 0) {
 		NCR5380_write(MODE_REG, MR_BASE);
@@ -1035,7 +1031,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	if (!hostdata->selecting) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		return NULL;
+		return false;
 	}
 
 	dsprintk(NDEBUG_ARBITRATION, instance, "won arbitration\n");
@@ -1118,13 +1114,13 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 
 		/* Can't touch cmd if it has been reclaimed by the scsi ML */
 		if (!hostdata->selecting)
-			return NULL;
+			return false;
 
 		cmd->result = DID_BAD_TARGET << 16;
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance,
 			"target did not respond within 250ms\n");
-		cmd = NULL;
+		ret = false;
 		goto out;
 	}
 
@@ -1156,7 +1152,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	}
 	if (!hostdata->selecting) {
 		do_abort(instance);
-		return NULL;
+		return false;
 	}
 
 	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",
@@ -1172,7 +1168,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 		cmd->result = DID_ERROR << 16;
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance, "IDENTIFY message transfer failed\n");
-		cmd = NULL;
+		ret = false;
 		goto out;
 	}
 
@@ -1187,13 +1183,13 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 
 	initialize_SCp(cmd);
 
-	cmd = NULL;
+	ret = false;
 
 out:
 	if (!hostdata->selecting)
 		return NULL;
 	hostdata->selecting = NULL;
-	return cmd;
+	return ret;
 }
 
 /*
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 8a6d002e67894..5935fd6d1a058 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -275,7 +275,7 @@ static irqreturn_t NCR5380_intr(int irq, void *dev_id);
 static void NCR5380_main(struct work_struct *work);
 static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
-static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
+static bool NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_poll_politely2(struct NCR5380_hostdata *,
-- 
2.20.1

