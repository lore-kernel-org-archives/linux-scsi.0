Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16F5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 22:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhKSWh4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 17:37:56 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:58479 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhKSWh4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 17:37:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637361294; x=1668897294;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I37dPb10B6UldGO1fL5ChQ7Ab0LfhdW5k30q43BOSOs=;
  b=gBaCZGLZrkpj6vgcy05sPo23grRDtwmTRZM51ydW9ekk4do5s0qH1DLJ
   HDd2TLkT8MWwpW0j4Df8yIWPAyHWwLFtM7KeLSWjoj2vwnoq54+wzBIU+
   ELgWG0beini8RgDa5dh5o77Y/xxlWvlOd17qY5kKHwAqgeT7aXnrGrjEq
   H5QOAiRm9sTnM0aFURhEEZOdpezvBVl5WP8AIBSyY24qQgUCVLd4yLFkX
   OA/Q1r3kb/J01rr4sNuIfhU4wN9ggS/BZv3p8VfsaW28FgFGmNavkAfZK
   imp9QXEhYA4jEwQdynj5jKrFt2kL2OMTmTwvfW9/xW0K9yjYDuVK9ko5s
   A==;
X-IronPort-AV: E=Sophos;i="5.87,248,1631548800"; 
   d="scan'208";a="187149573"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2021 06:34:54 +0800
IronPort-SDR: 60kHEOlOeQtmoIK9v4K7dPSQ9rJoSo2h9pldxxPijV3BP7riGbWjGuS1lEjPc1Wt2QoOJm9v1V
 RjCEMgF6+LZkwbkeglfFfxvyf63K1j9SvLN+TEfywDqfGxKm+9kjxczXqn+KbbqMlWvmsOLihO
 uw/rm1K4qvxLs8m2wviRIkEAjOPv2uNSfrICi+BuDHBis3Zrx8neeyD2ot88Dowwvb6+h1xRiC
 Lb9hfs/F3vpONZLe/Bze+TgMGD9cY367AWD5D8eBOljYm7vR5xlTO8UD5Q3LiaqIwRadj2FEPA
 gX9Q97Jak74JtBEiUVhmkkPv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 14:08:19 -0800
IronPort-SDR: fgIvaO4rrlvBNQfJFulMzlnyhzgJecGmY/6QyWbWs0bQmBlsdj/yznDru8L6Kx8/9Fa1LGDqkF
 BOf+LzuaUE4EkVJhZ81YsSI7sWvImQ4BnIwm4d+HuJyIjCOuEp+KRBQrcnkaS9QQpKl6tPvW73
 Hff3Q5Jz59HOD/Hnt47mO/LanasgjnKotj8Sj8Fcm+2cy4cy6hUiPi+oS/NPDvSbIs8SMqxtFR
 gfTgAaSxMNlwpY2CU7T2qxO6a1+d+d95mPSsnUr01bxhbVV3TdmEMl17M/jtxoeSrmaLK7LRN/
 PMs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 14:34:53 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Hws1925nFz1RtVp
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 14:34:53 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637361292; x=1639953293; bh=I37dPb10B6UldGO1fL5ChQ7Ab0LfhdW5k30
        q43BOSOs=; b=qtK1b4rleJPJg1MJztIPPru+VArwhBT+hlYdAbYD1B0zSR/ojT1
        T0kG1NQ6tzkemyMhLFxvDftvrcGvV9LaMFNWbF9UY4dqA/0S0sJ3eZktZQRSfa8n
        6LyJz/hJIZBJdBnyE6pEiC70ujGXQIs+/bp92IiJHxuUdrl0JLBgP7HTjMpD3wHo
        2z/QtlCSuj6nnKTTmibYLzxu4I2BvLT1iFLvqWnqfCOFarnT+wISR/N9o5Yrkcmz
        WNmsVyZRcnaZCk4ffnvMZ8hcth9LODFvcdJHXezCu8ax730JJDNbwM4y6xb04XL9
        R4B7qz8ny59wZoz5pudR/q70iICg6ZLymVQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jn-_joHXFrW4 for <linux-scsi@vger.kernel.org>;
        Fri, 19 Nov 2021 14:34:52 -0800 (PST)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Hws174VF4z1RtVl;
        Fri, 19 Nov 2021 14:34:51 -0800 (PST)
Message-ID: <8105e564-bb56-e239-bac0-a2882f18a048@opensource.wdc.com>
Date:   Sat, 20 Nov 2021 07:34:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] scsi: scsi_debug: Zero clear zones at reset write pointer
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20211119102204.259762-1-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20211119102204.259762-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/21 19:22, Shin'ichiro Kawasaki wrote:
> When reset write pointer is requested to scsi_debug devices with zoned
> model, positions of write pointers are reset, but the data in the target
> zones are not cleared. Read to the zones returns data written before the
> reset write pointer. This unexpected left data is confusing and does not
> allow using scsi_debug for stale page cache test of the BLKRESETZONE
> ioctl. Hence, zero clear the target zones at reset write pointer.
> 
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/scsi_debug.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1d0278da9041..6d1f1a4a6724 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4653,6 +4653,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
>  			 struct sdeb_zone_state *zsp)
>  {
>  	enum sdebug_z_cond zc;
> +	struct sdeb_store_info *sip = devip2sip(devip, false);
>  
>  	if (zbc_zone_is_conv(zsp))
>  		return;
> @@ -4667,6 +4668,9 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
>  	zsp->z_non_seq_resource = false;
>  	zsp->z_wp = zsp->z_start;
>  	zsp->z_cond = ZC1_EMPTY;
> +
> +	memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
> +	       devip->zsize * sdebug_sector_size);

May be do this only if the zone is *not* already empty ? Resetting an
empty zone is not an error, and in that case there will be no need for
the memset(). This will avoid a lot of memset() when this function is
called from zbc_rwp_all() to handle an all zone reset operation.

>  }
>  
>  static void zbc_rwp_all(struct sdebug_dev_info *devip)
> 


-- 
Damien Le Moal
Western Digital Research
