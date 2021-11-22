Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EC3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 06:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhKVGfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 01:35:51 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:27493 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhKVGfv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 01:35:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637562764; x=1669098764;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hAlPV2ezMof5pjyfmuJwM6x5RoCxfNfKdyCyt7CSXBU=;
  b=Jm59qTW+qLCe22BA7dD3+p3WAMiRgoPs0N8OPJf+WdrhlJi23lAXckOV
   9jqhyE1aL23Uhp7BGuNO4C1RqAz+xXVnXxxWxmQ8rL79UK7AU3EHPdQzQ
   ftC+wVkhXB9uZBM+hcQG7s9qkeLnZKttSbXnT4Usdfi+ZNtrlpqs5kPeK
   hHLMcJDOoT8IyKf8VL2BymnxGdlfsEs/m5XiSADLsp5uQlmzYYvakhwwI
   j0qanwEFXo7FZ4u8n8qQsf0ry3BqX2Ii9RI6kJ9uco077cWUMjPsGxuUG
   BMTStRhrPkIIlZb7TBmkNk1YXgOVrjrUg8VXRGCjr6xPoolr4PjAAe9WI
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,254,1631548800"; 
   d="scan'208";a="186286816"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Nov 2021 14:32:44 +0800
IronPort-SDR: cWGIX1SxAHuFAYi1LDFG1E7Gx8b35HQzBH5a88GkPRSpmfqJZc2WuwsoAvIENEAV/TSAMQN0WA
 0A+dcjVdKoZ0dxoppWeMbr+Jn63cL1Fk+X0lpU3FGLNlOpNddJU9BWGJKJzN+tWcHIHJK3N9cZ
 RPeUA6sMrsokcP3TH2B4HhxFRkNzKC5T+pDy9zcbVPxUmKz8+wZRn39X3kQTH4B6aUz/xpXip9
 SeosBmiM0NVjtgWPU3a26Bs98SKISSOMqyehwYvg3EyScy0tzQzn1e2+3a/+KWT0axbHBmuOhN
 N+GkinwECaW153kx3opFRHPl
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2021 22:06:08 -0800
IronPort-SDR: mP9KCZYHZyUwJceUah4TG7oj1s2iL0JCMJITLl+BkIjkqtqquJO/acJkwk5FgKbmy5z6QEyeNe
 WW9uizHTWEq73NdXIbqVtuXsMU5DuZcUSZpDhtjk7QaeU3ATEGNhzsqPEcCyLAd3koyE01BDGv
 wWQqLiejMDk/+QV2iOMrkVFKGoMbR5ds3am+Zuzd+XKUIGfDG9RsZHEXt6DEMNU9SS382PUns0
 WWjV1BcXB1wYm5phsLSpOSDBJ9CCoY8ndDh+p6BMp7/6gd6useXzc5ouczyqvpkdszth2TactB
 Czg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2021 22:32:45 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HyHWd0l4Nz1RtVv
        for <linux-scsi@vger.kernel.org>; Sun, 21 Nov 2021 22:32:45 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637562763; x=1640154764; bh=hAlPV2ezMof5pjyfmuJwM6x5RoCxfNfKdyC
        yt7CSXBU=; b=ZAx+bmyw1qsaL3s9hGyPonbHvAPE9cVfg94V6xXXuPNzSsCFYeo
        pD/lzW16fu7lLFBW/6Pv/GqyhsKRwS3oEwXsOot+Eb6P1BTG1QmbT9TdAnxmWUD8
        F5+P+Uty9F76OefktkIipkrjMEuQ4C6HKVNQ6QT7IxS49P2tkI/t/Oj66nLdH2DW
        XCNBVoGr2XRrHLaayCK8HyHxOp8Li5ypNROzo39H4IJwYAmQKsm9CWwZYkWuFG/h
        L1oL3B5XPjX+dXzU8y9O4BPHGNsuY26kQyk61GqGMJREY6YAoj/dnDkW/qA4kss2
        PaHcNo2QjeUufuL9GsRAOsI+qNsrUSJmDJg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id isqXzcpVV-bN for <linux-scsi@vger.kernel.org>;
        Sun, 21 Nov 2021 22:32:43 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HyHWb0Dn1z1RtVl;
        Sun, 21 Nov 2021 22:32:42 -0800 (PST)
Message-ID: <a307f2c2-12fc-a193-6438-fc44c653657b@opensource.wdc.com>
Date:   Mon, 22 Nov 2021 15:32:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2] scsi: scsi_debug: Zero clear zones at reset write
 pointer
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20211122061223.298890-1-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211122061223.298890-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/22 15:12, Shin'ichiro Kawasaki wrote:
> When reset write pointer is requested to scsi_debug devices with zoned
> model, positions of write pointers are reset, but the data in the target
> zones are not cleared. Read to the zones returns data written before the
> reset write pointer. This unexpected left data is confusing and does not
> allow using scsi_debug for stale page cache test of the BLKRESETZONE
> ioctl. Hence, zero clear the written data in the zones at reset write
> pointer.
> 
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
> Changes from v1:
> * Zero clear only the written data area in non-empty zones
> 
>  drivers/scsi/scsi_debug.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1d0278da9041..1ef9907c479a 100644
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
> @@ -4664,6 +4665,10 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
>  	if (zsp->z_cond == ZC4_CLOSED)
>  		devip->nr_closed--;
>  
> +	if (zsp->z_wp > zsp->z_start)
> +		memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
> +		       (zsp->z_wp - zsp->z_start) * sdebug_sector_size);
> +
>  	zsp->z_non_seq_resource = false;
>  	zsp->z_wp = zsp->z_start;
>  	zsp->z_cond = ZC1_EMPTY;
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research
