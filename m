Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C7FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 01:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbiFCBbp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 21:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240781AbiFCBbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 21:31:10 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FC83C490
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 18:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654219827; x=1685755827;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4/XRBVJlrbde9LFq9lEMFNDMZHqrnKfROAx+/nN8uZw=;
  b=gcA539ksgjsT9mbEypGYhxZrC2aYMsBSAKSqTi0mq8STY+8aOLaXcWl5
   RrduPyUiyFpYKo4ewd6MxFmAW7omdIwknTsSYWjqngV5Tb8g9eYo9AkA1
   zdksry8ydgHUFOdVa8w6lr00JiFcmFMX7HHNd1/CscSn6nmGwC9z3NxoH
   H2j3hPhc7tTXTdmRlxmZc3uM3uZtXf5LJwutHtR/uI//ogA8JlDCwHjiM
   D/ABHVlacmyg5S6DfU2AocWqzr+GbZVV6qt4H4xzJ958lerSIop1ErjpX
   RJ+52u2a/jl5Zl8j2wYwcZsXfjcSMB+Pou2HE07hT173zOrCuVQzVuYrC
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,273,1647273600"; 
   d="scan'208";a="202947957"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2022 09:30:18 +0800
IronPort-SDR: o8y3To35/aokIf4kSeagovz38G/fpS8pjkSOJlGP1qOFL3CUjkmmQuPS1LS57dedfUaJCW3SUV
 q0att4lW93ttzAtKCsSVJy7ZSsnyacc/30iTAgbebTfQZ1e4K50ESUpusopVEX7DyEl0QLw5x8
 B7hFmPkrTNoZ+RrthqfykuLwuf+WrkeAA43YGXdYeHp7tlNWXssuwTSGzE0wguyYcYxLTazcCm
 x8atG/kf+Zc8uOjqebnPPH2O/Iavuvpuenu45gsFmumVI5cB5yIjCdLTMJlc4hWv6y5cq5SPxX
 xuNjwnJLaUPSGC59FScKFpa1
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jun 2022 17:53:53 -0700
IronPort-SDR: ncq7vEkgj+nT85iUyIzcoMZFR6XfnZ+0/MOLV39RwXm6y+NeE51W6ORLcf3JIwI/mwFUUoym5m
 hjp9YOGcln0xYQkPqR6wBX7qmvGmFG6tPfffLiOkhBD6Iy6gl1fxOApwkPeP6GOm2atDaTtAYL
 zMpCwBSi7ZgaPE9F5kr4kTNW0TepR+ZvQ6cGVW0R67TziIhBZZpLTsZiHB7Ak7MSVpcI9/nrN6
 I5YU0/1B7D9d4VOMIjhorZnm+7XBQhq7G23LINBIqqplHTba9EjZGIXJgtxyPmRmXi3hUwW8w/
 wxA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jun 2022 18:30:18 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LDlgY2Bfjz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 18:30:17 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654219816; x=1656811817; bh=4/XRBVJlrbde9LFq9lEMFNDMZHqrnKfROAx
        +/nN8uZw=; b=eBY8VQn1azy3OxgTB0joSiNzuxnCa56ZCh3ZD/Qab7XLle0sgEM
        TmIh/nKOxOkgDQAMwlaktPb94XXAUK982Rv0wJhPM2aygGbYtQiBT6HZnDRiPRCT
        fpSCREdQ/rlUqdPv2Id3L4NJa8jL6BCuqwbQSR1UuR8Pr2x8dSOXXANVRoqdoIuR
        09G84gMZyL0QtN4wVAQsiD+69MJA4NVHqcgqU+Q6+gfyh7xA4rQymnWmHBBn5F9W
        eoJFPZdmgTFF59YFnBaeh8kEB8ZnrQuLXq40HcsQRK5Al6mCAkLV0GBRns7GZUlk
        lV/wkMW1BWJAbpJYUnZYBfGBj7jEL4138sA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yF1lX0yDnzpM for <linux-scsi@vger.kernel.org>;
        Thu,  2 Jun 2022 18:30:16 -0700 (PDT)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LDlgW4xkbz1Rvlc;
        Thu,  2 Jun 2022 18:30:15 -0700 (PDT)
Message-ID: <fcef5536-a4aa-f6f2-5e9a-c39708a74a50@opensource.wdc.com>
Date:   Fri, 3 Jun 2022 10:30:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 3/3] scsi: sd: Fix interpretation of VPD B9h length
Content-Language: en-US
To:     Tyler Erickson <tyler.erickson@seagate.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, stable@vger.kernel.org
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
 <20220602225113.10218-4-tyler.erickson@seagate.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220602225113.10218-4-tyler.erickson@seagate.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/22 07:51, Tyler Erickson wrote:
> Fixing the interpretation of the length of the B9h VPD page
> (concurrent positioning ranges). Adding 4 is necessary as
> the first 4 bytes of the page is the header with page number
> and length information. Adding 3 was likely a misinterpretation
> of the SBC-5 specification which sets all offsets starting at zero.
> 
> This fixes the error in dmesg:
> [ 9.014456] sd 1:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page
> 
> Cc: stable@vger.kernel.org
> Fixes: e815d36548f0 ("scsi: sd: add concurrent positioning ranges support")
> Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
> Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
> Tested-by: Michael English <michael.english@seagate.com>
> ---
>  drivers/scsi/sd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 749316462075..f25b0cc5dd21 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3072,7 +3072,7 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
>  		goto out;
>  
>  	/* We must have at least a 64B header and one 32B range descriptor */
> -	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
> +	vpd_len = get_unaligned_be16(&buffer[2]) + 4;
>  	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
>  		sd_printk(KERN_ERR, sdkp,
>  			  "Invalid Concurrent Positioning Ranges VPD page\n");

Martin,

If you take this one:

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
