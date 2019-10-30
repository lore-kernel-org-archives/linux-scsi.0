Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53BACA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 12:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F1852080F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 12:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZQprLW6L";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aQ+A1RVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfJ3Mnc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 08:43:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40586 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfJ3Mnc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 08:43:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2995060FEC; Wed, 30 Oct 2019 12:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572439411;
        bh=gtP9LfS5sCqnnlWgSSUJdbnN/P+H+DyR6tGOfbevBa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZQprLW6LCRVPBpRQQJhcS3XJF938VcYFw62n74Z6Fthy0yNAmkDjQAAzAsft85xY0
         Ymhk109Kma3gJ8FFusz0BBcMms5TkyFnJ70Y0hqogfhb6Zyv6sL3VOQ6WPfbxRiEYH
         GzKa4lBIfYAtdVXIJjsfeBstlOcpVq3FH7ggBnxI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 0A97660F5C;
        Wed, 30 Oct 2019 12:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572439410;
        bh=gtP9LfS5sCqnnlWgSSUJdbnN/P+H+DyR6tGOfbevBa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aQ+A1RVKqcRob0ei50QvOPjlkE0beOrqmBJz1zSmC7Agc8572oMlHgZnnxnI/7OZK
         KtwyOuhd0XoJJ8Ugl4x4kfKVSeu+Izv86FpqVw4phRYz/AlKskQlZBy9KBDK/KGHAC
         Ih3WCO2pAn4+bbLHQgDqsyySaC2KeUqWWNjU3xaQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 30 Oct 2019 20:43:29 +0800
From:   cang@codeaurora.org
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     'Alim Akhtar' <alim.akhtar@samsung.com>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Pedro Sousa' <pedrom.sousa@synopsys.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        'Evan Green' <evgreen@chromium.org>,
        'Stanley Chu' <stanley.chu@mediatek.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v1] scsi: ufs: delete redundant function
 ufshcd_def_desc_sizes()
In-Reply-To: <BN7PR08MB5684A3ACE214C3D4792CE729DB610@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <BN7PR08MB5684A3ACE214C3D4792CE729DB610@BN7PR08MB5684.namprd08.prod.outlook.com>
Message-ID: <32de5877a1fc6da9e0b23936d83ad956@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-29 22:22, Bean Huo (beanhuo) wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> There is no need to call ufshcd_def_desc_sizes() in ufshcd_init(),
> since descriptor lengths will be checked and initialized later in
> ufshcd_init_desc_sizes().
> 
> Fixes: a4b0e8a4e92b1b(scsi: ufs: Factor out ufshcd_read_desc_param)
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c28c144d9b4a..21a7244882a1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6778,23 +6778,13 @@ static void ufshcd_init_desc_sizes(struct 
> ufs_hba *hba)
>  		&hba->desc_size.geom_desc);
>  	if (err)
>  		hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
> +
>  	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_HEALTH, 0,
>  		&hba->desc_size.hlth_desc);
>  	if (err)
>  		hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
>  }
> 
> -static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
> -{
> -	hba->desc_size.dev_desc = QUERY_DESC_DEVICE_DEF_SIZE;
> -	hba->desc_size.pwr_desc = QUERY_DESC_POWER_DEF_SIZE;
> -	hba->desc_size.interc_desc = QUERY_DESC_INTERCONNECT_DEF_SIZE;
> -	hba->desc_size.conf_desc = QUERY_DESC_CONFIGURATION_DEF_SIZE;
> -	hba->desc_size.unit_desc = QUERY_DESC_UNIT_DEF_SIZE;
> -	hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
> -	hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
> -}
> -
>  static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
>  	{19200000, REF_CLK_FREQ_19_2_MHZ},
>  	{26000000, REF_CLK_FREQ_26_MHZ},
> @@ -8283,9 +8273,6 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  	hba->mmio_base = mmio_base;
>  	hba->irq = irq;
> 
> -	/* Set descriptor lengths to specification defaults */
> -	ufshcd_def_desc_sizes(hba);
> -
>  	err = ufshcd_hba_init(hba);
>  	if (err)
>  		goto out_error;

Reviewed-by: Can Guo <cang@codeaurora.org>

Best regards
Can Guo
