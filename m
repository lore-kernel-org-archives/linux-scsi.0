Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78086C4363C
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 17:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48CB020758
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 17:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601658561;
	bh=XkJhhfg+ucSqL54w1TIz8V8cWXLZKBm/Z7c5yzqPaMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZzClYDfz0Rv3hnJUBC3MvlyHHWvDqXzGj6TEvGQf3XBxQzFLkemNHitA497knPKFx
	 PSAl58YeslQ3/MuujXbFg/fS8lffoQPdFmun5CiPSn+PC0NsoK+Un2FdXG4r+blfpE
	 8vJpzQhTZozuawR1AubqN0z0GJcoTQWUBP9On/2k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388141AbgJBRJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 13:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbgJBRJR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 13:09:17 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC03C205ED;
        Fri,  2 Oct 2020 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601658557;
        bh=XkJhhfg+ucSqL54w1TIz8V8cWXLZKBm/Z7c5yzqPaMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VkZ5a2fYAyrxdUEU/k19Iva7CNZw4aV3k1fJ3wcIKa9aNCo2TKEd8DT5IOhvuV/gW
         sbcWrHkP5QVVtyItCGlE5+Vbcg4XxDxxbGb2EHxr3BgTtAJIKS2MHPhlkjyR33G4Bz
         V9Iwc2xEBZoK6nFvStRJEygFemItok06jVFtkIjY=
Date:   Fri, 2 Oct 2020 10:09:15 -0700
From:   ebiggers@kernel.org
To:     Pujin Shi <shipujin.t@gmail.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Satya Tangirala <satyat@google.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hankinsea@gmail.com
Subject: Re: [PATCH v2] scsi: ufs: fix missing brace warning for old compilers
Message-ID: <20201002170915.GA2119452@gmail.com>
References: <20201002063538.1250-1-shipujin.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002063538.1250-1-shipujin.t@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 02, 2020 at 02:35:38PM +0800, Pujin Shi wrote:
> For older versions of gcc, the array = {0}; will cause warnings:
> 
> drivers/scsi/ufs/ufshcd-crypto.c: In function 'ufshcd_crypto_keyslot_program':
> drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: missing braces around initializer [-Wmissing-braces]
>   union ufs_crypto_cfg_entry cfg = { 0 };
>         ^
> drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: (near initialization for 'cfg.reg_val') [-Wmissing-braces]
> drivers/scsi/ufs/ufshcd-crypto.c: In function 'ufshcd_clear_keyslot':
> drivers/scsi/ufs/ufshcd-crypto.c:103:8: warning: missing braces around initializer [-Wmissing-braces]
>   union ufs_crypto_cfg_entry cfg = { 0 };
>         ^
> 2 warnings generated
> 
> Fixes: 70297a8ac7a7 ("scsi: ufs: UFS crypto API")
> Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
> ---
>  drivers/scsi/ufs/ufshcd-crypto.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
> index d2edbd960ebf..07310b12a5dc 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.c
> +++ b/drivers/scsi/ufs/ufshcd-crypto.c
> @@ -59,7 +59,7 @@ static int ufshcd_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
>  	u8 data_unit_mask = key->crypto_cfg.data_unit_size / 512;
>  	int i;
>  	int cap_idx = -1;
> -	union ufs_crypto_cfg_entry cfg = { 0 };
> +	union ufs_crypto_cfg_entry cfg = {};
>  	int err;
>  
>  	BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID != 0);
> @@ -100,7 +100,7 @@ static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
>  	 * Clear the crypto cfg on the device. Clearing CFGE
>  	 * might not be sufficient, so just clear the entire cfg.
>  	 */
> -	union ufs_crypto_cfg_entry cfg = { 0 };
> +	union ufs_crypto_cfg_entry cfg = {};
>  

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>
