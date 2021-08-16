Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019A8C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D976760FC3
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhHPQaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 12:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhHPQ36 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 12:29:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FD0C0613C1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so15005549pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uJBmo6WbdZ+cUStJhJ08cbRtP5lkk6/v82/DZd9CSIw=;
        b=OEebyCnJen2wCCZ5PCdB9O0SQ39g1yxPkngJ7Ss9xCWpq19enz/72wQlCanXArPkPf
         4dx1gkizfevnfJjxeMeVF9rmIvrxfRySSpAs6vWouFigJU2+NSS5FprW/3LXBv4dXzBA
         nBmypBniWUnrwoBEnvJi/1VL2MM54S+Khnh6pOT6dSoq7TAeRSVgo+0rxRxEFdmPHJWk
         ZjtvnXZg34j+JZFTSEQTF48G3FpNTbJscahFxnOiK2URxf8fZjfk1Q3mNyJZEh6mErEU
         fvmLmw1VdxHky3yjlXLP9KDrqsrCd5i0MeYuiAVKxWqEWmaOZYZ/Z+A1LUsUfscBXido
         qlCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uJBmo6WbdZ+cUStJhJ08cbRtP5lkk6/v82/DZd9CSIw=;
        b=N2yTyiR3dCCm9a/S0YXhpuA8mYRAbgbKG61UhhXwcLPrd1/SzWW9+ejx5F4RKfSA16
         cbXGmIs20Px2Eu5GiD0pB950UGM4LmxNEwGfqI+7ullP7wsuSdMDhHnK9S6AqO2L3eds
         scvLZpb4qItu1LShHNfODBN5I6nyFKpDUMLB1WFYm3ls3I6C3MArQr+jXDefip4flLa+
         oNos20t1149cWWdJ9OsoQGRijtrXfwO5bdfA3WoSb1pe1zAPSHVoTSmqmebvGUisQWJy
         nbc8e21LNnEKtTpU3k3SCed/ywbwJf40/8seCPtX8MqjIGvimwEvV/OgR0GnDoGp2K+G
         RTSA==
X-Gm-Message-State: AOAM533FF5vusMtxOBk0HZ6iU/2tA2TfcNB1GLdr5Lbl8mXO0vYLijUk
        p87aJi5qWjFQ7RP+NZ2VulK7XOYXRz4=
X-Google-Smtp-Source: ABdhPJx1KUN/FwqaBr94yW7WgWwWqXsM3e8fWPFgdjioeWnFXZg3YTZWrRom2mUy2ipbS2R0oVqdUw==
X-Received: by 2002:a17:90b:f10:: with SMTP id br16mr18127280pjb.65.1629131365855;
        Mon, 16 Aug 2021 09:29:25 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm11257938pfv.131.2021.08.16.09.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:29:25 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v3 06/16] lpfc: Add cm statistics buffer support
Date:   Mon, 16 Aug 2021 09:28:51 -0700
Message-Id: <20210816162901.121235-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210816162901.121235-1-jsmart2021@gmail.com>
References: <20210816162901.121235-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The cmf framework requires the driver to maintain a cm statistics table,
accessible inband, of congestion related statistics that are reported
per minute, rolled up to per hour, and rolled up again per day. Several
days worth may be maintained.  The table is registered with the adapter
when the MIB feature is enabled.

Add definition of the table and add support to register the table
with the adapter. Includes definition and initialization of event counters
that are later added to the statistics table.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      | 133 ++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_crtn.h |   3 +
 drivers/scsi/lpfc/lpfc_hw4.h  |  17 +++++
 drivers/scsi/lpfc/lpfc_init.c | 109 ++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c  |  10 +++
 5 files changed, 272 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index f23905b89ee3..169cef789f73 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -403,6 +403,127 @@ struct lpfc_trunk_link  {
 				     link3;
 };
 
+/* Max number of days of congestion data */
+#define LPFC_MAX_CGN_DAYS 10
+
+/* Format of congestion buffer info
+ * This structure defines memory thats allocated and registered with
+ * the HBA firmware. When adding or removing fields from this structure
+ * the alignment must match the HBA firmware.
+ */
+
+struct lpfc_cgn_info {
+	/* Header */
+	__le16   cgn_info_size;		/* is sizeof(struct lpfc_cgn_info) */
+	uint8_t  cgn_info_version;	/* represents format of structure */
+#define LPFC_CGN_INFO_V1	1
+#define LPFC_CGN_INFO_V2	2
+#define LPFC_CGN_INFO_V3	3
+	uint8_t  cgn_info_mode;		/* 0=off 1=managed 2=monitor only */
+	uint8_t  cgn_info_detect;
+	uint8_t  cgn_info_action;
+	uint8_t  cgn_info_level0;
+	uint8_t  cgn_info_level1;
+	uint8_t  cgn_info_level2;
+
+	/* Start Time */
+	uint8_t  cgn_info_month;
+	uint8_t  cgn_info_day;
+	uint8_t  cgn_info_year;
+	uint8_t  cgn_info_hour;
+	uint8_t  cgn_info_minute;
+	uint8_t  cgn_info_second;
+
+	/* minute / hours / daily indices */
+	uint8_t  cgn_index_minute;
+	uint8_t  cgn_index_hour;
+	uint8_t  cgn_index_day;
+
+	__le16   cgn_warn_freq;
+	__le16   cgn_alarm_freq;
+	__le16   cgn_lunq;
+	uint8_t  cgn_pad1[8];
+
+	/* Driver Information */
+	__le16   cgn_drvr_min[60];
+	__le32   cgn_drvr_hr[24];
+	__le32   cgn_drvr_day[LPFC_MAX_CGN_DAYS];
+
+	/* Congestion Warnings */
+	__le16   cgn_warn_min[60];
+	__le32   cgn_warn_hr[24];
+	__le32   cgn_warn_day[LPFC_MAX_CGN_DAYS];
+
+	/* Latency Information */
+	__le32   cgn_latency_min[60];
+	__le32   cgn_latency_hr[24];
+	__le32   cgn_latency_day[LPFC_MAX_CGN_DAYS];
+
+	/* Bandwidth Information */
+	__le16   cgn_bw_min[60];
+	__le16   cgn_bw_hr[24];
+	__le16   cgn_bw_day[LPFC_MAX_CGN_DAYS];
+
+	/* Congestion Alarms */
+	__le16   cgn_alarm_min[60];
+	__le32   cgn_alarm_hr[24];
+	__le32   cgn_alarm_day[LPFC_MAX_CGN_DAYS];
+
+	/* Start of congestion statistics */
+	uint8_t  cgn_stat_npm;		/* Notifications per minute */
+
+	/* Start Time */
+	uint8_t  cgn_stat_month;
+	uint8_t  cgn_stat_day;
+	uint8_t  cgn_stat_year;
+	uint8_t  cgn_stat_hour;
+	uint8_t  cgn_stat_minute;
+	uint8_t  cgn_pad2[2];
+
+	__le32   cgn_notification;
+	__le32   cgn_peer_notification;
+	__le32   link_integ_notification;
+	__le32   delivery_notification;
+
+	uint8_t  cgn_stat_cgn_month; /* Last congestion notification FPIN */
+	uint8_t  cgn_stat_cgn_day;
+	uint8_t  cgn_stat_cgn_year;
+	uint8_t  cgn_stat_cgn_hour;
+	uint8_t  cgn_stat_cgn_min;
+	uint8_t  cgn_stat_cgn_sec;
+
+	uint8_t  cgn_stat_peer_month; /* Last peer congestion FPIN */
+	uint8_t  cgn_stat_peer_day;
+	uint8_t  cgn_stat_peer_year;
+	uint8_t  cgn_stat_peer_hour;
+	uint8_t  cgn_stat_peer_min;
+	uint8_t  cgn_stat_peer_sec;
+
+	uint8_t  cgn_stat_lnk_month; /* Last link integrity FPIN */
+	uint8_t  cgn_stat_lnk_day;
+	uint8_t  cgn_stat_lnk_year;
+	uint8_t  cgn_stat_lnk_hour;
+	uint8_t  cgn_stat_lnk_min;
+	uint8_t  cgn_stat_lnk_sec;
+
+	uint8_t  cgn_stat_del_month; /* Last delivery notification FPIN */
+	uint8_t  cgn_stat_del_day;
+	uint8_t  cgn_stat_del_year;
+	uint8_t  cgn_stat_del_hour;
+	uint8_t  cgn_stat_del_min;
+	uint8_t  cgn_stat_del_sec;
+#define LPFC_CGN_STAT_SIZE	48
+#define LPFC_CGN_DATA_SIZE	(sizeof(struct lpfc_cgn_info) -  \
+				LPFC_CGN_STAT_SIZE - sizeof(uint32_t))
+
+	__le32   cgn_info_crc;
+#define LPFC_CGN_CRC32_MAGIC_NUMBER	0x1EDC6F41
+#define LPFC_CGN_CRC32_SEED		0xFFFFFFFF
+};
+
+#define LPFC_CGN_INFO_SZ	(sizeof(struct lpfc_cgn_info) -  \
+				sizeof(uint32_t))
+
 struct lpfc_cgn_acqe_stat {
 	atomic64_t alarm;
 	atomic64_t warn;
@@ -1374,10 +1495,22 @@ struct lpfc_hba {
 	struct lpfc_cgn_acqe_stat cgn_acqe_stat;
 
 	/* Congestion buffer information */
+	struct lpfc_dmabuf *cgn_i;      /* Congestion Info buffer */
 	atomic_t cgn_fabric_warn_cnt;   /* Total warning cgn events for info */
 	atomic_t cgn_fabric_alarm_cnt;  /* Total alarm cgn events for info */
 	atomic_t cgn_sync_warn_cnt;     /* Total warning events for SYNC wqe */
 	atomic_t cgn_sync_alarm_cnt;    /* Total alarm events for SYNC wqe */
+	atomic_t cgn_driver_evt_cnt;    /* Total driver cgn events for fmw */
+	atomic_t cgn_latency_evt_cnt;
+	struct timespec64 cgn_daily_ts;
+	atomic64_t cgn_latency_evt;     /* Avg latency per minute */
+	unsigned long cgn_evt_timestamp;
+#define LPFC_CGN_TIMER_TO_MIN   60000 /* ms in a minute */
+	uint32_t cgn_evt_minute;
+#define LPFC_SEC_MIN		60
+#define LPFC_MIN_HOUR		60
+#define LPFC_HOUR_DAY		24
+#define LPFC_MIN_DAY		(LPFC_MIN_HOUR * LPFC_HOUR_DAY)
 
 	struct hlist_node cpuhp;	/* used for cpuhp per hba callback */
 	struct timer_list cpuhp_poll_timer;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index b1db01884990..e7fad8cd10ee 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -58,6 +58,7 @@ void lpfc_request_features(struct lpfc_hba *, struct lpfcMboxq *);
 int lpfc_sli4_mbox_rsrc_extent(struct lpfc_hba *, struct lpfcMboxq *,
 			   uint16_t, uint16_t, bool);
 int lpfc_get_sli4_parameters(struct lpfc_hba *, LPFC_MBOXQ_t *);
+int lpfc_reg_congestion_buf(struct lpfc_hba *phba);
 struct lpfc_vport *lpfc_find_vport_by_did(struct lpfc_hba *, uint32_t);
 void lpfc_cleanup_rcv_buffers(struct lpfc_vport *);
 void lpfc_rcv_seq_check_edtov(struct lpfc_vport *);
@@ -74,6 +75,8 @@ int lpfc_init_iocb_list(struct lpfc_hba *phba, int cnt);
 void lpfc_free_iocb_list(struct lpfc_hba *phba);
 int lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 			struct lpfc_queue *drq, int count, int idx);
+void lpfc_init_congestion_stat(struct lpfc_hba *phba);
+void lpfc_init_congestion_buf(struct lpfc_hba *phba);
 int lpfc_config_cgn_signal(struct lpfc_hba *phba);
 
 void lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index ebee1d302a49..3e81d02fb24f 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1025,6 +1025,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_SET_HOST_DATA			0x5D
 #define LPFC_MBOX_OPCODE_SEND_ACTIVATION		0x73
 #define LPFC_MBOX_OPCODE_RESET_LICENSES			0x74
+#define LPFC_MBOX_OPCODE_REG_CONGESTION_BUF		0x8E
 #define LPFC_MBOX_OPCODE_GET_RSRC_EXTENT_INFO		0x9A
 #define LPFC_MBOX_OPCODE_GET_ALLOC_RSRC_EXTENT		0x9B
 #define LPFC_MBOX_OPCODE_ALLOC_RSRC_EXTENT		0x9C
@@ -3503,6 +3504,21 @@ struct lpfc_mbx_get_sli4_parameters {
 	struct lpfc_sli4_parameters sli4_parameters;
 };
 
+struct lpfc_mbx_reg_congestion_buf {
+	struct mbox_header header;
+	uint32_t word0;
+#define lpfc_mbx_reg_cgn_buf_type_WORD		word0
+#define lpfc_mbx_reg_cgn_buf_type_SHIFT		0
+#define lpfc_mbx_reg_cgn_buf_type_MASK		0xFF
+#define lpfc_mbx_reg_cgn_buf_cnt_WORD		word0
+#define lpfc_mbx_reg_cgn_buf_cnt_SHIFT		16
+#define lpfc_mbx_reg_cgn_buf_cnt_MASK		0xFF
+	uint32_t word1;
+	uint32_t length;
+	uint32_t addr_lo;
+	uint32_t addr_hi;
+};
+
 struct lpfc_rscr_desc_generic {
 #define LPFC_RSRC_DESC_WSIZE			22
 	uint32_t desc[LPFC_RSRC_DESC_WSIZE];
@@ -3902,6 +3918,7 @@ struct lpfc_mqe {
 		struct lpfc_mbx_query_fw_config query_fw_cfg;
 		struct lpfc_mbx_set_beacon_config beacon_config;
 		struct lpfc_mbx_get_sli4_parameters get_sli4_parameters;
+		struct lpfc_mbx_reg_congestion_buf reg_congestion_buf;
 		struct lpfc_mbx_set_link_diag_state link_diag_state;
 		struct lpfc_mbx_set_link_diag_loopback link_diag_loopback;
 		struct lpfc_mbx_run_link_diag_test link_diag_test;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9e4446302855..71166c24ae89 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12234,6 +12234,115 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 		phba->pport->work_port_events = 0;
 }
 
+
+void
+lpfc_init_congestion_buf(struct lpfc_hba *phba)
+{
+	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+			"6235 INIT Congestion Buffer %p\n", phba->cgn_i);
+
+	if (!phba->cgn_i)
+		return;
+
+	atomic_set(&phba->cgn_fabric_warn_cnt, 0);
+	atomic_set(&phba->cgn_fabric_alarm_cnt, 0);
+	atomic_set(&phba->cgn_sync_alarm_cnt, 0);
+	atomic_set(&phba->cgn_sync_warn_cnt, 0);
+
+	atomic64_set(&phba->cgn_acqe_stat.alarm, 0);
+	atomic64_set(&phba->cgn_acqe_stat.warn, 0);
+	atomic_set(&phba->cgn_driver_evt_cnt, 0);
+	atomic_set(&phba->cgn_latency_evt_cnt, 0);
+	atomic64_set(&phba->cgn_latency_evt, 0);
+	phba->cgn_evt_minute = 0;
+
+	phba->cgn_evt_timestamp = jiffies +
+		msecs_to_jiffies(LPFC_CGN_TIMER_TO_MIN);
+}
+
+void
+lpfc_init_congestion_stat(struct lpfc_hba *phba)
+{
+	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+			"6236 INIT Congestion Stat %p\n", phba->cgn_i);
+
+	if (!phba->cgn_i)
+		return;
+}
+
+/**
+ * __lpfc_reg_congestion_buf - register congestion info buffer with HBA
+ * @phba: Pointer to hba context object.
+ * @reg: flag to determine register or unregister.
+ */
+static int
+__lpfc_reg_congestion_buf(struct lpfc_hba *phba, int reg)
+{
+	struct lpfc_mbx_reg_congestion_buf *reg_congestion_buf;
+	union  lpfc_sli4_cfg_shdr *shdr;
+	uint32_t shdr_status, shdr_add_status;
+	LPFC_MBOXQ_t *mboxq;
+	int length, rc;
+
+	if (!phba->cgn_i)
+		return -ENXIO;
+
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"2641 REG_CONGESTION_BUF mbox allocation fail: "
+				"HBA state x%x reg %d\n",
+				phba->pport->port_state, reg);
+		return -ENOMEM;
+	}
+
+	length = (sizeof(struct lpfc_mbx_reg_congestion_buf) -
+		sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_REG_CONGESTION_BUF, length,
+			 LPFC_SLI4_MBX_EMBED);
+	reg_congestion_buf = &mboxq->u.mqe.un.reg_congestion_buf;
+	bf_set(lpfc_mbx_reg_cgn_buf_type, reg_congestion_buf, 1);
+	if (reg > 0)
+		bf_set(lpfc_mbx_reg_cgn_buf_cnt, reg_congestion_buf, 1);
+	else
+		bf_set(lpfc_mbx_reg_cgn_buf_cnt, reg_congestion_buf, 0);
+	reg_congestion_buf->length = sizeof(struct lpfc_cgn_info);
+	reg_congestion_buf->addr_lo =
+		putPaddrLow(phba->cgn_i->phys);
+	reg_congestion_buf->addr_hi =
+		putPaddrHigh(phba->cgn_i->phys);
+
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mboxq->u.mqe.un.sli4_config.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+				 &shdr->response);
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2642 REG_CONGESTION_BUF mailbox "
+				"failed with status x%x add_status x%x,"
+				" mbx status x%x reg %d\n",
+				shdr_status, shdr_add_status, rc, reg);
+		return -ENXIO;
+	}
+	return 0;
+}
+
+static int
+lpfc_unreg_congestion_buf(struct lpfc_hba *phba)
+{
+	return __lpfc_reg_congestion_buf(phba, 0);
+}
+
+int
+lpfc_reg_congestion_buf(struct lpfc_hba *phba)
+{
+	return __lpfc_reg_congestion_buf(phba, 1);
+}
+
 /**
  * lpfc_get_sli4_parameters - Get the SLI4 Config PARAMETERS.
  * @phba: Pointer to HBA context object.
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3b6576d3be6d..e6d03a0cf5c1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7713,6 +7713,16 @@ lpfc_cmf_setup(struct lpfc_hba *phba)
 			sli4_params->mi_ver);
 
 	mempool_free(mboxq, phba->mbox_mem_pool);
+
+	/* Initialize atomic counters */
+	atomic_set(&phba->cgn_fabric_warn_cnt, 0);
+	atomic_set(&phba->cgn_fabric_alarm_cnt, 0);
+	atomic_set(&phba->cgn_sync_alarm_cnt, 0);
+	atomic_set(&phba->cgn_sync_warn_cnt, 0);
+	atomic_set(&phba->cgn_driver_evt_cnt, 0);
+	atomic_set(&phba->cgn_latency_evt_cnt, 0);
+	atomic64_set(&phba->cgn_latency_evt, 0);
+
 	return 0;
 }
 
-- 
2.26.2

