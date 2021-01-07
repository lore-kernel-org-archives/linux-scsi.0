Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77D8C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB49A23118
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAGAv5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbhAGAvz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 19:51:55 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E60C0612A9
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jan 2021 16:51:01 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id 4so2475522plk.5
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jan 2021 16:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x9tnUQzcTKLqMhB5SkioNA+V8H7PnQcuQ9uQL4K9hAc=;
        b=gKjfoupYFkVo+YcYrLkaYOLSdqx8Zj3mjMsoV6s2nxoXYLnrwfXOjgIDiNh4eGyAQ1
         ihhGCxhNFe9uQ9lh6qaDNLZWLFqGcvek4eyte0M7oC3L2HI7kqHCCibshmbU+R0xOq17
         h0q0eWi3Ehomgsik4LOgt9Fr7bR6cgBfhfyBWryKto7ytbk2s1MkvN+SkFhAHE/RQhMx
         wzy0DJh9kmwBnZ8csluFeNxdDh9S+h5aFAK3hTPukjnxa7lfMbR14C9ARF9E810eMrBc
         C37hubUPv0mhYTTe4vqq8AMbyDLD4VhSht6P0GfhLujeiNEk87fiYvBpQVSZ8N7aqTBs
         iaMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x9tnUQzcTKLqMhB5SkioNA+V8H7PnQcuQ9uQL4K9hAc=;
        b=icQq6I/K+0ji7Yc5RhoY+DT6/uu170DNnLlhH0NwTQHAU4/ZaUBJ+bENasV6ZgkLgx
         cn2CeTJvgfitxkH3m36ZwKmwLkkLxZyS6h1vOxaAfgYViUPm9NFhlEm8uMDC1A/n7jCP
         1wQ/4QSr8UspJkCiajLTWsllIvCweRQ7O6D5v7I+Mmq1iDBo/5kSHnCWASKP5uNwnp9s
         3pWObvDrim/Dw2UsH1zcmkLKUPoUvxm1/fqEBTca4PMnizroSE8d8T06EkXym/QJ+VcG
         akiUzElQFXwi54J4bEIPuVFQYYpSXLrRjRAn6GUj9HPdrCk1gNzxYIF3bWXOwiuK+OSU
         nSkg==
X-Gm-Message-State: AOAM533gzdTYCdPRCrwz9h8xtj6qP9hIjE2fevB7xpnstGmT1PWKmzNU
        MV4udbg9cJc1h2v9TzRjBOh2f2ws2/lgnQ==
X-Google-Smtp-Source: ABdhPJz0Y69bvnCpcoQQpakn7pSN9xPLUDd4g3T7a9qYzgng1gdl1YLA4DUetlGr8UxKgGUOy8HjCQ==
X-Received: by 2002:a17:90a:c588:: with SMTP id l8mr6661869pjt.147.1609980660645;
        Wed, 06 Jan 2021 16:51:00 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w27sm3600634pfq.104.2021.01.06.16.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 16:51:00 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v6 27/31] elx: efct: link and host statistics
Date:   Wed,  6 Jan 2021 16:50:26 -0800
Message-Id: <20210107005030.2929-28-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107005030.2929-1-jsmart2021@gmail.com>
References: <20210107005030.2929-1-jsmart2021@gmail.com>
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
 drivers/scsi/elx/efct/efct_hw.c | 325 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  31 +++
 2 files changed, 356 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index ada28bdbfa8f..f1a20f2d2ffe 100644
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
+		struct efct_hw_host_stat_counts *counters, void *arg);
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
@@ -3032,3 +3049,311 @@ efct_hw_send_frame(struct efct_hw *hw, struct fc_frame_header *hdr,
 
 	return EFCT_HW_RTN_SUCCESS;
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
+	return EFC_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_get_link_stats(struct efct_hw *hw, u8 req_ext_counters,
+		       u8 clear_overflow_flags, u8 clear_all_counters,
+		       void (*cb)(int status, u32 num_counters,
+				  struct efct_hw_link_stat_counts *counters,
+				  void *arg),
+		       void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
+	struct efct_hw_link_stat_cb_arg *cb_arg;
+	u8 mbxdata[SLI4_BMBX_SIZE];
+
+	cb_arg = kzalloc(sizeof(*cb_arg), GFP_ATOMIC);
+	if (!cb_arg)
+		return EFCT_HW_RTN_NO_MEMORY;
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
+		   EFCT_HW_HOST_STAT_MAX);
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
+	return EFC_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_get_host_stats(struct efct_hw *hw, u8 cc,
+		       void (*cb)(int status, u32 num_counters,
+				  struct efct_hw_host_stat_counts *counters,
+				  void *arg),
+		       void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
+	struct efct_hw_host_stat_cb_arg *cb_arg;
+	u8 mbxdata[SLI4_BMBX_SIZE];
+
+	cb_arg = kmalloc(sizeof(*cb_arg), GFP_ATOMIC);
+	if (!cb_arg)
+		return EFCT_HW_RTN_NO_MEMORY;
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
+
+	/*
+	 * Allocate a callback context (which includes the mbox cmd buffer),
+	 * we need this to be persistent as the mbox cmd submission may be
+	 * queued and executed later execution.
+	 */
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	ctx->callback = callback;
+	ctx->arg = arg;
+
+	/* Build and send a NOP mailbox command */
+	if (sli_cmd_common_nop(&hw->sli, ctx->cmd, 0)) {
+		efc_log_err(hw->os, "COMMON_NOP format failure\n");
+		kfree(ctx);
+		return EFC_FAIL;
+	}
+
+	if (efct_hw_command(hw, ctx->cmd, EFCT_CMD_NOWAIT, efct_hw_async_cb,
+			    ctx)) {
+		efc_log_err(hw->os, "COMMON_NOP command failure\n");
+		kfree(ctx);
+		return EFC_FAIL;
+	}
+	return EFC_SUCCESS;
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
+	return EFC_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_firmware_write(struct efct_hw *hw, struct efc_dma *dma, u32 size,
+		       u32 offset, int last,
+		       void (*cb)(int status, u32 bytes_written,
+				   u32 change_status, void *arg),
+		       void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
+	u8 mbxdata[SLI4_BMBX_SIZE];
+	struct efct_hw_fw_wr_cb_arg *cb_arg;
+	int noc = 0;
+
+	cb_arg = kzalloc(sizeof(*cb_arg), GFP_KERNEL);
+	if (!cb_arg)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	cb_arg->cb = cb;
+	cb_arg->arg = arg;
+
+	/* Write a portion of a firmware image to the device */
+	if (!sli_cmd_common_write_object(&hw->sli, mbxdata,
+					noc, last, size, offset, "/prg/",
+					dma))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_fw_write, cb_arg);
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		efc_log_debug(hw->os, "COMMON_WRITE_OBJECT failed\n");
+		kfree(cb_arg);
+	}
+
+	return rc;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index a030fc5ac719..0dc7e210c86a 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -721,4 +721,35 @@ int
 efct_hw_bls_send(struct efct *efct, u32 type, struct sli_bls_params *bls_params,
 		 void *cb, void *arg);
 
+/* Function for retrieving link statistics */
+enum efct_hw_rtn
+efct_hw_get_link_stats(struct efct_hw *hw,
+		       u8 req_ext_counters,
+		u8 clear_overflow_flags,
+		u8 clear_all_counters,
+		void (*efct_hw_link_stat_cb_t)(int status,
+					       u32 num_counters,
+			struct efct_hw_link_stat_counts *counters,
+			void *arg),
+		void *arg);
+/* Function for retrieving host statistics */
+enum efct_hw_rtn
+efct_hw_get_host_stats(struct efct_hw *hw,
+		       u8 cc,
+		void (*efct_hw_host_stat_cb_t)(int status,
+					       u32 num_counters,
+			struct efct_hw_host_stat_counts *counters,
+			void *arg),
+		void *arg);
+enum efct_hw_rtn
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

