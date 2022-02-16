Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0C6C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiBPVDJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiBPVDF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:05 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925EE20A364
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:52 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id u12so2933074plf.13
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTQFdYWzbePqO2QX4ieGC0QWMP0O+/4m+up6UMV8PjI=;
        b=yhpGWGdKkvdkbYYjFgFULgLZ8STpZuSSq7AlBCuoNd7QSeIUZzXBwUF1fHolxwVXT7
         4to+WrS4qa5rIKmU/pLUKyvFVEDv0fiFArod/seIkgtQWnCkNp+mlkYdMRAPY360efcD
         cQUbQKSmz1ynd73yMOC5xkXe1iolDx1Fc09lNm+slstdcj8f9hwz7bdP+q/b3RAfPo2b
         UxcbA44LplrViWhkPxMZWgAkDq5UN2gEqm6Kv9AYmHQG13Z3jceFWL2iScTnwsv79b5b
         dn6YoV3SzJH8v9XjabYxJx1lOLh9SiaSgLkGEj+2zGIi7o2oP2Nke85rf25XN+QIrOpc
         srTg==
X-Gm-Message-State: AOAM531C6ervyNffXaxbTejwnbtiCSVbmy9+B1vIpqp+ddRYgrfWNltD
        fa75Q3qSGrzvNUpISepO6+g=
X-Google-Smtp-Source: ABdhPJxIIkzCZs8lHS5OByUg8uD/I1f0/dqwCNG6kO2ic2tmLUfeyO717/JxZ2bqPaqurl69e53jUA==
X-Received: by 2002:a17:902:e944:b0:14e:dc4f:f099 with SMTP id b4-20020a170902e94400b0014edc4ff099mr4071688pll.161.1645045371898;
        Wed, 16 Feb 2022 13:02:51 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:02:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 05/50] scsi: nsp_cs: Use true and false instead of TRUE and FALSE
Date:   Wed, 16 Feb 2022 13:01:48 -0800
Message-Id: <20220216210233.28774-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
