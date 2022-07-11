Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86D0C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 23:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiGKXNL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiGKXNJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 19:13:09 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36642509E0
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657581187; x=1689117187;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x5cBnBVDgMOc3WUK8n5iq72XcAd+Qk4945ryUk97U7w=;
  b=f4zV0MSjLw1ecBaNekpkTzkCnF39puP+Y5oh5QcI9w6irfeiBHbHtu4H
   5JhPZ0eVzBWFstbRLledXYKQyRDEKyIz/pQ/6MLuGQZImvi0GMhSQQcjY
   zn2ee/a3bxzkyTHRxH4T2MZ5HW5Ivg7UeJ133OG7pzqaXaP+djlGbSQC0
   4ODKJJgAc6+8SVmtQ0wk/CB0Wosm5/fT0HdT4yWuENUxe3e/E7qunvBqx
   2n8m5xuyXX+cwBPFDaMi8kpvt6nJZ/R1GnEJ3SKcsy4b7vE+i/dc18SBp
   B+ZjjFD91fUFgVYMo3vgWDn4hs+ZjiReQhI2okN2LcmwjMiplkaXpax7h
   A==;
X-IronPort-AV: E=Sophos;i="5.92,264,1650902400"; 
   d="scan'208";a="205428029"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2022 07:13:07 +0800
IronPort-SDR: kaStp/syjqliDGyIzuzwkcxb7NG60pRO9x/mYx79+4ju8eH4STu0m9Is8EZjI4MfPr+zgv/Isl
 8d35SJar1mYhK6nwEtkHMnyEmUtcsIm68rSNGUjefuMlzcVk0S/Wxc57PulXCJqmsZioIb09CK
 Yt3W3WnbwbQLMXX483p5QEFf549TQ24Qtb72Cr0cPvh4O1BSQBWMCd4BMt576RNk6vgL7jRXxI
 uzBzPR+vozMDK/AOidCGe7QX6QuR+dto3DcuNnRHKLeY2AMe6VhAXlxOxEXMcDPirLfOk/2zoW
 oyVVOUDlTbFUDu5nLbMV0j9p
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 15:34:43 -0700
IronPort-SDR: u7KwbhXy0JOQxPm2SwRme/n0xIlUYUhr5cfVdTYV3pl/rrGMwdaHeJV/Hy8Z9KXtqi6qJ40+o3
 rTYLT1g57RgMswKk8daHbJ4dJd8oVWQP6++6eE72ScICUlARhWWmooC0gjaY6nenheX4Fjkn7a
 5TtLPRpgLkckYy9PZxOXGsZPjUONjZnM01eXm4YD8DBx30KJ3NZqBimSMw/9pwSMxdBOZNdfEV
 GR7S3n1SOiwgQOfxPWpEgenD4o9337a+9KpUrB+yiciLDFmYgXEWRzcwdI2q0NkW3GQpsTH6MP
 1TU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 16:13:08 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LhfnH1sK1z1Rwnm
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:13:07 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657581186; x=1660173187; bh=x5cBnBVDgMOc3WUK8n5iq72XcAd+Qk4945r
        yUk97U7w=; b=DEeDWdBjh0wnFdQRRANSp5CJG5nLkqt22+kX0x148msNbwBVaCl
        LW3j7I35oIngm3l9Yvr06or6nDjUa3FGGKorYzktDb2dLr2MMZug3Y6wRrhh41/w
        uAZNdVqcLQQsDUCo4bLR9P55XCfBNiSC6zqCb9nuJ5gSg2zi06JK6yco56Br7j40
        dxJ7IfFMaWDU7QOo6544tcHNRWA0autyBgxC4bAAo2pYmouMWPN01WohjPFlPZIa
        2Lit2gNguxaJMbjxNeBlWz4RgjmKoBkB22c9VmHWb3Urfpys0/+rfSZhtA8uUwaS
        YbYzxJNMIxgczkFC4cVkUKQRE2qSA3L0/Sg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id b1oTib6QRMJg for <linux-scsi@vger.kernel.org>;
        Mon, 11 Jul 2022 16:13:06 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LhfnF6HZ7z1RtVk;
        Mon, 11 Jul 2022 16:13:05 -0700 (PDT)
Message-ID: <c4b7b16b-4ff5-e1ff-3bee-6b783a2aaf61@opensource.wdc.com>
Date:   Tue, 12 Jul 2022 08:13:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/3] scsi_debug: Set the SAME field in the REPORT ZONES
 response
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-2-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220711230051.15372-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/22 08:00, Bart Van Assche wrote:
> Provide information to the SCSI initiator about whether or not all examined
> zones have the same zone type and zone length. From the description of the
> SAME field in ZBC-1:
> * 0: The zone type and zone length in each zone descriptor may be different.
> * 1: The zone type and zone length in each zone descriptor are equal to the
>   zone type and zone length indicated in the first zone descriptor in the
>   zone descriptor list.
> 
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_debug.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b8a76b89f85a..5a8efc328fb5 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4476,8 +4476,10 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>  	u64 lba, zs_lba;
>  	u8 *arr = NULL, *desc;
>  	u8 *cmd = scp->cmnd;
> -	struct sdeb_zone_state *zsp = NULL;
> +	struct sdeb_zone_state *zsp = NULL, *first_reported_zone = NULL;
>  	struct sdeb_store_info *sip = devip2sip(devip, false);
> +	/* 1: all zones in the response have the same type and length. */
> +	u8 same = 1;
>  
>  	if (!sdebug_dev_is_zoned(devip)) {
>  		mk_sense_invalid_opcode(scp);
> @@ -4571,6 +4573,13 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>  			goto fini;
>  		}
>  
> +		if (first_reported_zone) {
> +			if (zsp->z_type != first_reported_zone->z_type ||
> +			    zsp->z_size != first_reported_zone->z_size)
> +				same = 0;
> +		} else {
> +			first_reported_zone = zsp;
> +		}
>  		if (nrz < rep_max_zones) {
>  			/* Fill zone descriptor */
>  			desc[0] = zsp->z_type;
> @@ -4592,6 +4601,8 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>  	/* Report header */
>  	/* Zone list length. */
>  	put_unaligned_be32(nrz * RZONES_DESC_HD, arr + 0);
> +	/* SAME field. */
> +	arr[4] = same;
>  	/* Maximum LBA */
>  	put_unaligned_be64(sdebug_capacity - 1, arr + 8);
>  	/* Zone starting LBA granularity. */

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
