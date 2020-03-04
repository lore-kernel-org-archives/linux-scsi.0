Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0593FC3F2D8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68D6720842
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgCDFaI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 00:30:08 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40134 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgCDFaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 00:30:07 -0500
Received: by mail-pf1-f196.google.com with SMTP id l184so357754pfl.7
        for <linux-scsi@vger.kernel.org>; Tue, 03 Mar 2020 21:30:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/1but4mxhJ3jdSLZ6aM3BS0kC+SdMRnu0mZ4iRuo41M=;
        b=WHtqppJ8Uofvuiv3xTeSswjVcG23l7Cg6yU315ePk1/a9hYF20n5nCTU/h7YspcCtM
         yUxqvPBywPNXyEHKjQivkyLOTCe7Wq5Bj4OlfPBPE0IIoqaCDqf6Agl5Wu2tJVocTpnA
         9KDsd3KM0+AgoUAXpYCGdPMc9T+ZBceqSSmsL1gx6vQZd+ocmjX68ww3e06fqKjPWY1k
         Oo0DUsEu46IYTehZUW2TKzSWMWZ2GTZkRGjQ9QhRSI5cG+qthdq5f+X1Hw1214Qzqbu5
         2r8FA4QKUdHiv3ePaFGRih6YN9abnIYkER+GUlh9zSKK6WoLTiMEet3f9i4qu+xCWRzg
         uhGw==
X-Gm-Message-State: ANhLgQ2YHY5oqOeNiFKLqfhoBJelTq8Ob19Fyjh31g0H26sDnI+Ydq9N
        KTw84ak2Vp66CJ8W/uMQMvU=
X-Google-Smtp-Source: ADFU+vsEVP6/MGe+vd2oSsYHSepyqGhUWWTYTkV6L/eqmpSKHiZNu9Z5GgyyXeRDb0H1dMwe5ar6QA==
X-Received: by 2002:aa7:9a8c:: with SMTP id w12mr1423000pfi.218.1583299802547;
        Tue, 03 Mar 2020 21:30:02 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:a86e:343d:2eff:fb40])
        by smtp.gmail.com with ESMTPSA id p94sm972784pjp.15.2020.03.03.21.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 21:30:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 6/6] qla2xxx: Change {RD,WRT}_REG_*() function names from upper case into lower case
Date:   Tue,  3 Mar 2020 21:29:45 -0800
Message-Id: <20200304052945.23250-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304052945.23250-1-bvanassche@acm.org>
References: <20200304052945.23250-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was suggested by Daniel Wagner.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c    | 582 +++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_def.h    |  30 +-
 drivers/scsi/qla2xxx/qla_init.c   | 204 +++++------
 drivers/scsi/qla2xxx/qla_inline.h |   6 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |  64 ++--
 drivers/scsi/qla2xxx/qla_isr.c    | 128 +++----
 drivers/scsi/qla2xxx/qla_mbx.c    |  74 ++--
 drivers/scsi/qla2xxx/qla_mr.c     |  94 ++---
 drivers/scsi/qla2xxx/qla_mr.h     |  24 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |   4 +-
 drivers/scsi/qla2xxx/qla_nx.c     |  68 ++--
 drivers/scsi/qla2xxx/qla_nx2.c    |  12 +-
 drivers/scsi/qla2xxx/qla_os.c     |  26 +-
 drivers/scsi/qla2xxx/qla_sup.c    | 270 +++++++-------
 drivers/scsi/qla2xxx/qla_target.c |  10 +-
 drivers/scsi/qla2xxx/qla_tmpl.c   |   8 +-
 16 files changed, 802 insertions(+), 802 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 62d6ff5e5ec5..3f16636a6b42 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -124,26 +124,26 @@ qla27xx_dump_mpi_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
 		if (i + dwords > ram_dwords)
 			dwords = ram_dwords - i;
 
-		WRT_REG_WORD(&reg->mailbox0, MBC_LOAD_DUMP_MPI_RAM);
-		WRT_REG_WORD(&reg->mailbox1, LSW(addr));
-		WRT_REG_WORD(&reg->mailbox8, MSW(addr));
+		wrt_reg_word(&reg->mailbox0, MBC_LOAD_DUMP_MPI_RAM);
+		wrt_reg_word(&reg->mailbox1, LSW(addr));
+		wrt_reg_word(&reg->mailbox8, MSW(addr));
 
-		WRT_REG_WORD(&reg->mailbox2, MSW(LSD(dump_dma)));
-		WRT_REG_WORD(&reg->mailbox3, LSW(LSD(dump_dma)));
-		WRT_REG_WORD(&reg->mailbox6, MSW(MSD(dump_dma)));
-		WRT_REG_WORD(&reg->mailbox7, LSW(MSD(dump_dma)));
+		wrt_reg_word(&reg->mailbox2, MSW(LSD(dump_dma)));
+		wrt_reg_word(&reg->mailbox3, LSW(LSD(dump_dma)));
+		wrt_reg_word(&reg->mailbox6, MSW(MSD(dump_dma)));
+		wrt_reg_word(&reg->mailbox7, LSW(MSD(dump_dma)));
 
-		WRT_REG_WORD(&reg->mailbox4, MSW(dwords));
-		WRT_REG_WORD(&reg->mailbox5, LSW(dwords));
+		wrt_reg_word(&reg->mailbox4, MSW(dwords));
+		wrt_reg_word(&reg->mailbox5, LSW(dwords));
 
-		WRT_REG_WORD(&reg->mailbox9, 0);
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
+		wrt_reg_word(&reg->mailbox9, 0);
+		wrt_reg_dword(&reg->hccr, HCCRX_SET_HOST_INT);
 
 		ha->flags.mbox_int = 0;
 		while (timer--) {
 			udelay(5);
 
-			stat = RD_REG_DWORD(&reg->host_status);
+			stat = rd_reg_dword(&reg->host_status);
 			/* Check for pending interrupts. */
 			if (!(stat & HSRX_RISC_INT))
 				continue;
@@ -153,15 +153,15 @@ qla27xx_dump_mpi_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
 			    stat != 0x10 && stat != 0x11) {
 
 				/* Clear this intr; it wasn't a mailbox intr */
-				WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-				RD_REG_DWORD(&reg->hccr);
+				wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
+				rd_reg_dword(&reg->hccr);
 				continue;
 			}
 
 			set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-			rval = RD_REG_WORD(&reg->mailbox0) & MBS_MASK;
-			WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-			RD_REG_DWORD(&reg->hccr);
+			rval = rd_reg_word(&reg->mailbox0) & MBS_MASK;
+			wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
+			rd_reg_dword(&reg->hccr);
 			break;
 		}
 		ha->flags.mbox_int = 1;
@@ -204,23 +204,23 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
 		if (i + dwords > ram_dwords)
 			dwords = ram_dwords - i;
 
-		WRT_REG_WORD(&reg->mailbox0, MBC_DUMP_RISC_RAM_EXTENDED);
-		WRT_REG_WORD(&reg->mailbox1, LSW(addr));
-		WRT_REG_WORD(&reg->mailbox8, MSW(addr));
+		wrt_reg_word(&reg->mailbox0, MBC_DUMP_RISC_RAM_EXTENDED);
+		wrt_reg_word(&reg->mailbox1, LSW(addr));
+		wrt_reg_word(&reg->mailbox8, MSW(addr));
 
-		WRT_REG_WORD(&reg->mailbox2, MSW(LSD(dump_dma)));
-		WRT_REG_WORD(&reg->mailbox3, LSW(LSD(dump_dma)));
-		WRT_REG_WORD(&reg->mailbox6, MSW(MSD(dump_dma)));
-		WRT_REG_WORD(&reg->mailbox7, LSW(MSD(dump_dma)));
+		wrt_reg_word(&reg->mailbox2, MSW(LSD(dump_dma)));
+		wrt_reg_word(&reg->mailbox3, LSW(LSD(dump_dma)));
+		wrt_reg_word(&reg->mailbox6, MSW(MSD(dump_dma)));
+		wrt_reg_word(&reg->mailbox7, LSW(MSD(dump_dma)));
 
-		WRT_REG_WORD(&reg->mailbox4, MSW(dwords));
-		WRT_REG_WORD(&reg->mailbox5, LSW(dwords));
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
+		wrt_reg_word(&reg->mailbox4, MSW(dwords));
+		wrt_reg_word(&reg->mailbox5, LSW(dwords));
+		wrt_reg_dword(&reg->hccr, HCCRX_SET_HOST_INT);
 
 		ha->flags.mbox_int = 0;
 		while (timer--) {
 			udelay(5);
-			stat = RD_REG_DWORD(&reg->host_status);
+			stat = rd_reg_dword(&reg->host_status);
 
 			/* Check for pending interrupts. */
 			if (!(stat & HSRX_RISC_INT))
@@ -229,15 +229,15 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
 			stat &= 0xff;
 			if (stat != 0x1 && stat != 0x2 &&
 			    stat != 0x10 && stat != 0x11) {
-				WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-				RD_REG_DWORD(&reg->hccr);
+				wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
+				rd_reg_dword(&reg->hccr);
 				continue;
 			}
 
 			set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-			rval = RD_REG_WORD(&reg->mailbox0) & MBS_MASK;
-			WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-			RD_REG_DWORD(&reg->hccr);
+			rval = rd_reg_word(&reg->mailbox0) & MBS_MASK;
+			wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
+			rd_reg_dword(&reg->hccr);
 			break;
 		}
 		ha->flags.mbox_int = 1;
@@ -290,10 +290,10 @@ qla24xx_read_window(struct device_reg_24xx __iomem *reg, uint32_t iobase,
 {
 	__le32 __iomem *dmp_reg;
 
-	WRT_REG_DWORD(&reg->iobase_addr, iobase);
+	wrt_reg_dword(&reg->iobase_addr, iobase);
 	dmp_reg = &reg->iobase_window;
 	for ( ; count--; dmp_reg++)
-		*buf++ = htonl(RD_REG_DWORD(dmp_reg));
+		*buf++ = htonl(rd_reg_dword(dmp_reg));
 
 	return buf;
 }
@@ -301,11 +301,11 @@ qla24xx_read_window(struct device_reg_24xx __iomem *reg, uint32_t iobase,
 void
 qla24xx_pause_risc(struct device_reg_24xx __iomem *reg, struct qla_hw_data *ha)
 {
-	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
+	wrt_reg_dword(&reg->hccr, HCCRX_SET_RISC_PAUSE);
 
 	/* 100 usec delay is sufficient enough for hardware to pause RISC */
 	udelay(100);
-	if (RD_REG_DWORD(&reg->host_status) & HSRX_RISC_PAUSED)
+	if (rd_reg_dword(&reg->host_status) & HSRX_RISC_PAUSED)
 		set_bit(RISC_PAUSE_CMPL, &ha->fw_dump_cap_flags);
 }
 
@@ -322,17 +322,17 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 	 * Driver can proceed with the reset sequence after waiting
 	 * for a timeout period.
 	 */
-	WRT_REG_DWORD(&reg->ctrl_status, CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+	wrt_reg_dword(&reg->ctrl_status, CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
 	for (cnt = 0; cnt < 30000; cnt++) {
-		if ((RD_REG_DWORD(&reg->ctrl_status) & CSRX_DMA_ACTIVE) == 0)
+		if ((rd_reg_dword(&reg->ctrl_status) & CSRX_DMA_ACTIVE) == 0)
 			break;
 
 		udelay(10);
 	}
-	if (!(RD_REG_DWORD(&reg->ctrl_status) & CSRX_DMA_ACTIVE))
+	if (!(rd_reg_dword(&reg->ctrl_status) & CSRX_DMA_ACTIVE))
 		set_bit(DMA_SHUTDOWN_CMPL, &ha->fw_dump_cap_flags);
 
-	WRT_REG_DWORD(&reg->ctrl_status,
+	wrt_reg_dword(&reg->ctrl_status,
 	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
 
@@ -340,19 +340,19 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 
 	/* Wait for soft-reset to complete. */
 	for (cnt = 0; cnt < 30000; cnt++) {
-		if ((RD_REG_DWORD(&reg->ctrl_status) &
+		if ((rd_reg_dword(&reg->ctrl_status) &
 		    CSRX_ISP_SOFT_RESET) == 0)
 			break;
 
 		udelay(10);
 	}
-	if (!(RD_REG_DWORD(&reg->ctrl_status) & CSRX_ISP_SOFT_RESET))
+	if (!(rd_reg_dword(&reg->ctrl_status) & CSRX_ISP_SOFT_RESET))
 		set_bit(ISP_RESET_CMPL, &ha->fw_dump_cap_flags);
 
-	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
-	RD_REG_DWORD(&reg->hccr);             /* PCI Posting. */
+	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_RESET);
+	rd_reg_dword(&reg->hccr);             /* PCI Posting. */
 
-	for (cnt = 10000; RD_REG_WORD(&reg->mailbox0) != 0 &&
+	for (cnt = 10000; rd_reg_word(&reg->mailbox0) != 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		if (cnt)
 			udelay(10);
@@ -397,11 +397,11 @@ qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be16 *ram,
 		WRT_MAILBOX_REG(ha, reg, 7, LSW(MSD(dump_dma)));
 
 		WRT_MAILBOX_REG(ha, reg, 4, words);
-		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
+		wrt_reg_word(&reg->hccr, HCCR_SET_HOST_INT);
 
 		for (timer = 6000000; timer; timer--) {
 			/* Check for pending interrupts. */
-			stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
+			stat = rd_reg_dword(&reg->u.isp2300.host_status);
 			if (stat & HSR_RISC_INT) {
 				stat &= 0xff;
 
@@ -412,10 +412,10 @@ qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be16 *ram,
 					mb0 = RD_MAILBOX_REG(ha, reg, 0);
 
 					/* Release mailbox registers. */
-					WRT_REG_WORD(&reg->semaphore, 0);
-					WRT_REG_WORD(&reg->hccr,
+					wrt_reg_word(&reg->semaphore, 0);
+					wrt_reg_word(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
-					RD_REG_WORD(&reg->hccr);
+					rd_reg_word(&reg->hccr);
 					break;
 				} else if (stat == 0x10 || stat == 0x11) {
 					set_bit(MBX_INTERRUPT,
@@ -423,15 +423,15 @@ qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be16 *ram,
 
 					mb0 = RD_MAILBOX_REG(ha, reg, 0);
 
-					WRT_REG_WORD(&reg->hccr,
+					wrt_reg_word(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
-					RD_REG_WORD(&reg->hccr);
+					rd_reg_word(&reg->hccr);
 					break;
 				}
 
 				/* clear this intr; it wasn't a mailbox intr */
-				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-				RD_REG_WORD(&reg->hccr);
+				wrt_reg_word(&reg->hccr, HCCR_CLR_RISC_INT);
+				rd_reg_word(&reg->hccr);
 			}
 			udelay(5);
 		}
@@ -456,7 +456,7 @@ qla2xxx_read_window(struct device_reg_2xxx __iomem *reg, uint32_t count,
 	__le16 __iomem *dmp_reg = &reg->u.isp2300.fb_cmd;
 
 	for ( ; count--; dmp_reg++)
-		*buf++ = htons(RD_REG_WORD(dmp_reg));
+		*buf++ = htons(rd_reg_word(dmp_reg));
 }
 
 static inline void *
@@ -683,13 +683,13 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, __be32 **last_chain)
 		reg = ISP_QUE_REG(ha, cnt);
 		que_idx = cnt * 4;
 		mq->qregs[que_idx] =
-		    htonl(RD_REG_DWORD(&reg->isp25mq.req_q_in));
+		    htonl(rd_reg_dword(&reg->isp25mq.req_q_in));
 		mq->qregs[que_idx+1] =
-		    htonl(RD_REG_DWORD(&reg->isp25mq.req_q_out));
+		    htonl(rd_reg_dword(&reg->isp25mq.req_q_out));
 		mq->qregs[que_idx+2] =
-		    htonl(RD_REG_DWORD(&reg->isp25mq.rsp_q_in));
+		    htonl(rd_reg_dword(&reg->isp25mq.rsp_q_in));
 		mq->qregs[que_idx+3] =
-		    htonl(RD_REG_DWORD(&reg->isp25mq.rsp_q_out));
+		    htonl(rd_reg_dword(&reg->isp25mq.rsp_q_out));
 	}
 
 	return ptr + sizeof(struct qla2xxx_mq_chain);
@@ -756,13 +756,13 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla2xxx_prep_dump(ha, ha->fw_dump);
 
 	rval = QLA_SUCCESS;
-	fw->hccr = htons(RD_REG_WORD(&reg->hccr));
+	fw->hccr = htons(rd_reg_word(&reg->hccr));
 
 	/* Pause RISC. */
-	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
+	wrt_reg_word(&reg->hccr, HCCR_PAUSE_RISC);
 	if (IS_QLA2300(ha)) {
 		for (cnt = 30000;
-		    (RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) == 0 &&
+		    (rd_reg_word(&reg->hccr) & HCCR_RISC_PAUSE) == 0 &&
 			rval == QLA_SUCCESS; cnt--) {
 			if (cnt)
 				udelay(100);
@@ -770,74 +770,74 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 				rval = QLA_FUNCTION_TIMEOUT;
 		}
 	} else {
-		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
+		rd_reg_word(&reg->hccr);		/* PCI Posting. */
 		udelay(10);
 	}
 
 	if (rval == QLA_SUCCESS) {
 		dmp_reg = &reg->flash_address;
 		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++, dmp_reg++)
-			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
+			fw->pbiu_reg[cnt] = htons(rd_reg_word(dmp_reg));
 
 		dmp_reg = &reg->u.isp2300.req_q_in;
 		for (cnt = 0; cnt < sizeof(fw->risc_host_reg) / 2;
 		    cnt++, dmp_reg++)
-			fw->risc_host_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
+			fw->risc_host_reg[cnt] = htons(rd_reg_word(dmp_reg));
 
 		dmp_reg = &reg->u.isp2300.mailbox0;
 		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2;
 		    cnt++, dmp_reg++)
-			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
+			fw->mailbox_reg[cnt] = htons(rd_reg_word(dmp_reg));
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x40);
+		wrt_reg_word(&reg->ctrl_status, 0x40);
 		qla2xxx_read_window(reg, 32, fw->resp_dma_reg);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x50);
+		wrt_reg_word(&reg->ctrl_status, 0x50);
 		qla2xxx_read_window(reg, 48, fw->dma_reg);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x00);
+		wrt_reg_word(&reg->ctrl_status, 0x00);
 		dmp_reg = &reg->risc_hw;
 		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2;
 		    cnt++, dmp_reg++)
-			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
+			fw->risc_hdw_reg[cnt] = htons(rd_reg_word(dmp_reg));
 
-		WRT_REG_WORD(&reg->pcr, 0x2000);
+		wrt_reg_word(&reg->pcr, 0x2000);
 		qla2xxx_read_window(reg, 16, fw->risc_gp0_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2200);
+		wrt_reg_word(&reg->pcr, 0x2200);
 		qla2xxx_read_window(reg, 16, fw->risc_gp1_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2400);
+		wrt_reg_word(&reg->pcr, 0x2400);
 		qla2xxx_read_window(reg, 16, fw->risc_gp2_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2600);
+		wrt_reg_word(&reg->pcr, 0x2600);
 		qla2xxx_read_window(reg, 16, fw->risc_gp3_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2800);
+		wrt_reg_word(&reg->pcr, 0x2800);
 		qla2xxx_read_window(reg, 16, fw->risc_gp4_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2A00);
+		wrt_reg_word(&reg->pcr, 0x2A00);
 		qla2xxx_read_window(reg, 16, fw->risc_gp5_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2C00);
+		wrt_reg_word(&reg->pcr, 0x2C00);
 		qla2xxx_read_window(reg, 16, fw->risc_gp6_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2E00);
+		wrt_reg_word(&reg->pcr, 0x2E00);
 		qla2xxx_read_window(reg, 16, fw->risc_gp7_reg);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x10);
+		wrt_reg_word(&reg->ctrl_status, 0x10);
 		qla2xxx_read_window(reg, 64, fw->frame_buf_hdw_reg);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x20);
+		wrt_reg_word(&reg->ctrl_status, 0x20);
 		qla2xxx_read_window(reg, 64, fw->fpm_b0_reg);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x30);
+		wrt_reg_word(&reg->ctrl_status, 0x30);
 		qla2xxx_read_window(reg, 64, fw->fpm_b1_reg);
 
 		/* Reset RISC. */
-		WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+		wrt_reg_word(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
 		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_WORD(&reg->ctrl_status) &
+			if ((rd_reg_word(&reg->ctrl_status) &
 			    CSR_ISP_SOFT_RESET) == 0)
 				break;
 
@@ -929,11 +929,11 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla2xxx_prep_dump(ha, ha->fw_dump);
 
 	rval = QLA_SUCCESS;
-	fw->hccr = htons(RD_REG_WORD(&reg->hccr));
+	fw->hccr = htons(rd_reg_word(&reg->hccr));
 
 	/* Pause RISC. */
-	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
-	for (cnt = 30000; (RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) == 0 &&
+	wrt_reg_word(&reg->hccr, HCCR_PAUSE_RISC);
+	for (cnt = 30000; (rd_reg_word(&reg->hccr) & HCCR_RISC_PAUSE) == 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		if (cnt)
 			udelay(100);
@@ -943,60 +943,60 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	if (rval == QLA_SUCCESS) {
 		dmp_reg = &reg->flash_address;
 		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++, dmp_reg++)
-			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
+			fw->pbiu_reg[cnt] = htons(rd_reg_word(dmp_reg));
 
 		dmp_reg = &reg->u.isp2100.mailbox0;
 		for (cnt = 0; cnt < ha->mbx_count; cnt++, dmp_reg++) {
 			if (cnt == 8)
 				dmp_reg = &reg->u_end.isp2200.mailbox8;
 
-			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
+			fw->mailbox_reg[cnt] = htons(rd_reg_word(dmp_reg));
 		}
 
 		dmp_reg = &reg->u.isp2100.unused_2[0];
 		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++, dmp_reg++)
-			fw->dma_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
+			fw->dma_reg[cnt] = htons(rd_reg_word(dmp_reg));
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x00);
+		wrt_reg_word(&reg->ctrl_status, 0x00);
 		dmp_reg = &reg->risc_hw;
 		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++, dmp_reg++)
-			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
+			fw->risc_hdw_reg[cnt] = htons(rd_reg_word(dmp_reg));
 
-		WRT_REG_WORD(&reg->pcr, 0x2000);
+		wrt_reg_word(&reg->pcr, 0x2000);
 		qla2xxx_read_window(reg, 16, fw->risc_gp0_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2100);
+		wrt_reg_word(&reg->pcr, 0x2100);
 		qla2xxx_read_window(reg, 16, fw->risc_gp1_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2200);
+		wrt_reg_word(&reg->pcr, 0x2200);
 		qla2xxx_read_window(reg, 16, fw->risc_gp2_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2300);
+		wrt_reg_word(&reg->pcr, 0x2300);
 		qla2xxx_read_window(reg, 16, fw->risc_gp3_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2400);
+		wrt_reg_word(&reg->pcr, 0x2400);
 		qla2xxx_read_window(reg, 16, fw->risc_gp4_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2500);
+		wrt_reg_word(&reg->pcr, 0x2500);
 		qla2xxx_read_window(reg, 16, fw->risc_gp5_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2600);
+		wrt_reg_word(&reg->pcr, 0x2600);
 		qla2xxx_read_window(reg, 16, fw->risc_gp6_reg);
 
-		WRT_REG_WORD(&reg->pcr, 0x2700);
+		wrt_reg_word(&reg->pcr, 0x2700);
 		qla2xxx_read_window(reg, 16, fw->risc_gp7_reg);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x10);
+		wrt_reg_word(&reg->ctrl_status, 0x10);
 		qla2xxx_read_window(reg, 16, fw->frame_buf_hdw_reg);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x20);
+		wrt_reg_word(&reg->ctrl_status, 0x20);
 		qla2xxx_read_window(reg, 64, fw->fpm_b0_reg);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x30);
+		wrt_reg_word(&reg->ctrl_status, 0x30);
 		qla2xxx_read_window(reg, 64, fw->fpm_b1_reg);
 
 		/* Reset the ISP. */
-		WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+		wrt_reg_word(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
 	}
 
 	for (cnt = 30000; RD_MAILBOX_REG(ha, reg, 0) != 0 &&
@@ -1009,11 +1009,11 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Pause RISC. */
 	if (rval == QLA_SUCCESS && (IS_QLA2200(ha) || (IS_QLA2100(ha) &&
-	    (RD_REG_WORD(&reg->mctr) & (BIT_1 | BIT_0)) != 0))) {
+	    (rd_reg_word(&reg->mctr) & (BIT_1 | BIT_0)) != 0))) {
 
-		WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
+		wrt_reg_word(&reg->hccr, HCCR_PAUSE_RISC);
 		for (cnt = 30000;
-		    (RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) == 0 &&
+		    (rd_reg_word(&reg->hccr) & HCCR_RISC_PAUSE) == 0 &&
 		    rval == QLA_SUCCESS; cnt--) {
 			if (cnt)
 				udelay(100);
@@ -1023,13 +1023,13 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		if (rval == QLA_SUCCESS) {
 			/* Set memory configuration and timing. */
 			if (IS_QLA2100(ha))
-				WRT_REG_WORD(&reg->mctr, 0xf1);
+				wrt_reg_word(&reg->mctr, 0xf1);
 			else
-				WRT_REG_WORD(&reg->mctr, 0xf2);
-			RD_REG_WORD(&reg->mctr);	/* PCI Posting. */
+				wrt_reg_word(&reg->mctr, 0xf2);
+			rd_reg_word(&reg->mctr);	/* PCI Posting. */
 
 			/* Release RISC. */
-			WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+			wrt_reg_word(&reg->hccr, HCCR_RELEASE_RISC);
 		}
 	}
 
@@ -1042,26 +1042,26 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	for (cnt = 0; cnt < sizeof(fw->risc_ram) / 2 && rval == QLA_SUCCESS;
 	    cnt++, risc_address++) {
  		WRT_MAILBOX_REG(ha, reg, 1, risc_address);
-		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
+		wrt_reg_word(&reg->hccr, HCCR_SET_HOST_INT);
 
 		for (timer = 6000000; timer != 0; timer--) {
 			/* Check for pending interrupts. */
-			if (RD_REG_WORD(&reg->istatus) & ISR_RISC_INT) {
-				if (RD_REG_WORD(&reg->semaphore) & BIT_0) {
+			if (rd_reg_word(&reg->istatus) & ISR_RISC_INT) {
+				if (rd_reg_word(&reg->semaphore) & BIT_0) {
 					set_bit(MBX_INTERRUPT,
 					    &ha->mbx_cmd_flags);
 
 					mb0 = RD_MAILBOX_REG(ha, reg, 0);
 					mb2 = RD_MAILBOX_REG(ha, reg, 2);
 
-					WRT_REG_WORD(&reg->semaphore, 0);
-					WRT_REG_WORD(&reg->hccr,
+					wrt_reg_word(&reg->semaphore, 0);
+					wrt_reg_word(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
-					RD_REG_WORD(&reg->hccr);
+					rd_reg_word(&reg->hccr);
 					break;
 				}
-				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-				RD_REG_WORD(&reg->hccr);
+				wrt_reg_word(&reg->hccr, HCCR_CLR_RISC_INT);
+				rd_reg_word(&reg->hccr);
 			}
 			udelay(5);
 		}
@@ -1133,7 +1133,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	fw = &ha->fw_dump->isp.isp24;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
 
-	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
+	fw->host_status = htonl(rd_reg_dword(&reg->host_status));
 
 	/*
 	 * Pause RISC. No need to track timeout, as resetting the chip
@@ -1144,40 +1144,40 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
 	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
-		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
+		fw->host_reg[cnt] = htonl(rd_reg_dword(dmp_reg));
 
 	/* Disable interrupts. */
-	WRT_REG_DWORD(&reg->ictrl, 0);
-	RD_REG_DWORD(&reg->ictrl);
+	wrt_reg_dword(&reg->ictrl, 0);
+	rd_reg_dword(&reg->ictrl);
 
 	/* Shadow registers. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-	RD_REG_DWORD(&reg->iobase_addr);
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
-	fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_addr, 0x0F70);
+	rd_reg_dword(&reg->iobase_addr);
+	wrt_reg_dword(&reg->iobase_select, 0xB0000000);
+	fw->shadow_reg[0] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
-	fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0100000);
+	fw->shadow_reg[1] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
-	fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0200000);
+	fw->shadow_reg[2] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
-	fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0300000);
+	fw->shadow_reg[3] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
-	fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0400000);
+	fw->shadow_reg[4] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
-	fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0500000);
+	fw->shadow_reg[5] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
-	fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0600000);
+	fw->shadow_reg[6] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
 	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
-		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
+		fw->mailbox_reg[cnt] = htons(rd_reg_word(mbx_reg));
 
 	/* Transfer sequence registers. */
 	iter_reg = fw->xseq_gp_reg;
@@ -1216,19 +1216,19 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	iter_reg = qla24xx_read_window(reg, 0x7200, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	iter_reg = fw->resp0_dma_reg;
 	iter_reg = qla24xx_read_window(reg, 0x7300, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	iter_reg = fw->req1_dma_reg;
 	iter_reg = qla24xx_read_window(reg, 0x7400, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	/* Transmit DMA registers. */
 	iter_reg = fw->xmt0_dma_reg;
@@ -1389,7 +1389,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla2xxx_prep_dump(ha, ha->fw_dump);
 	ha->fw_dump->version = htonl(2);
 
-	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
+	fw->host_status = htonl(rd_reg_dword(&reg->host_status));
 
 	/*
 	 * Pause RISC. No need to track timeout, as resetting the chip
@@ -1403,73 +1403,73 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla24xx_read_window(reg, 0x7010, 16, iter_reg);
 
 	/* PCIe registers. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x7C00);
-	RD_REG_DWORD(&reg->iobase_addr);
-	WRT_REG_DWORD(&reg->iobase_window, 0x01);
+	wrt_reg_dword(&reg->iobase_addr, 0x7C00);
+	rd_reg_dword(&reg->iobase_addr);
+	wrt_reg_dword(&reg->iobase_window, 0x01);
 	dmp_reg = &reg->iobase_c4;
-	fw->pcie_regs[0] = htonl(RD_REG_DWORD(dmp_reg));
+	fw->pcie_regs[0] = htonl(rd_reg_dword(dmp_reg));
 	dmp_reg++;
-	fw->pcie_regs[1] = htonl(RD_REG_DWORD(dmp_reg));
+	fw->pcie_regs[1] = htonl(rd_reg_dword(dmp_reg));
 	dmp_reg++;
-	fw->pcie_regs[2] = htonl(RD_REG_DWORD(dmp_reg));
-	fw->pcie_regs[3] = htonl(RD_REG_DWORD(&reg->iobase_window));
+	fw->pcie_regs[2] = htonl(rd_reg_dword(dmp_reg));
+	fw->pcie_regs[3] = htonl(rd_reg_dword(&reg->iobase_window));
 
-	WRT_REG_DWORD(&reg->iobase_window, 0x00);
-	RD_REG_DWORD(&reg->iobase_window);
+	wrt_reg_dword(&reg->iobase_window, 0x00);
+	rd_reg_dword(&reg->iobase_window);
 
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
 	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
-		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
+		fw->host_reg[cnt] = htonl(rd_reg_dword(dmp_reg));
 
 	/* Disable interrupts. */
-	WRT_REG_DWORD(&reg->ictrl, 0);
-	RD_REG_DWORD(&reg->ictrl);
+	wrt_reg_dword(&reg->ictrl, 0);
+	rd_reg_dword(&reg->ictrl);
 
 	/* Shadow registers. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-	RD_REG_DWORD(&reg->iobase_addr);
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
-	fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_addr, 0x0F70);
+	rd_reg_dword(&reg->iobase_addr);
+	wrt_reg_dword(&reg->iobase_select, 0xB0000000);
+	fw->shadow_reg[0] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
-	fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0100000);
+	fw->shadow_reg[1] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
-	fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0200000);
+	fw->shadow_reg[2] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
-	fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0300000);
+	fw->shadow_reg[3] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
-	fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0400000);
+	fw->shadow_reg[4] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
-	fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0500000);
+	fw->shadow_reg[5] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
-	fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0600000);
+	fw->shadow_reg[6] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0700000);
-	fw->shadow_reg[7] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0700000);
+	fw->shadow_reg[7] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0800000);
-	fw->shadow_reg[8] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0800000);
+	fw->shadow_reg[8] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0900000);
-	fw->shadow_reg[9] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0900000);
+	fw->shadow_reg[9] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0A00000);
-	fw->shadow_reg[10] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0A00000);
+	fw->shadow_reg[10] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
 	/* RISC I/O register. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x0010);
-	fw->risc_io_reg = htonl(RD_REG_DWORD(&reg->iobase_window));
+	wrt_reg_dword(&reg->iobase_addr, 0x0010);
+	fw->risc_io_reg = htonl(rd_reg_dword(&reg->iobase_window));
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
 	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
-		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
+		fw->mailbox_reg[cnt] = htons(rd_reg_word(mbx_reg));
 
 	/* Transfer sequence registers. */
 	iter_reg = fw->xseq_gp_reg;
@@ -1533,19 +1533,19 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	iter_reg = qla24xx_read_window(reg, 0x7200, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	iter_reg = fw->resp0_dma_reg;
 	iter_reg = qla24xx_read_window(reg, 0x7300, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	iter_reg = fw->req1_dma_reg;
 	iter_reg = qla24xx_read_window(reg, 0x7400, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	/* Transmit DMA registers. */
 	iter_reg = fw->xmt0_dma_reg;
@@ -1713,7 +1713,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	fw = &ha->fw_dump->isp.isp81;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
 
-	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
+	fw->host_status = htonl(rd_reg_dword(&reg->host_status));
 
 	/*
 	 * Pause RISC. No need to track timeout, as resetting the chip
@@ -1727,73 +1727,73 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla24xx_read_window(reg, 0x7010, 16, iter_reg);
 
 	/* PCIe registers. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x7C00);
-	RD_REG_DWORD(&reg->iobase_addr);
-	WRT_REG_DWORD(&reg->iobase_window, 0x01);
+	wrt_reg_dword(&reg->iobase_addr, 0x7C00);
+	rd_reg_dword(&reg->iobase_addr);
+	wrt_reg_dword(&reg->iobase_window, 0x01);
 	dmp_reg = &reg->iobase_c4;
-	fw->pcie_regs[0] = htonl(RD_REG_DWORD(dmp_reg));
+	fw->pcie_regs[0] = htonl(rd_reg_dword(dmp_reg));
 	dmp_reg++;
-	fw->pcie_regs[1] = htonl(RD_REG_DWORD(dmp_reg));
+	fw->pcie_regs[1] = htonl(rd_reg_dword(dmp_reg));
 	dmp_reg++;
-	fw->pcie_regs[2] = htonl(RD_REG_DWORD(dmp_reg));
-	fw->pcie_regs[3] = htonl(RD_REG_DWORD(&reg->iobase_window));
+	fw->pcie_regs[2] = htonl(rd_reg_dword(dmp_reg));
+	fw->pcie_regs[3] = htonl(rd_reg_dword(&reg->iobase_window));
 
-	WRT_REG_DWORD(&reg->iobase_window, 0x00);
-	RD_REG_DWORD(&reg->iobase_window);
+	wrt_reg_dword(&reg->iobase_window, 0x00);
+	rd_reg_dword(&reg->iobase_window);
 
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
 	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
-		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
+		fw->host_reg[cnt] = htonl(rd_reg_dword(dmp_reg));
 
 	/* Disable interrupts. */
-	WRT_REG_DWORD(&reg->ictrl, 0);
-	RD_REG_DWORD(&reg->ictrl);
+	wrt_reg_dword(&reg->ictrl, 0);
+	rd_reg_dword(&reg->ictrl);
 
 	/* Shadow registers. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-	RD_REG_DWORD(&reg->iobase_addr);
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
-	fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_addr, 0x0F70);
+	rd_reg_dword(&reg->iobase_addr);
+	wrt_reg_dword(&reg->iobase_select, 0xB0000000);
+	fw->shadow_reg[0] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
-	fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0100000);
+	fw->shadow_reg[1] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
-	fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0200000);
+	fw->shadow_reg[2] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
-	fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0300000);
+	fw->shadow_reg[3] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
-	fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0400000);
+	fw->shadow_reg[4] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
-	fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0500000);
+	fw->shadow_reg[5] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
-	fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0600000);
+	fw->shadow_reg[6] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0700000);
-	fw->shadow_reg[7] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0700000);
+	fw->shadow_reg[7] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0800000);
-	fw->shadow_reg[8] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0800000);
+	fw->shadow_reg[8] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0900000);
-	fw->shadow_reg[9] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0900000);
+	fw->shadow_reg[9] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0A00000);
-	fw->shadow_reg[10] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0A00000);
+	fw->shadow_reg[10] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
 	/* RISC I/O register. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x0010);
-	fw->risc_io_reg = htonl(RD_REG_DWORD(&reg->iobase_window));
+	wrt_reg_dword(&reg->iobase_addr, 0x0010);
+	fw->risc_io_reg = htonl(rd_reg_dword(&reg->iobase_window));
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
 	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
-		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
+		fw->mailbox_reg[cnt] = htons(rd_reg_word(mbx_reg));
 
 	/* Transfer sequence registers. */
 	iter_reg = fw->xseq_gp_reg;
@@ -1857,19 +1857,19 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	iter_reg = qla24xx_read_window(reg, 0x7200, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	iter_reg = fw->resp0_dma_reg;
 	iter_reg = qla24xx_read_window(reg, 0x7300, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	iter_reg = fw->req1_dma_reg;
 	iter_reg = qla24xx_read_window(reg, 0x7400, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	/* Transmit DMA registers. */
 	iter_reg = fw->xmt0_dma_reg;
@@ -2041,7 +2041,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	fw = &ha->fw_dump->isp.isp83;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
 
-	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
+	fw->host_status = htonl(rd_reg_dword(&reg->host_status));
 
 	/*
 	 * Pause RISC. No need to track timeout, as resetting the chip
@@ -2049,24 +2049,24 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	 */
 	qla24xx_pause_risc(reg, ha);
 
-	WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
+	wrt_reg_dword(&reg->iobase_addr, 0x6000);
 	dmp_reg = &reg->iobase_window;
-	RD_REG_DWORD(dmp_reg);
-	WRT_REG_DWORD(dmp_reg, 0);
+	rd_reg_dword(dmp_reg);
+	wrt_reg_dword(dmp_reg, 0);
 
 	dmp_reg = &reg->unused_4_1[0];
-	RD_REG_DWORD(dmp_reg);
-	WRT_REG_DWORD(dmp_reg, 0);
+	rd_reg_dword(dmp_reg);
+	wrt_reg_dword(dmp_reg, 0);
 
-	WRT_REG_DWORD(&reg->iobase_addr, 0x6010);
+	wrt_reg_dword(&reg->iobase_addr, 0x6010);
 	dmp_reg = &reg->unused_4_1[2];
-	RD_REG_DWORD(dmp_reg);
-	WRT_REG_DWORD(dmp_reg, 0);
+	rd_reg_dword(dmp_reg);
+	wrt_reg_dword(dmp_reg, 0);
 
 	/* select PCR and disable ecc checking and correction */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-	RD_REG_DWORD(&reg->iobase_addr);
-	WRT_REG_DWORD(&reg->iobase_select, 0x60000000);	/* write to F0h = PCR */
+	wrt_reg_dword(&reg->iobase_addr, 0x0F70);
+	rd_reg_dword(&reg->iobase_addr);
+	wrt_reg_dword(&reg->iobase_select, 0x60000000);	/* write to F0h = PCR */
 
 	/* Host/Risc registers. */
 	iter_reg = fw->host_risc_reg;
@@ -2075,73 +2075,73 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla24xx_read_window(reg, 0x7040, 16, iter_reg);
 
 	/* PCIe registers. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x7C00);
-	RD_REG_DWORD(&reg->iobase_addr);
-	WRT_REG_DWORD(&reg->iobase_window, 0x01);
+	wrt_reg_dword(&reg->iobase_addr, 0x7C00);
+	rd_reg_dword(&reg->iobase_addr);
+	wrt_reg_dword(&reg->iobase_window, 0x01);
 	dmp_reg = &reg->iobase_c4;
-	fw->pcie_regs[0] = htonl(RD_REG_DWORD(dmp_reg));
+	fw->pcie_regs[0] = htonl(rd_reg_dword(dmp_reg));
 	dmp_reg++;
-	fw->pcie_regs[1] = htonl(RD_REG_DWORD(dmp_reg));
+	fw->pcie_regs[1] = htonl(rd_reg_dword(dmp_reg));
 	dmp_reg++;
-	fw->pcie_regs[2] = htonl(RD_REG_DWORD(dmp_reg));
-	fw->pcie_regs[3] = htonl(RD_REG_DWORD(&reg->iobase_window));
+	fw->pcie_regs[2] = htonl(rd_reg_dword(dmp_reg));
+	fw->pcie_regs[3] = htonl(rd_reg_dword(&reg->iobase_window));
 
-	WRT_REG_DWORD(&reg->iobase_window, 0x00);
-	RD_REG_DWORD(&reg->iobase_window);
+	wrt_reg_dword(&reg->iobase_window, 0x00);
+	rd_reg_dword(&reg->iobase_window);
 
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
 	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
-		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
+		fw->host_reg[cnt] = htonl(rd_reg_dword(dmp_reg));
 
 	/* Disable interrupts. */
-	WRT_REG_DWORD(&reg->ictrl, 0);
-	RD_REG_DWORD(&reg->ictrl);
+	wrt_reg_dword(&reg->ictrl, 0);
+	rd_reg_dword(&reg->ictrl);
 
 	/* Shadow registers. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-	RD_REG_DWORD(&reg->iobase_addr);
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
-	fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_addr, 0x0F70);
+	rd_reg_dword(&reg->iobase_addr);
+	wrt_reg_dword(&reg->iobase_select, 0xB0000000);
+	fw->shadow_reg[0] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
-	fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0100000);
+	fw->shadow_reg[1] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
-	fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0200000);
+	fw->shadow_reg[2] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
-	fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0300000);
+	fw->shadow_reg[3] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
-	fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0400000);
+	fw->shadow_reg[4] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
-	fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0500000);
+	fw->shadow_reg[5] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
-	fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0600000);
+	fw->shadow_reg[6] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0700000);
-	fw->shadow_reg[7] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0700000);
+	fw->shadow_reg[7] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0800000);
-	fw->shadow_reg[8] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0800000);
+	fw->shadow_reg[8] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0900000);
-	fw->shadow_reg[9] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0900000);
+	fw->shadow_reg[9] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
-	WRT_REG_DWORD(&reg->iobase_select, 0xB0A00000);
-	fw->shadow_reg[10] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+	wrt_reg_dword(&reg->iobase_select, 0xB0A00000);
+	fw->shadow_reg[10] = htonl(rd_reg_dword(&reg->iobase_sdata));
 
 	/* RISC I/O register. */
-	WRT_REG_DWORD(&reg->iobase_addr, 0x0010);
-	fw->risc_io_reg = htonl(RD_REG_DWORD(&reg->iobase_window));
+	wrt_reg_dword(&reg->iobase_addr, 0x0010);
+	fw->risc_io_reg = htonl(rd_reg_dword(&reg->iobase_window));
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
 	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
-		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
+		fw->mailbox_reg[cnt] = htons(rd_reg_word(mbx_reg));
 
 	/* Transfer sequence registers. */
 	iter_reg = fw->xseq_gp_reg;
@@ -2237,19 +2237,19 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	iter_reg = qla24xx_read_window(reg, 0x7200, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	iter_reg = fw->resp0_dma_reg;
 	iter_reg = qla24xx_read_window(reg, 0x7300, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	iter_reg = fw->req1_dma_reg;
 	iter_reg = qla24xx_read_window(reg, 0x7400, 8, iter_reg);
 	dmp_reg = &reg->iobase_q;
 	for (cnt = 0; cnt < 7; cnt++, dmp_reg++)
-		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg));
+		*iter_reg++ = htonl(rd_reg_dword(dmp_reg));
 
 	/* Transmit DMA registers. */
 	iter_reg = fw->xmt0_dma_reg;
@@ -2455,16 +2455,16 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 		ql_log(ql_log_warn, vha, 0xd00f, "try a bigger hammer!!!\n");
 
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
-		RD_REG_DWORD(&reg->hccr);
+		wrt_reg_dword(&reg->hccr, HCCRX_SET_RISC_RESET);
+		rd_reg_dword(&reg->hccr);
 
-		WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
-		RD_REG_DWORD(&reg->hccr);
+		wrt_reg_dword(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+		rd_reg_dword(&reg->hccr);
 
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
-		RD_REG_DWORD(&reg->hccr);
+		wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_RESET);
+		rd_reg_dword(&reg->hccr);
 
-		for (cnt = 30000; cnt && (RD_REG_WORD(&reg->mailbox0)); cnt--)
+		for (cnt = 30000; cnt && (rd_reg_word(&reg->mailbox0)); cnt--)
 			udelay(5);
 
 		if (!cnt) {
@@ -2732,7 +2732,7 @@ ql_dump_regs(uint level, scsi_qla_host_t *vha, uint id)
 	ql_dbg(level, vha, id, "Mailbox registers:\n");
 	for (i = 0; i < 6; i++, mbx_reg++)
 		ql_dbg(level, vha, id,
-		    "mbox[%d] %#04x\n", i, RD_REG_WORD(mbx_reg));
+		    "mbox[%d] %#04x\n", i, rd_reg_word(mbx_reg));
 }
 
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7e5677c69bed..1adb3ce07080 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -128,47 +128,47 @@ static inline uint32_t make_handle(uint16_t x, uint16_t y)
  * I/O register
 */
 
-static inline u8 RD_REG_BYTE(const volatile u8 __iomem *addr)
+static inline u8 rd_reg_byte(const volatile u8 __iomem *addr)
 {
 	return readb(addr);
 }
 
-static inline u16 RD_REG_WORD(const volatile __le16 __iomem *addr)
+static inline u16 rd_reg_word(const volatile __le16 __iomem *addr)
 {
 	return readw(addr);
 }
 
-static inline u32 RD_REG_DWORD(const volatile __le32 __iomem *addr)
+static inline u32 rd_reg_dword(const volatile __le32 __iomem *addr)
 {
 	return readl(addr);
 }
 
-static inline u8 RD_REG_BYTE_RELAXED(const volatile u8 __iomem *addr)
+static inline u8 rd_reg_byte_relaxed(const volatile u8 __iomem *addr)
 {
 	return readb_relaxed(addr);
 }
 
-static inline u16 RD_REG_WORD_RELAXED(const volatile __le16 __iomem *addr)
+static inline u16 rd_reg_word_relaxed(const volatile __le16 __iomem *addr)
 {
 	return readw_relaxed(addr);
 }
 
-static inline u32 RD_REG_DWORD_RELAXED(const volatile __le32 __iomem *addr)
+static inline u32 rd_reg_dword_relaxed(const volatile __le32 __iomem *addr)
 {
 	return readl_relaxed(addr);
 }
 
-static inline void WRT_REG_BYTE(volatile u8 __iomem *addr, u8 data)
+static inline void wrt_reg_byte(volatile u8 __iomem *addr, u8 data)
 {
 	return writeb(data, addr);
 }
 
-static inline void WRT_REG_WORD(volatile __le16 __iomem *addr, u16 data)
+static inline void wrt_reg_word(volatile __le16 __iomem *addr, u16 data)
 {
 	return writew(data, addr);
 }
 
-static inline void WRT_REG_DWORD(volatile __le32 __iomem *addr, u32 data)
+static inline void wrt_reg_dword(volatile __le32 __iomem *addr, u32 data)
 {
 	return writel(data, addr);
 }
@@ -258,8 +258,8 @@ static inline void WRT_REG_DWORD(volatile __le32 __iomem *addr, u32 data)
  * The ISP2312 v2 chip cannot access the FLASH/GPIO registers via MMIO in an
  * 133Mhz slot.
  */
-#define RD_REG_WORD_PIO(addr)		(inw((unsigned long)addr))
-#define WRT_REG_WORD_PIO(addr, data)	(outw(data, (unsigned long)addr))
+#define rd_reg_word_PIO(addr)		(inw((unsigned long)addr))
+#define wrt_reg_word_PIO(addr, data)	(outw(data, (unsigned long)addr))
 
 /*
  * Fibre Channel device definitions.
@@ -956,18 +956,18 @@ typedef union {
 	  &(reg)->u_end.isp2200.mailbox8 + (num) - 8) : \
 	 &(reg)->u.isp2300.mailbox0 + (num))
 #define RD_MAILBOX_REG(ha, reg, num) \
-	RD_REG_WORD(MAILBOX_REG(ha, reg, num))
+	rd_reg_word(MAILBOX_REG(ha, reg, num))
 #define WRT_MAILBOX_REG(ha, reg, num, data) \
-	WRT_REG_WORD(MAILBOX_REG(ha, reg, num), data)
+	wrt_reg_word(MAILBOX_REG(ha, reg, num), data)
 
 #define FB_CMD_REG(ha, reg) \
 	(IS_QLA2100(ha) || IS_QLA2200(ha) ? \
 	 &(reg)->fb_cmd_2100 : \
 	 &(reg)->u.isp2300.fb_cmd)
 #define RD_FB_CMD_REG(ha, reg) \
-	RD_REG_WORD(FB_CMD_REG(ha, reg))
+	rd_reg_word(FB_CMD_REG(ha, reg))
 #define WRT_FB_CMD_REG(ha, reg, data) \
-	WRT_REG_WORD(FB_CMD_REG(ha, reg), data)
+	wrt_reg_word(FB_CMD_REG(ha, reg), data)
 
 typedef struct {
 	uint32_t	out_mb;		/* outbound from driver */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bd9d3e0847c2..326231ccce70 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2219,7 +2219,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 
 	/* Check for secure flash support */
 	if (IS_QLA28XX(ha)) {
-		if (RD_REG_WORD(&reg->mailbox12) & BIT_0)
+		if (rd_reg_word(&reg->mailbox12) & BIT_0)
 			ha->flags.secure_adapter = 1;
 		ql_log(ql_log_info, vha, 0xffff, "Secure Adapter: %s\n",
 		    (ha->flags.secure_adapter) ? "Yes" : "No");
@@ -2357,7 +2357,7 @@ qla2100_pci_config(scsi_qla_host_t *vha)
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->pci_attr = RD_REG_WORD(&reg->ctrl_status);
+	ha->pci_attr = rd_reg_word(&reg->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_SUCCESS;
@@ -2399,17 +2399,17 @@ qla2300_pci_config(scsi_qla_host_t *vha)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 		/* Pause RISC. */
-		WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
+		wrt_reg_word(&reg->hccr, HCCR_PAUSE_RISC);
 		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) != 0)
+			if ((rd_reg_word(&reg->hccr) & HCCR_RISC_PAUSE) != 0)
 				break;
 
 			udelay(10);
 		}
 
 		/* Select FPM registers. */
-		WRT_REG_WORD(&reg->ctrl_status, 0x20);
-		RD_REG_WORD(&reg->ctrl_status);
+		wrt_reg_word(&reg->ctrl_status, 0x20);
+		rd_reg_word(&reg->ctrl_status);
 
 		/* Get the fb rev level */
 		ha->fb_rev = RD_FB_CMD_REG(ha, reg);
@@ -2418,13 +2418,13 @@ qla2300_pci_config(scsi_qla_host_t *vha)
 			pci_clear_mwi(ha->pdev);
 
 		/* Deselect FPM registers. */
-		WRT_REG_WORD(&reg->ctrl_status, 0x0);
-		RD_REG_WORD(&reg->ctrl_status);
+		wrt_reg_word(&reg->ctrl_status, 0x0);
+		rd_reg_word(&reg->ctrl_status);
 
 		/* Release RISC module. */
-		WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+		wrt_reg_word(&reg->hccr, HCCR_RELEASE_RISC);
 		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) == 0)
+			if ((rd_reg_word(&reg->hccr) & HCCR_RISC_PAUSE) == 0)
 				break;
 
 			udelay(10);
@@ -2439,7 +2439,7 @@ qla2300_pci_config(scsi_qla_host_t *vha)
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->pci_attr = RD_REG_WORD(&reg->ctrl_status);
+	ha->pci_attr = rd_reg_word(&reg->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_SUCCESS;
@@ -2483,7 +2483,7 @@ qla24xx_pci_config(scsi_qla_host_t *vha)
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->pci_attr = RD_REG_DWORD(&reg->ctrl_status);
+	ha->pci_attr = rd_reg_dword(&reg->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_SUCCESS;
@@ -2587,36 +2587,36 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
 
 	if (!IS_QLA2100(ha)) {
 		/* Pause RISC. */
-		WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
+		wrt_reg_word(&reg->hccr, HCCR_PAUSE_RISC);
 		if (IS_QLA2200(ha) || IS_QLA2300(ha)) {
 			for (cnt = 0; cnt < 30000; cnt++) {
-				if ((RD_REG_WORD(&reg->hccr) &
+				if ((rd_reg_word(&reg->hccr) &
 				    HCCR_RISC_PAUSE) != 0)
 					break;
 				udelay(100);
 			}
 		} else {
-			RD_REG_WORD(&reg->hccr);	/* PCI Posting. */
+			rd_reg_word(&reg->hccr);	/* PCI Posting. */
 			udelay(10);
 		}
 
 		/* Select FPM registers. */
-		WRT_REG_WORD(&reg->ctrl_status, 0x20);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+		wrt_reg_word(&reg->ctrl_status, 0x20);
+		rd_reg_word(&reg->ctrl_status);		/* PCI Posting. */
 
 		/* FPM Soft Reset. */
-		WRT_REG_WORD(&reg->fpm_diag_config, 0x100);
-		RD_REG_WORD(&reg->fpm_diag_config);	/* PCI Posting. */
+		wrt_reg_word(&reg->fpm_diag_config, 0x100);
+		rd_reg_word(&reg->fpm_diag_config);	/* PCI Posting. */
 
 		/* Toggle Fpm Reset. */
 		if (!IS_QLA2200(ha)) {
-			WRT_REG_WORD(&reg->fpm_diag_config, 0x0);
-			RD_REG_WORD(&reg->fpm_diag_config); /* PCI Posting. */
+			wrt_reg_word(&reg->fpm_diag_config, 0x0);
+			rd_reg_word(&reg->fpm_diag_config); /* PCI Posting. */
 		}
 
 		/* Select frame buffer registers. */
-		WRT_REG_WORD(&reg->ctrl_status, 0x10);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+		wrt_reg_word(&reg->ctrl_status, 0x10);
+		rd_reg_word(&reg->ctrl_status);		/* PCI Posting. */
 
 		/* Reset frame buffer FIFOs. */
 		if (IS_QLA2200(ha)) {
@@ -2634,23 +2634,23 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
 		}
 
 		/* Select RISC module registers. */
-		WRT_REG_WORD(&reg->ctrl_status, 0);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+		wrt_reg_word(&reg->ctrl_status, 0);
+		rd_reg_word(&reg->ctrl_status);		/* PCI Posting. */
 
 		/* Reset RISC processor. */
-		WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
+		wrt_reg_word(&reg->hccr, HCCR_RESET_RISC);
+		rd_reg_word(&reg->hccr);		/* PCI Posting. */
 
 		/* Release RISC processor. */
-		WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
-		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
+		wrt_reg_word(&reg->hccr, HCCR_RELEASE_RISC);
+		rd_reg_word(&reg->hccr);		/* PCI Posting. */
 	}
 
-	WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-	WRT_REG_WORD(&reg->hccr, HCCR_CLR_HOST_INT);
+	wrt_reg_word(&reg->hccr, HCCR_CLR_RISC_INT);
+	wrt_reg_word(&reg->hccr, HCCR_CLR_HOST_INT);
 
 	/* Reset ISP chip. */
-	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+	wrt_reg_word(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
 
 	/* Wait for RISC to recover from reset. */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
@@ -2661,7 +2661,7 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
 		 */
 		udelay(20);
 		for (cnt = 30000; cnt; cnt--) {
-			if ((RD_REG_WORD(&reg->ctrl_status) &
+			if ((rd_reg_word(&reg->ctrl_status) &
 			    CSR_ISP_SOFT_RESET) == 0)
 				break;
 			udelay(100);
@@ -2670,13 +2670,13 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
 		udelay(10);
 
 	/* Reset RISC processor. */
-	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+	wrt_reg_word(&reg->hccr, HCCR_RESET_RISC);
 
-	WRT_REG_WORD(&reg->semaphore, 0);
+	wrt_reg_word(&reg->semaphore, 0);
 
 	/* Release RISC processor. */
-	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
+	wrt_reg_word(&reg->hccr, HCCR_RELEASE_RISC);
+	rd_reg_word(&reg->hccr);			/* PCI Posting. */
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
 		for (cnt = 0; cnt < 30000; cnt++) {
@@ -2694,8 +2694,8 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
 
 	/* Disable RISC pause on FPM parity error. */
 	if (!IS_QLA2100(ha)) {
-		WRT_REG_WORD(&reg->hccr, HCCR_DISABLE_PARITY_PAUSE);
-		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
+		wrt_reg_word(&reg->hccr, HCCR_DISABLE_PARITY_PAUSE);
+		rd_reg_word(&reg->hccr);		/* PCI Posting. */
 	}
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -2740,32 +2740,32 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Reset RISC. */
-	WRT_REG_DWORD(&reg->ctrl_status, CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+	wrt_reg_dword(&reg->ctrl_status, CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
 	for (cnt = 0; cnt < 30000; cnt++) {
-		if ((RD_REG_DWORD(&reg->ctrl_status) & CSRX_DMA_ACTIVE) == 0)
+		if ((rd_reg_dword(&reg->ctrl_status) & CSRX_DMA_ACTIVE) == 0)
 			break;
 
 		udelay(10);
 	}
 
-	if (!(RD_REG_DWORD(&reg->ctrl_status) & CSRX_DMA_ACTIVE))
+	if (!(rd_reg_dword(&reg->ctrl_status) & CSRX_DMA_ACTIVE))
 		set_bit(DMA_SHUTDOWN_CMPL, &ha->fw_dump_cap_flags);
 
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x017e,
 	    "HCCR: 0x%x, Control Status %x, DMA active status:0x%x\n",
-	    RD_REG_DWORD(&reg->hccr),
-	    RD_REG_DWORD(&reg->ctrl_status),
-	    (RD_REG_DWORD(&reg->ctrl_status) & CSRX_DMA_ACTIVE));
+	    rd_reg_dword(&reg->hccr),
+	    rd_reg_dword(&reg->ctrl_status),
+	    (rd_reg_dword(&reg->ctrl_status) & CSRX_DMA_ACTIVE));
 
-	WRT_REG_DWORD(&reg->ctrl_status,
+	wrt_reg_dword(&reg->ctrl_status,
 	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
 
 	udelay(100);
 
 	/* Wait for firmware to complete NVRAM accesses. */
-	RD_REG_WORD(&reg->mailbox0);
-	for (cnt = 10000; RD_REG_WORD(&reg->mailbox0) != 0 &&
+	rd_reg_word(&reg->mailbox0);
+	for (cnt = 10000; rd_reg_word(&reg->mailbox0) != 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		barrier();
 		if (cnt)
@@ -2779,26 +2779,26 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x017f,
 	    "HCCR: 0x%x, MailBox0 Status 0x%x\n",
-	    RD_REG_DWORD(&reg->hccr),
-	    RD_REG_WORD(&reg->mailbox0));
+	    rd_reg_dword(&reg->hccr),
+	    rd_reg_word(&reg->mailbox0));
 
 	/* Wait for soft-reset to complete. */
-	RD_REG_DWORD(&reg->ctrl_status);
+	rd_reg_dword(&reg->ctrl_status);
 	for (cnt = 0; cnt < 60; cnt++) {
 		barrier();
-		if ((RD_REG_DWORD(&reg->ctrl_status) &
+		if ((rd_reg_dword(&reg->ctrl_status) &
 		    CSRX_ISP_SOFT_RESET) == 0)
 			break;
 
 		udelay(5);
 	}
-	if (!(RD_REG_DWORD(&reg->ctrl_status) & CSRX_ISP_SOFT_RESET))
+	if (!(rd_reg_dword(&reg->ctrl_status) & CSRX_ISP_SOFT_RESET))
 		set_bit(ISP_SOFT_RESET_CMPL, &ha->fw_dump_cap_flags);
 
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x015d,
 	    "HCCR: 0x%x, Soft Reset status: 0x%x\n",
-	    RD_REG_DWORD(&reg->hccr),
-	    RD_REG_DWORD(&reg->ctrl_status));
+	    rd_reg_dword(&reg->hccr),
+	    rd_reg_dword(&reg->ctrl_status));
 
 	/* If required, do an MPI FW reset now */
 	if (test_and_clear_bit(MPI_RESET_NEEDED, &vha->dpc_flags)) {
@@ -2817,17 +2817,17 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 		}
 	}
 
-	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
-	RD_REG_DWORD(&reg->hccr);
+	wrt_reg_dword(&reg->hccr, HCCRX_SET_RISC_RESET);
+	rd_reg_dword(&reg->hccr);
 
-	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);
+	wrt_reg_dword(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+	rd_reg_dword(&reg->hccr);
 
-	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
-	RD_REG_DWORD(&reg->hccr);
+	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_RESET);
+	rd_reg_dword(&reg->hccr);
 
-	RD_REG_WORD(&reg->mailbox0);
-	for (cnt = 60; RD_REG_WORD(&reg->mailbox0) != 0 &&
+	rd_reg_word(&reg->mailbox0);
+	for (cnt = 60; rd_reg_word(&reg->mailbox0) != 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		barrier();
 		if (cnt)
@@ -2840,8 +2840,8 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x015e,
 	    "Host Risc 0x%x, mailbox0 0x%x\n",
-	    RD_REG_DWORD(&reg->hccr),
-	     RD_REG_WORD(&reg->mailbox0));
+	    rd_reg_dword(&reg->hccr),
+	     rd_reg_word(&reg->mailbox0));
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -2860,8 +2860,8 @@ qla25xx_read_risc_sema_reg(scsi_qla_host_t *vha, uint32_t *data)
 {
 	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
 
-	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
-	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET);
+	wrt_reg_dword(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
+	*data = rd_reg_dword(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET);
 
 }
 
@@ -2870,8 +2870,8 @@ qla25xx_write_risc_sema_reg(scsi_qla_host_t *vha, uint32_t data)
 {
 	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
 
-	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
-	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET, data);
+	wrt_reg_dword(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
+	wrt_reg_dword(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET, data);
 }
 
 static void
@@ -2887,7 +2887,7 @@ qla25xx_manipulate_risc_semaphore(scsi_qla_host_t *vha)
 	    vha->hw->pdev->subsystem_device != 0x0240)
 		return;
 
-	WRT_REG_DWORD(&vha->hw->iobase->isp24.hccr, HCCRX_SET_RISC_PAUSE);
+	wrt_reg_dword(&vha->hw->iobase->isp24.hccr, HCCRX_SET_RISC_PAUSE);
 	udelay(100);
 
 attempt:
@@ -2989,7 +2989,7 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Reset ISP chip. */
-	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+	wrt_reg_word(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
 
 	/*
 	 * We need to have a delay here since the card will not respond while
@@ -2999,7 +2999,7 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	data = qla2x00_debounce_register(&reg->ctrl_status);
 	for (cnt = 6000000 ; cnt && (data & CSR_ISP_SOFT_RESET); cnt--) {
 		udelay(5);
-		data = RD_REG_WORD(&reg->ctrl_status);
+		data = rd_reg_word(&reg->ctrl_status);
 		barrier();
 	}
 
@@ -3010,8 +3010,8 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	    "Reset register cleared by chip reset.\n");
 
 	/* Reset RISC processor. */
-	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+	wrt_reg_word(&reg->hccr, HCCR_RESET_RISC);
+	wrt_reg_word(&reg->hccr, HCCR_RELEASE_RISC);
 
 	/* Workaround for QLA2312 PCI parity error */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
@@ -3652,8 +3652,8 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 	if (!IS_FWI2_CAPABLE(ha) && !IS_QLA2100(ha) && !IS_QLA2200(ha)) {
 		/* Disable SRAM, Instruction RAM and GP RAM parity.  */
 		spin_lock_irqsave(&ha->hardware_lock, flags);
-		WRT_REG_WORD(&reg->hccr, (HCCR_ENABLE_PARITY + 0x0));
-		RD_REG_WORD(&reg->hccr);
+		wrt_reg_word(&reg->hccr, (HCCR_ENABLE_PARITY + 0x0));
+		rd_reg_word(&reg->hccr);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
 
@@ -3760,11 +3760,11 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		if (IS_QLA2300(ha))
 			/* SRAM parity */
-			WRT_REG_WORD(&reg->hccr, HCCR_ENABLE_PARITY + 0x1);
+			wrt_reg_word(&reg->hccr, HCCR_ENABLE_PARITY + 0x1);
 		else
 			/* SRAM, Instruction RAM and GP RAM parity */
-			WRT_REG_WORD(&reg->hccr, HCCR_ENABLE_PARITY + 0x7);
-		RD_REG_WORD(&reg->hccr);
+			wrt_reg_word(&reg->hccr, HCCR_ENABLE_PARITY + 0x7);
+		rd_reg_word(&reg->hccr);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
 
@@ -4008,11 +4008,11 @@ qla2x00_config_rings(struct scsi_qla_host *vha)
 	put_unaligned_le64(req->dma, &ha->init_cb->request_q_address);
 	put_unaligned_le64(rsp->dma, &ha->init_cb->response_q_address);
 
-	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), 0);
-	WRT_REG_WORD(ISP_REQ_Q_OUT(ha, reg), 0);
-	WRT_REG_WORD(ISP_RSP_Q_IN(ha, reg), 0);
-	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), 0);
-	RD_REG_WORD(ISP_RSP_Q_OUT(ha, reg));		/* PCI Posting. */
+	wrt_reg_word(ISP_REQ_Q_IN(ha, reg), 0);
+	wrt_reg_word(ISP_REQ_Q_OUT(ha, reg), 0);
+	wrt_reg_word(ISP_RSP_Q_IN(ha, reg), 0);
+	wrt_reg_word(ISP_RSP_Q_OUT(ha, reg), 0);
+	rd_reg_word(ISP_RSP_Q_OUT(ha, reg));		/* PCI Posting. */
 }
 
 void
@@ -4074,15 +4074,15 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 		}
 		icb->firmware_options_2 |= cpu_to_le32(BIT_23);
 
-		WRT_REG_DWORD(&reg->isp25mq.req_q_in, 0);
-		WRT_REG_DWORD(&reg->isp25mq.req_q_out, 0);
-		WRT_REG_DWORD(&reg->isp25mq.rsp_q_in, 0);
-		WRT_REG_DWORD(&reg->isp25mq.rsp_q_out, 0);
+		wrt_reg_dword(&reg->isp25mq.req_q_in, 0);
+		wrt_reg_dword(&reg->isp25mq.req_q_out, 0);
+		wrt_reg_dword(&reg->isp25mq.rsp_q_in, 0);
+		wrt_reg_dword(&reg->isp25mq.rsp_q_out, 0);
 	} else {
-		WRT_REG_DWORD(&reg->isp24.req_q_in, 0);
-		WRT_REG_DWORD(&reg->isp24.req_q_out, 0);
-		WRT_REG_DWORD(&reg->isp24.rsp_q_in, 0);
-		WRT_REG_DWORD(&reg->isp24.rsp_q_out, 0);
+		wrt_reg_dword(&reg->isp24.req_q_in, 0);
+		wrt_reg_dword(&reg->isp24.req_q_out, 0);
+		wrt_reg_dword(&reg->isp24.rsp_q_in, 0);
+		wrt_reg_dword(&reg->isp24.rsp_q_out, 0);
 	}
 
 	qlt_24xx_config_rings(vha);
@@ -4096,7 +4096,7 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 	}
 
 	/* PCI posting */
-	RD_REG_WORD(&ioreg->hccr);
+	rd_reg_word(&ioreg->hccr);
 }
 
 /**
@@ -4569,7 +4569,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	ha->nvram_size = sizeof(*nv);
 	ha->nvram_base = 0;
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha))
-		if ((RD_REG_WORD(&reg->ctrl_status) >> 14) == 1)
+		if ((rd_reg_word(&reg->ctrl_status) >> 14) == 1)
 			ha->nvram_base = 0x80;
 
 	/* Get NVRAM data and calculate checksum. */
@@ -7082,10 +7082,10 @@ qla2x00_reset_adapter(scsi_qla_host_t *vha)
 	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
-	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
+	wrt_reg_word(&reg->hccr, HCCR_RESET_RISC);
+	rd_reg_word(&reg->hccr);			/* PCI Posting. */
+	wrt_reg_word(&reg->hccr, HCCR_RELEASE_RISC);
+	rd_reg_word(&reg->hccr);			/* PCI Posting. */
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_SUCCESS;
@@ -7106,10 +7106,10 @@ qla24xx_reset_adapter(scsi_qla_host_t *vha)
 	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
-	RD_REG_DWORD(&reg->hccr);
-	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);
+	wrt_reg_dword(&reg->hccr, HCCRX_SET_RISC_RESET);
+	rd_reg_dword(&reg->hccr);
+	wrt_reg_dword(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+	rd_reg_dword(&reg->hccr);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (IS_NOPOLLING_TYPE(ha))
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 77f97552fe74..1fb6ccac07cc 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -46,10 +46,10 @@ qla2x00_debounce_register(volatile __le16 __iomem *addr)
 	volatile uint16_t second;
 
 	do {
-		first = RD_REG_WORD(addr);
+		first = rd_reg_word(addr);
 		barrier();
 		cpu_relax();
-		second = RD_REG_WORD(addr);
+		second = rd_reg_word(addr);
 	} while (first != second);
 
 	return (first);
@@ -329,7 +329,7 @@ qla_83xx_start_iocbs(struct qla_qpair *qpair)
 	} else
 		req->ring_ptr++;
 
-	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+	wrt_reg_dword(req->req_q_in, req->ring_index);
 }
 
 static inline int
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d3b255898543..a481ab9895fc 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -376,7 +376,7 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Calculate the number of request entries needed. */
 	req_cnt = ha->isp_ops->calc_req_entries(tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
+		cnt = rd_reg_word_relaxed(ISP_REQ_Q_OUT(ha, reg));
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -428,8 +428,8 @@ qla2x00_start_scsi(srb_t *sp)
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
-	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), req->ring_index);
-	RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
+	wrt_reg_word(ISP_REQ_Q_IN(ha, reg), req->ring_index);
+	rd_reg_word_relaxed(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
 
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
@@ -472,21 +472,21 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 
 		/* Set chip new ring index. */
 		if (ha->mqenable || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-			WRT_REG_DWORD(req->req_q_in, req->ring_index);
+			wrt_reg_dword(req->req_q_in, req->ring_index);
 		} else if (IS_QLA83XX(ha)) {
-			WRT_REG_DWORD(req->req_q_in, req->ring_index);
-			RD_REG_DWORD_RELAXED(&ha->iobase->isp24.hccr);
+			wrt_reg_dword(req->req_q_in, req->ring_index);
+			rd_reg_dword_relaxed(&ha->iobase->isp24.hccr);
 		} else if (IS_QLAFX00(ha)) {
-			WRT_REG_DWORD(&reg->ispfx00.req_q_in, req->ring_index);
-			RD_REG_DWORD_RELAXED(&reg->ispfx00.req_q_in);
+			wrt_reg_dword(&reg->ispfx00.req_q_in, req->ring_index);
+			rd_reg_dword_relaxed(&reg->ispfx00.req_q_in);
 			QLAFX00_SET_HST_INTR(ha, ha->rqstq_intr_code);
 		} else if (IS_FWI2_CAPABLE(ha)) {
-			WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
-			RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
+			wrt_reg_dword(&reg->isp24.req_q_in, req->ring_index);
+			rd_reg_dword_relaxed(&reg->isp24.req_q_in);
 		} else {
-			WRT_REG_WORD(ISP_REQ_Q_IN(ha, &reg->isp),
+			wrt_reg_word(ISP_REQ_Q_IN(ha, &reg->isp),
 				req->ring_index);
-			RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, &reg->isp));
+			rd_reg_word_relaxed(ISP_REQ_Q_IN(ha, &reg->isp));
 		}
 	}
 }
@@ -1637,7 +1637,7 @@ qla24xx_start_scsi(srb_t *sp)
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    RD_REG_DWORD_RELAXED(req->req_q_out);
+		    rd_reg_dword_relaxed(req->req_q_out);
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -1698,7 +1698,7 @@ qla24xx_start_scsi(srb_t *sp)
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
-	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+	wrt_reg_dword(req->req_q_in, req->ring_index);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
@@ -1822,7 +1822,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	tot_dsds += nseg;
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    RD_REG_DWORD_RELAXED(req->req_q_out);
+		    rd_reg_dword_relaxed(req->req_q_out);
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -1881,7 +1881,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 		req->ring_ptr++;
 
 	/* Set chip new ring index. */
-	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+	wrt_reg_dword(req->req_q_in, req->ring_index);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -1957,7 +1957,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    RD_REG_DWORD_RELAXED(req->req_q_out);
+		    rd_reg_dword_relaxed(req->req_q_out);
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -2018,7 +2018,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
-	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+	wrt_reg_dword(req->req_q_in, req->ring_index);
 
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 	return QLA_SUCCESS;
@@ -2157,7 +2157,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	tot_dsds += nseg;
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    RD_REG_DWORD_RELAXED(req->req_q_out);
+		    rd_reg_dword_relaxed(req->req_q_out);
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -2214,7 +2214,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 		req->ring_ptr++;
 
 	/* Set chip new ring index. */
-	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+	wrt_reg_dword(req->req_q_in, req->ring_index);
 
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
@@ -2266,13 +2266,13 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 			cnt = *req->out_ptr;
 		else if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
 		    IS_QLA28XX(ha))
-			cnt = RD_REG_DWORD(&reg->isp25mq.req_q_out);
+			cnt = rd_reg_dword(&reg->isp25mq.req_q_out);
 		else if (IS_P3P_TYPE(ha))
-			cnt = RD_REG_DWORD(reg->isp82.req_q_out);
+			cnt = rd_reg_dword(reg->isp82.req_q_out);
 		else if (IS_FWI2_CAPABLE(ha))
-			cnt = RD_REG_DWORD(&reg->isp24.req_q_out);
+			cnt = rd_reg_dword(&reg->isp24.req_q_out);
 		else if (IS_QLAFX00(ha))
-			cnt = RD_REG_DWORD(&reg->ispfx00.req_q_out);
+			cnt = rd_reg_dword(&reg->ispfx00.req_q_out);
 		else
 			cnt = qla2x00_debounce_register(
 			    ISP_REQ_Q_OUT(ha, &reg->isp));
@@ -2305,8 +2305,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	pkt = req->ring_ptr;
 	memset(pkt, 0, REQUEST_ENTRY_SIZE);
 	if (IS_QLAFX00(ha)) {
-		WRT_REG_BYTE((void __iomem *)&pkt->entry_count, req_cnt);
-		WRT_REG_WORD((void __iomem *)&pkt->handle, handle);
+		wrt_reg_byte((void __iomem *)&pkt->entry_count, req_cnt);
+		wrt_reg_word((void __iomem *)&pkt->handle, handle);
 	} else {
 		pkt->entry_count = req_cnt;
 		pkt->handle = handle;
@@ -3311,7 +3311,7 @@ qla82xx_start_scsi(srb_t *sp)
 		req_cnt = 1;
 
 		if (req->cnt < (req_cnt + 2)) {
-			cnt = (uint16_t)RD_REG_DWORD_RELAXED(
+			cnt = (uint16_t)rd_reg_dword_relaxed(
 				&reg->req_q_out[0]);
 			if (req->ring_index < cnt)
 				req->cnt = cnt - req->ring_index;
@@ -3420,7 +3420,7 @@ qla82xx_start_scsi(srb_t *sp)
 
 		req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 		if (req->cnt < (req_cnt + 2)) {
-			cnt = (uint16_t)RD_REG_DWORD_RELAXED(
+			cnt = (uint16_t)rd_reg_dword_relaxed(
 			    &reg->req_q_out[0]);
 			if (req->ring_index < cnt)
 				req->cnt = cnt - req->ring_index;
@@ -3496,10 +3496,10 @@ qla82xx_start_scsi(srb_t *sp)
 	if (ql2xdbwr)
 		qla82xx_wr_32(ha, (uintptr_t __force)ha->nxdb_wr_ptr, dbval);
 	else {
-		WRT_REG_DWORD(ha->nxdb_wr_ptr, dbval);
+		wrt_reg_dword(ha->nxdb_wr_ptr, dbval);
 		wmb();
-		while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
-			WRT_REG_DWORD(ha->nxdb_wr_ptr, dbval);
+		while (rd_reg_dword(ha->nxdb_rd_ptr) != dbval) {
+			wrt_reg_dword(ha->nxdb_wr_ptr, dbval);
 			wmb();
 		}
 	}
@@ -3895,7 +3895,7 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	/* Check for room on request queue. */
 	if (req->cnt < req_cnt + 2) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    RD_REG_DWORD_RELAXED(req->req_q_out);
+		    rd_reg_dword_relaxed(req->req_q_out);
 		if  (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9d4084cd2acb..e8289c095832 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -205,7 +205,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
-		hccr = RD_REG_WORD(&reg->hccr);
+		hccr = rd_reg_word(&reg->hccr);
 		if (qla2x00_check_reg16_for_disconnect(vha, hccr))
 			break;
 		if (hccr & HCCR_RISC_PAUSE) {
@@ -217,18 +217,18 @@ qla2100_intr_handler(int irq, void *dev_id)
 			 * bit to be cleared.  Schedule a big hammer to get
 			 * out of the RISC PAUSED state.
 			 */
-			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-			RD_REG_WORD(&reg->hccr);
+			wrt_reg_word(&reg->hccr, HCCR_RESET_RISC);
+			rd_reg_word(&reg->hccr);
 
 			ha->isp_ops->fw_dump(vha, 1);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			break;
-		} else if ((RD_REG_WORD(&reg->istatus) & ISR_RISC_INT) == 0)
+		} else if ((rd_reg_word(&reg->istatus) & ISR_RISC_INT) == 0)
 			break;
 
-		if (RD_REG_WORD(&reg->semaphore) & BIT_0) {
-			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-			RD_REG_WORD(&reg->hccr);
+		if (rd_reg_word(&reg->semaphore) & BIT_0) {
+			wrt_reg_word(&reg->hccr, HCCR_CLR_RISC_INT);
+			rd_reg_word(&reg->hccr);
 
 			/* Get mailbox data. */
 			mb[0] = RD_MAILBOX_REG(ha, reg, 0);
@@ -247,13 +247,13 @@ qla2100_intr_handler(int irq, void *dev_id)
 				    mb[0]);
 			}
 			/* Release mailbox registers. */
-			WRT_REG_WORD(&reg->semaphore, 0);
-			RD_REG_WORD(&reg->semaphore);
+			wrt_reg_word(&reg->semaphore, 0);
+			rd_reg_word(&reg->semaphore);
 		} else {
 			qla2x00_process_response_queue(rsp);
 
-			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-			RD_REG_WORD(&reg->hccr);
+			wrt_reg_word(&reg->hccr, HCCR_CLR_RISC_INT);
+			rd_reg_word(&reg->hccr);
 		}
 	}
 	qla2x00_handle_mbx_completion(ha, status);
@@ -325,14 +325,14 @@ qla2300_intr_handler(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
-		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
+		stat = rd_reg_dword(&reg->u.isp2300.host_status);
 		if (qla2x00_check_reg32_for_disconnect(vha, stat))
 			break;
 		if (stat & HSR_RISC_PAUSED) {
 			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
-			hccr = RD_REG_WORD(&reg->hccr);
+			hccr = rd_reg_word(&reg->hccr);
 
 			if (hccr & (BIT_15 | BIT_13 | BIT_11 | BIT_8))
 				ql_log(ql_log_warn, vha, 0x5026,
@@ -348,8 +348,8 @@ qla2300_intr_handler(int irq, void *dev_id)
 			 * interrupt bit to be cleared.  Schedule a big
 			 * hammer to get out of the RISC PAUSED state.
 			 */
-			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-			RD_REG_WORD(&reg->hccr);
+			wrt_reg_word(&reg->hccr, HCCR_RESET_RISC);
+			rd_reg_word(&reg->hccr);
 
 			ha->isp_ops->fw_dump(vha, 1);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
@@ -366,7 +366,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 			status |= MBX_INTERRUPT;
 
 			/* Release mailbox registers. */
-			WRT_REG_WORD(&reg->semaphore, 0);
+			wrt_reg_word(&reg->semaphore, 0);
 			break;
 		case 0x12:
 			mb[0] = MSW(stat);
@@ -394,8 +394,8 @@ qla2300_intr_handler(int irq, void *dev_id)
 			    "Unrecognized interrupt type (%d).\n", stat & 0xff);
 			break;
 		}
-		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-		RD_REG_WORD_RELAXED(&reg->hccr);
+		wrt_reg_word(&reg->hccr, HCCR_CLR_RISC_INT);
+		rd_reg_word_relaxed(&reg->hccr);
 	}
 	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -437,7 +437,7 @@ qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 		if ((cnt == 4 || cnt == 5) && (mboxes & BIT_0))
 			ha->mailbox_out[cnt] = qla2x00_debounce_register(wptr);
 		else if (mboxes & BIT_0)
-			ha->mailbox_out[cnt] = RD_REG_WORD(wptr);
+			ha->mailbox_out[cnt] = rd_reg_word(wptr);
 
 		wptr++;
 		mboxes >>= 1;
@@ -464,7 +464,7 @@ qla81xx_idc_event(scsi_qla_host_t *vha, uint16_t aen, uint16_t descr)
 		return;
 
 	for (cnt = 0; cnt < QLA_IDC_ACK_REGS; cnt++, wptr++)
-		mb[cnt] = RD_REG_WORD(wptr);
+		mb[cnt] = rd_reg_word(wptr);
 
 	ql_dbg(ql_dbg_async, vha, 0x5021,
 	    "Inter-Driver Communication %s -- "
@@ -858,10 +858,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
 			u16 m[4];
 
-			m[0] = RD_REG_WORD(&reg24->mailbox4);
-			m[1] = RD_REG_WORD(&reg24->mailbox5);
-			m[2] = RD_REG_WORD(&reg24->mailbox6);
-			mbx = m[3] = RD_REG_WORD(&reg24->mailbox7);
+			m[0] = rd_reg_word(&reg24->mailbox4);
+			m[1] = rd_reg_word(&reg24->mailbox5);
+			m[2] = rd_reg_word(&reg24->mailbox6);
+			mbx = m[3] = rd_reg_word(&reg24->mailbox7);
 
 			ql_log(ql_log_warn, vha, 0x5003,
 			    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh mbx4=%xh mbx5=%xh mbx6=%xh mbx7=%xh.\n",
@@ -873,7 +873,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 
 		ha->fw_dump_mpi =
 		    (IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
-		    RD_REG_WORD(&reg24->mailbox7) & BIT_8;
+		    rd_reg_word(&reg24->mailbox7) & BIT_8;
 		ha->isp_ops->fw_dump(vha, 1);
 		ha->flags.fw_init_done = 0;
 		QLA_FW_STOPPED(ha);
@@ -979,8 +979,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		ha->current_topology = 0;
 
 		mbx = (IS_QLA81XX(ha) || IS_QLA8031(ha))
-			? RD_REG_WORD(&reg24->mailbox4) : 0;
-		mbx = (IS_P3P_TYPE(ha)) ? RD_REG_WORD(&reg82->mailbox_out[4])
+			? rd_reg_word(&reg24->mailbox4) : 0;
+		mbx = (IS_P3P_TYPE(ha)) ? rd_reg_word(&reg82->mailbox_out[4])
 			: mbx;
 		ql_log(ql_log_info, vha, 0x500b,
 		    "LOOP DOWN detected (%x %x %x %x).\n",
@@ -1347,7 +1347,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 	case MBA_IDC_NOTIFY:
 		if (IS_QLA8031(vha->hw) || IS_QLA8044(ha)) {
-			mb[4] = RD_REG_WORD(&reg24->mailbox4);
+			mb[4] = rd_reg_word(&reg24->mailbox4);
 			if (((mb[2] & 0x7fff) == MBC_PORT_RESET ||
 			    (mb[2] & 0x7fff) == MBC_SET_PORT_CONFIG) &&
 			    (mb[4] & INTERNAL_LOOPBACK_MASK) != 0) {
@@ -1389,10 +1389,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else if (IS_QLA83XX(ha)) {
-			mb[4] = RD_REG_WORD(&reg24->mailbox4);
-			mb[5] = RD_REG_WORD(&reg24->mailbox5);
-			mb[6] = RD_REG_WORD(&reg24->mailbox6);
-			mb[7] = RD_REG_WORD(&reg24->mailbox7);
+			mb[4] = rd_reg_word(&reg24->mailbox4);
+			mb[5] = rd_reg_word(&reg24->mailbox5);
+			mb[6] = rd_reg_word(&reg24->mailbox6);
+			mb[7] = rd_reg_word(&reg24->mailbox7);
 			qla83xx_handle_8200_aen(vha, mb);
 		} else {
 			ql_dbg(ql_dbg_async, vha, 0x5052,
@@ -2296,7 +2296,7 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 	}
 
 	/* Adjust ring index */
-	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), rsp->ring_index);
+	wrt_reg_word(ISP_RSP_Q_OUT(ha, reg), rsp->ring_index);
 }
 
 static inline void
@@ -3161,7 +3161,7 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
 		if (mboxes & BIT_0)
-			ha->mailbox_out[cnt] = RD_REG_WORD(wptr);
+			ha->mailbox_out[cnt] = rd_reg_word(wptr);
 
 		mboxes >>= 1;
 		wptr++;
@@ -3338,9 +3338,9 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	if (IS_P3P_TYPE(ha)) {
 		struct device_reg_82xx __iomem *reg = &ha->iobase->isp82;
 
-		WRT_REG_DWORD(&reg->rsp_q_out[0], rsp->ring_index);
+		wrt_reg_dword(&reg->rsp_q_out[0], rsp->ring_index);
 	} else {
-		WRT_REG_DWORD(rsp->rsp_q_out, rsp->ring_index);
+		wrt_reg_dword(rsp->rsp_q_out, rsp->ring_index);
 	}
 }
 
@@ -3357,13 +3357,13 @@ qla2xxx_check_risc_status(scsi_qla_host_t *vha)
 		return;
 
 	rval = QLA_SUCCESS;
-	WRT_REG_DWORD(&reg->iobase_addr, 0x7C00);
-	RD_REG_DWORD(&reg->iobase_addr);
-	WRT_REG_DWORD(&reg->iobase_window, 0x0001);
-	for (cnt = 10000; (RD_REG_DWORD(&reg->iobase_window) & BIT_0) == 0 &&
+	wrt_reg_dword(&reg->iobase_addr, 0x7C00);
+	rd_reg_dword(&reg->iobase_addr);
+	wrt_reg_dword(&reg->iobase_window, 0x0001);
+	for (cnt = 10000; (rd_reg_dword(&reg->iobase_window) & BIT_0) == 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		if (cnt) {
-			WRT_REG_DWORD(&reg->iobase_window, 0x0001);
+			wrt_reg_dword(&reg->iobase_window, 0x0001);
 			udelay(10);
 		} else
 			rval = QLA_FUNCTION_TIMEOUT;
@@ -3372,11 +3372,11 @@ qla2xxx_check_risc_status(scsi_qla_host_t *vha)
 		goto next_test;
 
 	rval = QLA_SUCCESS;
-	WRT_REG_DWORD(&reg->iobase_window, 0x0003);
-	for (cnt = 100; (RD_REG_DWORD(&reg->iobase_window) & BIT_0) == 0 &&
+	wrt_reg_dword(&reg->iobase_window, 0x0003);
+	for (cnt = 100; (rd_reg_dword(&reg->iobase_window) & BIT_0) == 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		if (cnt) {
-			WRT_REG_DWORD(&reg->iobase_window, 0x0003);
+			wrt_reg_dword(&reg->iobase_window, 0x0003);
 			udelay(10);
 		} else
 			rval = QLA_FUNCTION_TIMEOUT;
@@ -3385,13 +3385,13 @@ qla2xxx_check_risc_status(scsi_qla_host_t *vha)
 		goto done;
 
 next_test:
-	if (RD_REG_DWORD(&reg->iobase_c8) & BIT_3)
+	if (rd_reg_dword(&reg->iobase_c8) & BIT_3)
 		ql_log(ql_log_info, vha, 0x504c,
 		    "Additional code -- 0x55AA.\n");
 
 done:
-	WRT_REG_DWORD(&reg->iobase_window, 0x0000);
-	RD_REG_DWORD(&reg->iobase_window);
+	wrt_reg_dword(&reg->iobase_window, 0x0000);
+	rd_reg_dword(&reg->iobase_window);
 }
 
 /**
@@ -3435,14 +3435,14 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
-		stat = RD_REG_DWORD(&reg->host_status);
+		stat = rd_reg_dword(&reg->host_status);
 		if (qla2x00_check_reg32_for_disconnect(vha, stat))
 			break;
 		if (stat & HSRX_RISC_PAUSED) {
 			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
-			hccr = RD_REG_DWORD(&reg->hccr);
+			hccr = rd_reg_dword(&reg->hccr);
 
 			ql_log(ql_log_warn, vha, 0x504b,
 			    "RISC paused -- HCCR=%x, Dumping firmware.\n",
@@ -3467,9 +3467,9 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			break;
 		case INTR_ASYNC_EVENT:
 			mb[0] = MSW(stat);
-			mb[1] = RD_REG_WORD(&reg->mailbox1);
-			mb[2] = RD_REG_WORD(&reg->mailbox2);
-			mb[3] = RD_REG_WORD(&reg->mailbox3);
+			mb[1] = rd_reg_word(&reg->mailbox1);
+			mb[2] = rd_reg_word(&reg->mailbox2);
+			mb[3] = rd_reg_word(&reg->mailbox3);
 			qla2x00_async_event(vha, rsp, mb);
 			break;
 		case INTR_RSP_QUE_UPDATE:
@@ -3489,8 +3489,8 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			    "Unrecognized interrupt type (%d).\n", stat * 0xff);
 			break;
 		}
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-		RD_REG_DWORD_RELAXED(&reg->hccr);
+		wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
+		rd_reg_dword_relaxed(&reg->hccr);
 		if (unlikely(IS_QLA83XX(ha) && (ha->pdev->revision == 1)))
 			ndelay(3500);
 	}
@@ -3529,8 +3529,8 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	qla24xx_process_response_queue(vha, rsp);
 	if (!ha->flags.disable_msix_handshake) {
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-		RD_REG_DWORD_RELAXED(&reg->hccr);
+		wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
+		rd_reg_dword_relaxed(&reg->hccr);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -3564,14 +3564,14 @@ qla24xx_msix_default(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	do {
-		stat = RD_REG_DWORD(&reg->host_status);
+		stat = rd_reg_dword(&reg->host_status);
 		if (qla2x00_check_reg32_for_disconnect(vha, stat))
 			break;
 		if (stat & HSRX_RISC_PAUSED) {
 			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
-			hccr = RD_REG_DWORD(&reg->hccr);
+			hccr = rd_reg_dword(&reg->hccr);
 
 			ql_log(ql_log_info, vha, 0x5050,
 			    "RISC paused -- HCCR=%x, Dumping firmware.\n",
@@ -3596,9 +3596,9 @@ qla24xx_msix_default(int irq, void *dev_id)
 			break;
 		case INTR_ASYNC_EVENT:
 			mb[0] = MSW(stat);
-			mb[1] = RD_REG_WORD(&reg->mailbox1);
-			mb[2] = RD_REG_WORD(&reg->mailbox2);
-			mb[3] = RD_REG_WORD(&reg->mailbox3);
+			mb[1] = rd_reg_word(&reg->mailbox1);
+			mb[2] = rd_reg_word(&reg->mailbox2);
+			mb[3] = rd_reg_word(&reg->mailbox3);
 			qla2x00_async_event(vha, rsp, mb);
 			break;
 		case INTR_RSP_QUE_UPDATE:
@@ -3618,7 +3618,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 			    "Unrecognized interrupt type (%d).\n", stat & 0xff);
 			break;
 		}
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+		wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
 	} while (0);
 	qla2x00_handle_mbx_completion(ha, status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -3669,7 +3669,7 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
 
 	reg = &ha->iobase->isp24;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	queue_work(ha->wq, &qpair->q_work);
@@ -3930,7 +3930,7 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		goto fail;
 
 	spin_lock_irq(&ha->hardware_lock);
-	WRT_REG_WORD(&reg->isp.semaphore, 0);
+	wrt_reg_word(&reg->isp.semaphore, 0);
 	spin_unlock_irq(&ha->hardware_lock);
 
 fail:
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 6dfb6aca5960..451d88733fd5 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -226,7 +226,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		if (mboxes & BIT_0) {
 			ql_dbg(ql_dbg_mbx, vha, 0x1112,
 			    "mbox[%d]<-0x%04x\n", cnt, *iptr);
-			WRT_REG_WORD(optr, *iptr);
+			wrt_reg_word(optr, *iptr);
 		}
 
 		mboxes >>= 1;
@@ -252,11 +252,11 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
 		if (IS_P3P_TYPE(ha))
-			WRT_REG_DWORD(&reg->isp82.hint, HINT_MBX_INT_PENDING);
+			wrt_reg_dword(&reg->isp82.hint, HINT_MBX_INT_PENDING);
 		else if (IS_FWI2_CAPABLE(ha))
-			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
+			wrt_reg_dword(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
-			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
+			wrt_reg_word(&reg->isp.hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		wait_time = jiffies;
@@ -299,7 +299,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		    "Cmd=%x Polling Mode.\n", command);
 
 		if (IS_P3P_TYPE(ha)) {
-			if (RD_REG_DWORD(&reg->isp82.hint) &
+			if (rd_reg_dword(&reg->isp82.hint) &
 				HINT_MBX_INT_PENDING) {
 				ha->flags.mbox_busy = 0;
 				spin_unlock_irqrestore(&ha->hardware_lock,
@@ -310,11 +310,11 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 				rval = QLA_FUNCTION_TIMEOUT;
 				goto premature_exit;
 			}
-			WRT_REG_DWORD(&reg->isp82.hint, HINT_MBX_INT_PENDING);
+			wrt_reg_dword(&reg->isp82.hint, HINT_MBX_INT_PENDING);
 		} else if (IS_FWI2_CAPABLE(ha))
-			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
+			wrt_reg_dword(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
-			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
+			wrt_reg_word(&reg->isp.hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		wait_time = jiffies + mcp->tov * HZ; /* wait at most tov secs */
@@ -412,14 +412,14 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		uint16_t        w;
 
 		if (IS_FWI2_CAPABLE(ha)) {
-			mb[0] = RD_REG_WORD(&reg->isp24.mailbox0);
-			mb[1] = RD_REG_WORD(&reg->isp24.mailbox1);
-			mb[2] = RD_REG_WORD(&reg->isp24.mailbox2);
-			mb[3] = RD_REG_WORD(&reg->isp24.mailbox3);
-			mb[7] = RD_REG_WORD(&reg->isp24.mailbox7);
-			ictrl = RD_REG_DWORD(&reg->isp24.ictrl);
-			host_status = RD_REG_DWORD(&reg->isp24.host_status);
-			hccr = RD_REG_DWORD(&reg->isp24.hccr);
+			mb[0] = rd_reg_word(&reg->isp24.mailbox0);
+			mb[1] = rd_reg_word(&reg->isp24.mailbox1);
+			mb[2] = rd_reg_word(&reg->isp24.mailbox2);
+			mb[3] = rd_reg_word(&reg->isp24.mailbox3);
+			mb[7] = rd_reg_word(&reg->isp24.mailbox7);
+			ictrl = rd_reg_dword(&reg->isp24.ictrl);
+			host_status = rd_reg_dword(&reg->isp24.host_status);
+			hccr = rd_reg_dword(&reg->isp24.hccr);
 
 			ql_log(ql_log_warn, vha, 0xd04c,
 			    "MBX Command timeout for cmd %x, iocontrol=%x jiffies=%lx "
@@ -429,7 +429,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 		} else {
 			mb[0] = RD_MAILBOX_REG(ha, &reg->isp, 0);
-			ictrl = RD_REG_WORD(&reg->isp.ictrl);
+			ictrl = rd_reg_word(&reg->isp.ictrl);
 			ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1119,
 			    "MBX Command timeout for cmd %x, iocontrol=%x jiffies=%lx "
 			    "mb[0]=0x%x\n", command, ictrl, jiffies, mb[0]);
@@ -572,15 +572,15 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		if (IS_FWI2_CAPABLE(ha) && !(IS_P3P_TYPE(ha))) {
 			ql_dbg(ql_dbg_mbx, vha, 0x1198,
 			    "host_status=%#x intr_ctrl=%#x intr_status=%#x\n",
-			    RD_REG_DWORD(&reg->isp24.host_status),
-			    RD_REG_DWORD(&reg->isp24.ictrl),
-			    RD_REG_DWORD(&reg->isp24.istatus));
+			    rd_reg_dword(&reg->isp24.host_status),
+			    rd_reg_dword(&reg->isp24.ictrl),
+			    rd_reg_dword(&reg->isp24.istatus));
 		} else {
 			ql_dbg(ql_dbg_mbx, vha, 0x1206,
 			    "ctrl_status=%#x ictrl=%#x istatus=%#x\n",
-			    RD_REG_WORD(&reg->isp.ctrl_status),
-			    RD_REG_WORD(&reg->isp.ictrl),
-			    RD_REG_WORD(&reg->isp.istatus));
+			    rd_reg_word(&reg->isp.ctrl_status),
+			    rd_reg_word(&reg->isp.ictrl),
+			    rd_reg_word(&reg->isp.istatus));
 		}
 	} else {
 		ql_dbg(ql_dbg_mbx, base_vha, 0x1021, "Done %s.\n", __func__);
@@ -4426,9 +4426,9 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (!(req->options & BIT_0)) {
-		WRT_REG_DWORD(req->req_q_in, 0);
+		wrt_reg_dword(req->req_q_in, 0);
 		if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
-			WRT_REG_DWORD(req->req_q_out, 0);
+			wrt_reg_dword(req->req_q_out, 0);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -4497,9 +4497,9 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (!(rsp->options & BIT_0)) {
-		WRT_REG_DWORD(rsp->rsp_q_out, 0);
+		wrt_reg_dword(rsp->rsp_q_out, 0);
 		if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
-			WRT_REG_DWORD(rsp->rsp_q_in, 0);
+			wrt_reg_dword(rsp->rsp_q_in, 0);
 	}
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -5412,18 +5412,18 @@ qla81xx_write_mpi_register(scsi_qla_host_t *vha, uint16_t *mb)
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
 	/* Write the MBC data to the registers */
-	WRT_REG_WORD(&reg->mailbox0, MBC_WRITE_MPI_REGISTER);
-	WRT_REG_WORD(&reg->mailbox1, mb[0]);
-	WRT_REG_WORD(&reg->mailbox2, mb[1]);
-	WRT_REG_WORD(&reg->mailbox3, mb[2]);
-	WRT_REG_WORD(&reg->mailbox4, mb[3]);
+	wrt_reg_word(&reg->mailbox0, MBC_WRITE_MPI_REGISTER);
+	wrt_reg_word(&reg->mailbox1, mb[0]);
+	wrt_reg_word(&reg->mailbox2, mb[1]);
+	wrt_reg_word(&reg->mailbox3, mb[2]);
+	wrt_reg_word(&reg->mailbox4, mb[3]);
 
-	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
+	wrt_reg_dword(&reg->hccr, HCCRX_SET_HOST_INT);
 
 	/* Poll for MBC interrupt */
 	for (timer = 6000000; timer; timer--) {
 		/* Check for pending interrupts. */
-		stat = RD_REG_DWORD(&reg->host_status);
+		stat = rd_reg_dword(&reg->host_status);
 		if (stat & HSRX_RISC_INT) {
 			stat &= 0xff;
 
@@ -5431,10 +5431,10 @@ qla81xx_write_mpi_register(scsi_qla_host_t *vha, uint16_t *mb)
 			    stat == 0x10 || stat == 0x11) {
 				set_bit(MBX_INTERRUPT,
 				    &ha->mbx_cmd_flags);
-				mb0 = RD_REG_WORD(&reg->mailbox0);
-				WRT_REG_DWORD(&reg->hccr,
+				mb0 = rd_reg_word(&reg->mailbox0);
+				wrt_reg_dword(&reg->hccr,
 				    HCCRX_CLR_RISC_INT);
-				RD_REG_DWORD(&reg->hccr);
+				rd_reg_dword(&reg->hccr);
 				break;
 			}
 		}
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 6df48494b2b3..b791226f4e1f 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -117,7 +117,7 @@ qlafx00_mailbox_command(scsi_qla_host_t *vha, struct mbx_cmd_32 *mcp)
 
 	for (cnt = 0; cnt < ha->mbx_count; cnt++) {
 		if (mboxes & BIT_0)
-			WRT_REG_DWORD(optr, *iptr);
+			wrt_reg_dword(optr, *iptr);
 
 		mboxes >>= 1;
 		optr++;
@@ -676,14 +676,14 @@ qlafx00_config_rings(struct scsi_qla_host *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_fx00 __iomem *reg = &ha->iobase->ispfx00;
 
-	WRT_REG_DWORD(&reg->req_q_in, 0);
-	WRT_REG_DWORD(&reg->req_q_out, 0);
+	wrt_reg_dword(&reg->req_q_in, 0);
+	wrt_reg_dword(&reg->req_q_out, 0);
 
-	WRT_REG_DWORD(&reg->rsp_q_in, 0);
-	WRT_REG_DWORD(&reg->rsp_q_out, 0);
+	wrt_reg_dword(&reg->rsp_q_in, 0);
+	wrt_reg_dword(&reg->rsp_q_out, 0);
 
 	/* PCI posting */
-	RD_REG_DWORD(&reg->rsp_q_out);
+	rd_reg_dword(&reg->rsp_q_out);
 }
 
 char *
@@ -912,9 +912,9 @@ qlafx00_init_fw_ready(scsi_qla_host_t *vha)
 	/* 30 seconds wait - Adjust if required */
 	wait_time = 30;
 
-	pseudo_aen = RD_REG_DWORD(&reg->pseudoaen);
+	pseudo_aen = rd_reg_dword(&reg->pseudoaen);
 	if (pseudo_aen == 1) {
-		aenmbx7 = RD_REG_DWORD(&reg->initval7);
+		aenmbx7 = rd_reg_dword(&reg->initval7);
 		ha->mbx_intr_code = MSW(aenmbx7);
 		ha->rqstq_intr_code = LSW(aenmbx7);
 		rval = qlafx00_driver_shutdown(vha, 10);
@@ -925,7 +925,7 @@ qlafx00_init_fw_ready(scsi_qla_host_t *vha)
 	/* wait time before firmware ready */
 	wtime = jiffies + (wait_time * HZ);
 	do {
-		aenmbx = RD_REG_DWORD(&reg->aenmailbox0);
+		aenmbx = rd_reg_dword(&reg->aenmailbox0);
 		barrier();
 		ql_dbg(ql_dbg_mbx, vha, 0x0133,
 		    "aenmbx: 0x%x\n", aenmbx);
@@ -944,15 +944,15 @@ qlafx00_init_fw_ready(scsi_qla_host_t *vha)
 
 		case MBA_FW_RESTART_CMPLT:
 			/* Set the mbx and rqstq intr code */
-			aenmbx7 = RD_REG_DWORD(&reg->aenmailbox7);
+			aenmbx7 = rd_reg_dword(&reg->aenmailbox7);
 			ha->mbx_intr_code = MSW(aenmbx7);
 			ha->rqstq_intr_code = LSW(aenmbx7);
-			ha->req_que_off = RD_REG_DWORD(&reg->aenmailbox1);
-			ha->rsp_que_off = RD_REG_DWORD(&reg->aenmailbox3);
-			ha->req_que_len = RD_REG_DWORD(&reg->aenmailbox5);
-			ha->rsp_que_len = RD_REG_DWORD(&reg->aenmailbox6);
-			WRT_REG_DWORD(&reg->aenmailbox0, 0);
-			RD_REG_DWORD_RELAXED(&reg->aenmailbox0);
+			ha->req_que_off = rd_reg_dword(&reg->aenmailbox1);
+			ha->rsp_que_off = rd_reg_dword(&reg->aenmailbox3);
+			ha->req_que_len = rd_reg_dword(&reg->aenmailbox5);
+			ha->rsp_que_len = rd_reg_dword(&reg->aenmailbox6);
+			wrt_reg_dword(&reg->aenmailbox0, 0);
+			rd_reg_dword_relaxed(&reg->aenmailbox0);
 			ql_dbg(ql_dbg_init, vha, 0x0134,
 			    "f/w returned mbx_intr_code: 0x%x, "
 			    "rqstq_intr_code: 0x%x\n",
@@ -982,13 +982,13 @@ qlafx00_init_fw_ready(scsi_qla_host_t *vha)
 			 * 3. issue Get FW State Mbox cmd to determine fw state
 			 * Set the mbx and rqstq intr code from Shadow Regs
 			 */
-			aenmbx7 = RD_REG_DWORD(&reg->initval7);
+			aenmbx7 = rd_reg_dword(&reg->initval7);
 			ha->mbx_intr_code = MSW(aenmbx7);
 			ha->rqstq_intr_code = LSW(aenmbx7);
-			ha->req_que_off = RD_REG_DWORD(&reg->initval1);
-			ha->rsp_que_off = RD_REG_DWORD(&reg->initval3);
-			ha->req_que_len = RD_REG_DWORD(&reg->initval5);
-			ha->rsp_que_len = RD_REG_DWORD(&reg->initval6);
+			ha->req_que_off = rd_reg_dword(&reg->initval1);
+			ha->rsp_que_off = rd_reg_dword(&reg->initval3);
+			ha->req_que_len = rd_reg_dword(&reg->initval5);
+			ha->rsp_que_len = rd_reg_dword(&reg->initval6);
 			ql_dbg(ql_dbg_init, vha, 0x0135,
 			    "f/w returned mbx_intr_code: 0x%x, "
 			    "rqstq_intr_code: 0x%x\n",
@@ -1034,7 +1034,7 @@ qlafx00_init_fw_ready(scsi_qla_host_t *vha)
 			if (time_after_eq(jiffies, wtime)) {
 				ql_dbg(ql_dbg_init, vha, 0x0137,
 				    "Init f/w failed: aen[7]: 0x%x\n",
-				    RD_REG_DWORD(&reg->aenmailbox7));
+				    rd_reg_dword(&reg->aenmailbox7));
 				rval = QLA_FUNCTION_FAILED;
 				done = true;
 				break;
@@ -1428,7 +1428,7 @@ qlafx00_init_response_q_entries(struct rsp_que *rsp)
 	pkt = rsp->ring_ptr;
 	for (cnt = 0; cnt < rsp->length; cnt++) {
 		pkt->signature = RESPONSE_PROCESSED;
-		WRT_REG_DWORD((void __force __iomem *)&pkt->signature,
+		wrt_reg_dword((void __force __iomem *)&pkt->signature,
 		    RESPONSE_PROCESSED);
 		pkt++;
 	}
@@ -1444,13 +1444,13 @@ qlafx00_rescan_isp(scsi_qla_host_t *vha)
 
 	qla2x00_request_irqs(ha, ha->rsp_q_map[0]);
 
-	aenmbx7 = RD_REG_DWORD(&reg->aenmailbox7);
+	aenmbx7 = rd_reg_dword(&reg->aenmailbox7);
 	ha->mbx_intr_code = MSW(aenmbx7);
 	ha->rqstq_intr_code = LSW(aenmbx7);
-	ha->req_que_off = RD_REG_DWORD(&reg->aenmailbox1);
-	ha->rsp_que_off = RD_REG_DWORD(&reg->aenmailbox3);
-	ha->req_que_len = RD_REG_DWORD(&reg->aenmailbox5);
-	ha->rsp_que_len = RD_REG_DWORD(&reg->aenmailbox6);
+	ha->req_que_off = rd_reg_dword(&reg->aenmailbox1);
+	ha->rsp_que_off = rd_reg_dword(&reg->aenmailbox3);
+	ha->req_que_len = rd_reg_dword(&reg->aenmailbox5);
+	ha->rsp_que_len = rd_reg_dword(&reg->aenmailbox6);
 
 	ql_dbg(ql_dbg_disc, vha, 0x2094,
 	    "fw returned mbx_intr_code: 0x%x, rqstq_intr_code: 0x%x "
@@ -1495,7 +1495,7 @@ qlafx00_timer_routine(scsi_qla_host_t *vha)
 		    (!test_bit(UNLOADING, &vha->dpc_flags)) &&
 		    (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) &&
 		    (ha->mr.fw_hbt_en)) {
-			fw_heart_beat = RD_REG_DWORD(&reg->fwheartbeat);
+			fw_heart_beat = rd_reg_dword(&reg->fwheartbeat);
 			if (fw_heart_beat != ha->mr.old_fw_hbt_cnt) {
 				ha->mr.old_fw_hbt_cnt = fw_heart_beat;
 				ha->mr.fw_hbt_miss_cnt = 0;
@@ -1515,7 +1515,7 @@ qlafx00_timer_routine(scsi_qla_host_t *vha)
 
 	if (test_bit(FX00_RESET_RECOVERY, &vha->dpc_flags)) {
 		/* Reset recovery to be performed in timer routine */
-		aenmbx0 = RD_REG_DWORD(&reg->aenmailbox0);
+		aenmbx0 = rd_reg_dword(&reg->aenmailbox0);
 		if (ha->mr.fw_reset_timer_exp) {
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
@@ -2721,7 +2721,7 @@ qlafx00_process_response_queue(struct scsi_qla_host *vha,
 	uint16_t lreq_q_in = 0;
 	uint16_t lreq_q_out = 0;
 
-	lreq_q_in = RD_REG_DWORD(rsp->rsp_q_in);
+	lreq_q_in = rd_reg_dword(rsp->rsp_q_in);
 	lreq_q_out = rsp->ring_index;
 
 	while (lreq_q_in != lreq_q_out) {
@@ -2783,7 +2783,7 @@ qlafx00_process_response_queue(struct scsi_qla_host *vha,
 	}
 
 	/* Adjust ring index */
-	WRT_REG_DWORD(rsp->rsp_q_out, rsp->ring_index);
+	wrt_reg_dword(rsp->rsp_q_out, rsp->ring_index);
 }
 
 /**
@@ -2814,9 +2814,9 @@ qlafx00_async_event(scsi_qla_host_t *vha)
 		break;
 
 	case QLAFX00_MBA_PORT_UPDATE:		/* Port database update */
-		ha->aenmb[1] = RD_REG_DWORD(&reg->aenmailbox1);
-		ha->aenmb[2] = RD_REG_DWORD(&reg->aenmailbox2);
-		ha->aenmb[3] = RD_REG_DWORD(&reg->aenmailbox3);
+		ha->aenmb[1] = rd_reg_dword(&reg->aenmailbox1);
+		ha->aenmb[2] = rd_reg_dword(&reg->aenmailbox2);
+		ha->aenmb[3] = rd_reg_dword(&reg->aenmailbox3);
 		ql_dbg(ql_dbg_async, vha, 0x5077,
 		    "Asynchronous port Update received "
 		    "aenmb[0]: %x, aenmb[1]: %x, aenmb[2]: %x, aenmb[3]: %x\n",
@@ -2846,13 +2846,13 @@ qlafx00_async_event(scsi_qla_host_t *vha)
 		break;
 
 	default:
-		ha->aenmb[1] = RD_REG_DWORD(&reg->aenmailbox1);
-		ha->aenmb[2] = RD_REG_DWORD(&reg->aenmailbox2);
-		ha->aenmb[3] = RD_REG_DWORD(&reg->aenmailbox3);
-		ha->aenmb[4] = RD_REG_DWORD(&reg->aenmailbox4);
-		ha->aenmb[5] = RD_REG_DWORD(&reg->aenmailbox5);
-		ha->aenmb[6] = RD_REG_DWORD(&reg->aenmailbox6);
-		ha->aenmb[7] = RD_REG_DWORD(&reg->aenmailbox7);
+		ha->aenmb[1] = rd_reg_dword(&reg->aenmailbox1);
+		ha->aenmb[2] = rd_reg_dword(&reg->aenmailbox2);
+		ha->aenmb[3] = rd_reg_dword(&reg->aenmailbox3);
+		ha->aenmb[4] = rd_reg_dword(&reg->aenmailbox4);
+		ha->aenmb[5] = rd_reg_dword(&reg->aenmailbox5);
+		ha->aenmb[6] = rd_reg_dword(&reg->aenmailbox6);
+		ha->aenmb[7] = rd_reg_dword(&reg->aenmailbox7);
 		ql_dbg(ql_dbg_async, vha, 0x5078,
 		    "AEN:%04x %04x %04x %04x :%04x %04x %04x %04x\n",
 		    ha->aenmb[0], ha->aenmb[1], ha->aenmb[2], ha->aenmb[3],
@@ -2885,7 +2885,7 @@ qlafx00_mbx_completion(scsi_qla_host_t *vha, uint32_t mb0)
 	wptr = &reg->mailbox17;
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
-		ha->mailbox_out32[cnt] = RD_REG_DWORD(wptr);
+		ha->mailbox_out32[cnt] = rd_reg_dword(wptr);
 		wptr++;
 	}
 }
@@ -2939,13 +2939,13 @@ qlafx00_intr_handler(int irq, void *dev_id)
 			break;
 
 		if (stat & QLAFX00_INTR_MB_CMPLT) {
-			mb[0] = RD_REG_DWORD(&reg->mailbox16);
+			mb[0] = rd_reg_dword(&reg->mailbox16);
 			qlafx00_mbx_completion(vha, mb[0]);
 			status |= MBX_INTERRUPT;
 			clr_intr |= QLAFX00_INTR_MB_CMPLT;
 		}
 		if (intr_stat & QLAFX00_INTR_ASYNC_CMPLT) {
-			ha->aenmb[0] = RD_REG_DWORD(&reg->aenmailbox0);
+			ha->aenmb[0] = rd_reg_dword(&reg->aenmailbox0);
 			qlafx00_async_event(vha);
 			clr_intr |= QLAFX00_INTR_ASYNC_CMPLT;
 		}
@@ -3113,7 +3113,7 @@ qlafx00_start_scsi(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = RD_REG_DWORD_RELAXED(req->req_q_out);
+		cnt = rd_reg_dword_relaxed(req->req_q_out);
 
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
@@ -3178,7 +3178,7 @@ qlafx00_start_scsi(srb_t *sp)
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
-	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+	wrt_reg_dword(req->req_q_in, req->ring_index);
 	QLAFX00_SET_HST_INTR(ha, ha->rqstq_intr_code);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 2b335d86f174..762250891a8f 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -359,47 +359,47 @@ struct config_info_data {
 #define CONTINUE_A64_TYPE_FX00	0x03	/* Continuation entry. */
 
 #define QLAFX00_SET_HST_INTR(ha, value) \
-	WRT_REG_DWORD((ha)->cregbase + QLAFX00_HST_TO_HBA_REG, \
+	wrt_reg_dword((ha)->cregbase + QLAFX00_HST_TO_HBA_REG, \
 	value)
 
 #define QLAFX00_CLR_HST_INTR(ha, value) \
-	WRT_REG_DWORD((ha)->cregbase + QLAFX00_HBA_TO_HOST_REG, \
+	wrt_reg_dword((ha)->cregbase + QLAFX00_HBA_TO_HOST_REG, \
 	~value)
 
 #define QLAFX00_RD_INTR_REG(ha) \
-	RD_REG_DWORD((ha)->cregbase + QLAFX00_HBA_TO_HOST_REG)
+	rd_reg_dword((ha)->cregbase + QLAFX00_HBA_TO_HOST_REG)
 
 #define QLAFX00_CLR_INTR_REG(ha, value) \
-	WRT_REG_DWORD((ha)->cregbase + QLAFX00_HBA_TO_HOST_REG, \
+	wrt_reg_dword((ha)->cregbase + QLAFX00_HBA_TO_HOST_REG, \
 	~value)
 
 #define QLAFX00_SET_HBA_SOC_REG(ha, off, val)\
-	WRT_REG_DWORD((ha)->cregbase + off, val)
+	wrt_reg_dword((ha)->cregbase + off, val)
 
 #define QLAFX00_GET_HBA_SOC_REG(ha, off)\
-	RD_REG_DWORD((ha)->cregbase + off)
+	rd_reg_dword((ha)->cregbase + off)
 
 #define QLAFX00_HBA_RST_REG(ha, val)\
-	WRT_REG_DWORD((ha)->cregbase + QLAFX00_HST_RST_REG, val)
+	wrt_reg_dword((ha)->cregbase + QLAFX00_HST_RST_REG, val)
 
 #define QLAFX00_RD_ICNTRL_REG(ha) \
-	RD_REG_DWORD((ha)->cregbase + QLAFX00_HBA_ICNTRL_REG)
+	rd_reg_dword((ha)->cregbase + QLAFX00_HBA_ICNTRL_REG)
 
 #define QLAFX00_ENABLE_ICNTRL_REG(ha) \
-	WRT_REG_DWORD((ha)->cregbase + QLAFX00_HBA_ICNTRL_REG, \
+	wrt_reg_dword((ha)->cregbase + QLAFX00_HBA_ICNTRL_REG, \
 	(QLAFX00_GET_HBA_SOC_REG(ha, QLAFX00_HBA_ICNTRL_REG) | \
 	 QLAFX00_ICR_ENB_MASK))
 
 #define QLAFX00_DISABLE_ICNTRL_REG(ha) \
-	WRT_REG_DWORD((ha)->cregbase + QLAFX00_HBA_ICNTRL_REG, \
+	wrt_reg_dword((ha)->cregbase + QLAFX00_HBA_ICNTRL_REG, \
 	(QLAFX00_GET_HBA_SOC_REG(ha, QLAFX00_HBA_ICNTRL_REG) & \
 	 QLAFX00_ICR_DIS_MASK))
 
 #define QLAFX00_RD_REG(ha, off) \
-	RD_REG_DWORD((ha)->cregbase + off)
+	rd_reg_dword((ha)->cregbase + off)
 
 #define QLAFX00_WR_REG(ha, off, val) \
-	WRT_REG_DWORD((ha)->cregbase + off, val)
+	wrt_reg_dword((ha)->cregbase + off, val)
 
 struct qla_mt_iocb_rqst_fx00 {
 	__le32 reserved_0;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 84732125b559..179d0e7653f3 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -384,7 +384,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    RD_REG_DWORD_RELAXED(req->req_q_out);
+		    rd_reg_dword_relaxed(req->req_q_out);
 
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
@@ -514,7 +514,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	}
 
 	/* Set chip new ring index. */
-	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+	wrt_reg_dword(req->req_q_in, req->ring_index);
 
 queuing_error:
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index c04150110417..df13d77fa582 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -370,7 +370,7 @@ qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong off_in,
 	/* Read back value to make sure write has gone through before trying
 	 * to use it.
 	 */
-	win_read = RD_REG_DWORD(CRB_WINDOW_2M + ha->nx_pcibase);
+	win_read = rd_reg_dword(CRB_WINDOW_2M + ha->nx_pcibase);
 	if (win_read != ha->crb_win) {
 		ql_dbg(ql_dbg_p3p, vha, 0xb000,
 		    "%s: Written crbwin (0x%x) "
@@ -520,7 +520,7 @@ qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
 		qla82xx_crb_win_lock(ha);
 		qla82xx_pci_set_crbwindow_2M(ha, off_in, &off);
 	}
-	data = RD_REG_DWORD(off);
+	data = rd_reg_dword(off);
 
 	if (rv == 1) {
 		qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_UNLOCK));
@@ -937,17 +937,17 @@ qla82xx_md_rw_32(struct qla_hw_data *ha, uint32_t off, u32 data, uint8_t flag)
 {
 	uint32_t  off_value, rval = 0;
 
-	WRT_REG_DWORD(CRB_WINDOW_2M + ha->nx_pcibase, off & 0xFFFF0000);
+	wrt_reg_dword(CRB_WINDOW_2M + ha->nx_pcibase, off & 0xFFFF0000);
 
 	/* Read back value to make sure write has gone through */
-	RD_REG_DWORD(CRB_WINDOW_2M + ha->nx_pcibase);
+	rd_reg_dword(CRB_WINDOW_2M + ha->nx_pcibase);
 	off_value  = (off & 0x0000FFFF);
 
 	if (flag)
-		WRT_REG_DWORD(off_value + CRB_INDIRECT_2M + ha->nx_pcibase,
+		wrt_reg_dword(off_value + CRB_INDIRECT_2M + ha->nx_pcibase,
 			      data);
 	else
-		rval = RD_REG_DWORD(off_value + CRB_INDIRECT_2M +
+		rval = rd_reg_dword(off_value + CRB_INDIRECT_2M +
 				    ha->nx_pcibase);
 
 	return rval;
@@ -1791,9 +1791,9 @@ void qla82xx_config_rings(struct scsi_qla_host *vha)
 	put_unaligned_le64(req->dma, &icb->request_q_address);
 	put_unaligned_le64(rsp->dma, &icb->response_q_address);
 
-	WRT_REG_DWORD(&reg->req_q_out[0], 0);
-	WRT_REG_DWORD(&reg->rsp_q_in[0], 0);
-	WRT_REG_DWORD(&reg->rsp_q_out[0], 0);
+	wrt_reg_dword(&reg->req_q_out[0], 0);
+	wrt_reg_dword(&reg->rsp_q_in[0], 0);
+	wrt_reg_dword(&reg->rsp_q_out[0], 0);
 }
 
 static int
@@ -2008,7 +2008,7 @@ qla82xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	ha->mailbox_out[0] = mb0;
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
-		ha->mailbox_out[cnt] = RD_REG_WORD(wptr);
+		ha->mailbox_out[cnt] = rd_reg_word(wptr);
 		wptr++;
 	}
 
@@ -2070,8 +2070,8 @@ qla82xx_intr_handler(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 1; iter--; ) {
 
-		if (RD_REG_DWORD(&reg->host_int)) {
-			stat = RD_REG_DWORD(&reg->host_status);
+		if (rd_reg_dword(&reg->host_int)) {
+			stat = rd_reg_dword(&reg->host_status);
 
 			switch (stat & 0xff) {
 			case 0x1:
@@ -2083,9 +2083,9 @@ qla82xx_intr_handler(int irq, void *dev_id)
 				break;
 			case 0x12:
 				mb[0] = MSW(stat);
-				mb[1] = RD_REG_WORD(&reg->mailbox_out[1]);
-				mb[2] = RD_REG_WORD(&reg->mailbox_out[2]);
-				mb[3] = RD_REG_WORD(&reg->mailbox_out[3]);
+				mb[1] = rd_reg_word(&reg->mailbox_out[1]);
+				mb[2] = rd_reg_word(&reg->mailbox_out[2]);
+				mb[3] = rd_reg_word(&reg->mailbox_out[3]);
 				qla2x00_async_event(vha, rsp, mb);
 				break;
 			case 0x13:
@@ -2098,7 +2098,7 @@ qla82xx_intr_handler(int irq, void *dev_id)
 				break;
 			}
 		}
-		WRT_REG_DWORD(&reg->host_int, 0);
+		wrt_reg_dword(&reg->host_int, 0);
 	}
 
 	qla2x00_handle_mbx_completion(ha, status);
@@ -2136,11 +2136,11 @@ qla82xx_msix_default(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	do {
-		host_int = RD_REG_DWORD(&reg->host_int);
+		host_int = rd_reg_dword(&reg->host_int);
 		if (qla2x00_check_reg32_for_disconnect(vha, host_int))
 			break;
 		if (host_int) {
-			stat = RD_REG_DWORD(&reg->host_status);
+			stat = rd_reg_dword(&reg->host_status);
 
 			switch (stat & 0xff) {
 			case 0x1:
@@ -2152,9 +2152,9 @@ qla82xx_msix_default(int irq, void *dev_id)
 				break;
 			case 0x12:
 				mb[0] = MSW(stat);
-				mb[1] = RD_REG_WORD(&reg->mailbox_out[1]);
-				mb[2] = RD_REG_WORD(&reg->mailbox_out[2]);
-				mb[3] = RD_REG_WORD(&reg->mailbox_out[3]);
+				mb[1] = rd_reg_word(&reg->mailbox_out[1]);
+				mb[2] = rd_reg_word(&reg->mailbox_out[2]);
+				mb[3] = rd_reg_word(&reg->mailbox_out[3]);
 				qla2x00_async_event(vha, rsp, mb);
 				break;
 			case 0x13:
@@ -2167,7 +2167,7 @@ qla82xx_msix_default(int irq, void *dev_id)
 				break;
 			}
 		}
-		WRT_REG_DWORD(&reg->host_int, 0);
+		wrt_reg_dword(&reg->host_int, 0);
 	} while (0);
 
 	qla2x00_handle_mbx_completion(ha, status);
@@ -2197,11 +2197,11 @@ qla82xx_msix_rsp_q(int irq, void *dev_id)
 	reg = &ha->iobase->isp82;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
-	host_int = RD_REG_DWORD(&reg->host_int);
+	host_int = rd_reg_dword(&reg->host_int);
 	if (qla2x00_check_reg32_for_disconnect(vha, host_int))
 		goto out;
 	qla24xx_process_response_queue(vha, rsp);
-	WRT_REG_DWORD(&reg->host_int, 0);
+	wrt_reg_dword(&reg->host_int, 0);
 out:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return IRQ_HANDLED;
@@ -2232,11 +2232,11 @@ qla82xx_poll(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 
-	host_int = RD_REG_DWORD(&reg->host_int);
+	host_int = rd_reg_dword(&reg->host_int);
 	if (qla2x00_check_reg32_for_disconnect(vha, host_int))
 		goto out;
 	if (host_int) {
-		stat = RD_REG_DWORD(&reg->host_status);
+		stat = rd_reg_dword(&reg->host_status);
 		switch (stat & 0xff) {
 		case 0x1:
 		case 0x2:
@@ -2247,9 +2247,9 @@ qla82xx_poll(int irq, void *dev_id)
 			break;
 		case 0x12:
 			mb[0] = MSW(stat);
-			mb[1] = RD_REG_WORD(&reg->mailbox_out[1]);
-			mb[2] = RD_REG_WORD(&reg->mailbox_out[2]);
-			mb[3] = RD_REG_WORD(&reg->mailbox_out[3]);
+			mb[1] = rd_reg_word(&reg->mailbox_out[1]);
+			mb[2] = rd_reg_word(&reg->mailbox_out[2]);
+			mb[3] = rd_reg_word(&reg->mailbox_out[3]);
 			qla2x00_async_event(vha, rsp, mb);
 			break;
 		case 0x13:
@@ -2261,7 +2261,7 @@ qla82xx_poll(int irq, void *dev_id)
 			    stat * 0xff);
 			break;
 		}
-		WRT_REG_DWORD(&reg->host_int, 0);
+		wrt_reg_dword(&reg->host_int, 0);
 	}
 out:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -2819,10 +2819,10 @@ qla82xx_start_iocbs(scsi_qla_host_t *vha)
 	if (ql2xdbwr)
 		qla82xx_wr_32(ha, (unsigned long)ha->nxdb_wr_ptr, dbval);
 	else {
-		WRT_REG_DWORD(ha->nxdb_wr_ptr, dbval);
+		wrt_reg_dword(ha->nxdb_wr_ptr, dbval);
 		wmb();
-		while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
-			WRT_REG_DWORD(ha->nxdb_wr_ptr, dbval);
+		while (rd_reg_dword(ha->nxdb_rd_ptr) != dbval) {
+			wrt_reg_dword(ha->nxdb_wr_ptr, dbval);
 			wmb();
 		}
 	}
@@ -3855,7 +3855,7 @@ qla82xx_minidump_process_rdocm(scsi_qla_host_t *vha,
 	loop_cnt = ocm_hdr->op_count;
 
 	for (i = 0; i < loop_cnt; i++) {
-		r_value = RD_REG_DWORD(r_addr + ha->nx_pcibase);
+		r_value = rd_reg_dword(r_addr + ha->nx_pcibase);
 		*data_ptr++ = cpu_to_le32(r_value);
 		r_addr += r_stride;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index c056f466f1f4..53f4cd2a065e 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -3946,8 +3946,8 @@ qla8044_intr_handler(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (iter = 1; iter--; ) {
 
-		if (RD_REG_DWORD(&reg->host_int)) {
-			stat = RD_REG_DWORD(&reg->host_status);
+		if (rd_reg_dword(&reg->host_int)) {
+			stat = rd_reg_dword(&reg->host_status);
 			if ((stat & HSRX_RISC_INT) == 0)
 				break;
 
@@ -3961,9 +3961,9 @@ qla8044_intr_handler(int irq, void *dev_id)
 				break;
 			case 0x12:
 				mb[0] = MSW(stat);
-				mb[1] = RD_REG_WORD(&reg->mailbox_out[1]);
-				mb[2] = RD_REG_WORD(&reg->mailbox_out[2]);
-				mb[3] = RD_REG_WORD(&reg->mailbox_out[3]);
+				mb[1] = rd_reg_word(&reg->mailbox_out[1]);
+				mb[2] = rd_reg_word(&reg->mailbox_out[2]);
+				mb[3] = rd_reg_word(&reg->mailbox_out[3]);
 				qla2x00_async_event(vha, rsp, mb);
 				break;
 			case 0x13:
@@ -3976,7 +3976,7 @@ qla8044_intr_handler(int irq, void *dev_id)
 				break;
 			}
 		}
-		WRT_REG_DWORD(&reg->host_int, 0);
+		wrt_reg_dword(&reg->host_int, 0);
 	}
 
 	qla2x00_handle_mbx_completion(ha, status);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e7d753df7d7c..87ce1814df04 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1216,9 +1216,9 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
 
 	if (IS_P3P_TYPE(ha))
-		return ((RD_REG_DWORD(&reg82->host_int)) == ISP_REG_DISCONNECT);
+		return ((rd_reg_dword(&reg82->host_int)) == ISP_REG_DISCONNECT);
 	else
-		return ((RD_REG_DWORD(&reg->host_status)) ==
+		return ((rd_reg_dword(&reg->host_status)) ==
 			ISP_REG_DISCONNECT);
 }
 
@@ -1902,8 +1902,8 @@ qla2x00_enable_intrs(struct qla_hw_data *ha)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->interrupts_on = 1;
 	/* enable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, ICR_EN_INT | ICR_EN_RISC);
-	RD_REG_WORD(&reg->ictrl);
+	wrt_reg_word(&reg->ictrl, ICR_EN_INT | ICR_EN_RISC);
+	rd_reg_word(&reg->ictrl);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 }
@@ -1917,8 +1917,8 @@ qla2x00_disable_intrs(struct qla_hw_data *ha)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->interrupts_on = 0;
 	/* disable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, 0);
-	RD_REG_WORD(&reg->ictrl);
+	wrt_reg_word(&reg->ictrl, 0);
+	rd_reg_word(&reg->ictrl);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
@@ -1930,8 +1930,8 @@ qla24xx_enable_intrs(struct qla_hw_data *ha)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->interrupts_on = 1;
-	WRT_REG_DWORD(&reg->ictrl, ICRX_EN_RISC_INT);
-	RD_REG_DWORD(&reg->ictrl);
+	wrt_reg_dword(&reg->ictrl, ICRX_EN_RISC_INT);
+	rd_reg_dword(&reg->ictrl);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
@@ -1945,8 +1945,8 @@ qla24xx_disable_intrs(struct qla_hw_data *ha)
 		return;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->interrupts_on = 0;
-	WRT_REG_DWORD(&reg->ictrl, 0);
-	RD_REG_DWORD(&reg->ictrl);
+	wrt_reg_dword(&reg->ictrl, 0);
+	rd_reg_dword(&reg->ictrl);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
@@ -7574,15 +7574,15 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)){
-		stat = RD_REG_WORD(&reg->hccr);
+		stat = rd_reg_word(&reg->hccr);
 		if (stat & HCCR_RISC_PAUSE)
 			risc_paused = 1;
 	} else if (IS_QLA23XX(ha)) {
-		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
+		stat = rd_reg_dword(&reg->u.isp2300.host_status);
 		if (stat & HSR_RISC_PAUSED)
 			risc_paused = 1;
 	} else if (IS_FWI2_CAPABLE(ha)) {
-		stat = RD_REG_DWORD(&reg24->host_status);
+		stat = rd_reg_dword(&reg24->host_status);
 		if (stat & HSRX_RISC_PAUSED)
 			risc_paused = 1;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 6deb25c58185..e45ace00410c 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -26,24 +26,24 @@ qla2x00_lock_nvram_access(struct qla_hw_data *ha)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha)) {
-		data = RD_REG_WORD(&reg->nvram);
+		data = rd_reg_word(&reg->nvram);
 		while (data & NVR_BUSY) {
 			udelay(100);
-			data = RD_REG_WORD(&reg->nvram);
+			data = rd_reg_word(&reg->nvram);
 		}
 
 		/* Lock resource */
-		WRT_REG_WORD(&reg->u.isp2300.host_semaphore, 0x1);
-		RD_REG_WORD(&reg->u.isp2300.host_semaphore);
+		wrt_reg_word(&reg->u.isp2300.host_semaphore, 0x1);
+		rd_reg_word(&reg->u.isp2300.host_semaphore);
 		udelay(5);
-		data = RD_REG_WORD(&reg->u.isp2300.host_semaphore);
+		data = rd_reg_word(&reg->u.isp2300.host_semaphore);
 		while ((data & BIT_0) == 0) {
 			/* Lock failed */
 			udelay(100);
-			WRT_REG_WORD(&reg->u.isp2300.host_semaphore, 0x1);
-			RD_REG_WORD(&reg->u.isp2300.host_semaphore);
+			wrt_reg_word(&reg->u.isp2300.host_semaphore, 0x1);
+			rd_reg_word(&reg->u.isp2300.host_semaphore);
 			udelay(5);
-			data = RD_REG_WORD(&reg->u.isp2300.host_semaphore);
+			data = rd_reg_word(&reg->u.isp2300.host_semaphore);
 		}
 	}
 }
@@ -58,8 +58,8 @@ qla2x00_unlock_nvram_access(struct qla_hw_data *ha)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha)) {
-		WRT_REG_WORD(&reg->u.isp2300.host_semaphore, 0);
-		RD_REG_WORD(&reg->u.isp2300.host_semaphore);
+		wrt_reg_word(&reg->u.isp2300.host_semaphore, 0);
+		rd_reg_word(&reg->u.isp2300.host_semaphore);
 	}
 }
 
@@ -73,15 +73,15 @@ qla2x00_nv_write(struct qla_hw_data *ha, uint16_t data)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wrt_reg_word(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
+	rd_reg_word(&reg->nvram);		/* PCI Posting. */
 	NVRAM_DELAY();
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_CLOCK |
+	wrt_reg_word(&reg->nvram, data | NVR_SELECT | NVR_CLOCK |
 	    NVR_WRT_ENABLE);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	rd_reg_word(&reg->nvram);		/* PCI Posting. */
 	NVRAM_DELAY();
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wrt_reg_word(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
+	rd_reg_word(&reg->nvram);		/* PCI Posting. */
 	NVRAM_DELAY();
 }
 
@@ -120,21 +120,21 @@ qla2x00_nvram_request(struct qla_hw_data *ha, uint32_t nv_cmd)
 
 	/* Read data from NVRAM. */
 	for (cnt = 0; cnt < 16; cnt++) {
-		WRT_REG_WORD(&reg->nvram, NVR_SELECT | NVR_CLOCK);
-		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		wrt_reg_word(&reg->nvram, NVR_SELECT | NVR_CLOCK);
+		rd_reg_word(&reg->nvram);	/* PCI Posting. */
 		NVRAM_DELAY();
 		data <<= 1;
-		reg_data = RD_REG_WORD(&reg->nvram);
+		reg_data = rd_reg_word(&reg->nvram);
 		if (reg_data & NVR_DATA_IN)
 			data |= BIT_0;
-		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		wrt_reg_word(&reg->nvram, NVR_SELECT);
+		rd_reg_word(&reg->nvram);	/* PCI Posting. */
 		NVRAM_DELAY();
 	}
 
 	/* Deselect chip. */
-	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wrt_reg_word(&reg->nvram, NVR_DESELECT);
+	rd_reg_word(&reg->nvram);		/* PCI Posting. */
 	NVRAM_DELAY();
 
 	return data;
@@ -171,8 +171,8 @@ qla2x00_nv_deselect(struct qla_hw_data *ha)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wrt_reg_word(&reg->nvram, NVR_DESELECT);
+	rd_reg_word(&reg->nvram);		/* PCI Posting. */
 	NVRAM_DELAY();
 }
 
@@ -216,8 +216,8 @@ qla2x00_write_nvram_word(struct qla_hw_data *ha, uint32_t addr, __le16 data)
 	qla2x00_nv_deselect(ha);
 
 	/* Wait for NVRAM to become ready */
-	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wrt_reg_word(&reg->nvram, NVR_SELECT);
+	rd_reg_word(&reg->nvram);		/* PCI Posting. */
 	wait_cnt = NVR_WAIT_CNT;
 	do {
 		if (!--wait_cnt) {
@@ -226,7 +226,7 @@ qla2x00_write_nvram_word(struct qla_hw_data *ha, uint32_t addr, __le16 data)
 			break;
 		}
 		NVRAM_DELAY();
-		word = RD_REG_WORD(&reg->nvram);
+		word = rd_reg_word(&reg->nvram);
 	} while ((word & NVR_DATA_IN) == 0);
 
 	qla2x00_nv_deselect(ha);
@@ -275,11 +275,11 @@ qla2x00_write_nvram_word_tmo(struct qla_hw_data *ha, uint32_t addr,
 	qla2x00_nv_deselect(ha);
 
 	/* Wait for NVRAM to become ready */
-	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wrt_reg_word(&reg->nvram, NVR_SELECT);
+	rd_reg_word(&reg->nvram);		/* PCI Posting. */
 	do {
 		NVRAM_DELAY();
-		word = RD_REG_WORD(&reg->nvram);
+		word = rd_reg_word(&reg->nvram);
 		if (!--tmo) {
 			ret = QLA_FUNCTION_FAILED;
 			break;
@@ -347,8 +347,8 @@ qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 		qla2x00_nv_deselect(ha);
 
 		/* Wait for NVRAM to become ready. */
-		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		wrt_reg_word(&reg->nvram, NVR_SELECT);
+		rd_reg_word(&reg->nvram);	/* PCI Posting. */
 		wait_cnt = NVR_WAIT_CNT;
 		do {
 			if (!--wait_cnt) {
@@ -357,7 +357,7 @@ qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 				break;
 			}
 			NVRAM_DELAY();
-			word = RD_REG_WORD(&reg->nvram);
+			word = rd_reg_word(&reg->nvram);
 		} while ((word & NVR_DATA_IN) == 0);
 
 		if (wait_cnt)
@@ -407,8 +407,8 @@ qla2x00_set_nvram_protection(struct qla_hw_data *ha, int stat)
 	qla2x00_nv_deselect(ha);
 
 	/* Wait for NVRAM to become ready. */
-	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wrt_reg_word(&reg->nvram, NVR_SELECT);
+	rd_reg_word(&reg->nvram);		/* PCI Posting. */
 	wait_cnt = NVR_WAIT_CNT;
 	do {
 		if (!--wait_cnt) {
@@ -417,7 +417,7 @@ qla2x00_set_nvram_protection(struct qla_hw_data *ha, int stat)
 			break;
 		}
 		NVRAM_DELAY();
-		word = RD_REG_WORD(&reg->nvram);
+		word = rd_reg_word(&reg->nvram);
 	} while ((word & NVR_DATA_IN) == 0);
 }
 
@@ -456,11 +456,11 @@ qla24xx_read_flash_dword(struct qla_hw_data *ha, uint32_t addr, uint32_t *data)
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	ulong cnt = 30000;
 
-	WRT_REG_DWORD(&reg->flash_addr, addr & ~FARX_DATA_FLAG);
+	wrt_reg_dword(&reg->flash_addr, addr & ~FARX_DATA_FLAG);
 
 	while (cnt--) {
-		if (RD_REG_DWORD(&reg->flash_addr) & FARX_DATA_FLAG) {
-			*data = RD_REG_DWORD(&reg->flash_data);
+		if (rd_reg_dword(&reg->flash_addr) & FARX_DATA_FLAG) {
+			*data = rd_reg_dword(&reg->flash_data);
 			return QLA_SUCCESS;
 		}
 		udelay(10);
@@ -499,11 +499,11 @@ qla24xx_write_flash_dword(struct qla_hw_data *ha, uint32_t addr, uint32_t data)
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	ulong cnt = 500000;
 
-	WRT_REG_DWORD(&reg->flash_data, data);
-	WRT_REG_DWORD(&reg->flash_addr, addr | FARX_DATA_FLAG);
+	wrt_reg_dword(&reg->flash_data, data);
+	wrt_reg_dword(&reg->flash_addr, addr | FARX_DATA_FLAG);
 
 	while (cnt--) {
-		if (!(RD_REG_DWORD(&reg->flash_addr) & FARX_DATA_FLAG))
+		if (!(rd_reg_dword(&reg->flash_addr) & FARX_DATA_FLAG))
 			return QLA_SUCCESS;
 		udelay(10);
 		cond_resched();
@@ -1199,9 +1199,9 @@ qla24xx_unprotect_flash(scsi_qla_host_t *vha)
 		return qla81xx_fac_do_write_enable(vha, 1);
 
 	/* Enable flash write. */
-	WRT_REG_DWORD(&reg->ctrl_status,
-	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
-	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+	wrt_reg_dword(&reg->ctrl_status,
+	    rd_reg_dword(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
+	rd_reg_dword(&reg->ctrl_status);	/* PCI Posting. */
 
 	if (!ha->fdt_wrt_disable)
 		goto done;
@@ -1242,8 +1242,8 @@ qla24xx_protect_flash(scsi_qla_host_t *vha)
 
 skip_wrt_protect:
 	/* Disable flash write. */
-	WRT_REG_DWORD(&reg->ctrl_status,
-	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
+	wrt_reg_dword(&reg->ctrl_status,
+	    rd_reg_dword(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
 
 	return QLA_SUCCESS;
 }
@@ -1468,9 +1468,9 @@ qla24xx_write_nvram_data(scsi_qla_host_t *vha, void *buf, uint32_t naddr,
 		return ret;
 
 	/* Enable flash write. */
-	WRT_REG_DWORD(&reg->ctrl_status,
-	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
-	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+	wrt_reg_dword(&reg->ctrl_status,
+	    rd_reg_dword(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
+	rd_reg_dword(&reg->ctrl_status);	/* PCI Posting. */
 
 	/* Disable NVRAM write-protection. */
 	qla24xx_write_flash_dword(ha, nvram_conf_addr(ha, 0x101), 0);
@@ -1492,9 +1492,9 @@ qla24xx_write_nvram_data(scsi_qla_host_t *vha, void *buf, uint32_t naddr,
 	qla24xx_write_flash_dword(ha, nvram_conf_addr(ha, 0x101), 0x8c);
 
 	/* Disable flash write. */
-	WRT_REG_DWORD(&reg->ctrl_status,
-	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
-	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+	wrt_reg_dword(&reg->ctrl_status,
+	    rd_reg_dword(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
+	rd_reg_dword(&reg->ctrl_status);	/* PCI Posting. */
 
 	return ret;
 }
@@ -1587,21 +1587,21 @@ qla2x00_beacon_blink(struct scsi_qla_host *vha)
 
 	/* Save the Original GPIOE. */
 	if (ha->pio_address) {
-		gpio_enable = RD_REG_WORD_PIO(PIO_REG(ha, gpioe));
-		gpio_data = RD_REG_WORD_PIO(PIO_REG(ha, gpiod));
+		gpio_enable = rd_reg_word_PIO(PIO_REG(ha, gpioe));
+		gpio_data = rd_reg_word_PIO(PIO_REG(ha, gpiod));
 	} else {
-		gpio_enable = RD_REG_WORD(&reg->gpioe);
-		gpio_data = RD_REG_WORD(&reg->gpiod);
+		gpio_enable = rd_reg_word(&reg->gpioe);
+		gpio_data = rd_reg_word(&reg->gpiod);
 	}
 
 	/* Set the modified gpio_enable values */
 	gpio_enable |= GPIO_LED_MASK;
 
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(PIO_REG(ha, gpioe), gpio_enable);
+		wrt_reg_word_PIO(PIO_REG(ha, gpioe), gpio_enable);
 	} else {
-		WRT_REG_WORD(&reg->gpioe, gpio_enable);
-		RD_REG_WORD(&reg->gpioe);
+		wrt_reg_word(&reg->gpioe, gpio_enable);
+		rd_reg_word(&reg->gpioe);
 	}
 
 	qla2x00_flip_colors(ha, &led_color);
@@ -1614,10 +1614,10 @@ qla2x00_beacon_blink(struct scsi_qla_host *vha)
 
 	/* Set the modified gpio_data values */
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(PIO_REG(ha, gpiod), gpio_data);
+		wrt_reg_word_PIO(PIO_REG(ha, gpiod), gpio_data);
 	} else {
-		WRT_REG_WORD(&reg->gpiod, gpio_data);
-		RD_REG_WORD(&reg->gpiod);
+		wrt_reg_word(&reg->gpiod, gpio_data);
+		rd_reg_word(&reg->gpiod);
 	}
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1644,29 +1644,29 @@ qla2x00_beacon_on(struct scsi_qla_host *vha)
 	/* Turn off LEDs. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (ha->pio_address) {
-		gpio_enable = RD_REG_WORD_PIO(PIO_REG(ha, gpioe));
-		gpio_data = RD_REG_WORD_PIO(PIO_REG(ha, gpiod));
+		gpio_enable = rd_reg_word_PIO(PIO_REG(ha, gpioe));
+		gpio_data = rd_reg_word_PIO(PIO_REG(ha, gpiod));
 	} else {
-		gpio_enable = RD_REG_WORD(&reg->gpioe);
-		gpio_data = RD_REG_WORD(&reg->gpiod);
+		gpio_enable = rd_reg_word(&reg->gpioe);
+		gpio_data = rd_reg_word(&reg->gpiod);
 	}
 	gpio_enable |= GPIO_LED_MASK;
 
 	/* Set the modified gpio_enable values. */
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(PIO_REG(ha, gpioe), gpio_enable);
+		wrt_reg_word_PIO(PIO_REG(ha, gpioe), gpio_enable);
 	} else {
-		WRT_REG_WORD(&reg->gpioe, gpio_enable);
-		RD_REG_WORD(&reg->gpioe);
+		wrt_reg_word(&reg->gpioe, gpio_enable);
+		rd_reg_word(&reg->gpioe);
 	}
 
 	/* Clear out previously set LED colour. */
 	gpio_data &= ~GPIO_LED_MASK;
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(PIO_REG(ha, gpiod), gpio_data);
+		wrt_reg_word_PIO(PIO_REG(ha, gpiod), gpio_data);
 	} else {
-		WRT_REG_WORD(&reg->gpiod, gpio_data);
-		RD_REG_WORD(&reg->gpiod);
+		wrt_reg_word(&reg->gpiod, gpio_data);
+		rd_reg_word(&reg->gpiod);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -1733,13 +1733,13 @@ qla24xx_beacon_blink(struct scsi_qla_host *vha)
 
 	/* Save the Original GPIOD. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	gpio_data = RD_REG_DWORD(&reg->gpiod);
+	gpio_data = rd_reg_dword(&reg->gpiod);
 
 	/* Enable the gpio_data reg for update. */
 	gpio_data |= GPDX_LED_UPDATE_MASK;
 
-	WRT_REG_DWORD(&reg->gpiod, gpio_data);
-	gpio_data = RD_REG_DWORD(&reg->gpiod);
+	wrt_reg_dword(&reg->gpiod, gpio_data);
+	gpio_data = rd_reg_dword(&reg->gpiod);
 
 	/* Set the color bits. */
 	qla24xx_flip_colors(ha, &led_color);
@@ -1751,8 +1751,8 @@ qla24xx_beacon_blink(struct scsi_qla_host *vha)
 	gpio_data |= led_color;
 
 	/* Set the modified gpio_data values. */
-	WRT_REG_DWORD(&reg->gpiod, gpio_data);
-	gpio_data = RD_REG_DWORD(&reg->gpiod);
+	wrt_reg_dword(&reg->gpiod, gpio_data);
+	gpio_data = rd_reg_dword(&reg->gpiod);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
@@ -1883,12 +1883,12 @@ qla24xx_beacon_on(struct scsi_qla_host *vha)
 			goto skip_gpio;
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
-		gpio_data = RD_REG_DWORD(&reg->gpiod);
+		gpio_data = rd_reg_dword(&reg->gpiod);
 
 		/* Enable the gpio_data reg for update. */
 		gpio_data |= GPDX_LED_UPDATE_MASK;
-		WRT_REG_DWORD(&reg->gpiod, gpio_data);
-		RD_REG_DWORD(&reg->gpiod);
+		wrt_reg_dword(&reg->gpiod, gpio_data);
+		rd_reg_dword(&reg->gpiod);
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
@@ -1931,12 +1931,12 @@ qla24xx_beacon_off(struct scsi_qla_host *vha)
 
 	/* Give control back to firmware. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	gpio_data = RD_REG_DWORD(&reg->gpiod);
+	gpio_data = rd_reg_dword(&reg->gpiod);
 
 	/* Disable the gpio_data reg for update. */
 	gpio_data &= ~GPDX_LED_UPDATE_MASK;
-	WRT_REG_DWORD(&reg->gpiod, gpio_data);
-	RD_REG_DWORD(&reg->gpiod);
+	wrt_reg_dword(&reg->gpiod, gpio_data);
+	rd_reg_dword(&reg->gpiod);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 set_fw_options:
@@ -1972,10 +1972,10 @@ qla2x00_flash_enable(struct qla_hw_data *ha)
 	uint16_t data;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	data = RD_REG_WORD(&reg->ctrl_status);
+	data = rd_reg_word(&reg->ctrl_status);
 	data |= CSR_FLASH_ENABLE;
-	WRT_REG_WORD(&reg->ctrl_status, data);
-	RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+	wrt_reg_word(&reg->ctrl_status, data);
+	rd_reg_word(&reg->ctrl_status);		/* PCI Posting. */
 }
 
 /**
@@ -1988,10 +1988,10 @@ qla2x00_flash_disable(struct qla_hw_data *ha)
 	uint16_t data;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	data = RD_REG_WORD(&reg->ctrl_status);
+	data = rd_reg_word(&reg->ctrl_status);
 	data &= ~(CSR_FLASH_ENABLE);
-	WRT_REG_WORD(&reg->ctrl_status, data);
-	RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+	wrt_reg_word(&reg->ctrl_status, data);
+	rd_reg_word(&reg->ctrl_status);		/* PCI Posting. */
 }
 
 /**
@@ -2010,7 +2010,7 @@ qla2x00_read_flash_byte(struct qla_hw_data *ha, uint32_t addr)
 	uint16_t bank_select;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	bank_select = RD_REG_WORD(&reg->ctrl_status);
+	bank_select = rd_reg_word(&reg->ctrl_status);
 
 	if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
 		/* Specify 64K address range: */
@@ -2018,11 +2018,11 @@ qla2x00_read_flash_byte(struct qla_hw_data *ha, uint32_t addr)
 		bank_select &= ~0xf8;
 		bank_select |= addr >> 12 & 0xf0;
 		bank_select |= CSR_FLASH_64K_BANK;
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+		wrt_reg_word(&reg->ctrl_status, bank_select);
+		rd_reg_word(&reg->ctrl_status);	/* PCI Posting. */
 
-		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
-		data = RD_REG_WORD(&reg->flash_data);
+		wrt_reg_word(&reg->flash_address, (uint16_t)addr);
+		data = rd_reg_word(&reg->flash_data);
 
 		return (uint8_t)data;
 	}
@@ -2030,28 +2030,28 @@ qla2x00_read_flash_byte(struct qla_hw_data *ha, uint32_t addr)
 	/* Setup bit 16 of flash address. */
 	if ((addr & BIT_16) && ((bank_select & CSR_FLASH_64K_BANK) == 0)) {
 		bank_select |= CSR_FLASH_64K_BANK;
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+		wrt_reg_word(&reg->ctrl_status, bank_select);
+		rd_reg_word(&reg->ctrl_status);	/* PCI Posting. */
 	} else if (((addr & BIT_16) == 0) &&
 	    (bank_select & CSR_FLASH_64K_BANK)) {
 		bank_select &= ~(CSR_FLASH_64K_BANK);
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+		wrt_reg_word(&reg->ctrl_status, bank_select);
+		rd_reg_word(&reg->ctrl_status);	/* PCI Posting. */
 	}
 
 	/* Always perform IO mapped accesses to the FLASH registers. */
 	if (ha->pio_address) {
 		uint16_t data2;
 
-		WRT_REG_WORD_PIO(PIO_REG(ha, flash_address), (uint16_t)addr);
+		wrt_reg_word_PIO(PIO_REG(ha, flash_address), (uint16_t)addr);
 		do {
-			data = RD_REG_WORD_PIO(PIO_REG(ha, flash_data));
+			data = rd_reg_word_PIO(PIO_REG(ha, flash_data));
 			barrier();
 			cpu_relax();
-			data2 = RD_REG_WORD_PIO(PIO_REG(ha, flash_data));
+			data2 = rd_reg_word_PIO(PIO_REG(ha, flash_data));
 		} while (data != data2);
 	} else {
-		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
+		wrt_reg_word(&reg->flash_address, (uint16_t)addr);
 		data = qla2x00_debounce_register(&reg->flash_data);
 	}
 
@@ -2070,20 +2070,20 @@ qla2x00_write_flash_byte(struct qla_hw_data *ha, uint32_t addr, uint8_t data)
 	uint16_t bank_select;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	bank_select = RD_REG_WORD(&reg->ctrl_status);
+	bank_select = rd_reg_word(&reg->ctrl_status);
 	if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
 		/* Specify 64K address range: */
 		/*  clear out Module Select and Flash Address bits [19:16]. */
 		bank_select &= ~0xf8;
 		bank_select |= addr >> 12 & 0xf0;
 		bank_select |= CSR_FLASH_64K_BANK;
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+		wrt_reg_word(&reg->ctrl_status, bank_select);
+		rd_reg_word(&reg->ctrl_status);	/* PCI Posting. */
 
-		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
-		WRT_REG_WORD(&reg->flash_data, (uint16_t)data);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+		wrt_reg_word(&reg->flash_address, (uint16_t)addr);
+		rd_reg_word(&reg->ctrl_status);		/* PCI Posting. */
+		wrt_reg_word(&reg->flash_data, (uint16_t)data);
+		rd_reg_word(&reg->ctrl_status);		/* PCI Posting. */
 
 		return;
 	}
@@ -2091,24 +2091,24 @@ qla2x00_write_flash_byte(struct qla_hw_data *ha, uint32_t addr, uint8_t data)
 	/* Setup bit 16 of flash address. */
 	if ((addr & BIT_16) && ((bank_select & CSR_FLASH_64K_BANK) == 0)) {
 		bank_select |= CSR_FLASH_64K_BANK;
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+		wrt_reg_word(&reg->ctrl_status, bank_select);
+		rd_reg_word(&reg->ctrl_status);	/* PCI Posting. */
 	} else if (((addr & BIT_16) == 0) &&
 	    (bank_select & CSR_FLASH_64K_BANK)) {
 		bank_select &= ~(CSR_FLASH_64K_BANK);
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
+		wrt_reg_word(&reg->ctrl_status, bank_select);
+		rd_reg_word(&reg->ctrl_status);	/* PCI Posting. */
 	}
 
 	/* Always perform IO mapped accesses to the FLASH registers. */
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(PIO_REG(ha, flash_address), (uint16_t)addr);
-		WRT_REG_WORD_PIO(PIO_REG(ha, flash_data), (uint16_t)data);
+		wrt_reg_word_PIO(PIO_REG(ha, flash_address), (uint16_t)addr);
+		wrt_reg_word_PIO(PIO_REG(ha, flash_data), (uint16_t)data);
 	} else {
-		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
-		WRT_REG_WORD(&reg->flash_data, (uint16_t)data);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
+		wrt_reg_word(&reg->flash_address, (uint16_t)addr);
+		rd_reg_word(&reg->ctrl_status);		/* PCI Posting. */
+		wrt_reg_word(&reg->flash_data, (uint16_t)data);
+		rd_reg_word(&reg->ctrl_status);		/* PCI Posting. */
 	}
 }
 
@@ -2291,12 +2291,12 @@ qla2x00_read_flash_data(struct qla_hw_data *ha, uint8_t *tmp_buf,
 
 	midpoint = length / 2;
 
-	WRT_REG_WORD(&reg->nvram, 0);
-	RD_REG_WORD(&reg->nvram);
+	wrt_reg_word(&reg->nvram, 0);
+	rd_reg_word(&reg->nvram);
 	for (ilength = 0; ilength < length; saddr++, ilength++, tmp_buf++) {
 		if (ilength == midpoint) {
-			WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-			RD_REG_WORD(&reg->nvram);
+			wrt_reg_word(&reg->nvram, NVR_SELECT);
+			rd_reg_word(&reg->nvram);
 		}
 		data = qla2x00_read_flash_byte(ha, saddr);
 		if (saddr % 100)
@@ -2321,11 +2321,11 @@ qla2x00_suspend_hba(struct scsi_qla_host *vha)
 
 	/* Pause RISC. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
-	RD_REG_WORD(&reg->hccr);
+	wrt_reg_word(&reg->hccr, HCCR_PAUSE_RISC);
+	rd_reg_word(&reg->hccr);
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
 		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) != 0)
+			if ((rd_reg_word(&reg->hccr) & HCCR_RISC_PAUSE) != 0)
 				break;
 			udelay(100);
 		}
@@ -2364,12 +2364,12 @@ qla2x00_read_optrom_data(struct scsi_qla_host *vha, void *buf,
 	midpoint = ha->optrom_size / 2;
 
 	qla2x00_flash_enable(ha);
-	WRT_REG_WORD(&reg->nvram, 0);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wrt_reg_word(&reg->nvram, 0);
+	rd_reg_word(&reg->nvram);		/* PCI Posting. */
 	for (addr = offset, data = buf; addr < length; addr++, data++) {
 		if (addr == midpoint) {
-			WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-			RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+			wrt_reg_word(&reg->nvram, NVR_SELECT);
+			rd_reg_word(&reg->nvram);	/* PCI Posting. */
 		}
 
 		*data = qla2x00_read_flash_byte(ha, addr);
@@ -2401,7 +2401,7 @@ qla2x00_write_optrom_data(struct scsi_qla_host *vha, void *buf,
 	sec_number = 0;
 
 	/* Reset ISP chip. */
-	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+	wrt_reg_word(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
 
 	/* Go with write. */
@@ -2550,8 +2550,8 @@ qla2x00_write_optrom_data(struct scsi_qla_host *vha, void *buf,
 						}
 					}
 				} else if (addr == ha->optrom_size / 2) {
-					WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-					RD_REG_WORD(&reg->nvram);
+					wrt_reg_word(&reg->nvram, NVR_SELECT);
+					rd_reg_word(&reg->nvram);
 				}
 
 				if (flash_id == 0xda && man_id == 0xc1) {
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 23505c82439d..4bd773287c1c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2485,7 +2485,7 @@ static int qlt_check_reserve_free_req(struct qla_qpair *qpair,
 
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = (uint16_t)(qpair->use_shadow_reg ? *req->out_ptr :
-		    RD_REG_DWORD_RELAXED(req->req_q_out));
+		    rd_reg_dword_relaxed(req->req_q_out));
 
 		if  (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
@@ -6789,7 +6789,7 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 	}
 
 	/* Adjust ring index */
-	WRT_REG_DWORD(ISP_ATIO_Q_OUT(vha), ha->tgt.atio_ring_index);
+	wrt_reg_dword(ISP_ATIO_Q_OUT(vha), ha->tgt.atio_ring_index);
 }
 
 void
@@ -6802,9 +6802,9 @@ qlt_24xx_config_rings(struct scsi_qla_host *vha)
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
-	WRT_REG_DWORD(ISP_ATIO_Q_IN(vha), 0);
-	WRT_REG_DWORD(ISP_ATIO_Q_OUT(vha), 0);
-	RD_REG_DWORD(ISP_ATIO_Q_OUT(vha));
+	wrt_reg_dword(ISP_ATIO_Q_IN(vha), 0);
+	wrt_reg_dword(ISP_ATIO_Q_OUT(vha), 0);
+	rd_reg_dword(ISP_ATIO_Q_OUT(vha));
 
 	if (ha->flags.msix_enabled) {
 		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index ce69e5febae3..c6f80358c94b 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -48,7 +48,7 @@ qla27xx_read8(void __iomem *window, void *buf, ulong *len)
 	uint8_t value = ~0;
 
 	if (buf) {
-		value = RD_REG_BYTE(window);
+		value = rd_reg_byte(window);
 	}
 	qla27xx_insert32(value, buf, len);
 }
@@ -59,7 +59,7 @@ qla27xx_read16(void __iomem *window, void *buf, ulong *len)
 	uint16_t value = ~0;
 
 	if (buf) {
-		value = RD_REG_WORD(window);
+		value = rd_reg_word(window);
 	}
 	qla27xx_insert32(value, buf, len);
 }
@@ -70,7 +70,7 @@ qla27xx_read32(void __iomem *window, void *buf, ulong *len)
 	uint32_t value = ~0;
 
 	if (buf) {
-		value = RD_REG_DWORD(window);
+		value = rd_reg_dword(window);
 	}
 	qla27xx_insert32(value, buf, len);
 }
@@ -99,7 +99,7 @@ qla27xx_write_reg(__iomem struct device_reg_24xx *reg,
 	if (buf) {
 		void __iomem *window = (void __iomem *)reg + offset;
 
-		WRT_REG_DWORD(window, data);
+		wrt_reg_dword(window, data);
 	}
 }
 
