Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF72BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354094AbiBKWdP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354093AbiBKWdM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:12 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95084D4E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:10 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id t36so7833053pfg.0
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SdEmrnskR695c1/OXqy0w2r2p+hHyOK3mLcvyrnKBuw=;
        b=eNZ4v/A4xzMJJ1dPTwfskkCbCfSW5aRuWziNVgi4W20dELvwc+b1k/8j0jJqTZk7T+
         8Puu2Vzm5XsJJMxRayMyHgWQOmkXyTSss1b6OlCBXIl3WrqnUrbvc790zha/Oq8hOrcS
         L8LOLkegYJQTveBXI5DtJQ8tBegZuFjQq8L09FN4Cfr6GVuQFOI9DlkeltbIwWkQbAyF
         NwC9/PKJ5D3ucetvYu+phz0LGYQekTj+/H0tLwU641pTdCC7lKNm4tHyQbXs42bTuMXW
         E4Bopi5xxAzohL2aQAOLtZSjMu7XHN/4O5EiohvooD6O7USk4oduZuT3oTJIAuhGrr39
         SrjA==
X-Gm-Message-State: AOAM533yhIRncNwhbYpAhg0OlIZZwUtFj3ReOHKbcLtlM67zV8d/nnkn
        ncs1Tl/xgM/GHRt7S5ZzJMc=
X-Google-Smtp-Source: ABdhPJwBGgF0NLY9AdO3O5CeGlp6xL78ZBULTbNTBUJcKKSvPWa66QWeG6LQe1vZqM3YMy7nmcF9qA==
X-Received: by 2002:a05:6a00:170d:: with SMTP id h13mr3757627pfc.39.1644618789976;
        Fri, 11 Feb 2022 14:33:09 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 05/48] scsi: nsp_cs: Use true and false instead of TRUE and FALSE
Date:   Fri, 11 Feb 2022 14:32:04 -0800
Message-Id: <20220211223247.14369-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for removal of the drivers/scsi/scsi.h header file. That
header file defines the 'TRUE' and 'FALSE' constants.

Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/nsp_cs.c | 26 +++++++++++++-------------
 drivers/scsi/pcmcia/nsp_cs.h |  2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index a5c2dd7ebc16..a78a86511e94 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -243,7 +243,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt)
 		SCpnt->SCp.buffers_residual = 0;
 	}
 
-	if (nsphw_start_selection(SCpnt) == FALSE) {
+	if (!nsphw_start_selection(SCpnt)) {
 		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "selection fail");
 		SCpnt->result   = DID_BUS_BUSY << 16;
 		nsp_scsi_done(SCpnt);
@@ -263,14 +263,14 @@ static DEF_SCSI_QCMD(nsp_queuecommand)
 /*
  * setup PIO FIFO transfer mode and enable/disable to data out
  */
-static void nsp_setup_fifo(nsp_hw_data *data, int enabled)
+static void nsp_setup_fifo(nsp_hw_data *data, bool enabled)
 {
 	unsigned int  base = data->BaseAddress;
 	unsigned char transfer_mode_reg;
 
 	//nsp_dbg(NSP_DEBUG_DATA_IO, "enabled=%d", enabled);
 
-	if (enabled != FALSE) {
+	if (enabled) {
 		transfer_mode_reg = TRANSFER_GO | BRAIND;
 	} else {
 		transfer_mode_reg = 0;
@@ -348,13 +348,13 @@ static void nsphw_init(nsp_hw_data *data)
 					    SCSI_RESET_IRQ_EI	 );
 	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALLCLEAR);
 
-	nsp_setup_fifo(data, FALSE);
+	nsp_setup_fifo(data, false);
 }
 
 /*
  * Start selection phase
  */
-static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
+static bool nsphw_start_selection(struct scsi_cmnd *SCpnt)
 {
 	unsigned int  host_id	 = SCpnt->device->host->this_id;
 	unsigned int  base	 = SCpnt->device->host->io_port;
@@ -368,7 +368,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
 	phase = nsp_index_read(base, SCSIBUSMON);
 	if(phase != BUSMON_BUS_FREE) {
 		//nsp_dbg(NSP_DEBUG_RESELECTION, "bus busy");
-		return FALSE;
+		return false;
 	}
 
 	/* start arbitration */
@@ -388,7 +388,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
 	if (!(arbit & ARBIT_WIN)) {
 		//nsp_dbg(NSP_DEBUG_RESELECTION, "arbit fail");
 		nsp_index_write(base, SETARBIT, ARBIT_FLAG_CLEAR);
-		return FALSE;
+		return false;
 	}
 
 	/* assert select line */
@@ -407,7 +407,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
 	nsp_start_timer(SCpnt, 1000/51);
 	data->SelectionTimeOut = 1;
 
-	return TRUE;
+	return true;
 }
 
 struct nsp_sync_table {
@@ -477,7 +477,7 @@ static int nsp_analyze_sdtr(struct scsi_cmnd *SCpnt)
 		sync->SyncRegister    = 0;
 		sync->AckWidth	      = 0;
 
-		return FALSE;
+		return false;
 	}
 
 	sync->SyncRegister    = (sync_table->chip_period << SYNCREG_PERIOD_SHIFT) |
@@ -486,7 +486,7 @@ static int nsp_analyze_sdtr(struct scsi_cmnd *SCpnt)
 
 	nsp_dbg(NSP_DEBUG_SYNC, "sync_reg=0x%x, ack_width=0x%x", sync->SyncRegister, sync->AckWidth);
 
-	return TRUE;
+	return true;
 }
 
 
@@ -633,7 +633,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
 	nsp_dbg(NSP_DEBUG_DATA_IO, "use bypass quirk");
 	SCpnt->SCp.phase = PH_DATA;
 	nsp_pio_read(SCpnt);
-	nsp_setup_fifo(data, FALSE);
+	nsp_setup_fifo(data, false);
 
 	return 0;
 }
@@ -927,7 +927,7 @@ static int nsp_nexus(struct scsi_cmnd *SCpnt)
 	}
 
 	/* setup pdma fifo */
-	nsp_setup_fifo(data, TRUE);
+	nsp_setup_fifo(data, true);
 
 	/* clear ack counter */
  	data->FifoCount = 0;
@@ -1210,7 +1210,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		//*sync_neg = SYNC_NOT_YET;
 
 		data->MsgLen = i = 0;
-		data->MsgBuffer[i] = IDENTIFY(TRUE, lun); i++;
+		data->MsgBuffer[i] = IDENTIFY(true, lun); i++;
 
 		if (*sync_neg == SYNC_NOT_YET) {
 			data->Sync[target].SyncPeriod = 0;
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 94c1f6c7c601..7d5d1a5b36e0 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -305,7 +305,7 @@ static int nsp_bus_reset       (nsp_hw_data *data);
 
 /* */
 static void nsphw_init           (nsp_hw_data *data);
-static int  nsphw_start_selection(struct scsi_cmnd *SCpnt);
+static bool nsphw_start_selection(struct scsi_cmnd *SCpnt);
 static void nsp_start_timer      (struct scsi_cmnd *SCpnt, int time);
 static int  nsp_fifo_count       (struct scsi_cmnd *SCpnt);
 static void nsp_pio_read         (struct scsi_cmnd *SCpnt);
