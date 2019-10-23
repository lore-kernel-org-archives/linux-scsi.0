Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F28ACA9EBB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FE7F205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BSOCjjs9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436642AbfJWV45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41205 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436617AbfJWV44 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id p4so23714985wrm.8
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SNrncpX+W/Bj9Hy+5hlXxGVNDKGNL6/Q148Qan/Irq4=;
        b=BSOCjjs9RvzydRT4xPe1hziXZIFvQ1UbLdliLMhXlbRGYBk41xk2yh7DX5PpTWWVjS
         F9FSKiPnnOZ5GMBuhTAS955893jwhKcL/Mk0vLO0Ef/Rdm8ULBvTAkJcRqai+8omRedH
         QUj4XbJgvFeLYd4nkZH9T2Xze+PUgr5fD1g9ctyu2ij0yPat/9TQ8+z6hIeXksTsdOS0
         8hgFv9cL4vmfMkEpXNTt5gJ56q5dzOv2F+gLHZp1Bfs1sR1Gc9DmAAQiwR+8S3j/Bupg
         mxcu6s4Um771WFzOVrVb75RrWyWK3/Xy/nY0Idvb9F5K5eCgSsGbEXhlAcCfZx0RYemA
         NrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SNrncpX+W/Bj9Hy+5hlXxGVNDKGNL6/Q148Qan/Irq4=;
        b=JGabDPmZoJwOX6q81YzYQ8X7/SEUIGbGAciVlKZjHb1cq9Z4JTy0uLvNWCqzhb09U1
         ZtDYX6ba0OPAgdeRXDQjDrBBAuqrZT8KDXlDfghB7u5+cpfbjiKpXJQRY3D5xqDzpTU+
         SGKY+zCjs8Mni/CV8GV0NucOLgE1fxmF8TY3Z/5nfPEND/QC0Xrk+4o71VlSBey2vh3K
         aYpvYpOaL/CZIjnXtVuw6Ng8ZdoJcGs5mRcLps6IrTNcaXf951BMvupFcHUAD9CjuZSh
         T1Z+DAbA3oFG/vjYRJvKRU2cVCDWj13x/T9QscdsohXBOqffSJIi9CHwvC1n4bl3vlPT
         jHTQ==
X-Gm-Message-State: APjAAAWvQ2V9K3gCvX6nnvvb6oC7DYDEjQ/gWWLtkzZpsRa7G7q5PEnH
        lBT3fls1WctTyodqpAlfAbqbWwp5
X-Google-Smtp-Source: APXvYqzyVw2AjmgXb3BYQaOgcluRTcZNklTFq+gfdiXHz5mxYBpRTqOk/GEQiqz9t4yxX4XLLtJ0Dw==
X-Received: by 2002:adf:ecc7:: with SMTP id s7mr730231wro.305.1571867810235;
        Wed, 23 Oct 2019 14:56:50 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:49 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 26/32] elx: efct: link statistics and SFP data
Date:   Wed, 23 Oct 2019 14:55:51 -0700
Message-Id: <20191023215557.12581-27-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to retrieve link stats and SFP transceiver data.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 593 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  39 +++
 2 files changed, 632 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 5e0ecd621f91..f01a54d874b1 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -14,6 +14,50 @@
 
 #define EFCT_HW_REQUE_XRI_REGTAG	65534
 
+struct efct_hw_sfp_cb_arg {
+	void (*cb)(int status, u32 bytes_written,
+		   u32 *data, void *arg);
+	void *arg;
+	struct efc_dma_s payload;
+};
+
+struct efct_hw_temp_cb_arg {
+	void (*cb)(int status, u32 curr_temp,
+		   u32 crit_temp_thrshld,
+		   u32 warn_temp_thrshld,
+		   u32 norm_temp_thrshld,
+		   u32 fan_off_thrshld,
+		   u32 fan_on_thrshld,
+		   void *arg);
+	void *arg;
+};
+
+struct efct_hw_link_stat_cb_arg {
+	void (*cb)(int status,
+		   u32 num_counters,
+		struct efct_hw_link_stat_counts_s *counters,
+		void *arg);
+	void *arg;
+};
+
+struct efct_hw_host_stat_cb_arg {
+	void (*cb)(int status,
+		   u32 num_counters,
+		struct efct_hw_host_stat_counts_s *counters,
+		void *arg);
+	void *arg;
+};
+
+static int
+efct_hw_cb_sfp(struct efct_hw_s *, int, u8 *, void  *);
+static int
+efct_hw_cb_temp(struct efct_hw_s *, int, u8 *, void  *);
+static int
+efct_hw_cb_link_stat(struct efct_hw_s *, int, u8 *, void  *);
+static int
+efct_hw_cb_host_stat(struct efct_hw_s *hw, int status,
+		     u8 *mqe, void  *arg);
+
 /* HW global data */
 struct efct_hw_global_s hw_global;
 static void
@@ -4624,3 +4668,552 @@ efct_hw_io_get_count(struct efct_hw_s *hw,
 
 	return count;
 }
+
+/**
+ * @brief Called when the READ_TRANSCEIVER_DATA command completes.
+ *
+ * @par Description
+ * Get the number of bytes read out of the response, free the mailbox that was
+ * malloc'd by efct_hw_get_sfp(), then call the callback and pass the status
+ * and bytes written.
+ *
+ * @param hw Hardware context.
+ * @param status Status field from the mbox completion.
+ * @param mqe Mailbox response structure.
+ * @param arg Pointer to a callback function that signals the caller that the
+ * command is done.
+ * The callback function prototype is
+ * void cb(int status, u32 bytes_written, u32 *data, void *arg).
+ *
+ * @return Returns 0.
+ */
+static int
+efct_hw_cb_sfp(struct efct_hw_s *hw, int status, u8 *mqe, void  *arg)
+{
+	struct efct_hw_sfp_cb_arg *cb_arg = arg;
+	struct efc_dma_s *payload = &cb_arg->payload;
+	struct sli4_rsp_cmn_read_transceiver_data_s *mbox_rsp;
+	struct efct_s *efct = hw->os;
+	u32 bytes_written;
+
+	mbox_rsp =
+	(struct sli4_rsp_cmn_read_transceiver_data_s *)payload->virt;
+	bytes_written = le32_to_cpu(mbox_rsp->hdr.response_length);
+	if (cb_arg) {
+		if (cb_arg->cb) {
+			if (!status && mbox_rsp->hdr.status)
+				status = mbox_rsp->hdr.status;
+			cb_arg->cb(status, bytes_written, mbox_rsp->page_data,
+				   cb_arg->arg);
+		}
+
+		dma_free_coherent(&efct->pcidev->dev,
+				  cb_arg->payload.size, cb_arg->payload.virt,
+				  cb_arg->payload.phys);
+		memset(&cb_arg->payload, 0, sizeof(struct efc_dma_s));
+		kfree(cb_arg);
+	}
+
+	kfree(mqe);
+	return 0;
+}
+
+/**
+ * @ingroup io
+ * @brief Function to retrieve the SFP information.
+ *
+ * @param hw Hardware context.
+ * @param page The page of SFP data to retrieve (0xa0 or 0xa2).
+ * @param cb Function call upon completion of sending the data (may be NULL).
+ * @param arg Argument to pass to IO completion function.
+ *
+ * @return Returns EFCT_HW_RTN_SUCCESS, EFCT_HW_RTN_ERROR, or
+ * EFCT_HW_RTN_NO_MEMORY.
+ */
+enum efct_hw_rtn_e
+efct_hw_get_sfp(struct efct_hw_s *hw, u16 page,
+		void (*cb)(int, u32, u32 *, void *), void *arg)
+{
+	enum efct_hw_rtn_e rc = EFCT_HW_RTN_ERROR;
+	struct efct_hw_sfp_cb_arg *cb_arg;
+	u8 *mbxdata;
+	struct efct_s *efct = hw->os;
+	struct efc_dma_s *dma;
+
+	/* mbxdata holds the header of the command */
+	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_KERNEL);
+	if (!mbxdata)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(mbxdata, 0, SLI4_BMBX_SIZE);
+	/*
+	 * cb_arg holds the data that will be passed to the callback on
+	 * completion
+	 */
+	cb_arg = kmalloc(sizeof(*cb_arg), GFP_KERNEL);
+	if (!cb_arg) {
+		kfree(mbxdata);
+		return EFCT_HW_RTN_NO_MEMORY;
+	}
+	memset(cb_arg, 0, sizeof(struct efct_hw_sfp_cb_arg));
+
+	cb_arg->cb = cb;
+	cb_arg->arg = arg;
+
+	/* payload holds the non-embedded portion */
+	dma = &cb_arg->payload;
+	dma->size = sizeof(struct sli4_rsp_cmn_read_transceiver_data_s);
+	dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
+				       dma->size, &dma->phys, GFP_DMA);
+	if (!dma->virt) {
+		kfree(cb_arg);
+		kfree(mbxdata);
+		return EFCT_HW_RTN_NO_MEMORY;
+	}
+
+	/* Send the HW command */
+	if (!sli_cmd_common_read_transceiver_data(&hw->sli, mbxdata,
+						 SLI4_BMBX_SIZE, page,
+						 &cb_arg->payload))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_sfp, cb_arg);
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		efc_log_test(hw->os,
+			      "READ_TRANSCEIVER_DATA failed with status %d\n",
+			     rc);
+		dma_free_coherent(&efct->pcidev->dev,
+				  cb_arg->payload.size, cb_arg->payload.virt,
+				  cb_arg->payload.phys);
+		memset(&cb_arg->payload, 0, sizeof(struct efc_dma_s));
+		kfree(cb_arg);
+		kfree(mbxdata);
+	}
+
+	return rc;
+}
+
+/**
+ * @brief Function to retrieve the temperature information.
+ *
+ * @param hw Hardware context.
+ * @param cb Function call upon completion of sending the data (may be NULL).
+ * @param arg Argument to pass to IO completion function.
+ *
+ * @return Returns EFCT_HW_RTN_SUCCESS, EFCT_HW_RTN_ERROR, or
+ * EFCT_HW_RTN_NO_MEMORY.
+ */
+enum efct_hw_rtn_e
+efct_hw_get_temperature(struct efct_hw_s *hw,
+			void (*cb)(int status,
+				   u32 curr_temp,
+				u32 crit_temp_thrshld,
+				u32 warn_temp_thrshld,
+				u32 norm_temp_thrshld,
+				u32 fan_off_thrshld,
+				u32 fan_on_thrshld,
+				void *arg),
+			void *arg)
+{
+	enum efct_hw_rtn_e rc = EFCT_HW_RTN_ERROR;
+	struct efct_hw_temp_cb_arg *cb_arg;
+	u8 *mbxdata;
+
+	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_KERNEL);
+	if (!mbxdata)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(mbxdata, 0, SLI4_BMBX_SIZE);
+
+	cb_arg = kmalloc(sizeof(*cb_arg), GFP_KERNEL);
+	if (!cb_arg) {
+		kfree(mbxdata);
+		return EFCT_HW_RTN_NO_MEMORY;
+	}
+
+	cb_arg->cb = cb;
+	cb_arg->arg = arg;
+
+	/* Send the HW command */
+	if (!sli_cmd_dump_type4(&hw->sli, mbxdata, SLI4_BMBX_SIZE,
+			       SLI4_WKI_TAG_SAT_TEM))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_temp, cb_arg);
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		efc_log_test(hw->os, "DUMP_TYPE4 failed\n");
+		kfree(mbxdata);
+		kfree(cb_arg);
+	}
+
+	return rc;
+}
+
+/**
+ * @brief Called when the DUMP command completes.
+ *
+ * @par Description
+ * Get the temperature data out of the response, free the mailbox that was
+ * malloc'd by efct_hw_get_temperature(), then call the callback and pass the
+ * status and data.
+ *
+ * @param hw Hardware context.
+ * @param status Status field from the mbox completion.
+ * @param mqe Mailbox response structure.
+ * @param arg Pointer to a callback function that signals the caller that the
+ * command is done.
+ * The callback function prototype is defined by efct_hw_temp_cb_t.
+ *
+ * @return Returns 0.
+ */
+static int
+efct_hw_cb_temp(struct efct_hw_s *hw, int status, u8 *mqe, void  *arg)
+{
+	struct sli4_cmd_dump4_s *mbox_rsp = (struct sli4_cmd_dump4_s *)mqe;
+	struct efct_hw_temp_cb_arg *cb_arg = arg;
+	u32 curr_temp = le32_to_cpu(mbox_rsp->resp_data[0]); /* word 5 */
+	u32 crit_temp_thrshld =
+			le32_to_cpu(mbox_rsp->resp_data[1]); /* word 6 */
+	u32 warn_temp_thrshld =
+			le32_to_cpu(mbox_rsp->resp_data[2]); /* word 7 */
+	u32 norm_temp_thrshld =
+			le32_to_cpu(mbox_rsp->resp_data[3]); /* word 8 */
+	u32 fan_off_thrshld =
+			le32_to_cpu(mbox_rsp->resp_data[4]);   /* word 9 */
+	u32 fan_on_thrshld =
+			le32_to_cpu(mbox_rsp->resp_data[5]);    /* word 10 */
+
+	if (cb_arg) {
+		if (cb_arg->cb) {
+			if (status == 0 && le16_to_cpu(mbox_rsp->hdr.status))
+				status = le16_to_cpu(mbox_rsp->hdr.status);
+			cb_arg->cb(status,
+				   curr_temp,
+				   crit_temp_thrshld,
+				   warn_temp_thrshld,
+				   norm_temp_thrshld,
+				   fan_off_thrshld,
+				   fan_on_thrshld,
+				   cb_arg->arg);
+		}
+
+		kfree(cb_arg);
+	}
+	kfree(mqe);
+
+	return 0;
+}
+
+/**
+ * @brief Function to retrieve the link statistics.
+ *
+ * @param hw Hardware context.
+ * @param req_ext_counters If TRUE, then the extended counters will be
+ * requested.
+ * @param clear_overflow_flags If TRUE, then overflow flags will be cleared.
+ * @param clear_all_counters If TRUE, the counters will be cleared.
+ * @param cb Function call upon completion of sending the data (may be NULL).
+ * @param arg Argument to pass to IO completion function.
+ *
+ * @return Returns EFCT_HW_RTN_SUCCESS, EFCT_HW_RTN_ERROR, ori
+ * EFCT_HW_RTN_NO_MEMORY.
+ */
+enum efct_hw_rtn_e
+efct_hw_get_link_stats(struct efct_hw_s *hw,
+		       u8 req_ext_counters,
+		       u8 clear_overflow_flags,
+		       u8 clear_all_counters,
+		       void (*cb)(int status,
+				  u32 num_counters,
+			struct efct_hw_link_stat_counts_s *counters,
+			void *arg),
+		       void *arg)
+{
+	enum efct_hw_rtn_e rc = EFCT_HW_RTN_ERROR;
+	struct efct_hw_link_stat_cb_arg *cb_arg;
+	u8 *mbxdata;
+
+	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+	if (!mbxdata)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(mbxdata, 0, SLI4_BMBX_SIZE);
+
+	cb_arg = kmalloc(sizeof(*cb_arg), GFP_ATOMIC);
+	if (!cb_arg) {
+		kfree(mbxdata);
+		return EFCT_HW_RTN_NO_MEMORY;
+	}
+
+	cb_arg->cb = cb;
+	cb_arg->arg = arg;
+
+	/* Send the HW command */
+	if (!sli_cmd_read_link_stats(&hw->sli, mbxdata, SLI4_BMBX_SIZE,
+				    req_ext_counters,
+				    clear_overflow_flags,
+				    clear_all_counters))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_link_stat, cb_arg);
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		kfree(mbxdata);
+		kfree(cb_arg);
+	}
+
+	return rc;
+}
+
+/**
+ * @brief Called when the READ_LINK_STAT command completes.
+ *
+ * @par Description
+ * Get the counters out of the response, free the mailbox that was malloc'd
+ * by efct_hw_get_link_stats(), then call the callback and pass the status and
+ * data.
+ *
+ * @param hw Hardware context.
+ * @param status Status field from the mbox completion.
+ * @param mqe Mailbox response structure.
+ * @param arg Pointer to a callback function that signals the caller that the
+ * command is done.
+ * The callback function prototype is defined by efct_hw_link_stat_cb_t.
+ *
+ * @return Returns 0.
+ */
+static int
+efct_hw_cb_link_stat(struct efct_hw_s *hw, int status,
+		     u8 *mqe, void  *arg)
+{
+	struct sli4_cmd_read_link_stats_s *mbox_rsp;
+	struct efct_hw_link_stat_cb_arg *cb_arg = arg;
+	struct efct_hw_link_stat_counts_s counts[EFCT_HW_LINK_STAT_MAX];
+	u32 num_counters;
+	u32 mbox_rsp_flags = 0;
+
+	mbox_rsp = (struct sli4_cmd_read_link_stats_s *)mqe;
+	mbox_rsp_flags = le32_to_cpu(mbox_rsp->dw1_flags);
+	num_counters = (mbox_rsp_flags & SLI4_READ_LNKSTAT_GEC) ? 20 : 13;
+	memset(counts, 0, sizeof(struct efct_hw_link_stat_counts_s) *
+				 EFCT_HW_LINK_STAT_MAX);
+
+	counts[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W02OF);
+	counts[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W03OF);
+	counts[EFCT_HW_LINK_STAT_LOSS_OF_SIGNAL_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W04OF);
+	counts[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W05OF);
+	counts[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W06OF);
+	counts[EFCT_HW_LINK_STAT_CRC_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W07OF);
+	counts[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_TIMEOUT_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W08OF);
+	counts[EFCT_HW_LINK_STAT_ELASTIC_BUFFER_OVERRUN_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W09OF);
+	counts[EFCT_HW_LINK_STAT_ARB_TIMEOUT_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W10OF);
+	counts[EFCT_HW_LINK_STAT_ADVERTISED_RCV_B2B_CREDIT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W11OF);
+	counts[EFCT_HW_LINK_STAT_CURR_RCV_B2B_CREDIT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W12OF);
+	counts[EFCT_HW_LINK_STAT_ADVERTISED_XMIT_B2B_CREDIT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W13OF);
+	counts[EFCT_HW_LINK_STAT_CURR_XMIT_B2B_CREDIT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W14OF);
+	counts[EFCT_HW_LINK_STAT_RCV_EOFA_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W15OF);
+	counts[EFCT_HW_LINK_STAT_RCV_EOFDTI_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W16OF);
+	counts[EFCT_HW_LINK_STAT_RCV_EOFNI_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W17OF);
+	counts[EFCT_HW_LINK_STAT_RCV_SOFF_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W18OF);
+	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_AER_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W19OF);
+	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_RPI_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W20OF);
+	counts[EFCT_HW_LINK_STAT_RCV_DROPPED_NO_XRI_COUNT].overflow =
+		(mbox_rsp_flags & SLI4_READ_LNKSTAT_W21OF);
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
+	kfree(mqe);
+
+	return 0;
+}
+
+/**
+ * @brief Function to retrieve the link and host statistics.
+ *
+ * @param hw Hardware context.
+ * @param cc clear counters, if TRUE all counters will be cleared.
+ * @param cb Function call upon completion of receiving the data.
+ * @param arg Argument to pass to pointer fc hosts statistics structure.
+ *
+ * @return Returns EFCT_HW_RTN_SUCCESS, EFCT_HW_RTN_ERROR, or
+ * EFCT_HW_RTN_NO_MEMORY.
+ */
+enum efct_hw_rtn_e
+efct_hw_get_host_stats(struct efct_hw_s *hw, u8 cc,
+		       void (*cb)(int status,
+				  u32 num_counters,
+				  struct efct_hw_host_stat_counts_s *counters,
+				  void *arg),
+		       void *arg)
+{
+	enum efct_hw_rtn_e rc = EFCT_HW_RTN_ERROR;
+	struct efct_hw_host_stat_cb_arg *cb_arg;
+	u8 *mbxdata;
+
+	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+	if (!mbxdata)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(mbxdata, 0, SLI4_BMBX_SIZE);
+
+	cb_arg = kmalloc(sizeof(*cb_arg), GFP_ATOMIC);
+	if (!cb_arg) {
+		kfree(mbxdata);
+		return EFCT_HW_RTN_NO_MEMORY;
+	}
+
+	 cb_arg->cb = cb;
+	 cb_arg->arg = arg;
+
+	 /* Send the HW command to get the host stats */
+	if (!sli_cmd_read_status(&hw->sli, mbxdata, SLI4_BMBX_SIZE, cc))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_host_stat, cb_arg);
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		efc_log_test(hw->os, "READ_HOST_STATS failed\n");
+		kfree(mbxdata);
+		kfree(cb_arg);
+	}
+
+	return rc;
+}
+
+/**
+ * @brief Called when the READ_STATUS command completes.
+ *
+ * @par Description
+ * Get the counters out of the response, free the mailbox that was malloc'd
+ * by efct_hw_get_host_stats(), then call the callback and pass
+ * the status and data.
+ *
+ * @param hw Hardware context.
+ * @param status Status field from the mbox completion.
+ * @param mqe Mailbox response structure.
+ * @param arg Pointer to a callback function that signals the caller that the
+ * command is done.
+ * The callback function prototype is defined by
+ * efct_hw_host_stat_cb_t.
+ *
+ * @return Returns 0.
+ */
+static int
+efct_hw_cb_host_stat(struct efct_hw_s *hw, int status,
+		     u8 *mqe, void  *arg)
+{
+	struct sli4_cmd_read_status_s *mbox_rsp =
+					(struct sli4_cmd_read_status_s *)mqe;
+	struct efct_hw_host_stat_cb_arg *cb_arg = arg;
+	struct efct_hw_host_stat_counts_s counts[EFCT_HW_HOST_STAT_MAX];
+	u32 num_counters = EFCT_HW_HOST_STAT_MAX;
+
+	memset(counts, 0, sizeof(struct efct_hw_host_stat_counts_s) *
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
+	kfree(mqe);
+
+	return 0;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 7f1c4091d91a..b372250c4408 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -1130,5 +1130,44 @@ efct_hw_srrs_send(struct efct_hw_s *hw, enum efct_hw_io_type_e type,
 		  union efct_hw_io_param_u *iparam,
 		  efct_hw_srrs_cb_t cb,
 		  void *arg);
+/* Function for retrieving SFP data */
+extern enum efct_hw_rtn_e
+efct_hw_get_sfp(struct efct_hw_s *hw, u16 page,
+		void (*cb)(int, u32, u32 *, void *), void *arg);
+
+/* Function for retrieving temperature data */
+extern enum efct_hw_rtn_e
+efct_hw_get_temperature(struct efct_hw_s *hw,
+			void (*efct_hw_temp_cb_t)(int status,
+						  u32 curr_temp,
+				u32 crit_temp_thrshld,
+				u32 warn_temp_thrshld,
+				u32 norm_temp_thrshld,
+				u32 fan_off_thrshld,
+				u32 fan_on_thrshld,
+				void *arg),
+			void *arg);
+
+/* Function for retrieving link statistics */
+extern enum efct_hw_rtn_e
+efct_hw_get_link_stats(struct efct_hw_s *hw,
+		       u8 req_ext_counters,
+		u8 clear_overflow_flags,
+		u8 clear_all_counters,
+		void (*efct_hw_link_stat_cb_t)(int status,
+					       u32 num_counters,
+			struct efct_hw_link_stat_counts_s *counters,
+			void *arg),
+		void *arg);
+/* Function for retrieving host statistics */
+extern enum efct_hw_rtn_e
+efct_hw_get_host_stats(struct efct_hw_s *hw,
+		       u8 cc,
+		void (*efct_hw_host_stat_cb_t)(int status,
+					       u32 num_counters,
+			struct efct_hw_host_stat_counts_s *counters,
+			void *arg),
+		void *arg);
+
 
 #endif /* __EFCT_H__ */
-- 
2.13.7

