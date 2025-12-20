Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC2228641F
	for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2025 07:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766215061; cv=none; b=GZtOfnaKU7M/uSDAzcH8fNRzFkSih7i4fKycFXU9HuJSzX9ytCd4XsJtACj94K86JfrspMRAQbVhPnfNBws/CEpctMV02Ktn+Nh9l65qRsXKV1oDJP0tQA4BEhWJKct+yrMVPfKLlnQCMTYxwFnR2uoWrJQ1SQR04zDFDeZpWtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766215061; c=relaxed/simple;
	bh=FPEx8aatAYJqD3pMbICxw5zgrdvC5xkbKZcsuu8t0zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9E5cn0BNFVqO7ai4GkekN+tjGSZWGVla579tPdyMffClCUyBwE3LpWoaBHUvJ5AlZtA2Jjlekt/Ee9AefIeeuDhHsGk3I3Uo4cN9sPw+zkCPJ2lLYGWsPAvU1hA9sYSU0kRZ5cIIPeRQQKq1QgwjfD4mikaN7MGK7Sh1OJsz7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZW6yrjO; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZW6yrjO"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-29f30233d8aso31616315ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 23:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766215059; x=1766819859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30JKT/r2RLPWbmq7hD8++bT1ipdWcz7FO8dACzJS35s=;
        b=IZW6yrjOkAJBn7VY3P0g7Dj0AkXKOdRDO/jPJEwa/kM5X7/9KB68n9VVeGU3lB61LF
         4yoALvoQ3yS5Tb7KYXgaAuodOqVFK0mn7bq/8ByR+WTwnJNsg8L9HEIBM0u8yEKF3zOl
         o2ap6V/fnZySi/O6i14TdK+AU2uMzQaVkXRi9A2Y4j41fsj33aFtt7fiyiAv1y7OhCvK
         bshDEDGAkNJy05qds4vYD71QRYdPabNT24Q9Eu6Q5ZEPph4oibUeWvcg5CazAoR9iZju
         dfIajjdFLYLByz2UrLA8+lFtdTl7B2CqQVjk7mXoUhM4qHZkF95UWIlqbFY1Jor6DFvl
         isiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766215059; x=1766819859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=30JKT/r2RLPWbmq7hD8++bT1ipdWcz7FO8dACzJS35s=;
        b=K7rLRgthAUzJbEYnsTH7Td2/HFK+OeMnI0IdLxpiZmOq2umnEHorB7x7cQ+8eD72I0
         0ftISkTSqXOPlwJNAgXsJjqiqtIHAWVIx8YOW9nqZhSkr0sho48sOFcISqQAIYv2Qp8Q
         QVKE2nHr+D7nnk4PF2R+zCF5075hmdyjEZuVI/1quRxv7gSlQ6ZAlL3td6/kfVyzBzbb
         +kkTN/YJmaqOHg5G4B4bFSz0MZQljQt2tQzpLYRgzd2BMbTGj/7p8uRqjZYkoCwcvD2X
         6GLCp3ptffaphdNxFlkSZtMp2PJ1dKfAH0FZYvMSCFAo2urmYjpxGpZWzjNVXzLY0Uz6
         8NuQ==
X-Gm-Message-State: AOJu0Yxqt98PMSX/4qpd1zc9nulUG/amPU2Ao71hwIBifJXlRSixQ2Q9
	PU5pW9s7IDwIGvQ4z9euwGYwyR7GWai0gJHYnp3lfNPipSVzEB3shgZYpOuE0quDdCI=
X-Gm-Gg: AY/fxX6sHdY3brj1lApkubhMPMdDPZbpEb4BAMHLmxeP+STPVV4unWE0Q1P//5TOJZX
	fjHsPRRlYX65Dzm36DNTgNJStzOyDp1bCXfF89otsVSVGoIHW4OzZ8A0sMBfFVT5YR+NAUwKxRa
	c+TkqNMI+Q2Pno6Pc41QDw+WyJ6cSse1wyE9Uczdm8vZTtJ7wMBiHBdIN2PQmnZZLfHtSDOeIWx
	QtEzNr2+ChLAGM5oXLAR5HD5OB3omof+VDNuZ5ejWb1zJCQKqv1dMGymUH22Tl1MY0YQn9W46c7
	s4hND+UTph0woC8+sElPbnIy9QaIQ05NffNjf0BnsXMJJS50QLjAFQCIfIRVqco2u5nQiXojV33
	dbQWSUnDa9S3P88yfxZ1k3+ho0O+dPigPuJ8vwWFSW2/egkj/RLfr5pf/tECqHxmR7eSaMCu9KM
	1T5SNnFDMM/5u9rWBmVUDNmUnCjLsN1uylu6oeQuxikt8ixJJi/22rZVDuSV3TYZjeE7PZRn2df
	e5fkdVOa1gDT8iPndLbYZNqh8WBZfWhIEaZ8Eytmjh0jCy6FvfgRWa1vf74MeBh6iJZlNSTDIxq
	0HU4
X-Google-Smtp-Source: AGHT+IFEy9IpABr3XrcKAyfY5KVz4H3S7SygzG4ensrHmKdeDS8PX/esdaKqqH4fuydTtqykxO0Xxg==
X-Received: by 2002:a05:7022:2217:b0:11b:9386:a3c2 with SMTP id a92af1059eb24-121722ff9fbmr5401418c88.45.1766215059036;
        Fri, 19 Dec 2025 23:17:39 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254d369sm17527115c88.16.2025.12.19.23.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 23:17:38 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH v2 5/5] scsi: qla1280: remove function tracing macros
Date: Fri, 19 Dec 2025 23:17:15 -0800
Message-ID: <20251220071715.44296-3-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251220071715.44296-1-enelsonmoore@gmail.com>
References: <20251220071715.44296-1-enelsonmoore@gmail.com>
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
 drivers/scsi/qla1280.c | 90 ++----------------------------------------
 1 file changed, 3 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 26c312a48a19..3fb72449a54e 100644
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
@@ -2519,8 +2484,6 @@ qla1280_poll(struct scsi_qla_host *ha)
 
 	if (!list_empty(&done_q))
 		qla1280_done(ha);
-
-	/* LEAVE("qla1280_poll"); */
 }
 
 /*
@@ -2600,8 +2563,6 @@ qla1280_device_reset(struct scsi_qla_host *ha, int bus, int target)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int status;
 
-	ENTER("qla1280_device_reset");
-
 	mb[0] = MBC_ABORT_TARGET;
 	mb[1] = (bus ? (target | BIT_7) : target) << 8;
 	mb[2] = 1;
@@ -2613,7 +2574,6 @@ qla1280_device_reset(struct scsi_qla_host *ha, int bus, int target)
 	if (status)
 		dprintk(2, "qla1280_device_reset: **** FAILED ****\n");
 
-	LEAVE("qla1280_device_reset");
 	return status;
 }
 
@@ -2635,8 +2595,6 @@ qla1280_abort_command(struct scsi_qla_host *ha, struct srb * sp, int handle)
 	unsigned int bus, target, lun;
 	int status;
 
-	ENTER("qla1280_abort_command");
-
 	bus = SCSI_BUS_32(sp->cmd);
 	target = SCSI_TCN_32(sp->cmd);
 	lun = SCSI_LUN_32(sp->cmd);
@@ -2654,8 +2612,6 @@ qla1280_abort_command(struct scsi_qla_host *ha, struct srb * sp, int handle)
 		sp->flags &= ~SRB_ABORT_PENDING;
 	}
 
-
-	LEAVE("qla1280_abort_command");
 	return status;
 }
 
@@ -2671,16 +2627,12 @@ qla1280_reset_adapter(struct scsi_qla_host *ha)
 {
 	struct device_reg __iomem *reg = ha->iobase;
 
-	ENTER("qla1280_reset_adapter");
-
 	/* Disable ISP chip */
 	ha->flags.online = 0;
 	WRT_REG_WORD(&reg->ictrl, ISP_RESET);
 	WRT_REG_WORD(&reg->host_cmd,
 		     HC_RESET_RISC | HC_RELEASE_RISC | HC_DISABLE_BIOS);
 	RD_REG_WORD(&reg->id_l);	/* Flush PCI write */
-
-	LEAVE("qla1280_reset_adapter");
 }
 
 /*
@@ -2699,8 +2651,6 @@ qla1280_marker(struct scsi_qla_host *ha, int bus, int id, int lun, u8 type)
 {
 	struct mrk_entry *pkt;
 
-	ENTER("qla1280_marker");
-
 	/* Get request packet. */
 	if ((pkt = (struct mrk_entry *) qla1280_req_pkt(ha))) {
 		pkt->entry_type = MARKER_TYPE;
@@ -2712,8 +2662,6 @@ qla1280_marker(struct scsi_qla_host *ha, int bus, int id, int lun, u8 type)
 		/* Issue command to ISP */
 		qla1280_isp_cmd(ha);
 	}
-
-	LEAVE("qla1280_marker");
 }
 
 
@@ -2744,8 +2692,6 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	int seg_cnt;
 	u8 dir;
 
-	ENTER("qla1280_64bit_start_scsi:");
-
 	/* Calculate number of entries and segments required. */
 	req_cnt = 1;
 	seg_cnt = scsi_dma_map(cmd);
@@ -2997,8 +2943,6 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	int seg_cnt;
 	u8 dir;
 
-	ENTER("qla1280_32bit_start_scsi");
-
 	dprintk(1, "32bit_start: cmd=%p sp=%p CDB=%x\n", cmd, sp,
 		cmd->cmnd[0]);
 
@@ -3207,8 +3151,6 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	if (status)
 		dprintk(2, "qla1280_32bit_start_scsi: **** FAILED ****\n");
 
-	LEAVE("qla1280_32bit_start_scsi");
-
 	return status;
 }
 #endif
@@ -3232,8 +3174,6 @@ qla1280_req_pkt(struct scsi_qla_host *ha)
 	int cnt;
 	uint32_t timer;
 
-	ENTER("qla1280_req_pkt");
-
 	/*
 	 * This can be called from interrupt context, damn it!!!
 	 */
@@ -3297,8 +3237,6 @@ qla1280_isp_cmd(struct scsi_qla_host *ha)
 {
 	struct device_reg __iomem *reg = ha->iobase;
 
-	ENTER("qla1280_isp_cmd");
-
 	dprintk(5, "qla1280_isp_cmd: IOCB data:\n");
 	qla1280_dump_buffer(5, (char *)ha->request_ring_ptr,
 			    REQUEST_ENTRY_SIZE);
@@ -3315,8 +3253,6 @@ qla1280_isp_cmd(struct scsi_qla_host *ha)
 	 * Update request index to mailbox4 (Request Queue In).
 	 */
 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
-
-	LEAVE("qla1280_isp_cmd");
 }
 
 /****************************************************************************/
@@ -3342,8 +3278,6 @@ qla1280_isr(struct scsi_qla_host *ha, struct list_head *done_q)
 	uint32_t index;
 	u16 istatus;
 
-	ENTER("qla1280_isr");
-
 	istatus = RD_REG_WORD(&reg->istatus);
 	if (!(istatus & (RISC_INT | PCI_INT)))
 		return;
@@ -3488,11 +3422,11 @@ qla1280_isr(struct scsi_qla_host *ha, struct list_head *done_q)
 	 */
 	if (!(ha->flags.online && !ha->mailbox_wait)) {
 		dprintk(2, "qla1280_isr: Response pointer Error\n");
-		goto out;
+		return;
 	}
 
 	if (mailbox[5] >= RESPONSE_ENTRY_CNT)
-		goto out;
+		return;
 
 	while (ha->rsp_ring_index != mailbox[5]) {
 		pkt = ha->response_ring_ptr;
@@ -3539,9 +3473,6 @@ qla1280_isr(struct scsi_qla_host *ha, struct list_head *done_q)
 			WRT_REG_WORD(&reg->mailbox5, ha->rsp_ring_index);
 		}
 	}
-	
- out:
-	LEAVE("qla1280_isr");
 }
 
 /*
@@ -3556,8 +3487,6 @@ qla1280_rst_aen(struct scsi_qla_host *ha)
 {
 	uint8_t bus;
 
-	ENTER("qla1280_rst_aen");
-
 	if (ha->flags.online && !ha->flags.reset_active &&
 	    !ha->flags.abort_isp_active) {
 		ha->flags.reset_active = 1;
@@ -3574,8 +3503,6 @@ qla1280_rst_aen(struct scsi_qla_host *ha)
 			}
 		}
 	}
-
-	LEAVE("qla1280_rst_aen");
 }
 
 
@@ -3599,8 +3526,6 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 	uint16_t scsi_status = le16_to_cpu(pkt->scsi_status);
 	uint16_t comp_status = le16_to_cpu(pkt->comp_status);
 
-	ENTER("qla1280_status_entry");
-
 	/* Validate handle. */
 	if (handle < MAX_OUTSTANDING_COMMANDS)
 		sp = ha->outstanding_cmds[handle];
@@ -3609,7 +3534,7 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 
 	if (!sp) {
 		printk(KERN_WARNING "qla1280: Status Entry invalid handle\n");
-		goto out;
+		return;
 	}
 
 	/* Free outstanding command slot. */
@@ -3668,8 +3593,6 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 
 	/* Place command on done queue. */
 	list_add_tail(&sp->list, done_q);
- out:
-	LEAVE("qla1280_status_entry");
 }
 
 /*
@@ -3688,8 +3611,6 @@ qla1280_error_entry(struct scsi_qla_host *ha, struct response *pkt,
 	struct srb *sp;
 	uint32_t handle = le32_to_cpu(pkt->handle);
 
-	ENTER("qla1280_error_entry");
-
 	if (pkt->entry_status & BIT_3)
 		dprintk(2, "qla1280_error_entry: BAD PAYLOAD flag error\n");
 	else if (pkt->entry_status & BIT_2)
@@ -3731,8 +3652,6 @@ qla1280_error_entry(struct scsi_qla_host *ha, struct response *pkt,
 		printk(KERN_WARNING "!qla1280: Error Entry invalid handle");
 	}
 #endif
-
-	LEAVE("qla1280_error_entry");
 }
 
 /*
@@ -3754,8 +3673,6 @@ qla1280_abort_isp(struct scsi_qla_host *ha)
 	int cnt;
 	int bus;
 
-	ENTER("qla1280_abort_isp");
-
 	if (ha->flags.abort_isp_active || !ha->flags.online)
 		goto out;
 	
@@ -3807,7 +3724,6 @@ qla1280_abort_isp(struct scsi_qla_host *ha)
 		dprintk(2, "qla1280_abort_isp: **** FAILED ****\n");
 	}
 
-	LEAVE("qla1280_abort_isp");
 	return status;
 }
 
-- 
2.43.0

