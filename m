Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6500C4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A23A261351
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhFAX5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbhFAX5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 19:57:22 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CA1C061574
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 16:55:40 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v14so732275pgi.6
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 16:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1c6+PH4vQtTzC0FGE+bWVv14Jw+9oiSpCrrKaZGU9CA=;
        b=qJ590NN7BWnRq9pGfppiOUAEUzm0JKFBZPFV4W3ORtL/LmdGN3RDkbyoktWIptyYH3
         0ye8DzOl9eNEAHyFVn9AdKPP/IByLoH318Olcdfmjmk5x5YDdKcJDiwHJVp/HbsJ3Fdt
         BoyaOXngu1uqX8watvXit8ycH3xyum0KYGs9ZdLzQV7iJC/Qv9B8brvyTlhslKJf+aON
         2H+XSBuPBKTaGRzO0+979tSK638zwEBpNdMEU31YaQ7Et0qFI5fuvRZNWnuK14DRCDvc
         BVrZFpxk1KHSNiyXx2mQgXYZ1SF824hztldrt11d5fg0KvblN2+5QthQrRIl0y6D4UZo
         TEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1c6+PH4vQtTzC0FGE+bWVv14Jw+9oiSpCrrKaZGU9CA=;
        b=NYd1wEurHPUHenyyOT46SaVNjc84e3mvyZ5xyDTrBM5UxxKBcOsf6cRVspZ0tD58z+
         bnA6Xy/RHKi7yyKPwNDaldL4Nzbmwpk9K8KnflGrQRXVgo6CoEMvSTeQb4MfeUEKgnPA
         W3MbpuXHPkPZhFUUYu1mBH+5h9btO66NEpGsGaOSQJ9cQ0MJVr09kzd8bJsyrMyPoqHr
         GcKETrgkO804Rt/kk+ZLYDK2ysJeutaU5+flIxP4ln86KDEKeXMX1pD/tNbPdiLToBDw
         aWWl8DZTgRsgW7kpDsIBe6ZZlwRVBXrc1RvrDfwzZyqeyrlQVZ/7fGAfvrM5JACuni/h
         2p6Q==
X-Gm-Message-State: AOAM532oBRtH/wMyFTTZlZaYbXGQ03tiYSwoFIRTR4DLbo+cFdvcTApE
        moTLHCEb+LMhN7NpNtt1Y5L3AjXo4iY=
X-Google-Smtp-Source: ABdhPJw36l/+NOeWQlsNRoQT+yA/9HS0Y67Nc1Af4YbhCckN79w8ZyOOuXfbBWedV5l5ovCKedUoQw==
X-Received: by 2002:a62:148c:0:b029:2cf:3c2d:7ba with SMTP id 134-20020a62148c0000b02902cf3c2d07bamr24427539pfu.79.1622591739520;
        Tue, 01 Jun 2021 16:55:39 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm13915357pfm.187.2021.06.01.16.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 16:55:39 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v9 27/31] elx: efct: link and host statistics
Date:   Tue,  1 Jun 2021 16:55:08 -0700
Message-Id: <20210601235512.20104-28-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210601235512.20104-1-jsmart2021@gmail.com>
References: <20210601235512.20104-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to retrieve link stats and host stats.
Add Firmware update helper routines.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>

---
v9:
Non-functional changes:
  Remove EFC_SUCCESS/EFC_FAIL defines and use 0 and -Exxx errno values.
  Remove EFCT_xxx/EFCT_HW_RTN_xxx defines and use appropriate -Exxx errno
       values.
  Correct indentation on line continuations.
---
 drivers/scsi/elx/efct/efct_hw.c | 327 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  29 +++
 2 files changed, 356 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index ffe7dd106811..ddfbb74dbcbd 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -8,6 +8,23 @@
 #include "efct_hw.h"
 #include "efct_unsol.h"
 
+struct efct_hw_link_stat_cb_arg {
+	void (*cb)(int status, u32 num_counters,
+		   struct efct_hw_link_stat_counts *counters, void *arg);
+	void *arg;
+};
+
+struct efct_hw_host_stat_cb_arg {
+	void (*cb)(int status, u32 num_counters,
+		   struct efct_hw_host_stat_counts *counters, void *arg);
+	void *arg;
+};
+
+struct efct_hw_fw_wr_cb_arg {
+	void (*cb)(int status, u32 bytes_written, u32 change_status, void *arg);
+	void *arg;
+};
+
 struct efct_mbox_rqst_ctx {
 	int (*callback)(struct efc *efc, int status, u8 *mqe, void *arg);
 	void *arg;
@@ -3002,3 +3019,313 @@ efct_hw_send_frame(struct efct_hw *hw, struct fc_frame_header *hdr,
 
 	return 0;
 }
+
+static int
+efct_hw_cb_link_stat(struct efct_hw *hw, int status,
+		     u8 *mqe, void  *arg)
+{
+	struct sli4_cmd_read_link_stats *mbox_rsp;
+	struct efct_hw_link_stat_cb_arg *cb_arg = arg;
+	struct efct_hw_link_stat_counts counts[EFCT_HW_LINK_STAT_MAX];
+	u32 num_counters, i;
+	u32 mbox_rsp_flags = 0;
+
+	mbox_rsp = (struct sli4_cmd_read_link_stats *)mqe;
+	mbox_rsp_flags = le32_to_cpu(mbox_rsp->dw1_flags);
+	num_counters = (mbox_rsp_flags & SLI4_READ_LNKSTAT_GEC) ? 20 : 13;
+	memset(counts, 0, sizeof(struct efct_hw_link_stat_counts) *
+				 EFCT_HW_LINK_STAT_MAX);
+
+	/* Fill overflow counts, mask starts from SLI4_READ_LNKSTAT_W02OF*/
+	for (i = 0; i < EFCT_HW_LINK_STAT_MAX; i++)
+		counts[i].overflow = (mbox_rsp_flags & (1 << (i + 2)));
+
+	counts[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->linkfail_errcnt);
+	counts[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->losssync_errcnt);
+	counts[EFCT_HW_LINK_STAT_LOSS_OF_SIGNAL_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->losssignal_errcnt);
+	counts[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->primseq_errcnt);
+	counts[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->inval_txword_errcnt);
+	counts[EFCT_HW_LINK_STAT_CRC_COUNT].counter =
+		le32_to_cpu(mbox_rsp->crc_errcnt);
+	counts[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_TIMEOUT_COUNT].counter =
+		le32_to_cpu(mbox_rsp->primseq_eventtimeout_cnt);
+	counts[EFCT_HW_LINK_STAT_ELASTIC_BUFFER_OVERRUN_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->elastic_bufoverrun_errcnt);
+	counts[EFCT_HW_LINK_STAT_ARB_TIMEOUT_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->arbit_fc_al_timeout_cnt);
+	counts[EFCT_HW_LINK_STAT_ADVERTISED_RCV_B2B_CREDIT].counter =
+		 le32_to_cpu(mbox_rsp->adv_rx_buftor_to_buf_credit);
+	counts[EFCT_HW_LINK_STAT_CURR_RCV_B2B_CREDIT].counter =
+		 le32_to_cpu(mbox_rsp->curr_rx_buf_to_buf_credit);
+	counts[EFCT_HW_LINK_STAT_ADVERTISED_XMIT_B2B_CREDIT].counter =
+		 le32_to_cpu(mbox_rsp->adv_tx_buf_to_buf_credit);
+	counts[EFCT_HW_LINK_STAT_CURR_XMIT_B2B_CREDIT].counter =
+		 le32_to_cpu(mbox_rsp->curr_tx_buf_to_buf_credit);
+	counts[EFCT_HW_LINK_STAT_RCV_EOFA_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->rx_eofa_cnt);
+	counts[EFCT_HW_LINK_STAT_RCV_EOFDTI_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->rx_eofdti_cnt);
+	counts[EFCT_HW_LINK_STAT_RCV_EOFNI_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->rx_eofni_cnt);
+	counts[EFCT_HW_LINK_STAT_RCV_SOFF_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->rx_soff_cnt);
+	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_AER_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->rx_dropped_no_aer_cnt);
+	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_RPI_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->rx_dropped_no_avail_rpi_rescnt);
+	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_XRI_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->rx_dropped_no_avail_xri_rescnt);
+
+	if (cb_arg) {
+		if (cb_arg->cb) {
+			if (status == 0 && le16_to_cpu(mbox_rsp->hdr.status))
+				status = le16_to_cpu(mbox_rsp->hdr.status);
+			cb_arg->cb(status, num_counters, counts, cb_arg->arg);
+		}
+
+		kfree(cb_arg);
+	}
+
+	return 0;
+}
+
+int
+efct_hw_get_link_stats(struct efct_hw *hw, u8 req_ext_counters,
+		       u8 clear_overflow_flags, u8 clear_all_counters,
+		       void (*cb)(int status, u32 num_counters,
+				  struct efct_hw_link_stat_counts *counters,
+				  void *arg),
+		       void *arg)
+{
+	int rc = -EIO;
+	struct efct_hw_link_stat_cb_arg *cb_arg;
+	u8 mbxdata[SLI4_BMBX_SIZE];
+
+	cb_arg = kzalloc(sizeof(*cb_arg), GFP_ATOMIC);
+	if (!cb_arg)
+		return -ENOMEM;
+
+	cb_arg->cb = cb;
+	cb_arg->arg = arg;
+
+	/* Send the HW command */
+	if (!sli_cmd_read_link_stats(&hw->sli, mbxdata, req_ext_counters,
+				    clear_overflow_flags, clear_all_counters))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_link_stat, cb_arg);
+
+	if (rc)
+		kfree(cb_arg);
+
+	return rc;
+}
+
+static int
+efct_hw_cb_host_stat(struct efct_hw *hw, int status, u8 *mqe, void  *arg)
+{
+	struct sli4_cmd_read_status *mbox_rsp =
+					(struct sli4_cmd_read_status *)mqe;
+	struct efct_hw_host_stat_cb_arg *cb_arg = arg;
+	struct efct_hw_host_stat_counts counts[EFCT_HW_HOST_STAT_MAX];
+	u32 num_counters = EFCT_HW_HOST_STAT_MAX;
+
+	memset(counts, 0, sizeof(struct efct_hw_host_stat_counts) *
+	       EFCT_HW_HOST_STAT_MAX);
+
+	counts[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->trans_kbyte_cnt);
+	counts[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->recv_kbyte_cnt);
+	counts[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->trans_frame_cnt);
+	counts[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->recv_frame_cnt);
+	counts[EFCT_HW_HOST_STAT_TX_SEQ_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->trans_seq_cnt);
+	counts[EFCT_HW_HOST_STAT_RX_SEQ_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->recv_seq_cnt);
+	counts[EFCT_HW_HOST_STAT_TOTAL_EXCH_ORIG].counter =
+		 le32_to_cpu(mbox_rsp->tot_exchanges_orig);
+	counts[EFCT_HW_HOST_STAT_TOTAL_EXCH_RESP].counter =
+		 le32_to_cpu(mbox_rsp->tot_exchanges_resp);
+	counts[EFCT_HW_HOSY_STAT_RX_P_BSY_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->recv_p_bsy_cnt);
+	counts[EFCT_HW_HOST_STAT_RX_F_BSY_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->recv_f_bsy_cnt);
+	counts[EFCT_HW_HOST_STAT_DROP_FRM_DUE_TO_NO_RQ_BUF_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->no_rq_buf_dropped_frames_cnt);
+	counts[EFCT_HW_HOST_STAT_EMPTY_RQ_TIMEOUT_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->empty_rq_timeout_cnt);
+	counts[EFCT_HW_HOST_STAT_DROP_FRM_DUE_TO_NO_XRI_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->no_xri_dropped_frames_cnt);
+	counts[EFCT_HW_HOST_STAT_EMPTY_XRI_POOL_COUNT].counter =
+		 le32_to_cpu(mbox_rsp->empty_xri_pool_cnt);
+
+	if (cb_arg) {
+		if (cb_arg->cb) {
+			if (status == 0 && le16_to_cpu(mbox_rsp->hdr.status))
+				status = le16_to_cpu(mbox_rsp->hdr.status);
+			cb_arg->cb(status, num_counters, counts, cb_arg->arg);
+		}
+
+		kfree(cb_arg);
+	}
+
+	return 0;
+}
+
+int
+efct_hw_get_host_stats(struct efct_hw *hw, u8 cc,
+		       void (*cb)(int status, u32 num_counters,
+				  struct efct_hw_host_stat_counts *counters,
+				  void *arg),
+		       void *arg)
+{
+	int rc = -EIO;
+	struct efct_hw_host_stat_cb_arg *cb_arg;
+	u8 mbxdata[SLI4_BMBX_SIZE];
+
+	cb_arg = kmalloc(sizeof(*cb_arg), GFP_ATOMIC);
+	if (!cb_arg)
+		return -ENOMEM;
+
+	cb_arg->cb = cb;
+	cb_arg->arg = arg;
+
+	 /* Send the HW command to get the host stats */
+	if (!sli_cmd_read_status(&hw->sli, mbxdata, cc))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_host_stat, cb_arg);
+
+	if (rc) {
+		efc_log_debug(hw->os, "READ_HOST_STATS failed\n");
+		kfree(cb_arg);
+	}
+
+	return rc;
+}
+
+struct efct_hw_async_call_ctx {
+	efct_hw_async_cb_t callback;
+	void *arg;
+	u8 cmd[SLI4_BMBX_SIZE];
+};
+
+static void
+efct_hw_async_cb(struct efct_hw *hw, int status, u8 *mqe, void *arg)
+{
+	struct efct_hw_async_call_ctx *ctx = arg;
+
+	if (ctx) {
+		if (ctx->callback)
+			(*ctx->callback)(hw, status, mqe, ctx->arg);
+
+		kfree(ctx);
+	}
+}
+
+int
+efct_hw_async_call(struct efct_hw *hw, efct_hw_async_cb_t callback, void *arg)
+{
+	struct efct_hw_async_call_ctx *ctx;
+	int rc;
+
+	/*
+	 * Allocate a callback context (which includes the mbox cmd buffer),
+	 * we need this to be persistent as the mbox cmd submission may be
+	 * queued and executed later execution.
+	 */
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->callback = callback;
+	ctx->arg = arg;
+
+	/* Build and send a NOP mailbox command */
+	if (sli_cmd_common_nop(&hw->sli, ctx->cmd, 0)) {
+		efc_log_err(hw->os, "COMMON_NOP format failure\n");
+		kfree(ctx);
+		return -EIO;
+	}
+
+	rc = efct_hw_command(hw, ctx->cmd, EFCT_CMD_NOWAIT, efct_hw_async_cb,
+			     ctx);
+	if (rc) {
+		efc_log_err(hw->os, "COMMON_NOP command failure, rc=%d\n", rc);
+		kfree(ctx);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int
+efct_hw_cb_fw_write(struct efct_hw *hw, int status, u8 *mqe, void  *arg)
+{
+	struct sli4_cmd_sli_config *mbox_rsp =
+					(struct sli4_cmd_sli_config *)mqe;
+	struct sli4_rsp_cmn_write_object *wr_obj_rsp;
+	struct efct_hw_fw_wr_cb_arg *cb_arg = arg;
+	u32 bytes_written;
+	u16 mbox_status;
+	u32 change_status;
+
+	wr_obj_rsp = (struct sli4_rsp_cmn_write_object *)
+		      &mbox_rsp->payload.embed;
+	bytes_written = le32_to_cpu(wr_obj_rsp->actual_write_length);
+	mbox_status = le16_to_cpu(mbox_rsp->hdr.status);
+	change_status = (le32_to_cpu(wr_obj_rsp->change_status_dword) &
+			 RSP_CHANGE_STATUS);
+
+	if (cb_arg) {
+		if (cb_arg->cb) {
+			if (!status && mbox_status)
+				status = mbox_status;
+			cb_arg->cb(status, bytes_written, change_status,
+				   cb_arg->arg);
+		}
+
+		kfree(cb_arg);
+	}
+
+	return 0;
+}
+
+int
+efct_hw_firmware_write(struct efct_hw *hw, struct efc_dma *dma, u32 size,
+		       u32 offset, int last,
+		       void (*cb)(int status, u32 bytes_written,
+				   u32 change_status, void *arg),
+		       void *arg)
+{
+	int rc = -EIO;
+	u8 mbxdata[SLI4_BMBX_SIZE];
+	struct efct_hw_fw_wr_cb_arg *cb_arg;
+	int noc = 0;
+
+	cb_arg = kzalloc(sizeof(*cb_arg), GFP_KERNEL);
+	if (!cb_arg)
+		return -ENOMEM;
+
+	cb_arg->cb = cb;
+	cb_arg->arg = arg;
+
+	/* Write a portion of a firmware image to the device */
+	if (!sli_cmd_common_write_object(&hw->sli, mbxdata,
+					 noc, last, size, offset, "/prg/",
+					 dma))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_fw_write, cb_arg);
+
+	if (rc != 0) {
+		efc_log_debug(hw->os, "COMMON_WRITE_OBJECT failed\n");
+		kfree(cb_arg);
+	}
+
+	return rc;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index b9e7f5b4115b..016ba6ac7b96 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -705,4 +705,33 @@ int
 efct_hw_bls_send(struct efct *efct, u32 type, struct sli_bls_params *bls_params,
 		 void *cb, void *arg);
 
+/* Function for retrieving link statistics */
+int
+efct_hw_get_link_stats(struct efct_hw *hw,
+		       u8 req_ext_counters,
+		       u8 clear_overflow_flags,
+		       u8 clear_all_counters,
+		       void (*efct_hw_link_stat_cb_t)(int status,
+						      u32 num_counters,
+		       struct efct_hw_link_stat_counts *counters, void *arg),
+		       void *arg);
+/* Function for retrieving host statistics */
+int
+efct_hw_get_host_stats(struct efct_hw *hw,
+		       u8 cc,
+		       void (*efct_hw_host_stat_cb_t)(int status,
+						      u32 num_counters,
+		       struct efct_hw_host_stat_counts *counters, void *arg),
+		       void *arg);
+int
+efct_hw_firmware_write(struct efct_hw *hw, struct efc_dma *dma,
+		       u32 size, u32 offset, int last,
+		       void (*cb)(int status, u32 bytes_written,
+				  u32 change_status, void *arg),
+		       void *arg);
+typedef void (*efct_hw_async_cb_t)(struct efct_hw *hw, int status,
+				  u8 *mqe, void *arg);
+int
+efct_hw_async_call(struct efct_hw *hw, efct_hw_async_cb_t callback, void *arg);
+
 #endif /* __EFCT_H__ */
-- 
2.26.2

