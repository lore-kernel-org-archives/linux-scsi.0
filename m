Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A46C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 09:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbiC1JWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 05:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239727AbiC1JWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 05:22:05 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137539FE9
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 02:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648459223; x=1679995223;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LFPSLQaFilhfnDen4eZXPcOYMyeDq38BacsVPsDsYC0=;
  b=R5TENETbQvvnktAvT9Vj1ppsZrv+6p6CNe7EYcA9oYCNZ15/mdr51g9u
   x3KJ7tMaTs0Gp4ytxjvPfrwC0mjFj+YWvAoKcn5Xk/fVYYo62Vx+jL0e1
   BySZ7mvXMX5hNzOc5RZTPPasvBa3xbAnyMD5XoXro2c5xA+/CkJ686JZp
   mEsvkTMqTTyYM/WDiKsNWqWy3GoS+GIE+TZyqoMojZrD2R1xgl5kEvAAO
   1MvK2Gi8wuxN2HUORuN7LVxj5DyXVu2EysEBO2hTeGl5rh68j0ffopXRv
   YWxy5bSeBOFO26RQCAfvXJTiG/hXdWAoc8+jrj6w/YIkaIJaE7UyNtUDt
   g==;
X-IronPort-AV: E=Sophos;i="5.90,217,1643644800"; 
   d="scan'208";a="201276427"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2022 17:20:23 +0800
IronPort-SDR: YRxep+GbsbKgOTu4i8m5ivYOxdvrw3yzKRSIpOAKBgQu9Mp81bUfEd+Ja7aqL2OFvLZHuZQHSx
 9jl8sHBwW9nK27K60b12886etB4WXvBbUP7mSAFYFNs0a2csCfG5RmJcCJ0j0ycbqFulWEuhLU
 qnjPjQczC5VorVWfnCjVpB55Fik37oOjfCQ42owaBKmY+2X/pKu62evuH2/q80PgcFAUw843oh
 88elK1t9xXzetmo6lVlPCEARChK1tgcDbqN3m85en5M/ftWJ3iGbIlEaCovyGVCOWEg24sevcL
 lC992riFskpSoJJM3T+JpdWz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Mar 2022 01:51:17 -0700
IronPort-SDR: nL9pL7ff7xkArmpB8X5Pc5+vR2fjIo0SN0WjIcC8aA4QbawEH7gBktC7pIQwx5S1s36ofroX0a
 d1NyShbzi/PmFMKAmvEHJKThUjwtqyxkoLIDHwehRePEMwumqHxtJarrl6ACH82Mug51Z++nBZ
 1i/SK2xyEP3ZgyFhntML4lm0dHhNM5uHKiB4PZjbSbm33ucZf6GYZ5vLF7TA54UdxsFHIC57eD
 qYyK5uwaE1InRmnQjP9vcB/p3E2sMH0IqaW9sB3CQCtTvO7FYebyFWFnWCLG8A3P0WU9PlUrKP
 zEs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Mar 2022 02:20:24 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KRnGv6k0Lz1Rwrw
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 02:20:23 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1648459223; x=1651051224; bh=LFPSLQaFilhfnDen4eZXPcOYMyeDq38Bacs
        VPsDsYC0=; b=BSvPVuQLzI5yI2XsmnjXtXZkMRtLP3JAWQlOv525r6F53Ljofd4
        4RXq0Tfd8eWPV0p5QMbsTw89Mxx+5a4JsZ5HX6XElpritE+sNsMCf8hFjMY6h3ay
        iQSdWhyX5Ih85yPfU8uSp7erSS7xUA2tybATvNSbuponeA+tB+XWWFZygSDgXgyg
        LpSauUTkJpaL/r3+fMiV+wQyRd38cRIDSk8SWsuuxzm0GMs2Li/q4Y8WQv1LS8sI
        Lo+9XX62u5NguKtlk3YoblsBem0EhwDDhNvB74SfaPqNW29SER1FHtPJegY/52lD
        pMc4IyWkzLkAWnOcq48tFt33Z0N5FR+BVlQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rGI2-7OFPtKz for <linux-scsi@vger.kernel.org>;
        Mon, 28 Mar 2022 02:20:23 -0700 (PDT)
Received: from [10.225.163.121] (unknown [10.225.163.121])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KRnGt3ysZz1Rvlx;
        Mon, 28 Mar 2022 02:20:22 -0700 (PDT)
Message-ID: <6f377bbf-9797-7838-e0f0-631c38f85faf@opensource.wdc.com>
Date:   Mon, 28 Mar 2022 18:20:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] scsi: pm80xx: mask and unmask upper interrupt vectors
 32-63
Content-Language: en-US
To:     Ajish Koshy <Ajish.Koshy@microchip.com>, linux-scsi@vger.kernel.org
Cc:     Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        john.garry@huawei.com, Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
 <20220328084243.301493-2-Ajish.Koshy@microchip.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220328084243.301493-2-Ajish.Koshy@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/28/22 17:42, Ajish Koshy wrote:
> When upper inbound and outbound queues 32-63 are enabled, we see upper
> vectors 32-63 in interrupt service routine. We need corresponding
> registers to handle masking and unmasking of these upper interrupts.
> 
> To achieve this, we use registers MSGU_ODMR_U(0x34) to mask and
> MSGU_ODMR_CLR_U(0x3C) to unmask the interrupts. In these registers bit
> 0-31 represents interrupt vectors 32-63.
> 
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 35 +++++++++++++++++++++++++++-----
>  1 file changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 9bb31f66db85..b92e82a576e3 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1728,9 +1728,20 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  {
>  #ifdef PM8001_USE_MSIX
>  	u32 mask;
> -	mask = (u32)(1 << vec);
> +	u32 vec_u;
>  
> -	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
> +	if (vec < 32) {
> +		mask = (u32)(1 << vec);
> +		/*vectors 0 - 31*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR,
> +			    (u32)(mask & 0xFFFFFFFF));
> +	} else {
> +		vec_u = vec - 32;
> +		mask = (u32)(1 << vec_u);
> +		/*vectors 32 - 63*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
> +			    (u32)(mask & 0xFFFFFFFF));
> +	}
>  	return;
>  #endif
>  	pm80xx_chip_intx_interrupt_enable(pm8001_ha);
> @@ -1747,11 +1758,25 @@ pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  {
>  #ifdef PM8001_USE_MSIX
>  	u32 mask;
> -	if (vec == 0xFF)
> +	u32 vec_u;
> +
> +	if (vec == 0xFF) {
>  		mask = 0xFFFFFFFF;
> -	else
> +		/* disable all vectors 0-31, 32-63*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, mask);
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, mask);
> +	} else if (vec < 32) {
>  		mask = (u32)(1 << vec);
> -	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
> +		/*vectors 0 - 31*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR,
> +			    (u32)(mask & 0xFFFFFFFF));

mask is a u32, so the "& 0xFFFFFFFF" seems to be completely pointless...
And pm8001_cw32() takes a u32 value as last argument so the cast is also
pointless.

> +	} else {
> +		vec_u = vec - 32;
> +		mask = (u32)(1 << vec_u);

Cast not needed and this should probably be "1U << vec_u".
Also, the vec_u variable seems completely unnecessary.

> +		/*vectors 32 - 63*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
> +			    (u32)(mask & 0xFFFFFFFF));

Same here: The cast and masking are not needed.

> +	}
>  	return;
>  #endif
>  	pm80xx_chip_intx_interrupt_disable(pm8001_ha);


-- 
Damien Le Moal
Western Digital Research
