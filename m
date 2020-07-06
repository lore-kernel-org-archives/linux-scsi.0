Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37629C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14DAD206E9
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594064536;
	bh=2dq6Znvi2K91ububeGftlpHHcJqdWHCewj/ozfjx3wo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dqC0zsciycnKllglJKECoYmdQZrc2tajBsIl5UaovlGLLMs/fBraxongbbmvmrQA6
	 H+SIshGurU8nE2QkmQibxfchry2zt8Yh8bokrn9aKvsemmTRX+Ru0slBIGDzXUlm1Z
	 3zZDKueZsyYlQdXOSbmvsREyNfj7CrgIwxOajNcQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGFTmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGFTmP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Jul 2020 15:42:15 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1E3E20675;
        Mon,  6 Jul 2020 19:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594064534;
        bh=2dq6Znvi2K91ububeGftlpHHcJqdWHCewj/ozfjx3wo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jeEU51sA1yF5VNfxwY5cY2YfpQwIxtvA+wYlBojlIQLx9Cu7Ht4MArObQf8sRYl4K
         Xrf4mj6GKeahTNVj6cD8OQs0IhEEpB5zb4qlAW44n9xAMwagJNE0P2c38ihH6JxWcU
         qDYJpiczwf09UH2qATHj/fKFXqKR4tgs8tIhRiJc=
Date:   Mon, 6 Jul 2020 12:42:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-scsi@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v3 3/3] scsi: ufs: Add inline encryption support to UFS
Message-ID: <20200706194213.GB833@sol.localdomain>
References: <20200706191016.2012191-1-satyat@google.com>
 <20200706191016.2012191-4-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706191016.2012191-4-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 06, 2020 at 07:10:16PM +0000, Satya Tangirala wrote:
> +/**
> + * ufshcd_init_crypto - Initialize crypto hardware
> + * @hba: Per adapter instance
> + */
> +void ufshcd_init_crypto(struct ufs_hba *hba)
> +{
> +	int slot = 0;
> +
> +	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
> +		return;
> +
> +	/* Clear all keyslots - the number of keyslots is (CFGC + 1) */
> +	for (slot = 0; slot < hba->crypto_capabilities.config_count + 1; slot++)
> +		ufshcd_clear_keyslot(hba, slot);
> +}

This should just use 'int slot;'.  No need to initialize to 0.

> diff --git a/drivers/scsi/ufs/ufshcd-crypto.h b/drivers/scsi/ufs/ufshcd-crypto.h
> index 22677619de59..2512aef03f76 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.h
> +++ b/drivers/scsi/ufs/ufshcd-crypto.h
> @@ -10,9 +10,36 @@
>  #include "ufshcd.h"
>  #include "ufshci.h"
>  
> +static inline void ufshcd_prepare_lrbp_crypto(struct ufs_hba *hba,
> +					      struct request *rq,
> +					      struct ufshcd_lrb *lrbp)
> +{
> +	if (!rq || !rq->crypt_keyslot) {
> +		lrbp->crypto_key_slot = -1;
> +		return;
> +	}
> +
> +	lrbp->crypto_key_slot = blk_ksm_get_slot_idx(rq->crypt_keyslot);
> +	lrbp->data_unit_num = rq->crypt_ctx->bc_dun[0];
> +}

This function doesn't use the 'hba' argument, so it should be removed.

> +
> +static inline void
> +ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp, u32 *dword_0,
> +				   u32 *dword_1, u32 *dword_3)
> +{
> +	if (lrbp->crypto_key_slot >= 0) {
> +		*dword_0 |= UTP_REQ_DESC_CRYPTO_ENABLE_CMD;
> +		*dword_0 |= lrbp->crypto_key_slot;
> +		*dword_1 = lower_32_bits(lrbp->data_unit_num);
> +		*dword_3 = upper_32_bits(lrbp->data_unit_num);
> +	}
> +}
> +
>  bool ufshcd_crypto_enable(struct ufs_hba *hba);
>  
> -int ufshcd_hba_init_crypto(struct ufs_hba *hba);
> +void ufshcd_init_crypto(struct ufs_hba *hba);
> +
> +int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba);

The .c file defines ufshcd_hba_init_crypto_capabilities() before
ufshcd_init_crypto().  It would be nice to put the declarations in the same
order.

> @@ -2554,6 +2577,7 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
>  	lrbp->task_tag = tag;
>  	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
>  	lrbp->intr_cmd = true; /* No interrupt aggregation */
> +	ufshcd_prepare_lrbp_crypto(hba, NULL, lrbp);
>  	hba->dev_cmd.type = cmd_type;
>  
>  	return ufshcd_comp_devman_upiu(hba, lrbp);
> @@ -4650,6 +4674,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>  	if (ufshcd_is_rpm_autosuspend_allowed(hba))
>  		sdev->rpm_autosuspend = 1;
>  
> +	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
> +
>  	return 0;
>  }
>  
> @@ -6115,6 +6141,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>  	lrbp->task_tag = tag;
>  	lrbp->lun = 0;
>  	lrbp->intr_cmd = true;
> +#ifdef CONFIG_SCSI_UFS_CRYPTO
> +	lrbp->crypto_key_slot = -1; /* No crypto operations */
> +#endif

This should use ufshcd_prepare_lrbp_crypto(hba, NULL, lrbp),
like ufshcd_compose_dev_cmd() does.

- Eric
