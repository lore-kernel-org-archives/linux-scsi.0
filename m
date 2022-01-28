Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734B2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343672AbiA1WUi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:20:38 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:42850 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241593AbiA1WUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:20:36 -0500
Received: by mail-pg1-f173.google.com with SMTP id g2so6442949pgo.9
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:20:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SrJfzF0qehrzWiWL0we8YDsm2B6jgZS/wuTn/w2Nv4o=;
        b=iXvQFZ6YCeSyQxdkLdP6aWwJOwCcOYCjXNiuWtUtAtrbNleyd73CLwEk/NXk4cwfMX
         MZRV/B1gGcVkci3GNkXOBTr8wM3DjO+qrAqR4GSKUBAKNlD0CS9CQT0sjctcc1HkVQFU
         +odPy7K8SJScFOPIM7wiJCywLociE3tAPIv4G/oOG+YhnvL7WCSI0AdXPsdZqnYhK91e
         S8hQLZb3oWTuS5bsGSSWDY5vpM+F4C3/aEvw3bIE5rke7wirRCXtWzoG2oXZHZHxXaqB
         tmFoXYjFN3mkRrvAv9yH0cjgmv46mDX2ufd41G6dcH7TTHS3iX2/AyZYdiR4g29RvViE
         iu2g==
X-Gm-Message-State: AOAM531j9VkigrFIt5l7TdRgIvjE12X5lcpe5aO+S8ppswIS/rtfgIOK
        FLxZlhN/z85VQhGnZ/WVB+hKHGk3YjWe/w==
X-Google-Smtp-Source: ABdhPJwoPGZLAP6goUkDbEaT0/m/4UDRKeLl6y/ymTpVTqiL4NBZmfvXAA83gvfErI6PXjpmd9Znvg==
X-Received: by 2002:a63:924c:: with SMTP id s12mr8177032pgn.257.1643408435628;
        Fri, 28 Jan 2022 14:20:35 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:20:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 02/44] nsp_cs: Use true and false instead of TRUE and FALSE
Date:   Fri, 28 Jan 2022 14:18:27 -0800
Message-Id: <20220128221909.8141-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Additionally, change the return type of the functions that always return
TRUE from 'int' into 'void'. This patch prepares for removal of the
drivers/scsi/scsi.h header file. That header file defines the 'TRUE' and
'FALSE' constants.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/nsp_cs.c | 43 +++++++++++++++---------------------
 drivers/scsi/pcmcia/nsp_cs.h |  6 ++---
 2 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 92c818a8a84a..a78a86511e94 100644
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
@@ -298,7 +298,7 @@ static void nsphw_init_sync(nsp_hw_data *data)
 /*
  * Initialize Ninja hardware
  */
-static int nsphw_init(nsp_hw_data *data)
+static void nsphw_init(nsp_hw_data *data)
 {
 	unsigned int base     = data->BaseAddress;
 
@@ -348,15 +348,13 @@ static int nsphw_init(nsp_hw_data *data)
 					    SCSI_RESET_IRQ_EI	 );
 	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALLCLEAR);
 
-	nsp_setup_fifo(data, FALSE);
-
-	return TRUE;
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
@@ -370,7 +368,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
 	phase = nsp_index_read(base, SCSIBUSMON);
 	if(phase != BUSMON_BUS_FREE) {
 		//nsp_dbg(NSP_DEBUG_RESELECTION, "bus busy");
-		return FALSE;
+		return false;
 	}
 
 	/* start arbitration */
@@ -390,7 +388,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
 	if (!(arbit & ARBIT_WIN)) {
 		//nsp_dbg(NSP_DEBUG_RESELECTION, "arbit fail");
 		nsp_index_write(base, SETARBIT, ARBIT_FLAG_CLEAR);
-		return FALSE;
+		return false;
 	}
 
 	/* assert select line */
@@ -409,7 +407,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
 	nsp_start_timer(SCpnt, 1000/51);
 	data->SelectionTimeOut = 1;
 
-	return TRUE;
+	return true;
 }
 
 struct nsp_sync_table {
@@ -479,7 +477,7 @@ static int nsp_analyze_sdtr(struct scsi_cmnd *SCpnt)
 		sync->SyncRegister    = 0;
 		sync->AckWidth	      = 0;
 
-		return FALSE;
+		return false;
 	}
 
 	sync->SyncRegister    = (sync_table->chip_period << SYNCREG_PERIOD_SHIFT) |
@@ -488,7 +486,7 @@ static int nsp_analyze_sdtr(struct scsi_cmnd *SCpnt)
 
 	nsp_dbg(NSP_DEBUG_SYNC, "sync_reg=0x%x, ack_width=0x%x", sync->SyncRegister, sync->AckWidth);
 
-	return TRUE;
+	return true;
 }
 
 
@@ -635,7 +633,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
 	nsp_dbg(NSP_DEBUG_DATA_IO, "use bypass quirk");
 	SCpnt->SCp.phase = PH_DATA;
 	nsp_pio_read(SCpnt);
-	nsp_setup_fifo(data, FALSE);
+	nsp_setup_fifo(data, false);
 
 	return 0;
 }
@@ -643,7 +641,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
 /*
  * accept reselection
  */
-static int nsp_reselected(struct scsi_cmnd *SCpnt)
+static void nsp_reselected(struct scsi_cmnd *SCpnt)
 {
 	unsigned int  base    = SCpnt->device->host->io_port;
 	unsigned int  host_id = SCpnt->device->host->this_id;
@@ -675,8 +673,6 @@ static int nsp_reselected(struct scsi_cmnd *SCpnt)
 	bus_reg = nsp_index_read(base, SCSIBUSCTRL) & ~(SCSI_BSY | SCSI_ATN);
 	nsp_index_write(base, SCSIBUSCTRL, bus_reg);
 	nsp_index_write(base, SCSIBUSCTRL, bus_reg | AUTODIRECTION | ACKENB);
-
-	return TRUE;
 }
 
 /*
@@ -931,7 +927,7 @@ static int nsp_nexus(struct scsi_cmnd *SCpnt)
 	}
 
 	/* setup pdma fifo */
-	nsp_setup_fifo(data, TRUE);
+	nsp_setup_fifo(data, true);
 
 	/* clear ack counter */
  	data->FifoCount = 0;
@@ -1057,9 +1053,8 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		if (irq_phase & RESELECT_IRQ) {
 			nsp_dbg(NSP_DEBUG_INTR, "reselect");
 			nsp_write(base, IRQCONTROL, IRQCONTROL_RESELECT_CLEAR);
-			if (nsp_reselected(tmpSC) != FALSE) {
-				return IRQ_HANDLED;
-			}
+			nsp_reselected(tmpSC);
+			return IRQ_HANDLED;
 		}
 
 		if ((irq_phase & (PHASE_CHANGE_IRQ | LATCHED_BUS_FREE)) == 0) {
@@ -1215,7 +1210,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		//*sync_neg = SYNC_NOT_YET;
 
 		data->MsgLen = i = 0;
-		data->MsgBuffer[i] = IDENTIFY(TRUE, lun); i++;
+		data->MsgBuffer[i] = IDENTIFY(true, lun); i++;
 
 		if (*sync_neg == SYNC_NOT_YET) {
 			data->Sync[target].SyncPeriod = 0;
@@ -1614,9 +1609,7 @@ static int nsp_cs_config(struct pcmcia_device *link)
 	nsp_dbg(NSP_DEBUG_INIT, "I/O[0x%x+0x%x] IRQ %d",
 		data->BaseAddress, data->NumAddress, data->IrqNumber);
 
-	if(nsphw_init(data) == FALSE) {
-		goto cs_failed;
-	}
+	nsphw_init(data);
 
 	host = nsp_detect(&nsp_driver_template);
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 665bf8d0faf7..7d5d1a5b36e0 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -304,8 +304,8 @@ static int nsp_eh_host_reset   (struct scsi_cmnd *SCpnt);
 static int nsp_bus_reset       (nsp_hw_data *data);
 
 /* */
-static int  nsphw_init           (nsp_hw_data *data);
-static int  nsphw_start_selection(struct scsi_cmnd *SCpnt);
+static void nsphw_init           (nsp_hw_data *data);
+static bool nsphw_start_selection(struct scsi_cmnd *SCpnt);
 static void nsp_start_timer      (struct scsi_cmnd *SCpnt, int time);
 static int  nsp_fifo_count       (struct scsi_cmnd *SCpnt);
 static void nsp_pio_read         (struct scsi_cmnd *SCpnt);
@@ -320,7 +320,7 @@ static int  nsp_expect_signal    (struct scsi_cmnd *SCpnt,
 				  unsigned char  mask);
 static int  nsp_xfer             (struct scsi_cmnd *SCpnt, int phase);
 static int  nsp_dataphase_bypass (struct scsi_cmnd *SCpnt);
-static int  nsp_reselected       (struct scsi_cmnd *SCpnt);
+static void nsp_reselected       (struct scsi_cmnd *SCpnt);
 static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
 
 /* Interrupt handler */
