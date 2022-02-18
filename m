Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA575C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbiBRTwH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238121AbiBRTvu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:51:50 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4CE237FC
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:33 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id 10so7987758plj.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTQFdYWzbePqO2QX4ieGC0QWMP0O+/4m+up6UMV8PjI=;
        b=ogW34cgYktPPEnEfKb1zv1TXbNCWsbiKpcd7bn8Ps64yIWzYbabE1dVH/X0ufJ6oms
         w98TBGCJzld0CUPla44TbRACrNZp5NTYO8DglS2EGhum9iJzBkOZaeAOVYLJk/t4b0hN
         UILR5vLXFUX3QBtgkedUzmt1FYEKJSIEoKt+imzUoZ/omLCl1OtKR5LVvv4n3/scf71+
         nVjxcmITcugmD0FfrmZ46dfFZE4lfxov0cHHxWczFH9FMtpZY2NHxivin5hrTmAdADjE
         wI1cBnLAvWuYsYLoqgGBPhbRoSJ7PkgpQinXEjkJNDAdllGeFXRi8Lq5Khe1aiAAxy3B
         H8XA==
X-Gm-Message-State: AOAM532WkflXWJ5DFdzyv9PjaZUMF3unL/L6x818xJ55Q8yktaa631AD
        OTjn0LTKwVXhTVb8Ab3ow+4=
X-Google-Smtp-Source: ABdhPJwYcYQEiXf3V6YLW4zBfdOIB9RMVMfQ201S69LhE9y1vX+UjOlpC7dDeDRiv4pFv/SB8fT28w==
X-Received: by 2002:a17:90a:aa83:b0:1b9:7c62:61e5 with SMTP id l3-20020a17090aaa8300b001b97c6261e5mr10007853pjq.118.1645213892361;
        Fri, 18 Feb 2022 11:51:32 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:51:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 05/49] scsi: nsp_cs: Use true and false instead of TRUE and FALSE
Date:   Fri, 18 Feb 2022 11:50:33 -0800
Message-Id: <20220218195117.25689-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for removal of the drivers/scsi/scsi.h header file. That
header file defines the 'TRUE' and 'FALSE' constants.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
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
