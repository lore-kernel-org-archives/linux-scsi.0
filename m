Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927E0C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiKISYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiKISYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:24:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A49178B2
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 10:24:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B3F5B81F6A
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 18:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76026C433D6;
        Wed,  9 Nov 2022 18:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668018273;
        bh=r0os0TEsiCi8glhqa3Fb2Angc7O2Ahg4RXGfFI12Yhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rGxpxdl/dKGzy9ONJ6Rlg900dkZUDi6K5augz+dEbYsuJU8AMAjTKo23DlgpHnXch
         zP3h3/IAIBYwheoBY44K8udov40h3dN69j8umzYRVAYaHN/xw319DzXxyL0POnePxJ
         fTXPhLXC0rbfYNbSn5iBwF1+DBpP8mfxAckBkRxHZCrau28/dT+LugJFSsLiqb7dq3
         axTiEa72bu1Pp6Levc99ZoP2miHEseSKL61xDDpWC/yg8FfMXS6FhAhTJd8PaFdCi7
         19VJs3BgHuZca7VmeYeJGHf5YAzr+CK0ml7+JTLlL6dBhrnipEtAd2n/ODRgf2eGm+
         3jHUM/YvscPqQ==
Date:   Wed, 9 Nov 2022 10:24:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Message-ID: <Y2vwX3XlibvDi70/@sol.localdomain>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108233339.412808-6-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 08, 2022 at 03:33:39PM -0800, Bart Van Assche wrote:
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index 4cc2dbd79ed0..49017abdac92 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -124,3 +124,13 @@ config SCSI_UFS_EXYNOS
>  
>  	  Select this if you have UFS host controller on Samsung Exynos SoC.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> +	bool "Variable size UTP physical region descriptor"
> +	help
> +	  In the UFSHCI 3.0 standard the Physical Region Descriptor (PRD) is a
> +	  data structure used for transferring data between host and UFS
> +	  device. This data structure describes a single region in physical
> +	  memory. Although the standard requires that this data structure has a
> +	  size of 16 bytes, for some controllers this data structure has a
> +	  different size. Enable this option for UFS controllers that need it.

This shouldn't be a user-selectable option.  Just make it be enabled
automatically when it is needed.  Like this:

config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
	bool
	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO

Also, this patch doesn't make sense without the code that actually needs it, so
I hope you plan to send that upstream too.  I haven't been able to do so yet,
because no platform with this hardware actually can run the upstream kernel at
all, as far as I know.  Maybe commit 06874015327 ("arm64: dts: exynos: Add
initial device tree support for Exynos7885 SoC") changed that?  Any suggestions
would be greatly appreciated...  How are you testing this?

> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index bd45818bf0e8..c6854514e40e 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -754,6 +754,9 @@ struct ufs_hba_monitor {
>   * @vops: pointer to variant specific operations
>   * @vps: pointer to variant specific parameters
>   * @priv: pointer to variant specific private data
> +#ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> + * @sg_entry_size: size of struct ufshcd_sg_entry (may include variant fields)
> +#endif
>   * @irq: Irq number of the controller

It doesn't make sense to have an #ifdef in the middle of a comment.

- Eric
