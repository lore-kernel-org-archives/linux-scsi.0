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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1776CC2D0D3
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C11B92082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FO1s9Zag"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfLTWhk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:40 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33360 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbfLTWhk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:40 -0500
Received: by mail-pl1-f195.google.com with SMTP id c13so4720694pls.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e2ioJpDPtS521cIds3bLp/Mm20EudCe9sMuJy89jZRw=;
        b=FO1s9Zagh6Q4qYllM6RHwsd6AOz0oO5iVfcG6ChRzVNr2p1+JOlPuVWWxFhM4X8Vte
         Sd4BDBabq/VFX4CdNKlCybvCPsxTW3gu1/vOPuvnvxzlJXhEzHOGhcXwc4ZzHz+HqojG
         qSNIxFWo8R7tott1hjNz6zmL99Xe2Xs10TWDhvfkAOUudicPNx+9Dk26FEwx/wZuw7MC
         kVEX9iULVyZpyDj2Bcgd8ven0sxx6ubhL9pEedqKzCx7EAoqiikasF0Bb1ckNuDyKNJM
         6gnVZ7xFDMO3Uf0cYdJSUyE6UHqqgN+0l2DMbV2pPUkxyih1VrJz66XT3ZuxeMefDNYS
         JR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e2ioJpDPtS521cIds3bLp/Mm20EudCe9sMuJy89jZRw=;
        b=I9O2rq9noBKn3zqCvVoYcjUjHZnmJp5BffAocmBZGbOtClkWxFnm8GnfK0VUs3MYmy
         5MJ7rjQW3RU8YY9TCn6M6/nc1ccSbfA54WTRX/Ulde4Y+Ou5zqesKnrJw/G7RYDRzBm1
         2uycsi6QfQSAvTB0C4kzp85YVk4G+9gGG5CDNoh+LTqeThZZkJ84oBDCE/tZz0MZBSoJ
         a70JXuNiElyBeLnWcMGyKo+Btqab+8X48JoHPFWk+5OF20MYhdIGqyWfF6fkG2otE9ax
         LKuPxAYg28cQUVBa8mGMNRyE6RRifOm9kBc2fCgpNe4hgjpHN8NPWSzA5FNxYbvxEmrY
         m/Nw==
X-Gm-Message-State: APjAAAXfnjdGet2GSiFGmCtncIVcWHHNsCCkrT+a5vxhUmDCnLmJO49U
        2YBrQgaFK5D6/H3IRd4bJitWji1a
X-Google-Smtp-Source: APXvYqyC4FQm8CL05hwqU+6dPFcRwGwNipTEjU1Is4otEpiC7/4qmh3LnwIjz915Uqb1K3ybAF5wyg==
X-Received: by 2002:a17:902:d885:: with SMTP id b5mr2386027plz.156.1576881458155;
        Fri, 20 Dec 2019 14:37:38 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:37 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 06/32] elx: libefc_sli: bmbx routines and SLI config commands
Date:   Fri, 20 Dec 2019 14:36:57 -0800
Message-Id: <20191220223723.26563-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc_sli SLI-4 library population.

This patch adds routines to create mailbox commands used during
adapter initialization and adds APIs to issue mailbox commands to the
adapter through the bootstrap mailbox register.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc_sli/sli4.c | 1229 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/elx/libefc_sli/sli4.h |    2 +
 2 files changed, 1230 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 2ebe0235bc9e..3cdabb917df6 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -942,7 +942,6 @@ static int sli_cmd_cq_set_create(struct sli4 *sli4,
 	u16 dw6w1_flags = 0;
 	__le32 req_len;
 
-
 	n_cqe = qs[0]->dma.size / SLI4_CQE_BYTES;
 	switch (n_cqe) {
 	case 256:
@@ -3297,3 +3296,1231 @@ sli_fc_rqe_rqid_and_index(struct sli4 *sli4, u8 *cqe,
 
 	return rc;
 }
+
+/* Wait for the bootstrap mailbox to report "ready" */
+static int
+sli_bmbx_wait(struct sli4 *sli4, u32 msec)
+{
+	u32 val = 0;
+
+	do {
+		mdelay(1);	/* 1 ms */
+		val = readl(sli4->reg[0] + SLI4_BMBX_REG);
+		msec--;
+	} while (msec && !(val & SLI4_BMBX_RDY));
+
+	val = (!(val & SLI4_BMBX_RDY));
+	return val;
+}
+
+/* Write bootstrap mailbox */
+static int
+sli_bmbx_write(struct sli4 *sli4)
+{
+	u32 val = 0;
+
+	/* write buffer location to bootstrap mailbox register */
+	val = SLI4_BMBX_WRITE_HI(sli4->bmbx.phys);
+	writel(val, (sli4->reg[0] + SLI4_BMBX_REG));
+
+	if (sli_bmbx_wait(sli4, SLI4_BMBX_DELAY_US)) {
+		efc_log_crit(sli4, "BMBX WRITE_HI failed\n");
+		return -1;
+	}
+	val = SLI4_BMBX_WRITE_LO(sli4->bmbx.phys);
+	writel(val, (sli4->reg[0] + SLI4_BMBX_REG));
+
+	/* wait for SLI Port to set ready bit */
+	return sli_bmbx_wait(sli4, SLI4_BMBX_TIMEOUT_MSEC);
+}
+
+/* Submit a command to the bootstrap mailbox and check the status */
+int
+sli_bmbx_command(struct sli4 *sli4)
+{
+	void *cqe = (u8 *)sli4->bmbx.virt + SLI4_BMBX_SIZE;
+
+	if (sli_fw_error_status(sli4) > 0) {
+		efc_log_crit(sli4, "Chip is in an error state -Mailbox command rejected");
+		efc_log_crit(sli4, " status=%#x error1=%#x error2=%#x\n",
+			sli_reg_read_status(sli4),
+			sli_reg_read_err1(sli4),
+			sli_reg_read_err2(sli4));
+		return -1;
+	}
+
+	if (sli_bmbx_write(sli4)) {
+		efc_log_crit(sli4, "bootstrap mailbox write fail phys=%p reg=%#x\n",
+			(void *)sli4->bmbx.phys,
+			readl(sli4->reg[0] + SLI4_BMBX_REG));
+		return -1;
+	}
+
+	/* check completion queue entry status */
+	if (le32_to_cpu(((struct sli4_mcqe *)cqe)->dw3_flags) &
+	    SLI4_MCQE_VALID) {
+		return sli_cqe_mq(sli4, cqe);
+	}
+	efc_log_crit(sli4, "invalid or wrong type\n");
+	return -1;
+}
+
+/* Write a CONFIG_LINK command to the provided buffer */
+int
+sli_cmd_config_link(struct sli4 *sli4, void *buf, size_t size)
+{
+	struct sli4_cmd_config_link *config_link = buf;
+
+	memset(buf, 0, size);
+
+	config_link->hdr.command = MBX_CMD_CONFIG_LINK;
+
+	/* Port interprets zero in a field as "use default value" */
+
+	return EFC_SUCCESS;
+}
+
+/* Write a DOWN_LINK command to the provided buffer */
+int
+sli_cmd_down_link(struct sli4 *sli4, void *buf, size_t size)
+{
+	struct sli4_mbox_command_header *hdr = buf;
+
+	memset(buf, 0, size);
+
+	hdr->command = MBX_CMD_DOWN_LINK;
+
+	/* Port interprets zero in a field as "use default value" */
+
+	return EFC_SUCCESS;
+}
+
+/* Write a DUMP Type 4 command to the provided buffer */
+int
+sli_cmd_dump_type4(struct sli4 *sli4, void *buf,
+		   size_t size, u16 wki)
+{
+	struct sli4_cmd_dump4 *cmd = buf;
+
+	memset(buf, 0, size);
+
+	cmd->hdr.command = MBX_CMD_DUMP;
+	cmd->type_dword = cpu_to_le32(0x4);
+	cmd->wki_selection = cpu_to_le16(wki);
+	return EFC_SUCCESS;
+}
+
+/* Write a COMMON_READ_TRANSCEIVER_DATA command */
+int
+sli_cmd_common_read_transceiver_data(struct sli4 *sli4, void *buf,
+				     size_t size, u32 page_num,
+				     struct efc_dma *dma)
+{
+	struct sli4_rqst_cmn_read_transceiver_data *req = NULL;
+	u32 psize;
+
+	if (!dma)
+		psize = SLI_CONFIG_PYLD_LENGTH(cmn_read_transceiver_data);
+	else
+		psize = dma->size;
+
+	req = sli_config_cmd_init(sli4, buf, size,
+					    psize, dma);
+	if (!req)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&req->hdr, CMN_READ_TRANS_DATA, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V0, CFG_RQST_PYLD_LEN(cmn_read_transceiver_data));
+
+	req->page_number = cpu_to_le32(page_num);
+	req->port = cpu_to_le32(sli4->port_number);
+
+	return EFC_SUCCESS;
+}
+
+/* Write a READ_LINK_STAT command to the provided buffer */
+int
+sli_cmd_read_link_stats(struct sli4 *sli4, void *buf, size_t size,
+			u8 req_ext_counters,
+			u8 clear_overflow_flags,
+			u8 clear_all_counters)
+{
+	struct sli4_cmd_read_link_stats *cmd = buf;
+	u32 flags;
+
+	memset(buf, 0, size);
+
+	cmd->hdr.command = MBX_CMD_READ_LNK_STAT;
+
+	flags = 0;
+	if (req_ext_counters)
+		flags |= SLI4_READ_LNKSTAT_REC;
+	if (clear_all_counters)
+		flags |= SLI4_READ_LNKSTAT_CLRC;
+	if (clear_overflow_flags)
+		flags |= SLI4_READ_LNKSTAT_CLOF;
+
+	cmd->dw1_flags = cpu_to_le32(flags);
+	return EFC_SUCCESS;
+}
+
+/* Write a READ_STATUS command to the provided buffer */
+int
+sli_cmd_read_status(struct sli4 *sli4, void *buf, size_t size,
+		    u8 clear_counters)
+{
+	struct sli4_cmd_read_status *cmd = buf;
+	u32 flags = 0;
+
+	memset(buf, 0, size);
+
+	cmd->hdr.command = MBX_CMD_READ_STATUS;
+	if (clear_counters)
+		flags |= SLI4_READSTATUS_CLEAR_COUNTERS;
+	else
+		flags &= ~SLI4_READSTATUS_CLEAR_COUNTERS;
+
+	cmd->dw1_flags = cpu_to_le32(flags);
+	return EFC_SUCCESS;
+}
+
+/* Write an INIT_LINK command to the provided buffer */
+int
+sli_cmd_init_link(struct sli4 *sli4, void *buf, size_t size,
+		  u32 speed, u8 reset_alpa)
+{
+	struct sli4_cmd_init_link *init_link = buf;
+	u32 flags = 0;
+
+	memset(buf, 0, size);
+
+	init_link->hdr.command = MBX_CMD_INIT_LINK;
+
+	init_link->sel_reset_al_pa_dword =
+				cpu_to_le32(reset_alpa);
+	flags &= ~SLI4_INIT_LINK_FLAG_LOOPBACK;
+
+	init_link->link_speed_sel_code = cpu_to_le32(speed);
+	switch (speed) {
+	case FC_LINK_SPEED_1G:
+	case FC_LINK_SPEED_2G:
+	case FC_LINK_SPEED_4G:
+	case FC_LINK_SPEED_8G:
+	case FC_LINK_SPEED_16G:
+	case FC_LINK_SPEED_32G:
+		flags |= SLI4_INIT_LINK_FLAG_FIXED_SPEED;
+		break;
+	case FC_LINK_SPEED_10G:
+		efc_log_info(sli4, "unsupported FC speed %d\n", speed);
+		init_link->flags0 = cpu_to_le32(flags);
+		return EFC_FAIL;
+	}
+
+	switch (sli4->topology) {
+	case SLI4_READ_CFG_TOPO_FC:
+		/* Attempt P2P but failover to FC-AL */
+		flags |= SLI4_INIT_LINK_FLAG_EN_TOPO_FAILOVER;
+
+		flags &= ~SLI4_INIT_LINK_FLAG_TOPOLOGY;
+		flags |= (SLI4_INIT_LINK_F_P2P_FAIL_OVER << 1);
+		break;
+	case SLI4_READ_CFG_TOPO_FC_AL:
+		flags &= ~SLI4_INIT_LINK_FLAG_TOPOLOGY;
+		flags |= (SLI4_INIT_LINK_F_FCAL_ONLY << 1);
+		if (speed == FC_LINK_SPEED_16G ||
+		    speed == FC_LINK_SPEED_32G) {
+			efc_log_info(sli4, "unsupported FC-AL speed %d\n",
+				speed);
+			init_link->flags0 = cpu_to_le32(flags);
+			return EFC_FAIL;
+		}
+		break;
+	case SLI4_READ_CFG_TOPO_FC_DA:
+		flags &= ~SLI4_INIT_LINK_FLAG_TOPOLOGY;
+		flags |= (FC_TOPOLOGY_P2P << 1);
+		break;
+	default:
+
+		efc_log_info(sli4, "unsupported topology %#x\n",
+			sli4->topology);
+
+		init_link->flags0 = cpu_to_le32(flags);
+		return EFC_FAIL;
+	}
+
+	flags &= (~SLI4_INIT_LINK_FLAG_UNFAIR);
+	flags &= (~SLI4_INIT_LINK_FLAG_SKIP_LIRP_LILP);
+	flags &= (~SLI4_INIT_LINK_FLAG_LOOP_VALIDITY);
+	flags &= (~SLI4_INIT_LINK_FLAG_SKIP_LISA);
+	flags &= (~SLI4_INIT_LINK_FLAG_SEL_HIGHTEST_AL_PA);
+	init_link->flags0 = cpu_to_le32(flags);
+
+	return EFC_SUCCESS;
+}
+
+/* Write an INIT_VFI command to the provided buffer */
+int
+sli_cmd_init_vfi(struct sli4 *sli4, void *buf, size_t size,
+		 u16 vfi, u16 fcfi, u16 vpi)
+{
+	struct sli4_cmd_init_vfi *init_vfi = buf;
+	u16 flags = 0;
+
+	memset(buf, 0, size);
+
+	init_vfi->hdr.command = MBX_CMD_INIT_VFI;
+
+	init_vfi->vfi = cpu_to_le16(vfi);
+	init_vfi->fcfi = cpu_to_le16(fcfi);
+
+	/*
+	 * If the VPI is valid, initialize it at the same time as
+	 * the VFI
+	 */
+	if (vpi != U16_MAX) {
+		flags |= SLI4_INIT_VFI_FLAG_VP;
+		init_vfi->flags0_word = cpu_to_le16(flags);
+		init_vfi->vpi = cpu_to_le16(vpi);
+	}
+
+	return EFC_SUCCESS;
+}
+
+/* Write an INIT_VPI command to the provided buffer */
+int
+sli_cmd_init_vpi(struct sli4 *sli4, void *buf, size_t size,
+		 u16 vpi, u16 vfi)
+{
+	struct sli4_cmd_init_vpi *init_vpi = buf;
+
+	memset(buf, 0, size);
+
+	init_vpi->hdr.command = MBX_CMD_INIT_VPI;
+	init_vpi->vpi = cpu_to_le16(vpi);
+	init_vpi->vfi = cpu_to_le16(vfi);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_post_xri(struct sli4 *sli4, void *buf, size_t size,
+		 u16 xri_base, u16 xri_count)
+{
+	struct sli4_cmd_post_xri *post_xri = buf;
+	u16 xri_count_flags = 0;
+
+	memset(buf, 0, size);
+
+	post_xri->hdr.command = MBX_CMD_POST_XRI;
+	post_xri->xri_base = cpu_to_le16(xri_base);
+	xri_count_flags = (xri_count & SLI4_POST_XRI_COUNT);
+	xri_count_flags |= SLI4_POST_XRI_FLAG_ENX;
+	xri_count_flags |= SLI4_POST_XRI_FLAG_VAL;
+	post_xri->xri_count_flags = cpu_to_le16(xri_count_flags);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_release_xri(struct sli4 *sli4, void *buf, size_t size,
+		    u8 num_xri)
+{
+	struct sli4_cmd_release_xri *release_xri = buf;
+
+	memset(buf, 0, size);
+
+	release_xri->hdr.command = MBX_CMD_RELEASE_XRI;
+	release_xri->xri_count_word = cpu_to_le16(num_xri &
+					SLI4_RELEASE_XRI_COUNT);
+
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_read_config(struct sli4 *sli4, void *buf, size_t size)
+{
+	struct sli4_cmd_read_config *read_config = buf;
+
+	memset(buf, 0, size);
+
+	read_config->hdr.command = MBX_CMD_READ_CONFIG;
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_read_nvparms(struct sli4 *sli4, void *buf, size_t size)
+{
+	struct sli4_cmd_read_nvparms *read_nvparms = buf;
+
+	memset(buf, 0, size);
+
+	read_nvparms->hdr.command = MBX_CMD_READ_NVPARMS;
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_write_nvparms(struct sli4 *sli4, void *buf, size_t size,
+		      u8 *wwpn, u8 *wwnn, u8 hard_alpa,
+		u32 preferred_d_id)
+{
+	struct sli4_cmd_write_nvparms *write_nvparms = buf;
+
+	memset(buf, 0, size);
+
+	write_nvparms->hdr.command = MBX_CMD_WRITE_NVPARMS;
+	memcpy(write_nvparms->wwpn, wwpn, 8);
+	memcpy(write_nvparms->wwnn, wwnn, 8);
+
+	write_nvparms->hard_alpa_d_id =
+			cpu_to_le32((preferred_d_id << 8) | hard_alpa);
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_read_rev(struct sli4 *sli4, void *buf, size_t size,
+		 struct efc_dma *vpd)
+{
+	struct sli4_cmd_read_rev *read_rev = buf;
+
+	memset(buf, 0, size);
+
+	read_rev->hdr.command = MBX_CMD_READ_REV;
+
+	if (vpd && vpd->size) {
+		read_rev->flags0_word |= cpu_to_le16(SLI4_READ_REV_FLAG_VPD);
+
+		read_rev->available_length_dword =
+			cpu_to_le32(vpd->size &
+				    SLI4_READ_REV_AVAILABLE_LENGTH);
+
+		read_rev->hostbuf.low =
+				cpu_to_le32(lower_32_bits(vpd->phys));
+		read_rev->hostbuf.high =
+				cpu_to_le32(upper_32_bits(vpd->phys));
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_read_sparm64(struct sli4 *sli4, void *buf, size_t size,
+		     struct efc_dma *dma,
+		     u16 vpi)
+{
+	struct sli4_cmd_read_sparm64 *read_sparm64 = buf;
+
+	memset(buf, 0, size);
+
+	if (vpi == SLI4_READ_SPARM64_VPI_SPECIAL) {
+		efc_log_info(sli4, "special VPI not supported!!!\n");
+		return -1;
+	}
+
+	if (!dma || !dma->phys) {
+		efc_log_info(sli4, "bad DMA buffer\n");
+		return -1;
+	}
+
+	read_sparm64->hdr.command = MBX_CMD_READ_SPARM64;
+
+	read_sparm64->bde_64.bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				    (dma->size & SLI4_BDE_MASK_BUFFER_LEN));
+	read_sparm64->bde_64.u.data.low =
+			cpu_to_le32(lower_32_bits(dma->phys));
+	read_sparm64->bde_64.u.data.high =
+			cpu_to_le32(upper_32_bits(dma->phys));
+
+	read_sparm64->vpi = cpu_to_le16(vpi);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_read_topology(struct sli4 *sli4, void *buf, size_t size,
+		      struct efc_dma *dma)
+{
+	struct sli4_cmd_read_topology *read_topo = buf;
+
+	memset(buf, 0, size);
+
+	read_topo->hdr.command = MBX_CMD_READ_TOPOLOGY;
+
+	if (dma && dma->size) {
+		if (dma->size < SLI4_MIN_LOOP_MAP_BYTES) {
+			efc_log_info(sli4, "loop map buffer too small %jd\n",
+				dma->size);
+			return 0;
+		}
+
+		memset(dma->virt, 0, dma->size);
+
+		read_topo->bde_loop_map.bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				    (dma->size & SLI4_BDE_MASK_BUFFER_LEN));
+		read_topo->bde_loop_map.u.data.low  =
+			cpu_to_le32(lower_32_bits(dma->phys));
+		read_topo->bde_loop_map.u.data.high =
+			cpu_to_le32(upper_32_bits(dma->phys));
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_reg_fcfi(struct sli4 *sli4, void *buf, size_t size,
+		 u16 index,
+		 struct sli4_cmd_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG])
+{
+	struct sli4_cmd_reg_fcfi *reg_fcfi = buf;
+	u32 i;
+
+	memset(buf, 0, size);
+
+	reg_fcfi->hdr.command = MBX_CMD_REG_FCFI;
+
+	reg_fcfi->fcf_index = cpu_to_le16(index);
+
+	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
+		switch (i) {
+		case 0:
+			reg_fcfi->rqid0 = rq_cfg[0].rq_id;
+			break;
+		case 1:
+			reg_fcfi->rqid1 = rq_cfg[1].rq_id;
+			break;
+		case 2:
+			reg_fcfi->rqid2 = rq_cfg[2].rq_id;
+			break;
+		case 3:
+			reg_fcfi->rqid3 = rq_cfg[3].rq_id;
+			break;
+		}
+		reg_fcfi->rq_cfg[i].r_ctl_mask = rq_cfg[i].r_ctl_mask;
+		reg_fcfi->rq_cfg[i].r_ctl_match = rq_cfg[i].r_ctl_match;
+		reg_fcfi->rq_cfg[i].type_mask = rq_cfg[i].type_mask;
+		reg_fcfi->rq_cfg[i].type_match = rq_cfg[i].type_match;
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_reg_fcfi_mrq(struct sli4 *sli4, void *buf, size_t size,
+		     u8 mode, u16 fcf_index,
+		     u8 rq_selection_policy, u8 mrq_bit_mask,
+		     u16 num_mrqs,
+		struct sli4_cmd_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG])
+{
+	struct sli4_cmd_reg_fcfi_mrq *reg_fcfi_mrq = buf;
+	u32 i;
+	u32 mrq_flags = 0;
+
+	memset(buf, 0, size);
+
+	reg_fcfi_mrq->hdr.command = MBX_CMD_REG_FCFI_MRQ;
+	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE) {
+		reg_fcfi_mrq->fcf_index = cpu_to_le16(fcf_index);
+		goto done;
+	}
+
+	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
+		reg_fcfi_mrq->rq_cfg[i].r_ctl_mask = rq_cfg[i].r_ctl_mask;
+		reg_fcfi_mrq->rq_cfg[i].r_ctl_match = rq_cfg[i].r_ctl_match;
+		reg_fcfi_mrq->rq_cfg[i].type_mask = rq_cfg[i].type_mask;
+		reg_fcfi_mrq->rq_cfg[i].type_match = rq_cfg[i].type_match;
+
+		switch (i) {
+		case 3:
+			reg_fcfi_mrq->rqid3 = rq_cfg[i].rq_id;
+			break;
+		case 2:
+			reg_fcfi_mrq->rqid2 = rq_cfg[i].rq_id;
+			break;
+		case 1:
+			reg_fcfi_mrq->rqid1 = rq_cfg[i].rq_id;
+			break;
+		case 0:
+			reg_fcfi_mrq->rqid0 = rq_cfg[i].rq_id;
+			break;
+		}
+	}
+
+	mrq_flags = num_mrqs & SLI4_REGFCFI_MRQ_MASK_NUM_PAIRS;
+	mrq_flags |= (mrq_bit_mask << 8);
+	mrq_flags |= (rq_selection_policy << 12);
+	reg_fcfi_mrq->dw9_mrqflags = cpu_to_le32(mrq_flags);
+done:
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_reg_rpi(struct sli4 *sli4, void *buf, size_t size,
+		u32 nport_id, u16 rpi, u16 vpi,
+		struct efc_dma *dma, u8 update,
+		u8 enable_t10_pi)
+{
+	struct sli4_cmd_reg_rpi *reg_rpi = buf;
+	u32 rportid_flags = 0;
+
+	memset(buf, 0, size);
+
+	reg_rpi->hdr.command = MBX_CMD_REG_RPI;
+
+	reg_rpi->rpi = cpu_to_le16(rpi);
+
+	rportid_flags = nport_id & SLI4_REGRPI_REMOTE_N_PORTID;
+
+	if (update)
+		rportid_flags |= SLI4_REGRPI_UPD;
+	else
+		rportid_flags &= ~SLI4_REGRPI_UPD;
+
+	if (enable_t10_pi)
+		rportid_flags |= SLI4_REGRPI_ETOW;
+	else
+		rportid_flags &= ~SLI4_REGRPI_ETOW;
+
+	reg_rpi->dw2_rportid_flags = cpu_to_le32(rportid_flags);
+
+	reg_rpi->bde_64.bde_type_buflen =
+		cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			    (SLI4_REG_RPI_BUF_LEN & SLI4_BDE_MASK_BUFFER_LEN));
+	reg_rpi->bde_64.u.data.low  =
+		cpu_to_le32(lower_32_bits(dma->phys));
+	reg_rpi->bde_64.u.data.high =
+		cpu_to_le32(upper_32_bits(dma->phys));
+
+	reg_rpi->vpi = cpu_to_le16(vpi);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_reg_vfi(struct sli4 *sli4, void *buf, size_t size,
+		u16 vfi, u16 fcfi, struct efc_dma dma,
+		u16 vpi, __be64 sli_wwpn, u32 fc_id)
+{
+	struct sli4_cmd_reg_vfi *reg_vfi = buf;
+
+	if (!sli4 || !buf)
+		return 0;
+
+	memset(buf, 0, size);
+
+	reg_vfi->hdr.command = MBX_CMD_REG_VFI;
+
+	reg_vfi->vfi = cpu_to_le16(vfi);
+
+	reg_vfi->fcfi = cpu_to_le16(fcfi);
+
+	reg_vfi->sparm.bde_type_buflen =
+		cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			    (SLI4_REG_RPI_BUF_LEN & SLI4_BDE_MASK_BUFFER_LEN));
+	reg_vfi->sparm.u.data.low  =
+		cpu_to_le32(lower_32_bits(dma.phys));
+	reg_vfi->sparm.u.data.high =
+		cpu_to_le32(upper_32_bits(dma.phys));
+
+	reg_vfi->e_d_tov = cpu_to_le32(sli4->e_d_tov);
+	reg_vfi->r_a_tov = cpu_to_le32(sli4->r_a_tov);
+
+	reg_vfi->dw0w1_flags |= cpu_to_le16(SLI4_REGVFI_VP);
+	reg_vfi->vpi = cpu_to_le16(vpi);
+	memcpy(reg_vfi->wwpn, &sli_wwpn, sizeof(reg_vfi->wwpn));
+	reg_vfi->dw10_lportid_flags = cpu_to_le32(fc_id);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_reg_vpi(struct sli4 *sli4, void *buf, size_t size,
+		u32 fc_id, __be64 sli_wwpn, u16 vpi, u16 vfi,
+		bool update)
+{
+	struct sli4_cmd_reg_vpi *reg_vpi = buf;
+	u32 flags = 0;
+
+	if (!sli4 || !buf)
+		return 0;
+
+	memset(buf, 0, size);
+
+	reg_vpi->hdr.command = MBX_CMD_REG_VPI;
+
+	flags = (fc_id & SLI4_REGVPI_LOCAL_N_PORTID);
+	if (update)
+		flags |= SLI4_REGVPI_UPD;
+	else
+		flags &= ~SLI4_REGVPI_UPD;
+
+	reg_vpi->dw2_lportid_flags = cpu_to_le32(flags);
+	memcpy(reg_vpi->wwpn, &sli_wwpn, sizeof(reg_vpi->wwpn));
+	reg_vpi->vpi = cpu_to_le16(vpi);
+	reg_vpi->vfi = cpu_to_le16(vfi);
+
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_request_features(struct sli4 *sli4, void *buf, size_t size,
+			 u32 features_mask, bool query)
+{
+	struct sli4_cmd_request_features *req_features = buf;
+
+	memset(buf, 0, size);
+
+	req_features->hdr.command = MBX_CMD_RQST_FEATURES;
+
+	if (query)
+		req_features->dw1_qry = cpu_to_le32(SLI4_REQFEAT_QRY);
+
+	req_features->cmd = cpu_to_le32(features_mask);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_unreg_fcfi(struct sli4 *sli4, void *buf, size_t size,
+		   u16 indicator)
+{
+	struct sli4_cmd_unreg_fcfi *unreg_fcfi = buf;
+
+	if (!sli4 || !buf)
+		return 0;
+
+	memset(buf, 0, size);
+
+	unreg_fcfi->hdr.command = MBX_CMD_UNREG_FCFI;
+
+	unreg_fcfi->fcfi = cpu_to_le16(indicator);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_unreg_rpi(struct sli4 *sli4, void *buf, size_t size,
+		  u16 indicator,
+		  enum sli4_resource which, u32 fc_id)
+{
+	struct sli4_cmd_unreg_rpi *unreg_rpi = buf;
+	u32 flags = 0;
+
+	memset(buf, 0, size);
+
+	unreg_rpi->hdr.command = MBX_CMD_UNREG_RPI;
+
+	switch (which) {
+	case SLI_RSRC_RPI:
+		flags |= UNREG_RPI_II_RPI;
+		if (fc_id == U32_MAX)
+			break;
+
+		flags |= UNREG_RPI_DP;
+		unreg_rpi->dw2_dest_n_portid =
+			cpu_to_le32(fc_id & UNREG_RPI_DEST_N_PORTID_MASK);
+		break;
+	case SLI_RSRC_VPI:
+		flags |= UNREG_RPI_II_VPI;
+		break;
+	case SLI_RSRC_VFI:
+		flags |= UNREG_RPI_II_VFI;
+		break;
+	case SLI_RSRC_FCFI:
+		flags |= UNREG_RPI_II_FCFI;
+		break;
+	default:
+		efc_log_info(sli4, "unknown type %#x\n", which);
+		return EFC_FAIL;
+	}
+
+	unreg_rpi->dw1w1_flags = cpu_to_le16(flags);
+	unreg_rpi->index = cpu_to_le16(indicator);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_unreg_vfi(struct sli4 *sli4, void *buf, size_t size,
+		  u16 index, u32 which)
+{
+	struct sli4_cmd_unreg_vfi *unreg_vfi = buf;
+
+	memset(buf, 0, size);
+
+	unreg_vfi->hdr.command = MBX_CMD_UNREG_VFI;
+	switch (which) {
+	case SLI4_UNREG_TYPE_DOMAIN:
+		unreg_vfi->index = cpu_to_le16(index);
+		break;
+	case SLI4_UNREG_TYPE_FCF:
+		unreg_vfi->index = cpu_to_le16(index);
+		break;
+	case SLI4_UNREG_TYPE_ALL:
+		unreg_vfi->index = cpu_to_le16(U32_MAX);
+		break;
+	default:
+		return 0;
+	}
+
+	if (which != SLI4_UNREG_TYPE_DOMAIN)
+		unreg_vfi->dw2_flags =
+			cpu_to_le16(UNREG_VFI_II_FCFI);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_unreg_vpi(struct sli4 *sli4, void *buf, size_t size,
+		  u16 indicator, u32 which)
+{
+	struct sli4_cmd_unreg_vpi *unreg_vpi = buf;
+	u32 flags = 0;
+
+	memset(buf, 0, size);
+
+	unreg_vpi->hdr.command = MBX_CMD_UNREG_VPI;
+	unreg_vpi->index = cpu_to_le16(indicator);
+	switch (which) {
+	case SLI4_UNREG_TYPE_PORT:
+		flags |= UNREG_VPI_II_VPI;
+		break;
+	case SLI4_UNREG_TYPE_DOMAIN:
+		flags |= UNREG_VPI_II_VFI;
+		break;
+	case SLI4_UNREG_TYPE_FCF:
+		flags |= UNREG_VPI_II_FCFI;
+		break;
+	case SLI4_UNREG_TYPE_ALL:
+		/* override indicator */
+		unreg_vpi->index = cpu_to_le16(U32_MAX);
+		flags |= UNREG_VPI_II_FCFI;
+		break;
+	default:
+		return EFC_FAIL;
+	}
+
+	unreg_vpi->dw2w0_flags = cpu_to_le16(flags);
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_common_modify_eq_delay(struct sli4 *sli4, void *buf, size_t size,
+			       struct sli4_queue *q, int num_q, u32 shift,
+			       u32 delay_mult)
+{
+	struct sli4_rqst_cmn_modify_eq_delay *req = NULL;
+	int i;
+
+	req = sli_config_cmd_init(sli4, buf, size,
+				SLI_CONFIG_PYLD_LENGTH(cmn_modify_eq_delay),
+				NULL);
+	if (!req)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&req->hdr, CMN_MODIFY_EQ_DELAY, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V0, CFG_RQST_PYLD_LEN(cmn_modify_eq_delay));
+	req->num_eq = cpu_to_le32(num_q);
+
+	for (i = 0; i < num_q; i++) {
+		req->eq_delay_record[i].eq_id = cpu_to_le32(q[i].id);
+		req->eq_delay_record[i].phase = cpu_to_le32(shift);
+		req->eq_delay_record[i].delay_multiplier =
+			cpu_to_le32(delay_mult);
+	}
+
+	return EFC_SUCCESS;
+}
+
+void
+sli4_cmd_lowlevel_set_watchdog(struct sli4 *sli4, void *buf,
+			       size_t size, u16 timeout)
+{
+	struct sli4_rqst_lowlevel_set_watchdog *req = NULL;
+
+	req = sli_config_cmd_init(sli4, buf, size,
+			SLI_CONFIG_PYLD_LENGTH(lowlevel_set_watchdog),
+			NULL);
+	if (!req)
+		return;
+
+	sli_cmd_fill_hdr(&req->hdr, SLI4_OPC_LOWLEVEL_SET_WATCHDOG,
+			 SLI4_SUBSYSTEM_LOWLEVEL, CMD_V0,
+			 CFG_RQST_PYLD_LEN(lowlevel_set_watchdog));
+	req->watchdog_timeout = cpu_to_le16(timeout);
+}
+
+static int
+sli_cmd_common_get_cntl_attributes(struct sli4 *sli4, void *buf, size_t size,
+				   struct efc_dma *dma)
+{
+	struct sli4_rqst_hdr *hdr = NULL;
+
+	hdr = sli_config_cmd_init(sli4, buf, size, CFG_RQST_CMDSZ(hdr), dma);
+	if (!hdr)
+		return EFC_FAIL;
+
+	hdr->opcode = CMN_GET_CNTL_ATTRIBUTES;
+	hdr->subsystem = SLI4_SUBSYSTEM_COMMON;
+	hdr->request_length = cpu_to_le32(dma->size);
+
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_common_get_cntl_addl_attributes(struct sli4 *sli4, void *buf,
+					size_t size, struct efc_dma *dma)
+{
+	struct sli4_rqst_hdr *hdr = NULL;
+
+	hdr = sli_config_cmd_init(sli4, buf, size, CFG_RQST_CMDSZ(hdr), dma);
+	if (!hdr)
+		return EFC_FAIL;
+
+	hdr->opcode = CMN_GET_CNTL_ADDL_ATTRS;
+	hdr->subsystem = SLI4_SUBSYSTEM_COMMON;
+	hdr->request_length = cpu_to_le32(dma->size);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_common_nop(struct sli4 *sli4, void *buf,
+		   size_t size, uint64_t context)
+{
+	struct sli4_rqst_cmn_nop *nop = NULL;
+
+	nop = sli_config_cmd_init(sli4, buf, size,
+				  SLI_CONFIG_PYLD_LENGTH(cmn_nop), NULL);
+	if (!nop)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&nop->hdr, CMN_NOP, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V0, CFG_RQST_PYLD_LEN(cmn_nop));
+
+	memcpy(&nop->context, &context, sizeof(context));
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_common_get_resource_extent_info(struct sli4 *sli4, void *buf,
+					size_t size, u16 rtype)
+{
+	struct sli4_rqst_cmn_get_resource_extent_info *extent = NULL;
+
+	extent = sli_config_cmd_init(sli4, buf, size,
+			CFG_RQST_CMDSZ(cmn_get_resource_extent_info),
+				     NULL);
+	if (extent)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&extent->hdr, CMN_GET_RSC_EXTENT_INFO,
+			 SLI4_SUBSYSTEM_COMMON, CMD_V0,
+			 CFG_RQST_PYLD_LEN(cmn_get_resource_extent_info));
+
+	extent->resource_type = cpu_to_le16(rtype);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_common_get_sli4_parameters(struct sli4 *sli4, void *buf,
+				   size_t size)
+{
+	struct sli4_rqst_hdr *hdr = NULL;
+
+	hdr = sli_config_cmd_init(sli4, buf, size,
+				  SLI_CONFIG_PYLD_LENGTH(cmn_get_sli4_params),
+				  NULL);
+	if (!hdr)
+		return EFC_FAIL;
+
+	hdr->opcode = CMN_GET_SLI4_PARAMS;
+	hdr->subsystem = SLI4_SUBSYSTEM_COMMON;
+	hdr->request_length = CFG_RQST_PYLD_LEN(cmn_get_sli4_params);
+
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_common_get_port_name(struct sli4 *sli4, void *buf, size_t size)
+{
+	struct sli4_rqst_cmn_get_port_name *pname;
+
+	pname = sli_config_cmd_init(sli4, buf, size,
+				    SLI_CONFIG_PYLD_LENGTH(cmn_get_port_name),
+				    NULL);
+	if (!pname)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&pname->hdr, CMN_GET_PORT_NAME, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V1, CFG_RQST_PYLD_LEN(cmn_get_port_name));
+
+	/* Set the port type value (ethernet=0, FC=1) for V1 commands */
+	pname->port_type = PORT_TYPE_FC;
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_common_write_object(struct sli4 *sli4, void *buf, size_t size,
+			    u16 noc,
+			    u16 eof, u32 desired_write_length,
+			    u32 offset, char *object_name,
+			    struct efc_dma *dma)
+{
+	struct sli4_rqst_cmn_write_object *wr_obj = NULL;
+	struct sli4_bde *bde;
+	u32 dwflags = 0;
+
+	wr_obj = sli_config_cmd_init(sli4, buf, size,
+				     CFG_RQST_CMDSZ(cmn_write_object) +
+				     sizeof(*bde), NULL);
+	if (!wr_obj)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&wr_obj->hdr, CMN_WRITE_OBJECT, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V0,
+			 CFG_RQST_PYLD_LEN_VAR(cmn_write_object, sizeof(*bde)));
+
+	if (noc)
+		dwflags |= SLI4_RQ_DES_WRITE_LEN_NOC;
+	if (eof)
+		dwflags |= SLI4_RQ_DES_WRITE_LEN_EOF;
+	dwflags |= (desired_write_length & SLI4_RQ_DES_WRITE_LEN);
+
+	wr_obj->desired_write_len_dword = cpu_to_le32(dwflags);
+
+	wr_obj->write_offset = cpu_to_le32(offset);
+	strncpy(wr_obj->object_name, object_name,
+		sizeof(wr_obj->object_name));
+	wr_obj->host_buffer_descriptor_count = cpu_to_le32(1);
+
+	bde = (struct sli4_bde *)wr_obj->host_buffer_descriptor;
+
+	/* Setup to transfer xfer_size bytes to device */
+	bde->bde_type_buflen =
+		cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			    (desired_write_length & SLI4_BDE_MASK_BUFFER_LEN));
+	bde->u.data.low = cpu_to_le32(lower_32_bits(dma->phys));
+	bde->u.data.high = cpu_to_le32(upper_32_bits(dma->phys));
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_common_delete_object(struct sli4 *sli4, void *buf, size_t size,
+			     char *object_name)
+{
+	struct sli4_rqst_cmn_delete_object *req = NULL;
+
+	req = sli_config_cmd_init(sli4, buf, size,
+				  CFG_RQST_CMDSZ(cmn_delete_object), NULL);
+	if (!req)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&req->hdr, CMN_DELETE_OBJECT, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V0, CFG_RQST_PYLD_LEN(cmn_delete_object));
+
+	strncpy(req->object_name, object_name, sizeof(req->object_name));
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_common_read_object(struct sli4 *sli4, void *buf, size_t size,
+			   u32 desired_read_length, u32 offset,
+			   char *object_name, struct efc_dma *dma)
+{
+	struct sli4_rqst_cmn_read_object *rd_obj = NULL;
+	struct sli4_bde *bde;
+
+	rd_obj = sli_config_cmd_init(sli4, buf, size,
+				     CFG_RQST_CMDSZ(cmn_read_object) +
+				     sizeof(*bde), NULL);
+	if (!rd_obj)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&rd_obj->hdr, CMN_READ_OBJECT, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V0,
+			 CFG_RQST_PYLD_LEN_VAR(cmn_read_object, sizeof(*bde)));
+	rd_obj->desired_read_length_dword =
+		cpu_to_le32(desired_read_length & SLI4_REQ_DESIRE_READLEN);
+
+	rd_obj->read_offset = cpu_to_le32(offset);
+	strncpy(rd_obj->object_name, object_name,
+		sizeof(rd_obj->object_name));
+	rd_obj->host_buffer_descriptor_count = cpu_to_le32(1);
+
+	bde = (struct sli4_bde *)rd_obj->host_buffer_descriptor;
+
+	/* Setup to transfer xfer_size bytes to device */
+	bde->bde_type_buflen =
+		cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			    (desired_read_length & SLI4_BDE_MASK_BUFFER_LEN));
+	if (dma) {
+		bde->u.data.low = cpu_to_le32(lower_32_bits(dma->phys));
+		bde->u.data.high = cpu_to_le32(upper_32_bits(dma->phys));
+	} else {
+		bde->u.data.low = 0;
+		bde->u.data.high = 0;
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_dmtf_exec_clp_cmd(struct sli4 *sli4, void *buf, size_t size,
+			  struct efc_dma *cmd,
+			  struct efc_dma *resp)
+{
+	struct sli4_rqst_dmtf_exec_clp_cmd *clp_cmd = NULL;
+
+	clp_cmd = sli_config_cmd_init(sli4, buf, size,
+				      CFG_RQST_CMDSZ(dmtf_exec_clp_cmd), NULL);
+	if (!clp_cmd)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&clp_cmd->hdr, DMTF_EXEC_CLP_CMD, SLI4_SUBSYSTEM_DMTF,
+			 CMD_V0, CFG_RQST_PYLD_LEN(dmtf_exec_clp_cmd));
+
+	clp_cmd->cmd_buf_length = cpu_to_le32(cmd->size);
+	clp_cmd->cmd_buf_addr_low =  cpu_to_le32(lower_32_bits(cmd->phys));
+	clp_cmd->cmd_buf_addr_high =  cpu_to_le32(upper_32_bits(cmd->phys));
+	clp_cmd->resp_buf_length = cpu_to_le32(resp->size);
+	clp_cmd->resp_buf_addr_low =  cpu_to_le32(lower_32_bits(resp->phys));
+	clp_cmd->resp_buf_addr_high =  cpu_to_le32(upper_32_bits(resp->phys));
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_common_set_dump_location(struct sli4 *sli4, void *buf,
+				 size_t size, bool query,
+				 bool is_buffer_list,
+				 struct efc_dma *buffer, u8 fdb)
+{
+	struct sli4_rqst_cmn_set_dump_location *set_dump_loc = NULL;
+	u32 buffer_length_flag = 0;
+
+	set_dump_loc = sli_config_cmd_init(sli4, buf, size,
+					CFG_RQST_CMDSZ(cmn_set_dump_location),
+					NULL);
+	if (!set_dump_loc)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&set_dump_loc->hdr, CMN_SET_DUMP_LOCATION,
+			 SLI4_SUBSYSTEM_COMMON, CMD_V0,
+			 CFG_RQST_PYLD_LEN(cmn_set_dump_location));
+
+	if (is_buffer_list)
+		buffer_length_flag |= SLI4_RQ_COM_SET_DUMP_BLP;
+
+	if (query)
+		buffer_length_flag |= SLI4_RQ_COM_SET_DUMP_QRY;
+
+	if (fdb)
+		buffer_length_flag |= SLI4_RQ_COM_SET_DUMP_FDB;
+
+	if (buffer) {
+		set_dump_loc->buf_addr_low =
+			cpu_to_le32(lower_32_bits(buffer->phys));
+		set_dump_loc->buf_addr_high =
+			cpu_to_le32(upper_32_bits(buffer->phys));
+
+		buffer_length_flag |= (buffer->len &
+				       SLI4_RQ_COM_SET_DUMP_BUFFER_LEN);
+	} else {
+		set_dump_loc->buf_addr_low = 0;
+		set_dump_loc->buf_addr_high = 0;
+		set_dump_loc->buffer_length_dword = 0;
+	}
+	set_dump_loc->buffer_length_dword = cpu_to_le32(buffer_length_flag);
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_common_set_features(struct sli4 *sli4, void *buf, size_t size,
+			    u32 feature,
+			    u32 param_len,
+			    void *parameter)
+{
+	struct sli4_rqst_cmn_set_features *cmd = NULL;
+
+	cmd = sli_config_cmd_init(sli4, buf, size,
+				  CFG_RQST_CMDSZ(cmn_set_features), NULL);
+	if (!cmd)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&cmd->hdr, CMN_SET_FEATURES, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V0, CFG_RQST_PYLD_LEN(cmn_set_features));
+
+	cmd->feature = cpu_to_le32(feature);
+	cmd->param_len = cpu_to_le32(param_len);
+	memcpy(cmd->params, parameter, param_len);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cqe_mq(struct sli4 *sli4, void *buf)
+{
+	struct sli4_mcqe *mcqe = buf;
+	u32 dwflags = le32_to_cpu(mcqe->dw3_flags);
+	/*
+	 * Firmware can split mbx completions into two MCQEs: first with only
+	 * the "consumed" bit set and a second with the "complete" bit set.
+	 * Thus, ignore MCQE unless "complete" is set.
+	 */
+	if (!(dwflags & SLI4_MCQE_COMPLETED))
+		return -2;
+
+	if (le16_to_cpu(mcqe->completion_status)) {
+		efc_log_info(sli4, "status(st=%#x ext=%#x con=%d cmp=%d ae=%d val=%d)\n",
+			le16_to_cpu(mcqe->completion_status),
+			      le16_to_cpu(mcqe->extended_status),
+			      (dwflags & SLI4_MCQE_CONSUMED),
+			      (dwflags & SLI4_MCQE_COMPLETED),
+			      (dwflags & SLI4_MCQE_AE),
+			      (dwflags & SLI4_MCQE_VALID));
+	}
+
+	return le16_to_cpu(mcqe->completion_status);
+}
+
+int
+sli_cqe_async(struct sli4 *sli4, void *buf)
+{
+	struct sli4_acqe *acqe = buf;
+	int rc = -1;
+
+	if (!buf) {
+		efc_log_err(sli4, "bad parameter sli4=%p buf=%p\n", sli4, buf);
+		return -1;
+	}
+
+	switch (acqe->event_code) {
+	case SLI4_ACQE_EVENT_CODE_LINK_STATE:
+		rc = sli_fc_process_link_state(sli4, buf);
+		break;
+	case SLI4_ACQE_EVENT_CODE_GRP_5:
+		efc_log_info(sli4, "ACQE GRP5\n");
+		break;
+	case SLI4_ACQE_EVENT_CODE_SLI_PORT_EVENT:
+		efc_log_info(sli4, "ACQE SLI Port, type=0x%x, data1,2=0x%08x,0x%08x\n",
+			acqe->event_type,
+			le32_to_cpu(acqe->event_data[0]),
+			le32_to_cpu(acqe->event_data[1]));
+		break;
+	case SLI4_ACQE_EVENT_CODE_FC_LINK_EVENT:
+		rc = sli_fc_process_link_attention(sli4, buf);
+		break;
+	default:
+		efc_log_info(sli4, "ACQE unknown=%#x\n",
+			acqe->event_code);
+	}
+
+	return rc;
+}
diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
index 5c9609e7c72c..4184a7e0069a 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.h
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -12,6 +12,8 @@
 #ifndef _SLI4_H
 #define _SLI4_H
 
+#include <linux/pci.h>
+#include <linux/delay.h>
 #include "scsi/fc/fc_els.h"
 #include "scsi/fc/fc_fs.h"
 #include "../include/efc_common.h"
-- 
2.13.7

