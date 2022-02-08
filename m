Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54ACC4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383760AbiBHR1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384344AbiBHR0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:52 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5326EC0612C3
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:44 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id m7so16955590pjk.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=15bsG8fLI3TDryDWsMJFSCxbCC/K4eHMHIODSoMni90=;
        b=hQu264BuCpbNIH0NtvKVFytczDPaTDNtUgQNMGZ8ma5Tow1R9FAQPIkgQmwM1aig38
         N+Y592YIsabZMaasnBM7wPTNrtXAlQKtOmDGPYQU3OcfTIhOKxWjuzOWMcGgV5XIbKt6
         MFknvEizIXCoZB0BLjYoBLSl6d3Drva1QZReep3WH0jH697aSiC0bAW0RsijeVu3tPm1
         WGQL5tJNjIvQ421pqUtSFwtm8gYsJRMuZzCN4K3itxASyDSWIJVv8L8W9+Cu8Jb/IO07
         nnGQCHrsZn4SnB4JHX1kpmfLHokG0ik0mDbKTvCYNdWyp3SKsxkKy2kv6Igm/fJjeIpc
         xb3Q==
X-Gm-Message-State: AOAM533QrrOjuVwy3sp1a4et+Hs5ScO6ICjOMaB3i1f5On95VQvZH1BE
        WDFEmWdJTCr18FcWJvGkboLpdiCWIS25YH3x
X-Google-Smtp-Source: ABdhPJybkzJEUpUiJEsKiiJ5d9ps3M/0Jq39fM2tnfjIuVy+wCVXPbGjFwmKYq2+oUPEMwl26ngyWQ==
X-Received: by 2002:a17:902:b089:: with SMTP id p9mr5211358plr.93.1644341203260;
        Tue, 08 Feb 2022 09:26:43 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 33/44] nsp_cs: Move the SCSI pointer to private command data
Date:   Tue,  8 Feb 2022 09:25:03 -0800
Message-Id: <20220208172514.3481-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
in struct scsi_cmnd.
This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/nsp_cs.c    | 206 ++++++++++++++++++--------------
 drivers/scsi/pcmcia/nsp_cs.h    |   2 +-
 drivers/scsi/pcmcia/nsp_debug.c |   2 +-
 3 files changed, 120 insertions(+), 90 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index dcffda384eaf..94d8185d3190 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -70,6 +70,17 @@ static bool       free_ports = 0;
 module_param(free_ports, bool, 0);
 MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (default: 0 (=no))");
 
+struct nsp_cmd_priv {
+	struct scsi_pointer scsi_pointer;
+};
+
+static struct scsi_pointer *nsp_priv(struct scsi_cmnd *cmd)
+{
+	struct nsp_cmd_priv *ncmd = scsi_cmd_priv(cmd);
+
+	return &ncmd->scsi_pointer;
+}
+
 static struct scsi_host_template nsp_driver_template = {
 	.proc_name	         = "nsp_cs",
 	.show_info		 = nsp_show_info,
@@ -83,6 +94,7 @@ static struct scsi_host_template nsp_driver_template = {
 	.this_id		 = NSP_INITIATOR_ID,
 	.sg_tablesize		 = SG_ALL,
 	.dma_boundary		 = PAGE_SIZE - 1,
+	.cmd_size		 = sizeof(struct nsp_cmd_priv),
 };
 
 static nsp_hw_data nsp_data_base; /* attach <-> detect glue */
@@ -180,8 +192,9 @@ static void nsp_scsi_done(struct scsi_cmnd *SCpnt)
 	scsi_done(SCpnt);
 }
 
-static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt)
+static int nsp_queuecommand_lck(struct scsi_cmnd *const SCpnt)
 {
+	struct scsi_pointer *scsi_pointer = nsp_priv(SCpnt);
 #ifdef NSP_DEBUG
 	/*unsigned int host_id = SCpnt->device->host->this_id;*/
 	/*unsigned int base    = SCpnt->device->host->io_port;*/
@@ -217,11 +230,11 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt)
 
 	data->CurrentSC		= SCpnt;
 
-	SCpnt->SCp.Status	= SAM_STAT_CHECK_CONDITION;
-	SCpnt->SCp.Message	= 0;
-	SCpnt->SCp.have_data_in = IO_UNKNOWN;
-	SCpnt->SCp.sent_command = 0;
-	SCpnt->SCp.phase	= PH_UNDETERMINED;
+	scsi_pointer->Status	   = SAM_STAT_CHECK_CONDITION;
+	scsi_pointer->Message	   = 0;
+	scsi_pointer->have_data_in = IO_UNKNOWN;
+	scsi_pointer->sent_command = 0;
+	scsi_pointer->phase	   = PH_UNDETERMINED;
 	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
 
 	/* setup scratch area
@@ -231,15 +244,15 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt)
 	   SCp.buffers_residual : left buffers in list
 	   SCp.phase		: current state of the command */
 	if (scsi_bufflen(SCpnt)) {
-		SCpnt->SCp.buffer	    = scsi_sglist(SCpnt);
-		SCpnt->SCp.ptr		    = BUFFER_ADDR;
-		SCpnt->SCp.this_residual    = SCpnt->SCp.buffer->length;
-		SCpnt->SCp.buffers_residual = scsi_sg_count(SCpnt) - 1;
+		scsi_pointer->buffer	       = scsi_sglist(SCpnt);
+		scsi_pointer->ptr	       = BUFFER_ADDR(SCpnt);
+		scsi_pointer->this_residual    = scsi_pointer->buffer->length;
+		scsi_pointer->buffers_residual = scsi_sg_count(SCpnt) - 1;
 	} else {
-		SCpnt->SCp.ptr		    = NULL;
-		SCpnt->SCp.this_residual    = 0;
-		SCpnt->SCp.buffer	    = NULL;
-		SCpnt->SCp.buffers_residual = 0;
+		scsi_pointer->ptr	       = NULL;
+		scsi_pointer->this_residual    = 0;
+		scsi_pointer->buffer	       = NULL;
+		scsi_pointer->buffers_residual = 0;
 	}
 
 	if (!nsphw_start_selection(SCpnt)) {
@@ -353,8 +366,9 @@ static void nsphw_init(nsp_hw_data *data)
 /*
  * Start selection phase
  */
-static bool nsphw_start_selection(struct scsi_cmnd *SCpnt)
+static bool nsphw_start_selection(struct scsi_cmnd *const SCpnt)
 {
+	struct scsi_pointer *scsi_pointer = nsp_priv(SCpnt);
 	unsigned int  host_id	 = SCpnt->device->host->this_id;
 	unsigned int  base	 = SCpnt->device->host->io_port;
 	unsigned char target	 = scmd_id(SCpnt);
@@ -372,7 +386,7 @@ static bool nsphw_start_selection(struct scsi_cmnd *SCpnt)
 
 	/* start arbitration */
 	//nsp_dbg(NSP_DEBUG_RESELECTION, "start arbit");
-	SCpnt->SCp.phase = PH_ARBSTART;
+	scsi_pointer->phase = PH_ARBSTART;
 	nsp_index_write(base, SETARBIT, ARBIT_GO);
 
 	time_out = 1000;
@@ -392,7 +406,7 @@ static bool nsphw_start_selection(struct scsi_cmnd *SCpnt)
 
 	/* assert select line */
 	//nsp_dbg(NSP_DEBUG_RESELECTION, "assert SEL line");
-	SCpnt->SCp.phase = PH_SELSTART;
+	scsi_pointer->phase = PH_SELSTART;
 	udelay(3); /* wait 2.4us */
 	nsp_index_write(base, SCSIDATALATCH, BIT(host_id) | BIT(target));
 	nsp_index_write(base, SCSIBUSCTRL,   SCSI_SEL | SCSI_BSY                    | SCSI_ATN);
@@ -568,8 +582,9 @@ static int nsp_expect_signal(struct scsi_cmnd *SCpnt,
 /*
  * transfer SCSI message
  */
-static int nsp_xfer(struct scsi_cmnd *SCpnt, int phase)
+static int nsp_xfer(struct scsi_cmnd *const SCpnt, int phase)
 {
+	struct scsi_pointer *scsi_pointer = nsp_priv(SCpnt);
 	unsigned int  base = SCpnt->device->host->io_port;
 	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	char	     *buf  = data->MsgBuffer;
@@ -587,7 +602,7 @@ static int nsp_xfer(struct scsi_cmnd *SCpnt, int phase)
 		}
 
 		/* if last byte, negate ATN */
-		if (len == 1 && SCpnt->SCp.phase == PH_MSG_OUT) {
+		if (len == 1 && scsi_pointer->phase == PH_MSG_OUT) {
 			nsp_index_write(base, SCSIBUSCTRL, AUTODIRECTION | ACKENB);
 		}
 
@@ -608,14 +623,15 @@ static int nsp_xfer(struct scsi_cmnd *SCpnt, int phase)
 /*
  * get extra SCSI data from fifo
  */
-static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
+static int nsp_dataphase_bypass(struct scsi_cmnd *const SCpnt)
 {
+	struct scsi_pointer *scsi_pointer = nsp_priv(SCpnt);
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int count;
 
 	//nsp_dbg(NSP_DEBUG_DATA_IO, "in");
 
-	if (SCpnt->SCp.have_data_in != IO_IN) {
+	if (scsi_pointer->have_data_in != IO_IN) {
 		return 0;
 	}
 
@@ -630,7 +646,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
 	 * data phase skip only occures in case of SCSI_LOW_READ
 	 */
 	nsp_dbg(NSP_DEBUG_DATA_IO, "use bypass quirk");
-	SCpnt->SCp.phase = PH_DATA;
+	scsi_pointer->phase = PH_DATA;
 	nsp_pio_read(SCpnt);
 	nsp_setup_fifo(data, false);
 
@@ -704,8 +720,9 @@ static int nsp_fifo_count(struct scsi_cmnd *SCpnt)
 /*
  * read data in DATA IN phase
  */
-static void nsp_pio_read(struct scsi_cmnd *SCpnt)
+static void nsp_pio_read(struct scsi_cmnd *const SCpnt)
 {
+	struct scsi_pointer *scsi_pointer = nsp_priv(SCpnt);
 	unsigned int  base      = SCpnt->device->host->io_port;
 	unsigned long mmio_base = SCpnt->device->host->base;
 	nsp_hw_data  *data      = (nsp_hw_data *)SCpnt->device->host->hostdata;
@@ -716,24 +733,25 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 	ocount = data->FifoCount;
 
 	nsp_dbg(NSP_DEBUG_DATA_IO, "in SCpnt=0x%p resid=%d ocount=%d ptr=0x%p this_residual=%d buffers=0x%p nbuf=%d",
-		SCpnt, scsi_get_resid(SCpnt), ocount, SCpnt->SCp.ptr,
-		SCpnt->SCp.this_residual, SCpnt->SCp.buffer,
-		SCpnt->SCp.buffers_residual);
+		SCpnt, scsi_get_resid(SCpnt), ocount, scsi_pointer->ptr,
+		scsi_pointer->this_residual, scsi_pointer->buffer,
+		scsi_pointer->buffers_residual);
 
 	time_out = 1000;
 
 	while ((time_out-- != 0) &&
-	       (SCpnt->SCp.this_residual > 0 || SCpnt->SCp.buffers_residual > 0 ) ) {
+	       (scsi_pointer->this_residual > 0 ||
+		scsi_pointer->buffers_residual > 0)) {
 
 		stat = nsp_index_read(base, SCSIBUSMON);
 		stat &= BUSMON_PHASE_MASK;
 
 
 		res = nsp_fifo_count(SCpnt) - ocount;
-		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=0x%p this=0x%x ocount=0x%x res=0x%x", SCpnt->SCp.ptr, SCpnt->SCp.this_residual, ocount, res);
+		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=0x%p this=0x%x ocount=0x%x res=0x%x", scsi_pointer->ptr, scsi_pointer->this_residual, ocount, res);
 		if (res == 0) { /* if some data available ? */
 			if (stat == BUSPHASE_DATA_IN) { /* phase changed? */
-				//nsp_dbg(NSP_DEBUG_DATA_IO, " wait for data this=%d", SCpnt->SCp.this_residual);
+				//nsp_dbg(NSP_DEBUG_DATA_IO, " wait for data this=%d", scsi_pointer->this_residual);
 				continue;
 			} else {
 				nsp_dbg(NSP_DEBUG_DATA_IO, "phase changed stat=0x%x", stat);
@@ -747,20 +765,21 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 			continue;
 		}
 
-		res = min(res, SCpnt->SCp.this_residual);
+		res = min(res, scsi_pointer->this_residual);
 
 		switch (data->TransferMode) {
 		case MODE_IO32:
 			res &= ~(BIT(1)|BIT(0)); /* align 4 */
-			nsp_fifo32_read(base, SCpnt->SCp.ptr, res >> 2);
+			nsp_fifo32_read(base, scsi_pointer->ptr, res >> 2);
 			break;
 		case MODE_IO8:
-			nsp_fifo8_read (base, SCpnt->SCp.ptr, res     );
+			nsp_fifo8_read(base, scsi_pointer->ptr, res);
 			break;
 
 		case MODE_MEM32:
 			res &= ~(BIT(1)|BIT(0)); /* align 4 */
-			nsp_mmio_fifo32_read(mmio_base, SCpnt->SCp.ptr, res >> 2);
+			nsp_mmio_fifo32_read(mmio_base, scsi_pointer->ptr,
+					     res >> 2);
 			break;
 
 		default:
@@ -769,22 +788,23 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 		}
 
 		nsp_inc_resid(SCpnt, -res);
-		SCpnt->SCp.ptr		 += res;
-		SCpnt->SCp.this_residual -= res;
+		scsi_pointer->ptr += res;
+		scsi_pointer->this_residual -= res;
 		ocount			 += res;
-		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=0x%p this_residual=0x%x ocount=0x%x", SCpnt->SCp.ptr, SCpnt->SCp.this_residual, ocount);
+		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=0x%p this_residual=0x%x ocount=0x%x", scsi_pointer->ptr, scsi_pointer->this_residual, ocount);
 
 		/* go to next scatter list if available */
-		if (SCpnt->SCp.this_residual	== 0 &&
-		    SCpnt->SCp.buffers_residual != 0 ) {
+		if (scsi_pointer->this_residual	== 0 &&
+		    scsi_pointer->buffers_residual != 0 ) {
 			//nsp_dbg(NSP_DEBUG_DATA_IO, "scatterlist next timeout=%d", time_out);
-			SCpnt->SCp.buffers_residual--;
-			SCpnt->SCp.buffer = sg_next(SCpnt->SCp.buffer);
-			SCpnt->SCp.ptr		 = BUFFER_ADDR;
-			SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
+			scsi_pointer->buffers_residual--;
+			scsi_pointer->buffer = sg_next(scsi_pointer->buffer);
+			scsi_pointer->ptr = BUFFER_ADDR(SCpnt);
+			scsi_pointer->this_residual =
+				scsi_pointer->buffer->length;
 			time_out = 1000;
 
-			//nsp_dbg(NSP_DEBUG_DATA_IO, "page: 0x%p, off: 0x%x", SCpnt->SCp.buffer->page, SCpnt->SCp.buffer->offset);
+			//nsp_dbg(NSP_DEBUG_DATA_IO, "page: 0x%p, off: 0x%x", scsi_pointer->buffer->page, scsi_pointer->buffer->offset);
 		}
 	}
 
@@ -792,8 +812,8 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
 
 	if (time_out < 0) {
 		nsp_msg(KERN_DEBUG, "pio read timeout resid=%d this_residual=%d buffers_residual=%d",
-			scsi_get_resid(SCpnt), SCpnt->SCp.this_residual,
-			SCpnt->SCp.buffers_residual);
+			scsi_get_resid(SCpnt), scsi_pointer->this_residual,
+			scsi_pointer->buffers_residual);
 	}
 	nsp_dbg(NSP_DEBUG_DATA_IO, "read ocount=0x%x", ocount);
 	nsp_dbg(NSP_DEBUG_DATA_IO, "r cmd=%d resid=0x%x\n", data->CmdId,
@@ -805,6 +825,7 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
  */
 static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 {
+	struct scsi_pointer *scsi_pointer = nsp_priv(SCpnt);
 	unsigned int  base      = SCpnt->device->host->io_port;
 	unsigned long mmio_base = SCpnt->device->host->base;
 	nsp_hw_data  *data      = (nsp_hw_data *)SCpnt->device->host->hostdata;
@@ -815,14 +836,15 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 	ocount	 = data->FifoCount;
 
 	nsp_dbg(NSP_DEBUG_DATA_IO, "in fifocount=%d ptr=0x%p this_residual=%d buffers=0x%p nbuf=%d resid=0x%x",
-		data->FifoCount, SCpnt->SCp.ptr, SCpnt->SCp.this_residual,
-		SCpnt->SCp.buffer, SCpnt->SCp.buffers_residual,
+		data->FifoCount, scsi_pointer->ptr, scsi_pointer->this_residual,
+		scsi_pointer->buffer, scsi_pointer->buffers_residual,
 		scsi_get_resid(SCpnt));
 
 	time_out = 1000;
 
 	while ((time_out-- != 0) &&
-	       (SCpnt->SCp.this_residual > 0 || SCpnt->SCp.buffers_residual > 0)) {
+	       (scsi_pointer->this_residual > 0 ||
+		scsi_pointer->buffers_residual > 0)) {
 		stat = nsp_index_read(base, SCSIBUSMON);
 		stat &= BUSMON_PHASE_MASK;
 
@@ -832,9 +854,9 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 			nsp_dbg(NSP_DEBUG_DATA_IO, "phase changed stat=0x%x, res=%d\n", stat, res);
 			/* Put back pointer */
 			nsp_inc_resid(SCpnt, res);
-			SCpnt->SCp.ptr		 -= res;
-			SCpnt->SCp.this_residual += res;
-			ocount			 -= res;
+			scsi_pointer->ptr -= res;
+			scsi_pointer->this_residual += res;
+			ocount -= res;
 
 			break;
 		}
@@ -845,21 +867,22 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 			continue;
 		}
 
-		res = min(SCpnt->SCp.this_residual, WFIFO_CRIT);
+		res = min(scsi_pointer->this_residual, WFIFO_CRIT);
 
-		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=0x%p this=0x%x res=0x%x", SCpnt->SCp.ptr, SCpnt->SCp.this_residual, res);
+		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=0x%p this=0x%x res=0x%x", scsi_pointer->ptr, scsi_pointer->this_residual, res);
 		switch (data->TransferMode) {
 		case MODE_IO32:
 			res &= ~(BIT(1)|BIT(0)); /* align 4 */
-			nsp_fifo32_write(base, SCpnt->SCp.ptr, res >> 2);
+			nsp_fifo32_write(base, scsi_pointer->ptr, res >> 2);
 			break;
 		case MODE_IO8:
-			nsp_fifo8_write (base, SCpnt->SCp.ptr, res     );
+			nsp_fifo8_write(base, scsi_pointer->ptr, res);
 			break;
 
 		case MODE_MEM32:
 			res &= ~(BIT(1)|BIT(0)); /* align 4 */
-			nsp_mmio_fifo32_write(mmio_base, SCpnt->SCp.ptr, res >> 2);
+			nsp_mmio_fifo32_write(mmio_base, scsi_pointer->ptr,
+					      res >> 2);
 			break;
 
 		default:
@@ -868,18 +891,19 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
 		}
 
 		nsp_inc_resid(SCpnt, -res);
-		SCpnt->SCp.ptr		 += res;
-		SCpnt->SCp.this_residual -= res;
-		ocount			 += res;
+		scsi_pointer->ptr += res;
+		scsi_pointer->this_residual -= res;
+		ocount += res;
 
 		/* go to next scatter list if available */
-		if (SCpnt->SCp.this_residual	== 0 &&
-		    SCpnt->SCp.buffers_residual != 0 ) {
+		if (scsi_pointer->this_residual	== 0 &&
+		    scsi_pointer->buffers_residual != 0 ) {
 			//nsp_dbg(NSP_DEBUG_DATA_IO, "scatterlist next");
-			SCpnt->SCp.buffers_residual--;
-			SCpnt->SCp.buffer = sg_next(SCpnt->SCp.buffer);
-			SCpnt->SCp.ptr		 = BUFFER_ADDR;
-			SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
+			scsi_pointer->buffers_residual--;
+			scsi_pointer->buffer = sg_next(scsi_pointer->buffer);
+			scsi_pointer->ptr = BUFFER_ADDR(SCpnt);
+			scsi_pointer->this_residual =
+				scsi_pointer->buffer->length;
 			time_out = 1000;
 		}
 	}
@@ -947,6 +971,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 	unsigned int   base;
 	unsigned char  irq_status, irq_phase, phase;
 	struct scsi_cmnd *tmpSC;
+	struct scsi_pointer *scsi_pointer;
 	unsigned char  target, lun;
 	unsigned int  *sync_neg;
 	int            i, tmp;
@@ -1025,9 +1050,10 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 
 		if(data->CurrentSC != NULL) {
 			tmpSC = data->CurrentSC;
-			tmpSC->result  = (DID_RESET                   << 16) |
-				         ((tmpSC->SCp.Message & 0xff) <<  8) |
-				         ((tmpSC->SCp.Status  & 0xff) <<  0);
+			scsi_pointer = nsp_priv(tmpSC);
+			tmpSC->result = (DID_RESET              << 16) |
+				((scsi_pointer->Message & 0xff) <<  8) |
+				((scsi_pointer->Status  & 0xff) <<  0);
 			nsp_scsi_done(tmpSC);
 		}
 		return IRQ_HANDLED;
@@ -1041,6 +1067,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 	}
 
 	tmpSC    = data->CurrentSC;
+	scsi_pointer = nsp_priv(tmpSC);
 	target   = tmpSC->device->id;
 	lun      = tmpSC->device->lun;
 	sync_neg = &(data->Sync[target].SyncNegotiation);
@@ -1063,7 +1090,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 
 	//show_phase(tmpSC);
 
-	switch(tmpSC->SCp.phase) {
+	switch (scsi_pointer->phase) {
 	case PH_SELSTART:
 		// *sync_neg = SYNC_NOT_YET;
 		if ((phase & BUSMON_BSY) == 0) {
@@ -1086,7 +1113,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		/* attention assert */
 		//nsp_dbg(NSP_DEBUG_INTR, "attention assert");
 		data->SelectionTimeOut = 0;
-		tmpSC->SCp.phase       = PH_SELECTED;
+		scsi_pointer->phase = PH_SELECTED;
 		nsp_index_write(base, SCSIBUSCTRL, SCSI_ATN);
 		udelay(1);
 		nsp_index_write(base, SCSIBUSCTRL, SCSI_ATN | AUTODIRECTION | ACKENB);
@@ -1115,17 +1142,18 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 	//nsp_dbg(NSP_DEBUG_INTR, "start scsi seq");
 
 	/* normal disconnect */
-	if (((tmpSC->SCp.phase == PH_MSG_IN) || (tmpSC->SCp.phase == PH_MSG_OUT)) &&
-	    (irq_phase & LATCHED_BUS_FREE) != 0 ) {
+	if ((scsi_pointer->phase == PH_MSG_IN ||
+	     scsi_pointer->phase == PH_MSG_OUT) &&
+	    (irq_phase & LATCHED_BUS_FREE) != 0) {
 		nsp_dbg(NSP_DEBUG_INTR, "normal disconnect irq_status=0x%x, phase=0x%x, irq_phase=0x%x", irq_status, phase, irq_phase);
 
 		//*sync_neg       = SYNC_NOT_YET;
 
 		/* all command complete and return status */
-		if (tmpSC->SCp.Message == COMMAND_COMPLETE) {
-			tmpSC->result = (DID_OK		             << 16) |
-					((tmpSC->SCp.Message & 0xff) <<  8) |
-					((tmpSC->SCp.Status  & 0xff) <<  0);
+		if (scsi_pointer->Message == COMMAND_COMPLETE) {
+			tmpSC->result = (DID_OK		        << 16) |
+				((scsi_pointer->Message & 0xff) <<  8) |
+				((scsi_pointer->Status  & 0xff) <<  0);
 			nsp_dbg(NSP_DEBUG_INTR, "command complete result=0x%x", tmpSC->result);
 			nsp_scsi_done(tmpSC);
 
@@ -1154,7 +1182,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 			return IRQ_HANDLED;
 		}
 
-		tmpSC->SCp.phase = PH_COMMAND;
+		scsi_pointer->phase = PH_COMMAND;
 
 		nsp_nexus(tmpSC);
 
@@ -1170,8 +1198,8 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 	case BUSPHASE_DATA_OUT:
 		nsp_dbg(NSP_DEBUG_INTR, "BUSPHASE_DATA_OUT");
 
-		tmpSC->SCp.phase        = PH_DATA;
-		tmpSC->SCp.have_data_in = IO_OUT;
+		scsi_pointer->phase        = PH_DATA;
+		scsi_pointer->have_data_in = IO_OUT;
 
 		nsp_pio_write(tmpSC);
 
@@ -1180,8 +1208,8 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 	case BUSPHASE_DATA_IN:
 		nsp_dbg(NSP_DEBUG_INTR, "BUSPHASE_DATA_IN");
 
-		tmpSC->SCp.phase        = PH_DATA;
-		tmpSC->SCp.have_data_in = IO_IN;
+		scsi_pointer->phase        = PH_DATA;
+		scsi_pointer->have_data_in = IO_IN;
 
 		nsp_pio_read(tmpSC);
 
@@ -1191,10 +1219,11 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		nsp_dataphase_bypass(tmpSC);
 		nsp_dbg(NSP_DEBUG_INTR, "BUSPHASE_STATUS");
 
-		tmpSC->SCp.phase = PH_STATUS;
+		scsi_pointer->phase = PH_STATUS;
 
-		tmpSC->SCp.Status = nsp_index_read(base, SCSIDATAWITHACK);
-		nsp_dbg(NSP_DEBUG_INTR, "message=0x%x status=0x%x", tmpSC->SCp.Message, tmpSC->SCp.Status);
+		scsi_pointer->Status = nsp_index_read(base, SCSIDATAWITHACK);
+		nsp_dbg(NSP_DEBUG_INTR, "message=0x%x status=0x%x",
+			scsi_pointer->Message, scsi_pointer->Status);
 
 		break;
 
@@ -1204,7 +1233,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 			goto timer_out;
 		}
 
-		tmpSC->SCp.phase = PH_MSG_OUT;
+		scsi_pointer->phase = PH_MSG_OUT;
 
 		//*sync_neg = SYNC_NOT_YET;
 
@@ -1237,7 +1266,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 			goto timer_out;
 		}
 
-		tmpSC->SCp.phase = PH_MSG_IN;
+		scsi_pointer->phase = PH_MSG_IN;
 		nsp_message_in(tmpSC);
 
 		/**/
@@ -1269,9 +1298,10 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 				i += (1 + data->MsgBuffer[i+1]);
 			}
 		}
-		tmpSC->SCp.Message = tmp;
+		scsi_pointer->Message = tmp;
 
-		nsp_dbg(NSP_DEBUG_INTR, "message=0x%x len=%d", tmpSC->SCp.Message, data->MsgLen);
+		nsp_dbg(NSP_DEBUG_INTR, "message=0x%x len=%d",
+			scsi_pointer->Message, data->MsgLen);
 		show_message(data);
 
 		break;
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 7d5d1a5b36e0..e1ee8ef90ad3 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -371,7 +371,7 @@ enum _burst_mode {
 };
 
 /* scatter-gather table */
-#  define BUFFER_ADDR ((char *)((sg_virt(SCpnt->SCp.buffer))))
+#define BUFFER_ADDR(SCpnt) ((char *)(sg_virt(nsp_priv(SCpnt)->buffer)))
 
 #endif  /*__nsp_cs__*/
 /* end */
diff --git a/drivers/scsi/pcmcia/nsp_debug.c b/drivers/scsi/pcmcia/nsp_debug.c
index 6aa7d269d3b3..23b68dd26f74 100644
--- a/drivers/scsi/pcmcia/nsp_debug.c
+++ b/drivers/scsi/pcmcia/nsp_debug.c
@@ -145,7 +145,7 @@ static void show_command(struct scsi_cmnd *SCpnt)
 
 static void show_phase(struct scsi_cmnd *SCpnt)
 {
-	int i = SCpnt->SCp.phase;
+	int i = nsp_scsi_pointer(SCpnt)->phase;
 
 	char *ph[] = {
 		"PH_UNDETERMINED",
