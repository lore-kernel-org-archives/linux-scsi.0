Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C90C2D0D2
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 594152082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qs4Zjyr8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfLTWiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:38:03 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37014 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfLTWiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:38:02 -0500
Received: by mail-pj1-f67.google.com with SMTP id m13so4761186pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/1KMg8A3RtP7VRz+65D80OswnaC28GWu1UnLtDJHT/Q=;
        b=Qs4Zjyr8AScVvpd4Rmi6Cy+Ri+71JRtIwiCzJsjZ2p+aRrLlSv+DOM19v4pUJcfvwP
         N/5LdXx/ize/gbmVrvcpHkgfDnoYjn3WC4v57T+lYI9QVl8k1uva2MjCli5Vtq3+YrVk
         x7P8R17OcTvRONNhGhJsTA0lCxAM7EfwUwdhwBTy2i6lcUSPlx7ZxJ474AL02/p+gNW4
         2juAJt1/zzWvKyKOazZUYalzcgTCaSHR6kAacSIPSBQXb7pFmRilOWfPx1WEusSgLF00
         S1iuF2zvGKhn06cyWQMHs8tndqmZHEwofpwoAk2a1TvPsn7TU0fy08Nq+WbclnDGfKC7
         sHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/1KMg8A3RtP7VRz+65D80OswnaC28GWu1UnLtDJHT/Q=;
        b=PXz9Bid7DsjoGvVcQypFwUnUC8j6WAfnrjcxmABOAhNI17Zr9nAcrfLNjHYI9SwXIJ
         cCXw/O/j3l7SSa5NF6GV/YXcOuOx2SXWm8aj7y9j8zVHtHEo+yDVocALA40zSU3LHOX1
         8mVo4a/4gp9o11oWD7SzHhkP5a+b0eUcgK3TX2qNrMdlkMDGaWd/9ZllQh8LXlI6t4sE
         dEtf8gYYn+ScBHC0exCeXi4JX+CxKtId6KiWUUYDJcOlbnhIr9n+6KEYRuTF9pmc36Mz
         8wN2GCcKzQq8D75OTxaGkjRaAe6wzgwXSsszWDOmYThAepFXuRCS/qOYavn8XJPJBxy3
         0H8w==
X-Gm-Message-State: APjAAAWI7cdJCfWRfHM83eGUBBRUsHEo7hrNsNJ6TGMf+h6Z1zXNBQ4s
        uWEGdQijcxReUl2DxpiIO9Zmf83j
X-Google-Smtp-Source: APXvYqwQVRoEL0LsFw+urbXacS9Ij1o8Sw2yXIWxAPzuC0ypW9Y8COahb+07mcLw8P7xgAqQsYrHgw==
X-Received: by 2002:a17:90a:c385:: with SMTP id h5mr18630748pjt.122.1576881481623;
        Fri, 20 Dec 2019 14:38:01 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.38.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:38:00 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 26/32] elx: efct: link statistics and SFP data
Date:   Fri, 20 Dec 2019 14:37:17 -0800
Message-Id: <20191220223723.26563-27-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
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
 drivers/scsi/elx/efct/efct_hw.c | 468 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  39 ++++
 2 files changed, 507 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 440c4fa196bf..33eefda7ba51 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -14,6 +14,40 @@
 
 #define EFCT_HW_REQUE_XRI_REGTAG	65534
 
+struct efct_hw_sfp_cb_arg {
+	void (*cb)(int status, u32 bytes_written,
+		   u8 *data, void *arg);
+	void *arg;
+	struct efc_dma payload;
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
+		struct efct_hw_link_stat_counts *counters,
+		void *arg);
+	void *arg;
+};
+
+struct efct_hw_host_stat_cb_arg {
+	void (*cb)(int status,
+		   u32 num_counters,
+		struct efct_hw_host_stat_counts *counters,
+		void *arg);
+	void *arg;
+};
+
 /* HW global data */
 struct efct_hw_global hw_global;
 
@@ -4015,3 +4049,437 @@ efct_hw_io_get_count(struct efct_hw *hw,
 
 	return count;
 }
+
+static int
+efct_hw_cb_sfp(struct efct_hw *hw, int status, u8 *mqe, void  *arg)
+{
+	struct efct_hw_sfp_cb_arg *cb_arg = arg;
+	struct efc_dma *payload = &cb_arg->payload;
+	struct sli4_rsp_cmn_read_transceiver_data *mbox_rsp;
+	struct efct *efct = hw->os;
+	u32 bytes_written;
+
+	mbox_rsp =
+	(struct sli4_rsp_cmn_read_transceiver_data *)payload->virt;
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
+		memset(&cb_arg->payload, 0, sizeof(struct efc_dma));
+		kfree(cb_arg);
+	}
+
+	kfree(mqe);
+	return 0;
+}
+
+/* Function to retrieve the SFP information */
+enum efct_hw_rtn
+efct_hw_get_sfp(struct efct_hw *hw, u16 page,
+		void (*cb)(int, u32, u8 *, void *), void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
+	struct efct_hw_sfp_cb_arg *cb_arg;
+	u8 *mbxdata;
+	struct efct *efct = hw->os;
+	struct efc_dma *dma;
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
+	dma->size = sizeof(struct sli4_rsp_cmn_read_transceiver_data);
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
+		memset(&cb_arg->payload, 0, sizeof(struct efc_dma));
+		kfree(cb_arg);
+		kfree(mbxdata);
+	}
+
+	return rc;
+}
+
+static int
+efct_hw_cb_temp(struct efct_hw *hw, int status, u8 *mqe, void  *arg)
+{
+	struct sli4_cmd_dump4 *mbox_rsp = (struct sli4_cmd_dump4 *)mqe;
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
+/* Function to retrieve the temperature information */
+enum efct_hw_rtn
+efct_hw_get_temperature(struct efct_hw *hw,
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
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
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
+static int
+efct_hw_cb_link_stat(struct efct_hw *hw, int status,
+		     u8 *mqe, void  *arg)
+{
+	struct sli4_cmd_read_link_stats *mbox_rsp;
+	struct efct_hw_link_stat_cb_arg *cb_arg = arg;
+	struct efct_hw_link_stat_counts counts[EFCT_HW_LINK_STAT_MAX];
+	u32 num_counters;
+	u32 mbox_rsp_flags = 0;
+
+	mbox_rsp = (struct sli4_cmd_read_link_stats *)mqe;
+	mbox_rsp_flags = le32_to_cpu(mbox_rsp->dw1_flags);
+	num_counters = (mbox_rsp_flags & SLI4_READ_LNKSTAT_GEC) ? 20 : 13;
+	memset(counts, 0, sizeof(struct efct_hw_link_stat_counts) *
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
+enum efct_hw_rtn
+efct_hw_get_link_stats(struct efct_hw *hw,
+		       u8 req_ext_counters,
+		       u8 clear_overflow_flags,
+		       u8 clear_all_counters,
+		       void (*cb)(int status,
+				  u32 num_counters,
+			struct efct_hw_link_stat_counts *counters,
+			void *arg),
+		       void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
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
+static int
+efct_hw_cb_host_stat(struct efct_hw *hw, int status,
+		     u8 *mqe, void  *arg)
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
+	kfree(mqe);
+
+	return 0;
+}
+
+enum efct_hw_rtn
+efct_hw_get_host_stats(struct efct_hw *hw, u8 cc,
+		       void (*cb)(int status,
+				  u32 num_counters,
+				  struct efct_hw_host_stat_counts *counters,
+				  void *arg),
+		       void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
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
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 1a019594c471..278f241e8705 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -970,5 +970,44 @@ efct_hw_srrs_send(struct efct_hw *hw, enum efct_hw_io_type type,
 		  union efct_hw_io_param_u *iparam,
 		  efct_hw_srrs_cb_t cb,
 		  void *arg);
+/* Function for retrieving SFP data */
+extern enum efct_hw_rtn
+efct_hw_get_sfp(struct efct_hw *hw, u16 page,
+		void (*cb)(int, u32, u8 *, void *), void *arg);
+
+/* Function for retrieving temperature data */
+extern enum efct_hw_rtn
+efct_hw_get_temperature(struct efct_hw *hw,
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
+extern enum efct_hw_rtn
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
+extern enum efct_hw_rtn
+efct_hw_get_host_stats(struct efct_hw *hw,
+		       u8 cc,
+		void (*efct_hw_host_stat_cb_t)(int status,
+					       u32 num_counters,
+			struct efct_hw_host_stat_counts *counters,
+			void *arg),
+		void *arg);
+
 
 #endif /* __EFCT_H__ */
-- 
2.13.7

