Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D40C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5308F222E8
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgJTH4A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 03:56:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:49626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgJTH4A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 03:56:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 09C09ACA1;
        Tue, 20 Oct 2020 07:56:00 +0000 (UTC)
Date:   Tue, 20 Oct 2020 09:55:58 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v4 06/31] elx: libefc_sli: bmbx routines and SLI config
 commands
Message-ID: <20201020075558.xiih5z4coi4qliyn@beryllium.lan>
References: <20201012225147.54404-1-james.smart@broadcom.com>
 <20201012225147.54404-7-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012225147.54404-7-james.smart@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 12, 2020 at 03:51:22PM -0700, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch adds routines to create mailbox commands used during
> adapter initialization and adds APIs to issue mailbox commands to the
> adapter through the bootstrap mailbox register.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>

Two small nitpicks but the rest looks good.

Reviewed-by: Daniel Wagner <dwagner@suse.de>

> +int
> +sli_cmd_read_sparm64(struct sli4 *sli4, void *buf, struct efc_dma *dma, u16 vpi)
> +{
> +	struct sli4_cmd_read_sparm64 *read_sparm64 = buf;
> +
> +	memset(buf, 0, SLI4_BMBX_SIZE);
> +
> +	if (vpi == U16_MAX) {
> +		efc_log_err(sli4, "special VPI not supported!!!\n");
> +		return EFC_FAIL;
> +	}
> +
> +	if (!dma || !dma->phys) {
> +		efc_log_err(sli4, "bad DMA buffer\n");
> +		return EFC_FAIL;
> +	}
> +

The memset should be after the two ifs.

> +	read_sparm64->hdr.command = SLI4_MBX_CMD_READ_SPARM64;
> +
> +	read_sparm64->bde_64.bde_type_buflen =
> +			cpu_to_le32((SLI4_BDE_TYPE_VAL(64)) |
> +				    (dma->size & SLI4_BDE_LEN_MASK));
> +	read_sparm64->bde_64.u.data.low =
> +			cpu_to_le32(lower_32_bits(dma->phys));
> +	read_sparm64->bde_64.u.data.high =
> +			cpu_to_le32(upper_32_bits(dma->phys));
> +
> +	read_sparm64->vpi = cpu_to_le16(vpi);
> +
> +	return EFC_SUCCESS;
> +}



> +int
> +sli_cmd_reg_fcfi_mrq(struct sli4 *sli4, void *buf, u8 mode, u16 fcf_index,
> +		     u8 rq_selection_policy, u8 mrq_bit_mask, u16 num_mrqs,
> +		struct sli4_cmd_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG])

Are these arguments list not getting a little bit big? If I got it right,
sizeof(struct sli4_cmd_rq_cfg) * SLI4_CMD_REG_FCFI_NUM_RQ_CFG = 6 * 4 =
24 bytes. As it is used, passing in a pointer would do the trick as well.

> +{
> +	struct sli4_cmd_reg_fcfi_mrq *reg_fcfi_mrq = buf;
> +	u32 i;
> +	u32 mrq_flags = 0;
> +
> +	memset(buf, 0, SLI4_BMBX_SIZE);
> +
> +	reg_fcfi_mrq->hdr.command = SLI4_MBX_CMD_REG_FCFI_MRQ;
> +	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE) {
> +		reg_fcfi_mrq->fcf_index = cpu_to_le16(fcf_index);
> +		goto done;
> +	}

Could the memset be after the if?

