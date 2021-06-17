Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119FEC48BE5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 00:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF88B613CB
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 00:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbhFQARt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 20:17:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14770 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229575AbhFQARs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Jun 2021 20:17:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15H0AbwU026585
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jun 2021 17:15:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=oTi9YVxzUuiFk++1AKmxsu7MUrxw15T4ynLA9tgoulw=;
 b=k0aSz36HZkArOk7xDf+qoZN6VNG7t2KcX7QbbzhFMFnkyJi1oEsY/SqNTYJVETVJeLZl
 0m+T1/UuJaAlcj555TeM2YKV8wB4odkEthHFoLHfpg+KrRuCr0wULwbkwWGYf1omcguv
 0Ti/XxFPFmGAAvWwur2vFttFpFXuO1M6yzqdyu4XlkCB1e6ahPeWF3Ptu535jFLRySWC
 SKlKlN8P71W+uGdzV98UK8MFeWmXW0JEC/+ZzPnbOvfyzU3ChHQK27eRhWIM1otsDPQU
 YgExo1q1Hjer6/ONXn2yfJOthClZ8wWvn4TLL8wBf9SwEz89nAhg/FfBydFFNOVcFq+l nQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 397udrr24f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jun 2021 17:15:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Jun
 2021 17:15:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 16 Jun 2021 17:15:39 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 546905B692F;
        Wed, 16 Jun 2021 17:15:39 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 15H0FdME002532;
        Wed, 16 Jun 2021 17:15:39 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 16 Jun 2021 17:15:39 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 03/15] scsi: qla2xxx: Use the proper SCSI midlayer
 interfaces for PI
In-Reply-To: <20210609033929.3815-4-martin.petersen@oracle.com>
Message-ID: <alpine.LRH.2.21.9999.2106161711000.17918@irv1user01.caveonetworks.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-4-martin.petersen@oracle.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-ORIG-GUID: 1WIPShpyLvMJeZGD14JidVdPWp0wnyKh
X-Proofpoint-GUID: 1WIPShpyLvMJeZGD14JidVdPWp0wnyKh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-16_16:2021-06-15,2021-06-16 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Jun 2021, 8:39pm, Martin K. Petersen wrote:

> Use the SCSI midlayer interfaces to query protection interval,
> reference tag, and per-command DIX flags.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 84 ++++++---------------------------
>  1 file changed, 15 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 38b5bdde2405..42a6fbba7529 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -145,7 +145,6 @@ inline int
>  qla24xx_configure_prot_mode(srb_t *sp, uint16_t *fw_prot_opts)
>  {
>  	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
> -	uint8_t	guard = scsi_host_get_guard(cmd->device->host);
>  
>  	/* We always use DIFF Bundling for best performance */
>  	*fw_prot_opts = 0;
> @@ -166,7 +165,7 @@ qla24xx_configure_prot_mode(srb_t *sp, uint16_t *fw_prot_opts)
>  		break;
>  	case SCSI_PROT_READ_PASS:
>  	case SCSI_PROT_WRITE_PASS:
> -		if (guard & SHOST_DIX_GUARD_IP)
> +		if (cmd->prot_flags & SCSI_PROT_IP_CHECKSUM)
>  			*fw_prot_opts |= PO_MODE_DIF_TCP_CKSUM;
>  		else
>  			*fw_prot_opts |= PO_MODE_DIF_PASS;
> @@ -176,6 +175,9 @@ qla24xx_configure_prot_mode(srb_t *sp, uint16_t *fw_prot_opts)
>  		break;
>  	}
>  
> +	if (!(cmd->prot_flags & SCSI_PROT_GUARD_CHECK))
> +		*fw_prot_opts |= PO_DISABLE_GUARD_CHECK;
> +
>  	return scsi_prot_sg_count(cmd);
>  }
>  
> @@ -772,74 +774,18 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
>  {
>  	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
>  
> -	switch (scsi_get_prot_type(cmd)) {
> -	case SCSI_PROT_DIF_TYPE0:
> -		/*
> -		 * No check for ql2xenablehba_err_chk, as it would be an
> -		 * I/O error if hba tag generation is not done.
> -		 */
> -		pkt->ref_tag = cpu_to_le32((uint32_t)
> -		    (0xffffffff & scsi_get_lba(cmd)));
> -
> -		if (!qla2x00_hba_err_chk_enabled(sp))
> -			break;
> -
> -		pkt->ref_tag_mask[0] = 0xff;
> -		pkt->ref_tag_mask[1] = 0xff;
> -		pkt->ref_tag_mask[2] = 0xff;
> -		pkt->ref_tag_mask[3] = 0xff;
> -		break;
> -
> -	/*
> -	 * For TYPE 2 protection: 16 bit GUARD + 32 bit REF tag has to
> -	 * match LBA in CDB + N
> -	 */
> -	case SCSI_PROT_DIF_TYPE2:
> -		pkt->app_tag = cpu_to_le16(0);
> -		pkt->app_tag_mask[0] = 0x0;
> -		pkt->app_tag_mask[1] = 0x0;
> -
> -		pkt->ref_tag = cpu_to_le32((uint32_t)
> -		    (0xffffffff & scsi_get_lba(cmd)));
> +	pkt->ref_tag = cpu_to_le32(scsi_prot_ref_tag(cmd));
>  
> -		if (!qla2x00_hba_err_chk_enabled(sp))
> -			break;
> -
> -		/* enable ALL bytes of the ref tag */
> -		pkt->ref_tag_mask[0] = 0xff;
> -		pkt->ref_tag_mask[1] = 0xff;
> -		pkt->ref_tag_mask[2] = 0xff;
> -		pkt->ref_tag_mask[3] = 0xff;
> -		break;
> -
> -	/* For Type 3 protection: 16 bit GUARD only */
> -	case SCSI_PROT_DIF_TYPE3:
> -		pkt->ref_tag_mask[0] = pkt->ref_tag_mask[1] =
> -			pkt->ref_tag_mask[2] = pkt->ref_tag_mask[3] =
> -								0x00;
> -		break;
> -
> -	/*
> -	 * For TYpe 1 protection: 16 bit GUARD tag, 32 bit REF tag, and
> -	 * 16 bit app tag.
> -	 */
> -	case SCSI_PROT_DIF_TYPE1:
> -		pkt->ref_tag = cpu_to_le32((uint32_t)
> -		    (0xffffffff & scsi_get_lba(cmd)));
> -		pkt->app_tag = cpu_to_le16(0);
> -		pkt->app_tag_mask[0] = 0x0;
> -		pkt->app_tag_mask[1] = 0x0;
> -
> -		if (!qla2x00_hba_err_chk_enabled(sp))
> -			break;
> -
> -		/* enable ALL bytes of the ref tag */
> -		pkt->ref_tag_mask[0] = 0xff;
> -		pkt->ref_tag_mask[1] = 0xff;
> -		pkt->ref_tag_mask[2] = 0xff;
> -		pkt->ref_tag_mask[3] = 0xff;
> -		break;
> +	if (cmd->prot_flags & SCSI_PROT_REF_CHECK) {

I would also add a "&& qla2x00_hba_err_chk_enabled(sp)" to the above check 
to preserve the old semantics (which was helpful during testing).

With that:

Reviewed-by: Arun Easi <aeasi@marvell.com>

Regards,
-Arun


> +                pkt->ref_tag_mask[0] = 0xff;
> +                pkt->ref_tag_mask[1] = 0xff;
> +                pkt->ref_tag_mask[2] = 0xff;
> +                pkt->ref_tag_mask[3] = 0xff;
>  	}
> +
> +	pkt->app_tag = __constant_cpu_to_le16(0);
> +	pkt->app_tag_mask[0] = 0x0;
> +	pkt->app_tag_mask[1] = 0x0;
>  }
>  
>  int
> @@ -905,7 +851,7 @@ qla24xx_walk_and_build_sglist_no_difb(struct qla_hw_data *ha, srb_t *sp,
>  	memset(&sgx, 0, sizeof(struct qla2_sgx));
>  	if (sp) {
>  		cmd = GET_CMD_SP(sp);
> -		prot_int = cmd->device->sector_size;
> +		prot_int = scsi_prot_interval(cmd);
>  
>  		sgx.tot_bytes = scsi_bufflen(cmd);
>  		sgx.cur_sg = scsi_sglist(cmd);
> 
