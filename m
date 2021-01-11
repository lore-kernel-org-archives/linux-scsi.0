Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554B3C4321A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B15922CF7
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405528AbhALAZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390752AbhAKWpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 17:45:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5E6222CAF;
        Mon, 11 Jan 2021 22:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610405105;
        bh=chIuNkxQOqz1a6QXqkz+qMeyAZzOJBFgOOVyoy2AHg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lXVSvkmweExnqRTKLa4hpHUhuJffG6JpHvCiOnlK86JHt7ENw9EteCKmdUipxAR0J
         v9yc3z0R6Tb0vKtcvrbJCcEFhAiaWp6us0g7wJo06bmKcI4j3FKVmFlEHWwHF+0iqh
         OhM/aLkcLfIApH8H3zQbBNjLpbsF8pkMz2XLda9nJ4rGteA6tzhxHnJwWnn55ZPYRU
         WHIvLyQAS5mVXZx+jKx/Zo143FY44JUZG0ajrJN0RFhwRWSxQJy6KnfK2hXyYf81W/
         TXJ7pNJoRCmyXXhQUzQqWNsvk8ag1wfFpq83ZDE1KU5w5IC7iXRV8Ru7HD99vKSqNE
         5fb44Pgt8gEPQ==
Date:   Mon, 11 Jan 2021 14:45:02 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, satyat@google.com,
        shipujin.t@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Remove unnecessary devm_kfree
Message-ID: <X/zU7uWK5s22th4B@sol.localdomain>
References: <20210111223202.26369-1-huobean@gmail.com>
 <20210111223202.26369-3-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111223202.26369-3-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 11, 2021 at 11:32:02PM +0100, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> The memory allocated with devm_kzalloc() is freed automatically
> no need to explicitly call devm_kfree.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd-crypto.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
> index 07310b12a5dc..ec80ec83cf85 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.c
> +++ b/drivers/scsi/ufs/ufshcd-crypto.c
> @@ -182,7 +182,7 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
>  	err = blk_ksm_init(&hba->ksm,
>  			   hba->crypto_capabilities.config_count + 1);
>  	if (err)
> -		goto out_free_caps;
> +		goto out;
>  
>  	hba->ksm.ksm_ll_ops = ufshcd_ksm_ops;
>  	/* UFS only supports 8 bytes for any DUN */
> @@ -208,8 +208,6 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
>  
>  	return 0;
>  
> -out_free_caps:
> -	devm_kfree(hba->dev, hba->crypto_cap_array);
>  out:
>  	/* Indicate that init failed by clearing UFSHCD_CAP_CRYPTO */
>  	hba->caps &= ~UFSHCD_CAP_CRYPTO;

Looks fine, feel free to add:

	Reviewed-by: Eric Biggers <ebiggers@google.com>

I think this was here to free the memory in the case where the crypto support
gets disabled but the UFS host initialization still continues, so that the space
wouldn't be wasted.  But that's not what happens, as this is only reached on
ENOMEM which is a fatal error.

- Eric
