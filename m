Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C05C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 00:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344285AbhLBATz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 19:19:55 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41871 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbhLBATx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 19:19:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638404192; x=1669940192;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fwQYE5YGlHzG1+y9UKZarfKQm8Ini2bY+Ad8LpucwpU=;
  b=hUyRrqbG1/Sdundc/mIlbE+ek7Kr26HCghQpGkMfszihfuWg2cyOOq+D
   r+TpHO0WZCmxKNoYRLE5GeYnzZE5f/uLcPKHBxdQhROfhVHxNoCVJWJmM
   Sr3J3rdKWLR6QT2cUFYy2S/st2FS/HtqYpC0Ife9+K3ew5xgRvWS7Fikm
   vOzfeU8izsK9VK1qTpUJgVCghGo6jNLJ8cD9v8OlpO8NC8sOpFWv1hQZz
   eTN/kuRQNMzJEqqr9Xx0LGVUIzq4aN7vzDvKcgJIh+XIgu6Mp0KNuqLmK
   6TSaC3lVLC2gvZmaUu3SuESCCODvNhUvRTTnaX5W+A9EQvAu4dSNonMci
   g==;
X-IronPort-AV: E=Sophos;i="5.87,280,1631548800"; 
   d="scan'208";a="186214670"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Dec 2021 07:51:58 +0800
IronPort-SDR: 7fuZil3RLi7B/4hauo8vAGZbt1HLBpjDkwstAQl2RIf2TWZ4ECWkYcF8gg5dhzA3daNbr2NQgi
 4fCKtso+vPCCEWCBO5CW4n4xlpjCt6w7nUZhaU2bu66jMAtYdoXZfEKlzy4bBw8nn1Ni4RIDWm
 PST+m0Sjh1JlGSMDXkXDYJFU6zvL4TRpRSMJWzqSEpMjtEz1NWsm6utr1BKQZbs7NV1z6UwDYU
 Brbhf0JC6ISq28XTSWBoN/26/TGOxbYrOB4yR/wPB6ji+P4QOtqk1q0UQ10CUAzUIPivpeI5Hh
 bx0RJBaN6Zu0HPv4yzkXMJBp
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 15:26:41 -0800
IronPort-SDR: IgpxJOy6Y0IisI3BFaZTaz7IHMnNfbVTEyn+GhZmiJP7bP4V6i9tIKOXx8Ct5/tdwesYGM9NXu
 v4TYEW4amOejJJazTgbEyHA56YYVClzN8BaKD6hY/yh3SA++n19N168/Q5af0FSRgfLtT7oQsU
 MbRWb3szdqWvNxLnnRgvV+bw4wf6iwTQrv8XZu1PMDEriy7ezvgiO8eqIJa8z+5S2ZyMArlAue
 39LxNETZ3rM2NHOcPjuaoTSvb41hmDFVReLGBOY19MmNzbDlRDIlsEQC92NJmTZ+ljB8075Zi1
 rKQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 15:51:59 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J4G8Y4yZrz1RtVn
        for <linux-scsi@vger.kernel.org>; Wed,  1 Dec 2021 15:51:57 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1638402717; x=1640994718; bh=fwQYE5YGlHzG1+y9UKZarfKQm8Ini2bY+Ad
        8LpucwpU=; b=Xiy9Zj1t8N0e0YHG+NM6HByGLyMlT+Qat/doNEDQgXD+C4cRIDf
        TKsM+vtsI4ySopw2tL0D3rOIqchEnAzsu3qfGIFq111omy6c9/3BkbHlOti7ZF9z
        MY2pC+UCs0kGmgaViFDUDwPXP3VhpHBps3XvznJOrO90b5Urr8iWgfNnADwgI61c
        FeCy0GTq5cznw+5Y89dub3Xf5tcr/rpvAVlVPHyACSze5/UCroG3HeJ1ZnJVAWjJ
        0crLRPx7SCy17FjvwrKE7uQiPzqtsSWGeUvlXMqUhmBqwgK9aR/YJh96DZsU1Zb0
        oY9t0li7TEVTIMk5CnWVsrOvokHKMCctNKw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6z-4hEcfB0ph for <linux-scsi@vger.kernel.org>;
        Wed,  1 Dec 2021 15:51:57 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J4G8X519Zz1RtVl;
        Wed,  1 Dec 2021 15:51:56 -0800 (PST)
Message-ID: <98db1d5d-2b19-6bd9-01fd-2f5cb462d0d3@opensource.wdc.com>
Date:   Thu, 2 Dec 2021 08:51:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v3 1/2] scsi: sd_zbc: Simplify zone full condition check
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211201142821.64650-1-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211201142821.64650-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/12/01 23:28, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> According to the ZBC (and ZAC) specification, a zone that has Zone Type set
> to Conventional, must also have its Zone Condition set to
> "Not Write Pointer".
> 
> Therefore, a conventional zone will never have Zone Condition set to
> "Full", which means that we can omit the non-conventional prerequisite from
> the zone full condition check.
> 
> Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
> Changes since v2:
> - New patch in series, as suggested by Damien.
> 
>  drivers/scsi/sd_zbc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index ed06798983f8..749c5e5a70c7 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -62,8 +62,7 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
>  	zone.capacity = zone.len;
>  	zone.start = logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
>  	zone.wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
> -	if (zone.type != ZBC_ZONE_TYPE_CONV &&
> -	    zone.cond == ZBC_ZONE_COND_FULL)
> +	if (zone.cond == ZBC_ZONE_COND_FULL)
>  		zone.wp = zone.start + zone.len;
>  
>  	ret = cb(&zone, idx, data);
> 

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
