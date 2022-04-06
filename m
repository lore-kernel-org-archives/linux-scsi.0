Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7BBC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 09:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346552AbiDFJbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582849AbiDFJWM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 05:22:12 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785BE2706
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 20:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649214165; x=1680750165;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xLYeIzpE7JMPtN2mYXxJbH0QzN58v5C1//5Cz+Tsrjg=;
  b=FBpnXv8KjjCcCzWWzgERBb/YkAPAKSEpHtlsM7INsr8Dctib5AkDOe5q
   WEImuVR/cqeYTa79ASjYejGzJIqWbs2G+lt99Rxy9PDk8tPDs+lB/nvKo
   Vv1K9GwKI0jfyG26urv4hEr8WbqoFlz4g9QhCqBz7yNdwSGd0fVwAwrMY
   xpsjkgilBvI7j+kc7naU9UZEDaB2PL/8t0TTdlQF6+pCFacHE0PcPu1lD
   F8dcI2NqhSsJOTnBIJGRJXlrhJaQhPMaJoi349vTM17tXlkrLIxju/t4y
   VhNa82GyJJQr5FsIePYPfrc4YeuK5cR55MQCg4tcPoE/JaDi/I5KQsaht
   w==;
X-IronPort-AV: E=Sophos;i="5.90,238,1643644800"; 
   d="scan'208";a="301366223"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2022 11:02:44 +0800
IronPort-SDR: Qj88baJdB/V/GCjqyYa7WG+3FczJJX64qPWQUwROgleNJzaYXZqn+ZUrxHDpfbicDuZ6Ta+9yw
 P0OgTIcaC5ryvN76n1vq6uUBHOeVjolkTg9g2vRdCKkLeb/tzrOH3MqXZdVvsPAKjUTtSx29hi
 xrxfylTvj890m4NdBoaVeXW1lh4cHcb45qNjVrQG1l6wZewEwvg26/fn0lmLOJ9hnXFt0UBXy7
 hYL3K/+kI3c9FRCSqHuVfIJZpUIj2qMh4Gn01S8EhtOq5Kbp7wHjaq8zIAUk3yuGF7kTWTKfNI
 dAgGyKWdOhspX7dqYBhr/B3R
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Apr 2022 19:34:17 -0700
IronPort-SDR: NbO9tOVeUpSP6IF9JW8CClXqinK8//sFQDhCInTVopooHWOkEpwf10oThzO8Df1s/lEZV5XGCt
 cdl+XMWqr+SfL/a8Fdej00FfawYZZfdv4n8Oy2gxUhUYjXQ/B2JYSfkP3BFrryQ/1YAappKJVS
 8OroJoeaYzTWLNJhyl7tSkhGIy5Py8Q3GvcmU7TRf/NnzShomk9oFlATKd+PqnN7xFB1lIXeGO
 yueeDz9NbEmy+59qLjhdX4F4JXcByJ/vOvr/BTf3jvjSeM51zzSqS4IDI/IG9NqTLywJ0BahtR
 oNA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Apr 2022 20:02:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KY8T00r3rz1Rwrw
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 20:02:44 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649214163; x=1651806164; bh=xLYeIzpE7JMPtN2mYXxJbH0QzN58v5C1//5
        Cz+Tsrjg=; b=MYK6df3GyPOrzNDBB+0Qbo4NczEMFDNbzrmo4CCAt2z2d8ac9HX
        Rhlaw1nimhXaV3IJ/MBiaYioPEWRYB910j/bCtK+wZaTGbUxKVYG0o/9yzBSV5L1
        sYTzqvfmG/diOI9qRH+ob+oVfhQqYB0VWHNxK4eILmw6w3ALfBHekjM+Mmgaibne
        LSPj+M388iB3jHgdcq4c26C8joy/U6sR46+JHWbrBt9D5Owm/Z+Es53iQNXperba
        bNqtpfl3vjKPRFtliFM85i5YD4BaVWsgRaNpCPbP/jxALIbt4vyXY0DPAksJLMgJ
        8ywNxlo6Rn1cp92xPDdLZt5eGcyUWSwso1g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xKssJ_xWcy4h for <linux-scsi@vger.kernel.org>;
        Tue,  5 Apr 2022 20:02:43 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KY8Sy4hfbz1Rvlx;
        Tue,  5 Apr 2022 20:02:42 -0700 (PDT)
Message-ID: <3f94f4e6-762b-d1af-7021-45e5b250ab6d@opensource.wdc.com>
Date:   Wed, 6 Apr 2022 12:02:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] scsi: pm80xx: mask and unmask upper interrupt
 vectors 32-63
Content-Language: en-US
To:     Ajish Koshy <Ajish.Koshy@microchip.com>, linux-scsi@vger.kernel.org
Cc:     Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        john.garry@huawei.com, Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20220405092833.83335-1-Ajish.Koshy@microchip.com>
 <20220405092833.83335-2-Ajish.Koshy@microchip.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220405092833.83335-2-Ajish.Koshy@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/5/22 18:28, Ajish Koshy wrote:
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
> Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
> ---
>   drivers/scsi/pm8001/pm80xx_hwi.c | 31 +++++++++++++++++++++++++------
>   1 file changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 9bb31f66db85..3e6413e21bfe 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1728,9 +1728,17 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>   {
>   #ifdef PM8001_USE_MSIX
>   	u32 mask;
> -	mask = (u32)(1 << vec);
>   
> -	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
> +	if (vec < 32) {
> +		mask = 1U << vec;

Nit: Drop this...

> +		/*vectors 0 - 31*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, mask);

...and do:

		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, 1U << vec);

> +	} else {
> +		vec = vec - 32;
> +		mask = 1U << vec;
> +		/*vectors 32 - 63*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U, mask);

And here:

		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
			    1U << (vec - 32));

Then you do not need the mask variable.

> +	}
>   	return;
>   #endif
>   	pm80xx_chip_intx_interrupt_enable(pm8001_ha);
> @@ -1747,11 +1755,22 @@ pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>   {
>   #ifdef PM8001_USE_MSIX
>   	u32 mask;
> -	if (vec == 0xFF)
> +
> +	if (vec == 0xFF) {

This is not symmetric with pm80xx_chip_interrupt_enable(). Does 
pm80xx_chip_interrupt_enable() need the same case too ?

>   		mask = 0xFFFFFFFF;
> -	else
> -		mask = (u32)(1 << vec);
> -	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
> +		/* disable all vectors 0-31, 32-63*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, mask);
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, mask);

Similar here, no need for the mask variable.

		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 0xFFFFFFFF);
		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, 0xFFFFFFFF);

> +	} else if (vec < 32) {
> +		mask = 1U << vec;
> +		/*vectors 0 - 31*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, mask);

And here.
		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 1U << vec);

> +	} else {
> +		vec = vec - 32;
> +		mask = 1U << vec;
> +		/*vectors 32 - 63*/
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, mask);

And here.
		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
			    1U << (vec - 32));

> +	}
>   	return;
>   #endif
>   	pm80xx_chip_intx_interrupt_disable(pm8001_ha);


-- 
Damien Le Moal
Western Digital Research
