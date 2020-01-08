Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E29C33C9B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 08:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA13120705
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 08:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgAHIFf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:05:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:46156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgAHIFe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 03:05:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 698ABAD31;
        Wed,  8 Jan 2020 08:05:29 +0000 (UTC)
Subject: Re: [PATCH v2 06/32] elx: libefc_sli: bmbx routines and SLI config
 commands
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-7-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <cb005b73-fb97-f4b6-de1e-56491732df02@suse.de>
Date:   Wed, 8 Jan 2020 09:05:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-7-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 11:36 PM, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch adds routines to create mailbox commands used during
> adapter initialization and adds APIs to issue mailbox commands to the
> adapter through the bootstrap mailbox register.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/libefc_sli/sli4.c | 1229 +++++++++++++++++++++++++++++++++++-
>  drivers/scsi/elx/libefc_sli/sli4.h |    2 +
>  2 files changed, 1230 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
> index 2ebe0235bc9e..3cdabb917df6 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.c
> +++ b/drivers/scsi/elx/libefc_sli/sli4.c
> @@ -942,7 +942,6 @@ static int sli_cmd_cq_set_create(struct sli4 *sli4,
>  	u16 dw6w1_flags = 0;
>  	__le32 req_len;
>  
> -
>  	n_cqe = qs[0]->dma.size / SLI4_CQE_BYTES;
>  	switch (n_cqe) {
>  	case 256:
> @@ -3297,3 +3296,1231 @@ sli_fc_rqe_rqid_and_index(struct sli4 *sli4, u8 *cqe,
>  
>  	return rc;
>  }
> +
> +/* Wait for the bootstrap mailbox to report "ready" */
> +static int
> +sli_bmbx_wait(struct sli4 *sli4, u32 msec)
> +{
> +	u32 val = 0;
> +
> +	do {
> +		mdelay(1);	/* 1 ms */
> +		val = readl(sli4->reg[0] + SLI4_BMBX_REG);
> +		msec--;
> +	} while (msec && !(val & SLI4_BMBX_RDY));
> +
> +	val = (!(val & SLI4_BMBX_RDY));
> +	return val;
> +}
> +
> +/* Write bootstrap mailbox */
> +static int
> +sli_bmbx_write(struct sli4 *sli4)
> +{
> +	u32 val = 0;
> +
> +	/* write buffer location to bootstrap mailbox register */
> +	val = SLI4_BMBX_WRITE_HI(sli4->bmbx.phys);
> +	writel(val, (sli4->reg[0] + SLI4_BMBX_REG));
> +
> +	if (sli_bmbx_wait(sli4, SLI4_BMBX_DELAY_US)) {
> +		efc_log_crit(sli4, "BMBX WRITE_HI failed\n");
> +		return -1;
> +	}

EFC_FAIL?

> +	val = SLI4_BMBX_WRITE_LO(sli4->bmbx.phys);
> +	writel(val, (sli4->reg[0] + SLI4_BMBX_REG));
> +
> +	/* wait for SLI Port to set ready bit */
> +	return sli_bmbx_wait(sli4, SLI4_BMBX_TIMEOUT_MSEC);
> +}
> +
> +/* Submit a command to the bootstrap mailbox and check the status */
> +int
> +sli_bmbx_command(struct sli4 *sli4)
> +{
> +	void *cqe = (u8 *)sli4->bmbx.virt + SLI4_BMBX_SIZE;
> +
> +	if (sli_fw_error_status(sli4) > 0) {
> +		efc_log_crit(sli4, "Chip is in an error state -Mailbox command rejected");
> +		efc_log_crit(sli4, " status=%#x error1=%#x error2=%#x\n",
> +			sli_reg_read_status(sli4),
> +			sli_reg_read_err1(sli4),
> +			sli_reg_read_err2(sli4));
> +		return -1;
> +	}
> +
Same here.

> +	if (sli_bmbx_write(sli4)) {
> +		efc_log_crit(sli4, "bootstrap mailbox write fail phys=%p reg=%#x\n",
> +			(void *)sli4->bmbx.phys,
> +			readl(sli4->reg[0] + SLI4_BMBX_REG));
> +		return -1;
> +	}
> +
And here.

> +	/* check completion queue entry status */
> +	if (le32_to_cpu(((struct sli4_mcqe *)cqe)->dw3_flags) &
> +	    SLI4_MCQE_VALID) {
> +		return sli_cqe_mq(sli4, cqe);
> +	}
> +	efc_log_crit(sli4, "invalid or wrong type\n");
> +	return -1;
> +}
> +
> +/* Write a CONFIG_LINK command to the provided buffer */
> +int
> +sli_cmd_config_link(struct sli4 *sli4, void *buf, size_t size)
> +{
> +	struct sli4_cmd_config_link *config_link = buf;
> +
> +	memset(buf, 0, size);
> +
> +	config_link->hdr.command = MBX_CMD_CONFIG_LINK;
> +
> +	/* Port interprets zero in a field as "use default value" */
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write a DOWN_LINK command to the provided buffer */
> +int
> +sli_cmd_down_link(struct sli4 *sli4, void *buf, size_t size)
> +{
> +	struct sli4_mbox_command_header *hdr = buf;
> +
> +	memset(buf, 0, size);
> +
> +	hdr->command = MBX_CMD_DOWN_LINK;
> +
> +	/* Port interprets zero in a field as "use default value" */
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write a DUMP Type 4 command to the provided buffer */
> +int
> +sli_cmd_dump_type4(struct sli4 *sli4, void *buf,
> +		   size_t size, u16 wki)
> +{
> +	struct sli4_cmd_dump4 *cmd = buf;
> +
> +	memset(buf, 0, size);
> +
> +	cmd->hdr.command = MBX_CMD_DUMP;
> +	cmd->type_dword = cpu_to_le32(0x4);
> +	cmd->wki_selection = cpu_to_le16(wki);
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write a COMMON_READ_TRANSCEIVER_DATA command */
> +int
> +sli_cmd_common_read_transceiver_data(struct sli4 *sli4, void *buf,
> +				     size_t size, u32 page_num,
> +				     struct efc_dma *dma)
> +{
> +	struct sli4_rqst_cmn_read_transceiver_data *req = NULL;
> +	u32 psize;
> +
> +	if (!dma)
> +		psize = SLI_CONFIG_PYLD_LENGTH(cmn_read_transceiver_data);
> +	else
> +		psize = dma->size;
> +
> +	req = sli_config_cmd_init(sli4, buf, size,
> +					    psize, dma);
> +	if (!req)
> +		return EFC_FAIL;
> +
> +	sli_cmd_fill_hdr(&req->hdr, CMN_READ_TRANS_DATA, SLI4_SUBSYSTEM_COMMON,
> +			 CMD_V0, CFG_RQST_PYLD_LEN(cmn_read_transceiver_data));
> +
> +	req->page_number = cpu_to_le32(page_num);
> +	req->port = cpu_to_le32(sli4->port_number);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write a READ_LINK_STAT command to the provided buffer */
> +int
> +sli_cmd_read_link_stats(struct sli4 *sli4, void *buf, size_t size,
> +			u8 req_ext_counters,
> +			u8 clear_overflow_flags,
> +			u8 clear_all_counters)
> +{
> +	struct sli4_cmd_read_link_stats *cmd = buf;
> +	u32 flags;
> +
> +	memset(buf, 0, size);
> +
> +	cmd->hdr.command = MBX_CMD_READ_LNK_STAT;
> +
> +	flags = 0;
> +	if (req_ext_counters)
> +		flags |= SLI4_READ_LNKSTAT_REC;
> +	if (clear_all_counters)
> +		flags |= SLI4_READ_LNKSTAT_CLRC;
> +	if (clear_overflow_flags)
> +		flags |= SLI4_READ_LNKSTAT_CLOF;
> +
> +	cmd->dw1_flags = cpu_to_le32(flags);
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write a READ_STATUS command to the provided buffer */
> +int
> +sli_cmd_read_status(struct sli4 *sli4, void *buf, size_t size,
> +		    u8 clear_counters)
> +{
> +	struct sli4_cmd_read_status *cmd = buf;
> +	u32 flags = 0;
> +
> +	memset(buf, 0, size);
> +
> +	cmd->hdr.command = MBX_CMD_READ_STATUS;
> +	if (clear_counters)
> +		flags |= SLI4_READSTATUS_CLEAR_COUNTERS;
> +	else
> +		flags &= ~SLI4_READSTATUS_CLEAR_COUNTERS;
> +
> +	cmd->dw1_flags = cpu_to_le32(flags);
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write an INIT_LINK command to the provided buffer */
> +int
> +sli_cmd_init_link(struct sli4 *sli4, void *buf, size_t size,
> +		  u32 speed, u8 reset_alpa)
> +{
> +	struct sli4_cmd_init_link *init_link = buf;
> +	u32 flags = 0;
> +
> +	memset(buf, 0, size);
> +
> +	init_link->hdr.command = MBX_CMD_INIT_LINK;
> +
> +	init_link->sel_reset_al_pa_dword =
> +				cpu_to_le32(reset_alpa);
> +	flags &= ~SLI4_INIT_LINK_FLAG_LOOPBACK;
> +
> +	init_link->link_speed_sel_code = cpu_to_le32(speed);
> +	switch (speed) {
> +	case FC_LINK_SPEED_1G:
> +	case FC_LINK_SPEED_2G:
> +	case FC_LINK_SPEED_4G:
> +	case FC_LINK_SPEED_8G:
> +	case FC_LINK_SPEED_16G:
> +	case FC_LINK_SPEED_32G:
> +		flags |= SLI4_INIT_LINK_FLAG_FIXED_SPEED;
> +		break;

I was under the impression that 64G FC is already underway, is it not?

> +	case FC_LINK_SPEED_10G:
> +		efc_log_info(sli4, "unsupported FC speed %d\n", speed);
> +		init_link->flags0 = cpu_to_le32(flags);
> +		return EFC_FAIL;
> +	}
> +
> +	switch (sli4->topology) {
> +	case SLI4_READ_CFG_TOPO_FC:
> +		/* Attempt P2P but failover to FC-AL */
> +		flags |= SLI4_INIT_LINK_FLAG_EN_TOPO_FAILOVER;
> +
> +		flags &= ~SLI4_INIT_LINK_FLAG_TOPOLOGY;
> +		flags |= (SLI4_INIT_LINK_F_P2P_FAIL_OVER << 1);
> +		break;
> +	case SLI4_READ_CFG_TOPO_FC_AL:
> +		flags &= ~SLI4_INIT_LINK_FLAG_TOPOLOGY;
> +		flags |= (SLI4_INIT_LINK_F_FCAL_ONLY << 1);
> +		if (speed == FC_LINK_SPEED_16G ||
> +		    speed == FC_LINK_SPEED_32G) {
> +			efc_log_info(sli4, "unsupported FC-AL speed %d\n",
> +				speed);
> +			init_link->flags0 = cpu_to_le32(flags);
> +			return EFC_FAIL;
> +		}
> +		break;
> +	case SLI4_READ_CFG_TOPO_FC_DA:
> +		flags &= ~SLI4_INIT_LINK_FLAG_TOPOLOGY;
> +		flags |= (FC_TOPOLOGY_P2P << 1);
> +		break;
> +	default:
> +
> +		efc_log_info(sli4, "unsupported topology %#x\n",
> +			sli4->topology);
> +
> +		init_link->flags0 = cpu_to_le32(flags);
> +		return EFC_FAIL;
> +	}
> +
> +	flags &= (~SLI4_INIT_LINK_FLAG_UNFAIR);
> +	flags &= (~SLI4_INIT_LINK_FLAG_SKIP_LIRP_LILP);
> +	flags &= (~SLI4_INIT_LINK_FLAG_LOOP_VALIDITY);
> +	flags &= (~SLI4_INIT_LINK_FLAG_SKIP_LISA);
> +	flags &= (~SLI4_INIT_LINK_FLAG_SEL_HIGHTEST_AL_PA);
> +	init_link->flags0 = cpu_to_le32(flags);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write an INIT_VFI command to the provided buffer */
> +int
> +sli_cmd_init_vfi(struct sli4 *sli4, void *buf, size_t size,
> +		 u16 vfi, u16 fcfi, u16 vpi)
> +{
> +	struct sli4_cmd_init_vfi *init_vfi = buf;
> +	u16 flags = 0;
> +
> +	memset(buf, 0, size);
> +
> +	init_vfi->hdr.command = MBX_CMD_INIT_VFI;
> +
> +	init_vfi->vfi = cpu_to_le16(vfi);
> +	init_vfi->fcfi = cpu_to_le16(fcfi);
> +
> +	/*
> +	 * If the VPI is valid, initialize it at the same time as
> +	 * the VFI
> +	 */
> +	if (vpi != U16_MAX) {
> +		flags |= SLI4_INIT_VFI_FLAG_VP;
> +		init_vfi->flags0_word = cpu_to_le16(flags);
> +		init_vfi->vpi = cpu_to_le16(vpi);
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write an INIT_VPI command to the provided buffer */
> +int
> +sli_cmd_init_vpi(struct sli4 *sli4, void *buf, size_t size,
> +		 u16 vpi, u16 vfi)
> +{
> +	struct sli4_cmd_init_vpi *init_vpi = buf;
> +
> +	memset(buf, 0, size);
> +
> +	init_vpi->hdr.command = MBX_CMD_INIT_VPI;
> +	init_vpi->vpi = cpu_to_le16(vpi);
> +	init_vpi->vfi = cpu_to_le16(vfi);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_post_xri(struct sli4 *sli4, void *buf, size_t size,
> +		 u16 xri_base, u16 xri_count)
> +{
> +	struct sli4_cmd_post_xri *post_xri = buf;
> +	u16 xri_count_flags = 0;
> +
> +	memset(buf, 0, size);
> +
> +	post_xri->hdr.command = MBX_CMD_POST_XRI;
> +	post_xri->xri_base = cpu_to_le16(xri_base);
> +	xri_count_flags = (xri_count & SLI4_POST_XRI_COUNT);
> +	xri_count_flags |= SLI4_POST_XRI_FLAG_ENX;
> +	xri_count_flags |= SLI4_POST_XRI_FLAG_VAL;
> +	post_xri->xri_count_flags = cpu_to_le16(xri_count_flags);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_release_xri(struct sli4 *sli4, void *buf, size_t size,
> +		    u8 num_xri)
> +{
> +	struct sli4_cmd_release_xri *release_xri = buf;
> +
> +	memset(buf, 0, size);
> +
> +	release_xri->hdr.command = MBX_CMD_RELEASE_XRI;
> +	release_xri->xri_count_word = cpu_to_le16(num_xri &
> +					SLI4_RELEASE_XRI_COUNT);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +sli_cmd_read_config(struct sli4 *sli4, void *buf, size_t size)
> +{
> +	struct sli4_cmd_read_config *read_config = buf;
> +
> +	memset(buf, 0, size);
> +
> +	read_config->hdr.command = MBX_CMD_READ_CONFIG;
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_read_nvparms(struct sli4 *sli4, void *buf, size_t size)
> +{
> +	struct sli4_cmd_read_nvparms *read_nvparms = buf;
> +
> +	memset(buf, 0, size);
> +
> +	read_nvparms->hdr.command = MBX_CMD_READ_NVPARMS;
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_write_nvparms(struct sli4 *sli4, void *buf, size_t size,
> +		      u8 *wwpn, u8 *wwnn, u8 hard_alpa,
> +		u32 preferred_d_id)
> +{
> +	struct sli4_cmd_write_nvparms *write_nvparms = buf;
> +
> +	memset(buf, 0, size);
> +
> +	write_nvparms->hdr.command = MBX_CMD_WRITE_NVPARMS;
> +	memcpy(write_nvparms->wwpn, wwpn, 8);
> +	memcpy(write_nvparms->wwnn, wwnn, 8);
> +
> +	write_nvparms->hard_alpa_d_id =
> +			cpu_to_le32((preferred_d_id << 8) | hard_alpa);
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +sli_cmd_read_rev(struct sli4 *sli4, void *buf, size_t size,
> +		 struct efc_dma *vpd)
> +{
> +	struct sli4_cmd_read_rev *read_rev = buf;
> +
> +	memset(buf, 0, size);
> +
> +	read_rev->hdr.command = MBX_CMD_READ_REV;
> +
> +	if (vpd && vpd->size) {
> +		read_rev->flags0_word |= cpu_to_le16(SLI4_READ_REV_FLAG_VPD);
> +
> +		read_rev->available_length_dword =
> +			cpu_to_le32(vpd->size &
> +				    SLI4_READ_REV_AVAILABLE_LENGTH);
> +
> +		read_rev->hostbuf.low =
> +				cpu_to_le32(lower_32_bits(vpd->phys));
> +		read_rev->hostbuf.high =
> +				cpu_to_le32(upper_32_bits(vpd->phys));
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_read_sparm64(struct sli4 *sli4, void *buf, size_t size,
> +		     struct efc_dma *dma,
> +		     u16 vpi)
> +{
> +	struct sli4_cmd_read_sparm64 *read_sparm64 = buf;
> +
> +	memset(buf, 0, size);
> +
> +	if (vpi == SLI4_READ_SPARM64_VPI_SPECIAL) {
> +		efc_log_info(sli4, "special VPI not supported!!!\n");
> +		return -1;
> +	}

EFC_FAIL

> +
> +	if (!dma || !dma->phys) {
> +		efc_log_info(sli4, "bad DMA buffer\n");
> +		return -1;
> +	}
> +
Same here.

> +	read_sparm64->hdr.command = MBX_CMD_READ_SPARM64;
> +
> +	read_sparm64->bde_64.bde_type_buflen =
> +			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
> +				    (dma->size & SLI4_BDE_MASK_BUFFER_LEN));
> +	read_sparm64->bde_64.u.data.low =
> +			cpu_to_le32(lower_32_bits(dma->phys));
> +	read_sparm64->bde_64.u.data.high =
> +			cpu_to_le32(upper_32_bits(dma->phys));
> +
> +	read_sparm64->vpi = cpu_to_le16(vpi);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_read_topology(struct sli4 *sli4, void *buf, size_t size,
> +		      struct efc_dma *dma)
> +{
> +	struct sli4_cmd_read_topology *read_topo = buf;
> +
> +	memset(buf, 0, size);
> +
> +	read_topo->hdr.command = MBX_CMD_READ_TOPOLOGY;
> +
> +	if (dma && dma->size) {
> +		if (dma->size < SLI4_MIN_LOOP_MAP_BYTES) {
> +			efc_log_info(sli4, "loop map buffer too small %jd\n",
> +				dma->size);
> +			return 0;
> +		}

Ah. So this is not an error?
And if this function can't fail, why not make it a void function?

> +
> +		memset(dma->virt, 0, dma->size);
> +
> +		read_topo->bde_loop_map.bde_type_buflen =
> +			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
> +				    (dma->size & SLI4_BDE_MASK_BUFFER_LEN));
> +		read_topo->bde_loop_map.u.data.low  =
> +			cpu_to_le32(lower_32_bits(dma->phys));
> +		read_topo->bde_loop_map.u.data.high =
> +			cpu_to_le32(upper_32_bits(dma->phys));
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_reg_fcfi(struct sli4 *sli4, void *buf, size_t size,
> +		 u16 index,
> +		 struct sli4_cmd_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG])
> +{
> +	struct sli4_cmd_reg_fcfi *reg_fcfi = buf;
> +	u32 i;
> +
> +	memset(buf, 0, size);
> +
> +	reg_fcfi->hdr.command = MBX_CMD_REG_FCFI;
> +
> +	reg_fcfi->fcf_index = cpu_to_le16(index);
> +
> +	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
> +		switch (i) {
> +		case 0:
> +			reg_fcfi->rqid0 = rq_cfg[0].rq_id;
> +			break;
> +		case 1:
> +			reg_fcfi->rqid1 = rq_cfg[1].rq_id;
> +			break;
> +		case 2:
> +			reg_fcfi->rqid2 = rq_cfg[2].rq_id;
> +			break;
> +		case 3:
> +			reg_fcfi->rqid3 = rq_cfg[3].rq_id;
> +			break;
> +		}
> +		reg_fcfi->rq_cfg[i].r_ctl_mask = rq_cfg[i].r_ctl_mask;
> +		reg_fcfi->rq_cfg[i].r_ctl_match = rq_cfg[i].r_ctl_match;
> +		reg_fcfi->rq_cfg[i].type_mask = rq_cfg[i].type_mask;
> +		reg_fcfi->rq_cfg[i].type_match = rq_cfg[i].type_match;
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_reg_fcfi_mrq(struct sli4 *sli4, void *buf, size_t size,
> +		     u8 mode, u16 fcf_index,
> +		     u8 rq_selection_policy, u8 mrq_bit_mask,
> +		     u16 num_mrqs,
> +		struct sli4_cmd_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG])
> +{
> +	struct sli4_cmd_reg_fcfi_mrq *reg_fcfi_mrq = buf;
> +	u32 i;
> +	u32 mrq_flags = 0;
> +
> +	memset(buf, 0, size);
> +
> +	reg_fcfi_mrq->hdr.command = MBX_CMD_REG_FCFI_MRQ;
> +	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE) {
> +		reg_fcfi_mrq->fcf_index = cpu_to_le16(fcf_index);
> +		goto done;
> +	}
> +
> +	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
> +		reg_fcfi_mrq->rq_cfg[i].r_ctl_mask = rq_cfg[i].r_ctl_mask;
> +		reg_fcfi_mrq->rq_cfg[i].r_ctl_match = rq_cfg[i].r_ctl_match;
> +		reg_fcfi_mrq->rq_cfg[i].type_mask = rq_cfg[i].type_mask;
> +		reg_fcfi_mrq->rq_cfg[i].type_match = rq_cfg[i].type_match;
> +
> +		switch (i) {
> +		case 3:
> +			reg_fcfi_mrq->rqid3 = rq_cfg[i].rq_id;
> +			break;
> +		case 2:
> +			reg_fcfi_mrq->rqid2 = rq_cfg[i].rq_id;
> +			break;
> +		case 1:
> +			reg_fcfi_mrq->rqid1 = rq_cfg[i].rq_id;
> +			break;
> +		case 0:
> +			reg_fcfi_mrq->rqid0 = rq_cfg[i].rq_id;
> +			break;
> +		}
> +	}
> +
> +	mrq_flags = num_mrqs & SLI4_REGFCFI_MRQ_MASK_NUM_PAIRS;
> +	mrq_flags |= (mrq_bit_mask << 8);
> +	mrq_flags |= (rq_selection_policy << 12);
> +	reg_fcfi_mrq->dw9_mrqflags = cpu_to_le32(mrq_flags);
> +done:
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_reg_rpi(struct sli4 *sli4, void *buf, size_t size,
> +		u32 nport_id, u16 rpi, u16 vpi,
> +		struct efc_dma *dma, u8 update,
> +		u8 enable_t10_pi)
> +{
> +	struct sli4_cmd_reg_rpi *reg_rpi = buf;
> +	u32 rportid_flags = 0;
> +
> +	memset(buf, 0, size);
> +
> +	reg_rpi->hdr.command = MBX_CMD_REG_RPI;
> +
> +	reg_rpi->rpi = cpu_to_le16(rpi);
> +
> +	rportid_flags = nport_id & SLI4_REGRPI_REMOTE_N_PORTID;
> +
> +	if (update)
> +		rportid_flags |= SLI4_REGRPI_UPD;
> +	else
> +		rportid_flags &= ~SLI4_REGRPI_UPD;
> +
> +	if (enable_t10_pi)
> +		rportid_flags |= SLI4_REGRPI_ETOW;
> +	else
> +		rportid_flags &= ~SLI4_REGRPI_ETOW;
> +
> +	reg_rpi->dw2_rportid_flags = cpu_to_le32(rportid_flags);
> +
> +	reg_rpi->bde_64.bde_type_buflen =
> +		cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
> +			    (SLI4_REG_RPI_BUF_LEN & SLI4_BDE_MASK_BUFFER_LEN));
> +	reg_rpi->bde_64.u.data.low  =
> +		cpu_to_le32(lower_32_bits(dma->phys));
> +	reg_rpi->bde_64.u.data.high =
> +		cpu_to_le32(upper_32_bits(dma->phys));
> +
> +	reg_rpi->vpi = cpu_to_le16(vpi);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_reg_vfi(struct sli4 *sli4, void *buf, size_t size,
> +		u16 vfi, u16 fcfi, struct efc_dma dma,
> +		u16 vpi, __be64 sli_wwpn, u32 fc_id)
> +{
> +	struct sli4_cmd_reg_vfi *reg_vfi = buf;
> +
> +	if (!sli4 || !buf)
> +		return 0;
> +

EFC_SUCCESS?
And why is this not an error?

> +	memset(buf, 0, size);
> +
> +	reg_vfi->hdr.command = MBX_CMD_REG_VFI;
> +
> +	reg_vfi->vfi = cpu_to_le16(vfi);
> +
> +	reg_vfi->fcfi = cpu_to_le16(fcfi);
> +
> +	reg_vfi->sparm.bde_type_buflen =
> +		cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
> +			    (SLI4_REG_RPI_BUF_LEN & SLI4_BDE_MASK_BUFFER_LEN));
> +	reg_vfi->sparm.u.data.low  =
> +		cpu_to_le32(lower_32_bits(dma.phys));
> +	reg_vfi->sparm.u.data.high =
> +		cpu_to_le32(upper_32_bits(dma.phys));
> +
> +	reg_vfi->e_d_tov = cpu_to_le32(sli4->e_d_tov);
> +	reg_vfi->r_a_tov = cpu_to_le32(sli4->r_a_tov);
> +
> +	reg_vfi->dw0w1_flags |= cpu_to_le16(SLI4_REGVFI_VP);
> +	reg_vfi->vpi = cpu_to_le16(vpi);
> +	memcpy(reg_vfi->wwpn, &sli_wwpn, sizeof(reg_vfi->wwpn));
> +	reg_vfi->dw10_lportid_flags = cpu_to_le32(fc_id);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_reg_vpi(struct sli4 *sli4, void *buf, size_t size,
> +		u32 fc_id, __be64 sli_wwpn, u16 vpi, u16 vfi,
> +		bool update)
> +{
> +	struct sli4_cmd_reg_vpi *reg_vpi = buf;
> +	u32 flags = 0;
> +
> +	if (!sli4 || !buf)
> +		return 0;
> +

Same here. Why is this not returning EFC_SUCCESS?
And why is it not an error?

> +	memset(buf, 0, size);
> +
> +	reg_vpi->hdr.command = MBX_CMD_REG_VPI;
> +
> +	flags = (fc_id & SLI4_REGVPI_LOCAL_N_PORTID);
> +	if (update)
> +		flags |= SLI4_REGVPI_UPD;
> +	else
> +		flags &= ~SLI4_REGVPI_UPD;
> +
> +	reg_vpi->dw2_lportid_flags = cpu_to_le32(flags);
> +	memcpy(reg_vpi->wwpn, &sli_wwpn, sizeof(reg_vpi->wwpn));
> +	reg_vpi->vpi = cpu_to_le16(vpi);
> +	reg_vpi->vfi = cpu_to_le16(vfi);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +sli_cmd_request_features(struct sli4 *sli4, void *buf, size_t size,
> +			 u32 features_mask, bool query)
> +{
> +	struct sli4_cmd_request_features *req_features = buf;
> +

And why does this function _not_ have the check?

> +	memset(buf, 0, size);
> +
> +	req_features->hdr.command = MBX_CMD_RQST_FEATURES;
> +
> +	if (query)
> +		req_features->dw1_qry = cpu_to_le32(SLI4_REQFEAT_QRY);
> +
> +	req_features->cmd = cpu_to_le32(features_mask);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_unreg_fcfi(struct sli4 *sli4, void *buf, size_t size,
> +		   u16 indicator)
> +{
> +	struct sli4_cmd_unreg_fcfi *unreg_fcfi = buf;
> +
> +	if (!sli4 || !buf)
> +		return 0;
> +
> +	memset(buf, 0, size);
> +
> +	unreg_fcfi->hdr.command = MBX_CMD_UNREG_FCFI;
> +
> +	unreg_fcfi->fcfi = cpu_to_le16(indicator);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_unreg_rpi(struct sli4 *sli4, void *buf, size_t size,
> +		  u16 indicator,
> +		  enum sli4_resource which, u32 fc_id)
> +{
> +	struct sli4_cmd_unreg_rpi *unreg_rpi = buf;
> +	u32 flags = 0;
> +

Same here.
Why is there no check?

[ .. ]
> +
> +int
> +sli_cqe_mq(struct sli4 *sli4, void *buf)
> +{
> +	struct sli4_mcqe *mcqe = buf;
> +	u32 dwflags = le32_to_cpu(mcqe->dw3_flags);
> +	/*
> +	 * Firmware can split mbx completions into two MCQEs: first with only
> +	 * the "consumed" bit set and a second with the "complete" bit set.
> +	 * Thus, ignore MCQE unless "complete" is set.
> +	 */
> +	if (!(dwflags & SLI4_MCQE_COMPLETED))
> +		return -2;
> +

Now you're getting creative.
-2 ?

What happened to EFC_SUCCESS/EFC_FAIL?
If this is deliberate please add another EFC_XXX define and document it
why this is not the standard return value.

> +	if (le16_to_cpu(mcqe->completion_status)) {
> +		efc_log_info(sli4, "status(st=%#x ext=%#x con=%d cmp=%d ae=%d val=%d)\n",
> +			le16_to_cpu(mcqe->completion_status),
> +			      le16_to_cpu(mcqe->extended_status),
> +			      (dwflags & SLI4_MCQE_CONSUMED),
> +			      (dwflags & SLI4_MCQE_COMPLETED),
> +			      (dwflags & SLI4_MCQE_AE),
> +			      (dwflags & SLI4_MCQE_VALID));
> +	}
> +
> +	return le16_to_cpu(mcqe->completion_status);
> +}
> +
> +int
> +sli_cqe_async(struct sli4 *sli4, void *buf)
> +{
> +	struct sli4_acqe *acqe = buf;
> +	int rc = -1;
> +
> +	if (!buf) {
> +		efc_log_err(sli4, "bad parameter sli4=%p buf=%p\n", sli4, buf);
> +		return -1;
> +	}
> +

EFC_FAIL...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
