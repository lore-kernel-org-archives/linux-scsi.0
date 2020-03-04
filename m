Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02764C3F2D7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0FC120842
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgCDFaC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 00:30:02 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36157 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgCDFaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 00:30:02 -0500
Received: by mail-pf1-f193.google.com with SMTP id i13so367045pfe.3
        for <linux-scsi@vger.kernel.org>; Tue, 03 Mar 2020 21:30:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Smtv5KnV8K/186fc8hgz/oqZu6mQlYbYWw87SYC6Vqg=;
        b=AxiRWgKi3xwgj4TutbBtPDNLWNeiTr3rJkwosQ1nePZi3Ldzgn6dmQQNiHhYnN3nax
         xnQVntxXji85iPI8k5oUk4xLqyK6EVh+tQbKgKWcg0HX6BvgB9P8+LexeRrdHgvY1EaT
         7TJ8JQQpoT3gcFlN3wIqi3fuyOda9BWE1jy5dPqq4kcEBNxTvPY65hIR2SQL3sex9xh1
         pm8kTUNWvF9jS3TZIVaolmCjKGjjRA2mnxmzApjSAPwhPXfcaoeudYkwFswXY8b3ziNz
         VEvKjyQ6PFsVB9zWDSVbMmchMIIzaSF5WqNfS+QDy1YLaTnLff2R635ywqglcr4wqAtt
         NwLg==
X-Gm-Message-State: ANhLgQ1ln9mFMG6mAxYEQb71vuZv8/kL+Rl13tU8i5Lwts8kTc1OuUSU
        rZfqEp/D7CDHhHVvdQC+Czc=
X-Google-Smtp-Source: ADFU+vtNyC4BEterJNuXUirtAgkvNz6Ca3O16wtvI9dXBeT84RsljcIs0rEaEdb71gB2yc8D1FEYDw==
X-Received: by 2002:aa7:9497:: with SMTP id z23mr1416270pfk.229.1583299800220;
        Tue, 03 Mar 2020 21:30:00 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:a86e:343d:2eff:fb40])
        by smtp.gmail.com with ESMTPSA id p94sm972784pjp.15.2020.03.03.21.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 21:29:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 5/6] qla2xxx: Fix the code that reads from mailbox registers
Date:   Tue,  3 Mar 2020 21:29:44 -0800
Message-Id: <20200304052945.23250-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304052945.23250-1-bvanassche@acm.org>
References: <20200304052945.23250-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the MMIO accessors stronly typed such that the compiler checks whether
the accessor function is used that matches the register width. Fix those
MMIO reads where another number of bits was read or written than the size
of the register.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 53 +++++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_init.c |  6 ++--
 drivers/scsi/qla2xxx/qla_iocb.c |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c  |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c  |  2 +-
 drivers/scsi/qla2xxx/qla_mr.c   | 26 ++++++++--------
 drivers/scsi/qla2xxx/qla_nx.c   |  4 +--
 drivers/scsi/qla2xxx/qla_os.c   |  2 +-
 8 files changed, 67 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ebb22c1a9df7..7e5677c69bed 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -128,15 +128,50 @@ static inline uint32_t make_handle(uint16_t x, uint16_t y)
  * I/O register
 */
 
-#define RD_REG_BYTE(addr)		readb(addr)
-#define RD_REG_WORD(addr)		readw(addr)
-#define RD_REG_DWORD(addr)		readl(addr)
-#define RD_REG_BYTE_RELAXED(addr)	readb_relaxed(addr)
-#define RD_REG_WORD_RELAXED(addr)	readw_relaxed(addr)
-#define RD_REG_DWORD_RELAXED(addr)	readl_relaxed(addr)
-#define WRT_REG_BYTE(addr, data)	writeb(data, addr)
-#define WRT_REG_WORD(addr, data)	writew(data, addr)
-#define WRT_REG_DWORD(addr, data)	writel(data, addr)
+static inline u8 RD_REG_BYTE(const volatile u8 __iomem *addr)
+{
+	return readb(addr);
+}
+
+static inline u16 RD_REG_WORD(const volatile __le16 __iomem *addr)
+{
+	return readw(addr);
+}
+
+static inline u32 RD_REG_DWORD(const volatile __le32 __iomem *addr)
+{
+	return readl(addr);
+}
+
+static inline u8 RD_REG_BYTE_RELAXED(const volatile u8 __iomem *addr)
+{
+	return readb_relaxed(addr);
+}
+
+static inline u16 RD_REG_WORD_RELAXED(const volatile __le16 __iomem *addr)
+{
+	return readw_relaxed(addr);
+}
+
+static inline u32 RD_REG_DWORD_RELAXED(const volatile __le32 __iomem *addr)
+{
+	return readl_relaxed(addr);
+}
+
+static inline void WRT_REG_BYTE(volatile u8 __iomem *addr, u8 data)
+{
+	return writeb(data, addr);
+}
+
+static inline void WRT_REG_WORD(volatile __le16 __iomem *addr, u16 data)
+{
+	return writew(data, addr);
+}
+
+static inline void WRT_REG_DWORD(volatile __le32 __iomem *addr, u32 data)
+{
+	return writel(data, addr);
+}
 
 /*
  * ISP83XX specific remote register addresses
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1ce0b89d6bd5..bd9d3e0847c2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2219,7 +2219,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 
 	/* Check for secure flash support */
 	if (IS_QLA28XX(ha)) {
-		if (RD_REG_DWORD(&reg->mailbox12) & BIT_0)
+		if (RD_REG_WORD(&reg->mailbox12) & BIT_0)
 			ha->flags.secure_adapter = 1;
 		ql_log(ql_log_info, vha, 0xffff, "Secure Adapter: %s\n",
 		    (ha->flags.secure_adapter) ? "Yes" : "No");
@@ -2780,7 +2780,7 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x017f,
 	    "HCCR: 0x%x, MailBox0 Status 0x%x\n",
 	    RD_REG_DWORD(&reg->hccr),
-	    RD_REG_DWORD(&reg->mailbox0));
+	    RD_REG_WORD(&reg->mailbox0));
 
 	/* Wait for soft-reset to complete. */
 	RD_REG_DWORD(&reg->ctrl_status);
@@ -4096,7 +4096,7 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 	}
 
 	/* PCI posting */
-	RD_REG_DWORD(&ioreg->hccr);
+	RD_REG_WORD(&ioreg->hccr);
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 46c189105149..d3b255898543 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2268,7 +2268,7 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 		    IS_QLA28XX(ha))
 			cnt = RD_REG_DWORD(&reg->isp25mq.req_q_out);
 		else if (IS_P3P_TYPE(ha))
-			cnt = RD_REG_DWORD(&reg->isp82.req_q_out);
+			cnt = RD_REG_DWORD(reg->isp82.req_q_out);
 		else if (IS_FWI2_CAPABLE(ha))
 			cnt = RD_REG_DWORD(&reg->isp24.req_q_out);
 		else if (IS_QLAFX00(ha))
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 50c0d77fcf2d..9d4084cd2acb 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -452,7 +452,7 @@ qla81xx_idc_event(scsi_qla_host_t *vha, uint16_t aen, uint16_t descr)
 	int rval;
 	struct device_reg_24xx __iomem *reg24 = &vha->hw->iobase->isp24;
 	struct device_reg_82xx __iomem *reg82 = &vha->hw->iobase->isp82;
-	uint16_t __iomem *wptr;
+	__le16 __iomem *wptr;
 	uint16_t cnt, timeout, mb[QLA_IDC_ACK_REGS];
 
 	/* Seed data -- mailbox1 -> mailbox7. */
@@ -3141,7 +3141,7 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 {
 	uint16_t	cnt;
 	uint32_t	mboxes;
-	uint16_t __iomem *wptr;
+	__le16 __iomem *wptr;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0927952d5d99..6dfb6aca5960 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -106,7 +106,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	uint8_t		io_lock_on;
 	uint16_t	command = 0;
 	uint16_t	*iptr;
-	uint16_t __iomem *optr;
+	__le16 __iomem  *optr;
 	uint32_t	cnt;
 	uint32_t	mboxes;
 	unsigned long	wait_time;
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 8b02a2c0f0c2..6df48494b2b3 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -46,7 +46,7 @@ qlafx00_mailbox_command(scsi_qla_host_t *vha, struct mbx_cmd_32 *mcp)
 	uint8_t		io_lock_on;
 	uint16_t	command = 0;
 	uint32_t	*iptr;
-	uint32_t __iomem *optr;
+	__le32 __iomem *optr;
 	uint32_t	cnt;
 	uint32_t	mboxes;
 	unsigned long	wait_time;
@@ -109,7 +109,7 @@ qlafx00_mailbox_command(scsi_qla_host_t *vha, struct mbx_cmd_32 *mcp)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Load mailbox registers. */
-	optr = (uint32_t __iomem *)&reg->ispfx00.mailbox0;
+	optr = &reg->ispfx00.mailbox0;
 
 	iptr = mcp->mb;
 	command = mcp->mb[0];
@@ -2846,13 +2846,13 @@ qlafx00_async_event(scsi_qla_host_t *vha)
 		break;
 
 	default:
-		ha->aenmb[1] = RD_REG_WORD(&reg->aenmailbox1);
-		ha->aenmb[2] = RD_REG_WORD(&reg->aenmailbox2);
-		ha->aenmb[3] = RD_REG_WORD(&reg->aenmailbox3);
-		ha->aenmb[4] = RD_REG_WORD(&reg->aenmailbox4);
-		ha->aenmb[5] = RD_REG_WORD(&reg->aenmailbox5);
-		ha->aenmb[6] = RD_REG_WORD(&reg->aenmailbox6);
-		ha->aenmb[7] = RD_REG_WORD(&reg->aenmailbox7);
+		ha->aenmb[1] = RD_REG_DWORD(&reg->aenmailbox1);
+		ha->aenmb[2] = RD_REG_DWORD(&reg->aenmailbox2);
+		ha->aenmb[3] = RD_REG_DWORD(&reg->aenmailbox3);
+		ha->aenmb[4] = RD_REG_DWORD(&reg->aenmailbox4);
+		ha->aenmb[5] = RD_REG_DWORD(&reg->aenmailbox5);
+		ha->aenmb[6] = RD_REG_DWORD(&reg->aenmailbox6);
+		ha->aenmb[7] = RD_REG_DWORD(&reg->aenmailbox7);
 		ql_dbg(ql_dbg_async, vha, 0x5078,
 		    "AEN:%04x %04x %04x %04x :%04x %04x %04x %04x\n",
 		    ha->aenmb[0], ha->aenmb[1], ha->aenmb[2], ha->aenmb[3],
@@ -2872,7 +2872,7 @@ static void
 qlafx00_mbx_completion(scsi_qla_host_t *vha, uint32_t mb0)
 {
 	uint16_t	cnt;
-	uint32_t __iomem *wptr;
+	__le32 __iomem *wptr;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_fx00 __iomem *reg = &ha->iobase->ispfx00;
 
@@ -2882,7 +2882,7 @@ qlafx00_mbx_completion(scsi_qla_host_t *vha, uint32_t mb0)
 	/* Load return mailbox registers. */
 	ha->flags.mbox_int = 1;
 	ha->mailbox_out32[0] = mb0;
-	wptr = (uint32_t __iomem *)&reg->mailbox17;
+	wptr = &reg->mailbox17;
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
 		ha->mailbox_out32[cnt] = RD_REG_DWORD(wptr);
@@ -2939,13 +2939,13 @@ qlafx00_intr_handler(int irq, void *dev_id)
 			break;
 
 		if (stat & QLAFX00_INTR_MB_CMPLT) {
-			mb[0] = RD_REG_WORD(&reg->mailbox16);
+			mb[0] = RD_REG_DWORD(&reg->mailbox16);
 			qlafx00_mbx_completion(vha, mb[0]);
 			status |= MBX_INTERRUPT;
 			clr_intr |= QLAFX00_INTR_MB_CMPLT;
 		}
 		if (intr_stat & QLAFX00_INTR_ASYNC_CMPLT) {
-			ha->aenmb[0] = RD_REG_WORD(&reg->aenmailbox0);
+			ha->aenmb[0] = RD_REG_DWORD(&reg->aenmailbox0);
 			qlafx00_async_event(vha);
 			clr_intr |= QLAFX00_INTR_ASYNC_CMPLT;
 		}
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b295a5308646..c04150110417 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1997,11 +1997,11 @@ void
 qla82xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 {
 	uint16_t	cnt;
-	uint16_t __iomem *wptr;
+	__le16 __iomem *wptr;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_82xx __iomem *reg = &ha->iobase->isp82;
 
-	wptr = (uint16_t __iomem *)&reg->mailbox_out[1];
+	wptr = &reg->mailbox_out[1];
 
 	/* Load return mailbox registers. */
 	ha->flags.mbox_int = 1;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e78e1649c818..e7d753df7d7c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7574,7 +7574,7 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)){
-		stat = RD_REG_DWORD(&reg->hccr);
+		stat = RD_REG_WORD(&reg->hccr);
 		if (stat & HCCR_RISC_PAUSE)
 			risc_paused = 1;
 	} else if (IS_QLA23XX(ha)) {
