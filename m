Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146D5C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E382B206E9
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594063773;
	bh=xIuH/H2+mWdDyVq+s+CoNqob/PyRS4e1Oxdpxt6PuTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ourVWrYTcigcGMOn2M3OGCSvn1iAuG2MHSJi6O3PT7V75Q9aU8ARw9qlLFSQ2BGSv
	 xUzziV0ufuYwW1jmmEsjfl4DCoJyjtmcDQ5UCDCxI4yqb688k/4jFDoqyXNXGoVblM
	 BPIX2L8PCQd1V07zwecPCZ4JOmG+CD7rhABmthoQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgGFT3d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGFT3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Jul 2020 15:29:33 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1468206B6;
        Mon,  6 Jul 2020 19:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594063773;
        bh=xIuH/H2+mWdDyVq+s+CoNqob/PyRS4e1Oxdpxt6PuTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gCy24i5ZAXT/e2r5pfxlnK99o00LvGdxHcgQZsaW7Ua9ImuPChWYYjO/KNtnH0rwX
         a7fAbPGBjccs+oo82+tAR9O1Y/E4dl59teBdB9BZeg4HPoOcPE8amBjgxQrB9ZsZ8/
         7cOCPQDPOxTlFovIiFviceLD46K0ERm1ZU3uJTcM=
Date:   Mon, 6 Jul 2020 12:29:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-scsi@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v3 3/3] scsi: ufs: Add inline encryption support to UFS
Message-ID: <20200706192931.GA833@sol.localdomain>
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
> Wire up ufshcd.c with the UFS Crypto API, the block layer inline
> encryption additions and the keyslot manager.
> 
> Many existing inline crypto devices require some additional behaviour not
> specified in the UFSHCI v2.1 specification - as such the vendor specific
> drivers will need to be updated where necessary to make it possible to use
> those devices. Some of these changes have already been proposed upstream,
> such as for the Qualcomm 845 SoC at
> https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-ebiggers@kernel.org/
> and for ufs-mediatek at
> https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/
> 
> This patch has been tested on the db845c, sm8150-mtp and sm8250-mtp
> (which have Qualcomm chipsets) and on some mediatek chipsets using these
> aforementioned vendor specific driver updates.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd-crypto.c | 30 ++++++++++++++------
>  drivers/scsi/ufs/ufshcd-crypto.h | 41 +++++++++++++++++++++++++--
>  drivers/scsi/ufs/ufshcd.c        | 48 +++++++++++++++++++++++++++-----
>  drivers/scsi/ufs/ufshcd.h        |  6 ++++
>  4 files changed, 107 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
> index 65a3115d2a2d..c13cf42652aa 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.c
> +++ b/drivers/scsi/ufs/ufshcd-crypto.c
> @@ -138,18 +138,17 @@ ufshcd_find_blk_crypto_mode(union ufs_crypto_cap_entry cap)
>  }
>  
>  /**
> - * ufshcd_hba_init_crypto - Read crypto capabilities, init crypto fields in hba
> + * ufshcd_hba_init_crypto_capabilities - Read crypto capabilities, init crypto
> + *					 fields in hba
>   * @hba: Per adapter instance
>   *
>   * Return: 0 if crypto was initialized or is not supported, else a -errno value.
>   */
> -int ufshcd_hba_init_crypto(struct ufs_hba *hba)
> +int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
>  {
>  	int cap_idx = 0;
>  	int err = 0;
>  	enum blk_crypto_mode_num blk_mode_num;
> -	int slot = 0;
> -	int num_keyslots;
>  
>  	/*
>  	 * Don't use crypto if either the hardware doesn't advertise the
> @@ -173,8 +172,8 @@ int ufshcd_hba_init_crypto(struct ufs_hba *hba)
>  	}
>  
>  	/* The actual number of configurations supported is (CFGC+1) */
> -	num_keyslots = hba->crypto_capabilities.config_count + 1;
> -	err = blk_ksm_init(&hba->ksm, num_keyslots);
> +	err = blk_ksm_init(&hba->ksm,
> +			   hba->crypto_capabilities.config_count + 1);
>  	if (err)
>  		goto out_free_caps;
>  
> @@ -200,9 +199,6 @@ int ufshcd_hba_init_crypto(struct ufs_hba *hba)
>  				hba->crypto_cap_array[cap_idx].sdus_mask * 512;
>  	}
>  
> -	for (slot = 0; slot < num_keyslots; slot++)
> -		ufshcd_clear_keyslot(hba, slot);
> -
>  	return 0;
>  
>  out_free_caps:
> @@ -213,6 +209,22 @@ int ufshcd_hba_init_crypto(struct ufs_hba *hba)
>  	return err;
>  }
>  
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
> +
>  void ufshcd_crypto_setup_rq_keyslot_manager(struct ufs_hba *hba,
>  					    struct request_queue *q)
>  {

Seems that these changes got folded into the wrong patch.
They should go in patch 2.

- Eric
