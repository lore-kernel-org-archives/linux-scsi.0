Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976C122258C
	for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2025 05:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766207787; cv=none; b=fx7EhChPjuOrPdQLU6rR+B9SwexlJzaEYjy/ui+8i+K39EW3qqsRg0tCfMpnA6HwPUxVSUpYtHTCqFM5WULLu0d1NbGxut8K93X7Wo60In6qhI9lC3jlUiPHL68uoOirelzqsY2jNWgEIhymU4l/Ec3qsq/Y0b0m7M9BzfOOyKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766207787; c=relaxed/simple;
	bh=Ki24IxuV/1/e/nANY8PcPZYwUGEtlW5jYF16w70JS04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+Ewbz3kaI9v++7Lj+6DPU2+mxHlMbGvVjelt25ENds9HFaLbtS8p4hHEwLG3DJHvrfKPFqmkQRTpefKRqtK29l7wWofZDCCb3JSFiZKVswL4faZMETTIivCxBSq7iTuVqcjUzxjgS61zcEmvWvxhO36s9a1HUpjL+QdJ8cmuHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P1DlkdjV; arc=none smtp.client-ip=74.125.82.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P1DlkdjV"
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-11b6bc976d6so5145748c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 21:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766207785; x=1766812585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wbluyv2f0qt6p1MY53RlGoAvTkt9zjdh66Dvxn1zs40=;
        b=P1DlkdjVb6hInAQphrIIwXAMV46vkZFqNve0WWAIMNp5gT2A261EbZvywOyFxXzhif
         I1gqlStfkZIfcHjoo9irSrR6w4Oy/6JhmbhZAxpJjmcuOz/7BdmpyRbjz2MRZNAgMfCR
         A1Jm2u/BW1cZFRZIC1cuU27yGtijFJrZhd8j9VxwvWIiu2MA0vFmhBhQgSQWYlwhlMbU
         T5SxmTavU5xH/IcPklYIRHmcOunhUX/0p3i0rwCCs7eGpCOIOkOQd0FhHJrLreDBbQSu
         9bKNGyiecwn3LEFNEo8RFdvhG5N/KhdOVfRU1OETOKp4EtTTXg7KV7pFjHejXBgexVE0
         5D8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766207785; x=1766812585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wbluyv2f0qt6p1MY53RlGoAvTkt9zjdh66Dvxn1zs40=;
        b=swkiR8wAaPxwdy07j3i5Iin1nX/c9gSn5I/3VS2sUXg1w+o5CmNdiPkP7bx+0O6pbX
         H2ea1HWYn4l4TRwA4XzGPBi80NQjUZdpNmS1vrcSjUptpE2j6f1iPG98dw59mRWa38ni
         dII9gLBTjXuaeCC8letmx5IhpfAEOgfs4jbY/+WkeM6izg026BEJL08YGqhskDIPlN0u
         ajdMf5Z3vxRc4eCHYt/WNvY1HheJpGde+wDqaMJlxilDRICLJlq0/OJqUoCHjF0t7uu+
         Q60rec/WWBrOYlfNLz4VKpuhKXWfhCBRsE+jufsYdEG9kqiIgaQIqGxmT/FYbAqKjpGb
         KMwA==
X-Gm-Message-State: AOJu0Yzc37kltF0Oi+MR8hYQkh55tDAl/EjhER6RKX98cYKk65Ax4juQ
	CiHmRv7Diw0Apg2xrk4j6QC2pAsFTmg/V+ec/l+ZE3EDvbjfWIHTwrnXjBACJofUs7o=
X-Gm-Gg: AY/fxX6wVX3IR59zud+HQ8jFIBqDvo9WzKmrOD5WZDN7hEYiWVDZNFR66zYDHy1cnKn
	qtia7vqikfVjdjoaKHVthhujCwRXk4oxGX8ynBPpbbUhhawgF7DsSuccDKG3kBHEhbmQX+TZbIz
	k6evgT+ClEePuDDolwrZphzAY8WPfi8L6vI9sKpp+X33eML3LK7PqWpTi9hA31AV2tTF6mW0E3+
	1u/Eh6MUi+RlJQid1Ikrze82I0t7OzqRBykTNAx9VLEO3SiI9oQg4se5KIyI6ygLAXIhoQr73EL
	9ChKMXqsjVHjvnEizkk6gxNrRzWCOsZh+O7VaOE7IZ6SDA0t8QKmn82PmdzsOX4e5HRlsYB4cm+
	+lumSQkMLvzLyCW98we+ZY3ZmUbpSDNOdrkwy16oSKX0ntcUaOObDMcN2hBECX+DGHCesMLsmeC
	orANxvGEIFzHC1S/qWxhvkMrXhT6HeeKsmZ6nmdgajQy4IBOLkK+BI5Ou8tTQPnZ3sCVvPa3mzT
	eqkmkcSM9sR1rIyX3n/SDeLrUN+9z2fOis4OoJ2FGm11yajnJcOhddUc6Yz1jPZCTkFxzV6t0BI
	KgMY
X-Google-Smtp-Source: AGHT+IFu4nZnXbNmbu2gHJptGT4a14jU2qrUtISjvrerA7vVRvNh7h1BaEyVESwMugenhdxX2Izp8g==
X-Received: by 2002:a05:7022:a87:b0:11c:883d:1ef0 with SMTP id a92af1059eb24-120619755eamr8929126c88.15.1766207784514;
        Fri, 19 Dec 2025 21:16:24 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724dd7f5sm16482269c88.5.2025.12.19.21.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 21:16:24 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH 5/5] scsi: qla1280: remove function tracing macros
Date: Fri, 19 Dec 2025 21:16:02 -0800
Message-ID: <20251220051602.28029-5-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251220051602.28029-1-enelsonmoore@gmail.com>
References: <20251220051602.28029-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These function tracing macros clutter the code and provide
no value over ftrace. Remove them.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/qla1280.c | 75 ------------------------------------------
 1 file changed, 75 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 26c312a48a19..15f0df1ff63f 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -561,12 +561,6 @@ static int ql_debug_level = 1;
 #define qla1280_print_scsi_cmd(a, b)	do{}while(0)
 #endif
 
-#define ENTER(x)		dprintk(3, "qla1280 : Entering %s()\n", x);
-#define LEAVE(x)		dprintk(3, "qla1280 : Leaving %s()\n", x);
-#define ENTER_INTR(x)		dprintk(4, "qla1280 : Entering %s()\n", x);
-#define LEAVE_INTR(x)		dprintk(4, "qla1280 : Leaving %s()\n", x);
-
-
 static int qla1280_read_nvram(struct scsi_qla_host *ha)
 {
 	uint16_t *wptr;
@@ -574,8 +568,6 @@ static int qla1280_read_nvram(struct scsi_qla_host *ha)
 	int cnt, i;
 	struct nvram *nv;
 
-	ENTER("qla1280_read_nvram");
-
 	if (driver_setup.no_nvram)
 		return 1;
 
@@ -641,7 +633,6 @@ static int qla1280_read_nvram(struct scsi_qla_host *ha)
 		nv->bus[i].max_queue_depth = cpu_to_le16(nv->bus[i].max_queue_depth);
 	}
 	dprintk(1, "qla1280_read_nvram: Completed Reading NVRAM\n");
-	LEAVE("qla1280_read_nvram");
 
 	return chksum;
 }
@@ -817,8 +808,6 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
 	int wait_for_target = -1;
 	DECLARE_COMPLETION_ONSTACK(wait);
 
-	ENTER("qla1280_error_action");
-
 	ha = (struct scsi_qla_host *)(CMD_HOST(cmd)->hostdata);
 	sp = scsi_cmd_priv(cmd);
 	bus = SCSI_BUS_32(cmd);
@@ -938,7 +927,6 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
 
 	dprintk(1, "RESET returning %d\n", result);
 
-	LEAVE("qla1280_error_action");
 	return result;
 }
 
@@ -1075,7 +1063,6 @@ qla1280_intr_handler(int irq, void *dev_id)
 	u16 data;
 	int handled = 0;
 
-	ENTER_INTR ("qla1280_intr_handler");
 	ha = (struct scsi_qla_host *)dev_id;
 
 	spin_lock(ha->host->host_lock);
@@ -1098,7 +1085,6 @@ qla1280_intr_handler(int irq, void *dev_id)
 
 	qla1280_enable_intrs(ha);
 
-	LEAVE_INTR("qla1280_intr_handler");
 	return IRQ_RETVAL(handled);
 }
 
@@ -1236,8 +1222,6 @@ qla1280_done(struct scsi_qla_host *ha)
 	int bus, target;
 	struct scsi_cmnd *cmd;
 
-	ENTER("qla1280_done");
-
 	done_q = &ha->done_q;
 
 	while (!list_empty(done_q)) {
@@ -1274,7 +1258,6 @@ qla1280_done(struct scsi_qla_host *ha)
 		else
 			complete(sp->wait);
 	}
-	LEAVE("qla1280_done");
 }
 
 /*
@@ -1303,8 +1286,6 @@ qla1280_return_status(struct response * sts, struct scsi_cmnd *cp)
 	};
 #endif				/* DEBUG_QLA1280_INTR */
 
-	ENTER("qla1280_return_status");
-
 #if DEBUG_QLA1280_INTR
 	/*
 	  dprintk(1, "qla1280_return_status: compl status = 0x%04x\n",
@@ -1374,8 +1355,6 @@ qla1280_return_status(struct response * sts, struct scsi_cmnd *cp)
 		reason[host_status], scsi_status);
 #endif
 
-	LEAVE("qla1280_return_status");
-
 	return (scsi_status & 0xff) | (host_status << 16);
 }
 
@@ -1401,8 +1380,6 @@ qla1280_initialize_adapter(struct scsi_qla_host *ha)
 	int bus;
 	unsigned long flags;
 
-	ENTER("qla1280_initialize_adapter");
-
 	/* Clear adapter flags. */
 	ha->flags.online = 0;
 	ha->flags.disable_host_adapter = 0;
@@ -1470,7 +1447,6 @@ qla1280_initialize_adapter(struct scsi_qla_host *ha)
 	if (status)
 		dprintk(2, "qla1280_initialize_adapter: **** FAILED ****\n");
 
-	LEAVE("qla1280_initialize_adapter");
 	return status;
 }
 
@@ -1879,8 +1855,6 @@ qla1280_init_rings(struct scsi_qla_host *ha)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int status = 0;
 
-	ENTER("qla1280_init_rings");
-
 	/* Clear outstanding commands array. */
 	memset(ha->outstanding_cmds, 0,
 	       sizeof(struct srb *) * MAX_OUTSTANDING_COMMANDS);
@@ -1919,7 +1893,6 @@ qla1280_init_rings(struct scsi_qla_host *ha)
 	if (status)
 		dprintk(2, "qla1280_init_rings: **** FAILED ****\n");
 
-	LEAVE("qla1280_init_rings");
 	return status;
 }
 
@@ -2156,8 +2129,6 @@ qla1280_nvram_config(struct scsi_qla_host *ha)
 	int bus, target, status = 0;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 
-	ENTER("qla1280_nvram_config");
-
 	if (ha->nvram_valid) {
 		/* Always force AUTO sense for LINUX SCSI */
 		for (bus = 0; bus < MAX_BUSES; bus++)
@@ -2288,7 +2259,6 @@ qla1280_nvram_config(struct scsi_qla_host *ha)
 	if (status)
 		dprintk(2, "qla1280_nvram_config: **** FAILED ****\n");
 
-	LEAVE("qla1280_nvram_config");
 	return status;
 }
 
@@ -2419,8 +2389,6 @@ qla1280_mailbox_command(struct scsi_qla_host *ha, uint8_t mr, uint16_t *mb)
 	uint16_t __iomem *mptr;
 	DECLARE_COMPLETION_ONSTACK(wait);
 
-	ENTER("qla1280_mailbox_command");
-
 	if (ha->mailbox_wait) {
 		printk(KERN_ERR "Warning mailbox wait already in use!\n");
 	}
@@ -2487,7 +2455,6 @@ qla1280_mailbox_command(struct scsi_qla_host *ha, uint8_t mr, uint16_t *mb)
 		dprintk(2, "qla1280_mailbox_command: **** FAILED, mailbox0 = "
 			"0x%x ****\n", mb[0]);
 
-	LEAVE("qla1280_mailbox_command");
 	return status;
 }
 
@@ -2505,8 +2472,6 @@ qla1280_poll(struct scsi_qla_host *ha)
 	uint16_t data;
 	LIST_HEAD(done_q);
 
-	/* ENTER("qla1280_poll"); */
-
 	/* Check for pending interrupts. */
 	data = RD_REG_WORD(&reg->istatus);
 	if (data & RISC_INT)
@@ -2520,7 +2485,6 @@ qla1280_poll(struct scsi_qla_host *ha)
 	if (!list_empty(&done_q))
 		qla1280_done(ha);
 
-	/* LEAVE("qla1280_poll"); */
 }
 
 /*
@@ -2600,8 +2564,6 @@ qla1280_device_reset(struct scsi_qla_host *ha, int bus, int target)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int status;
 
-	ENTER("qla1280_device_reset");
-
 	mb[0] = MBC_ABORT_TARGET;
 	mb[1] = (bus ? (target | BIT_7) : target) << 8;
 	mb[2] = 1;
@@ -2613,7 +2575,6 @@ qla1280_device_reset(struct scsi_qla_host *ha, int bus, int target)
 	if (status)
 		dprintk(2, "qla1280_device_reset: **** FAILED ****\n");
 
-	LEAVE("qla1280_device_reset");
 	return status;
 }
 
@@ -2635,8 +2596,6 @@ qla1280_abort_command(struct scsi_qla_host *ha, struct srb * sp, int handle)
 	unsigned int bus, target, lun;
 	int status;
 
-	ENTER("qla1280_abort_command");
-
 	bus = SCSI_BUS_32(sp->cmd);
 	target = SCSI_TCN_32(sp->cmd);
 	lun = SCSI_LUN_32(sp->cmd);
@@ -2654,8 +2613,6 @@ qla1280_abort_command(struct scsi_qla_host *ha, struct srb * sp, int handle)
 		sp->flags &= ~SRB_ABORT_PENDING;
 	}
 
-
-	LEAVE("qla1280_abort_command");
 	return status;
 }
 
@@ -2671,8 +2628,6 @@ qla1280_reset_adapter(struct scsi_qla_host *ha)
 {
 	struct device_reg __iomem *reg = ha->iobase;
 
-	ENTER("qla1280_reset_adapter");
-
 	/* Disable ISP chip */
 	ha->flags.online = 0;
 	WRT_REG_WORD(&reg->ictrl, ISP_RESET);
@@ -2680,7 +2635,6 @@ qla1280_reset_adapter(struct scsi_qla_host *ha)
 		     HC_RESET_RISC | HC_RELEASE_RISC | HC_DISABLE_BIOS);
 	RD_REG_WORD(&reg->id_l);	/* Flush PCI write */
 
-	LEAVE("qla1280_reset_adapter");
 }
 
 /*
@@ -2699,8 +2653,6 @@ qla1280_marker(struct scsi_qla_host *ha, int bus, int id, int lun, u8 type)
 {
 	struct mrk_entry *pkt;
 
-	ENTER("qla1280_marker");
-
 	/* Get request packet. */
 	if ((pkt = (struct mrk_entry *) qla1280_req_pkt(ha))) {
 		pkt->entry_type = MARKER_TYPE;
@@ -2713,7 +2665,6 @@ qla1280_marker(struct scsi_qla_host *ha, int bus, int id, int lun, u8 type)
 		qla1280_isp_cmd(ha);
 	}
 
-	LEAVE("qla1280_marker");
 }
 
 
@@ -2744,8 +2695,6 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	int seg_cnt;
 	u8 dir;
 
-	ENTER("qla1280_64bit_start_scsi:");
-
 	/* Calculate number of entries and segments required. */
 	req_cnt = 1;
 	seg_cnt = scsi_dma_map(cmd);
@@ -2997,8 +2946,6 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	int seg_cnt;
 	u8 dir;
 
-	ENTER("qla1280_32bit_start_scsi");
-
 	dprintk(1, "32bit_start: cmd=%p sp=%p CDB=%x\n", cmd, sp,
 		cmd->cmnd[0]);
 
@@ -3207,8 +3154,6 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	if (status)
 		dprintk(2, "qla1280_32bit_start_scsi: **** FAILED ****\n");
 
-	LEAVE("qla1280_32bit_start_scsi");
-
 	return status;
 }
 #endif
@@ -3232,8 +3177,6 @@ qla1280_req_pkt(struct scsi_qla_host *ha)
 	int cnt;
 	uint32_t timer;
 
-	ENTER("qla1280_req_pkt");
-
 	/*
 	 * This can be called from interrupt context, damn it!!!
 	 */
@@ -3297,8 +3240,6 @@ qla1280_isp_cmd(struct scsi_qla_host *ha)
 {
 	struct device_reg __iomem *reg = ha->iobase;
 
-	ENTER("qla1280_isp_cmd");
-
 	dprintk(5, "qla1280_isp_cmd: IOCB data:\n");
 	qla1280_dump_buffer(5, (char *)ha->request_ring_ptr,
 			    REQUEST_ENTRY_SIZE);
@@ -3316,7 +3257,6 @@ qla1280_isp_cmd(struct scsi_qla_host *ha)
 	 */
 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
 
-	LEAVE("qla1280_isp_cmd");
 }
 
 /****************************************************************************/
@@ -3342,8 +3282,6 @@ qla1280_isr(struct scsi_qla_host *ha, struct list_head *done_q)
 	uint32_t index;
 	u16 istatus;
 
-	ENTER("qla1280_isr");
-
 	istatus = RD_REG_WORD(&reg->istatus);
 	if (!(istatus & (RISC_INT | PCI_INT)))
 		return;
@@ -3541,7 +3479,6 @@ qla1280_isr(struct scsi_qla_host *ha, struct list_head *done_q)
 	}
 	
  out:
-	LEAVE("qla1280_isr");
 }
 
 /*
@@ -3556,8 +3493,6 @@ qla1280_rst_aen(struct scsi_qla_host *ha)
 {
 	uint8_t bus;
 
-	ENTER("qla1280_rst_aen");
-
 	if (ha->flags.online && !ha->flags.reset_active &&
 	    !ha->flags.abort_isp_active) {
 		ha->flags.reset_active = 1;
@@ -3575,7 +3510,6 @@ qla1280_rst_aen(struct scsi_qla_host *ha)
 		}
 	}
 
-	LEAVE("qla1280_rst_aen");
 }
 
 
@@ -3599,8 +3533,6 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 	uint16_t scsi_status = le16_to_cpu(pkt->scsi_status);
 	uint16_t comp_status = le16_to_cpu(pkt->comp_status);
 
-	ENTER("qla1280_status_entry");
-
 	/* Validate handle. */
 	if (handle < MAX_OUTSTANDING_COMMANDS)
 		sp = ha->outstanding_cmds[handle];
@@ -3669,7 +3601,6 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 	/* Place command on done queue. */
 	list_add_tail(&sp->list, done_q);
  out:
-	LEAVE("qla1280_status_entry");
 }
 
 /*
@@ -3688,8 +3619,6 @@ qla1280_error_entry(struct scsi_qla_host *ha, struct response *pkt,
 	struct srb *sp;
 	uint32_t handle = le32_to_cpu(pkt->handle);
 
-	ENTER("qla1280_error_entry");
-
 	if (pkt->entry_status & BIT_3)
 		dprintk(2, "qla1280_error_entry: BAD PAYLOAD flag error\n");
 	else if (pkt->entry_status & BIT_2)
@@ -3732,7 +3661,6 @@ qla1280_error_entry(struct scsi_qla_host *ha, struct response *pkt,
 	}
 #endif
 
-	LEAVE("qla1280_error_entry");
 }
 
 /*
@@ -3754,8 +3682,6 @@ qla1280_abort_isp(struct scsi_qla_host *ha)
 	int cnt;
 	int bus;
 
-	ENTER("qla1280_abort_isp");
-
 	if (ha->flags.abort_isp_active || !ha->flags.online)
 		goto out;
 	
@@ -3807,7 +3733,6 @@ qla1280_abort_isp(struct scsi_qla_host *ha)
 		dprintk(2, "qla1280_abort_isp: **** FAILED ****\n");
 	}
 
-	LEAVE("qla1280_abort_isp");
 	return status;
 }
 
-- 
2.43.0

