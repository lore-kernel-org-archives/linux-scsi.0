Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97448C2BBC7
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DAFB2073E
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:34:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PjCHkDK/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgDLDd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36765 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgDLDd7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id n10so2999298pff.3
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tQRdpDK1tz1Az9rzF1eDr8hqzHTosPNSycarvDbgh6U=;
        b=PjCHkDK/bNc3MT3ouF7LiV4bJOxmk9dZQ0DA4/wsC/0XT1jcYThqaq2FHIE8lwrsVO
         ODJj+Y1v8Dhe4V6ezjRs3VH9cV5tbZXqWoosyYxY52vMThAe/ldLJpeNbAXgA1CFxiqg
         8pL52cnl3tvDEuALFn6NXonffAkgPgn9FJIXHzKlt1w7dyRx3wUV2tQeaKjqIu4cNB4L
         qb3L2DXhBaYGg9wUfJRMgCp3la93eq71mruAUZRTtea0bk1c8VQm/VOKx+cc40kk9d6a
         oM4NnuFgHQzQrwk83vssbHceSaBa6xmxPYKgzEFTft+9UB1BKMqqnqf1RrKPUaSOzlFR
         +Amg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tQRdpDK1tz1Az9rzF1eDr8hqzHTosPNSycarvDbgh6U=;
        b=A9HDmNgDmwDVqCgFFuPig5goELlmujMW8a7zTsulnhbc6VKtESnUg2/PDCkTPgWATD
         MnwSCos9sFAd3BraD4rnTctUVhjLvP9ZxE3eu7GpBgKmzjlRnVpXNNaCyZ1TMjNWZijl
         n89dTDC5lwLNWWsrsLiJYZCBFUdwlBgCXWDyBadjiPwFXJ+NWOOFFd7oCULAI7B9vgoW
         67tgFVAEIwLdy1pNITMWYrO4kNcxmDOwG8GO6wsY5VYUWv+SXsU3dRPxi6ttSANq9SQQ
         FSu7jkFPBE7+CRV5gr64sT/eqQ/WkNdN8dxDKKusb7pLDz+guuCjdzI1WGQsuu2N+/DP
         AO+w==
X-Gm-Message-State: AGi0PuayAH8Z0fbcC7XjMQJXrXx75a1dCLD8zCho6OOCUykjysCZ3b/v
        YJfKsz0pQ8tBQ72Uq7B/SjiyqX9s
X-Google-Smtp-Source: APiQypLCQ6oH/cR4nY7wuI1+H5b799kg9LlimEWACEX4/AXynT5zwiA4JBMrQk0iHsc5V5mL6eW7zA==
X-Received: by 2002:a63:1d4a:: with SMTP id d10mr8455661pgm.188.1586662435715;
        Sat, 11 Apr 2020 20:33:55 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:55 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 26/31] elx: efct: link statistics and SFP data
Date:   Sat, 11 Apr 2020 20:32:58 -0700
Message-Id: <20200412033303.29574-27-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200412033303.29574-1-jsmart2021@gmail.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to retrieve link stats and SFP transceiver data.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/elx/efct/efct_hw.c | 468 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  39 ++++
 2 files changed, 507 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 26dd9bd1eeef..ca2fd237c7d6 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -8,6 +8,40 @@
 #include "efct_hw.h"
 #include "efct_unsol.h"
 
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
 static enum efct_hw_rtn
 efct_hw_link_event_init(struct efct_hw *hw)
 {
@@ -3035,3 +3069,437 @@ efct_hw_io_get_count(struct efct_hw *hw,
 
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
+	return EFC_SUCCESS;
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
+	return EFC_SUCCESS;
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
+	return EFC_SUCCESS;
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
+	return EFC_SUCCESS;
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
index 36a832f32616..0b6838c7f924 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -733,4 +733,43 @@ efct_hw_srrs_send(struct efct_hw *hw, enum efct_hw_io_type type,
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
2.16.4

