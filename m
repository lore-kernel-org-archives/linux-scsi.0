Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C478C4727D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 04:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE74B20874
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 04:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601612355;
	bh=VNJapsQTTyEmiuSQJg6sqrJGIXXBuxZSpS+OAzNcVm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=klrDR9X5l6jHMmw9W3zLjjfdisgELK7XeZZ4dO1RgZ1uSeq9dFHKSBsR09peKzX93
	 m+gOh+F8gOS7AtfIxWtHMKsjZ4wae/sIpEa2HUobKyyNwyrmSjslzGhnKJgaezCgoY
	 NKbK7fYTjWj5eWpy5U2eiwvV14bQ2rTrMS1/LlpU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgJBETN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 00:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgJBETM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 00:19:12 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 589E920796;
        Fri,  2 Oct 2020 04:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601612352;
        bh=VNJapsQTTyEmiuSQJg6sqrJGIXXBuxZSpS+OAzNcVm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K89zENm0GcOS4C1dUyty0oeWptjfCLrtXMUt+15Jp1eDyjKnqtAMoQu3Rm8qKyOqV
         FSWS8i5Et4I+SWKlOybASR3Rop8GkaQxP8PR/YO7B3rQk3++v0QjWYixya02T8PFzj
         P1hTfSpOYbwF+jnynnoWJGD6S1QevfuVs1ZlktJw=
Date:   Thu, 1 Oct 2020 21:19:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pujin Shi <shipujin.t@gmail.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Satya Tangirala <satyat@google.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hankinsea@gmail.com
Subject: Re: [PATCH 1/2] scsi: ufs: Use memset to initialize variable in
 ufshcd_crypto_keyslot_program
Message-ID: <20201002041910.GB78003@sol.localdomain>
References: <20201002040518.1224-1-shipujin.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002040518.1224-1-shipujin.t@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 02, 2020 at 12:05:17PM +0800, Pujin Shi wrote:
> Clang warns:
> 
> drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: missing braces around initializer [-Wmissing-braces]
>   union ufs_crypto_cfg_entry cfg = { 0 };
>         ^
> 

Which version of clang?  I don't see the warning with clang 10.0.1
(or with gcc 10.2.0).

> Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
> ---
>  drivers/scsi/ufs/ufshcd-crypto.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
> index d2edbd960ebf..8fca2a40c517 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.c
> +++ b/drivers/scsi/ufs/ufshcd-crypto.c
> @@ -59,9 +59,11 @@ static int ufshcd_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
>  	u8 data_unit_mask = key->crypto_cfg.data_unit_size / 512;
>  	int i;
>  	int cap_idx = -1;
> -	union ufs_crypto_cfg_entry cfg = { 0 };
> +	union ufs_crypto_cfg_entry cfg;
>  	int err;
>  
> +	memset(&cfg, 0, sizeof(cfg));
> +

How about an empty initializer?

	union ufs_crypto_cfg_entry cfg = {};

Same comments on your other patch.

- Eric
