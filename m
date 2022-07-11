Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDFDC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 23:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiGKXTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiGKXTd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 19:19:33 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C065E8148D
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657581571; x=1689117571;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0CE4i3QQ+tcOrjmsv56y1y0+cov8yGaiZFHifys4wtw=;
  b=WeO5YGzwCHsZ4Fw0dRnnLgTs8dmCn2/H4i5rU72f7AKvIHdXQWFhNhlU
   loVohxEkBz6SFovPe+Zzs/0lmzRDovXvQ1YhQYH3IgKCvOOtoT3fGrba7
   cshKqHJKv4Hd2VowYOvGg7Lo3f2jYrxRkCoP9oxKhwThATEQYOep/Ikzn
   9jOmD34hr4pSTjm6+U17VuIgSAAmOGwT+BjV3erWE+I89EhHw78IXBBNQ
   QfXgu8XJNX2k0PJLm6XdeQY6O7B8lWraGPleV5iIOYLLQDPStT+68nU5Y
   OLrBqqYmeZqRZbkigAVUyQJYHqEOh+Q5xexYOnhWzTnmW6Wd7dWZAElot
   w==;
X-IronPort-AV: E=Sophos;i="5.92,264,1650902400"; 
   d="scan'208";a="317561447"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2022 07:19:31 +0800
IronPort-SDR: 3vfF1pJ+B0VEmTC1xSUWF49TJvx0N4fcSU+2YWQpXzg8KUc7tob5yjIi/EnKJYYK3U4yANo9GH
 kXQlV2AfuPDCyzfN73zbfxcAWGA2RcIlEtwb9Y0ZW/vcmTd9rOqnrFQsaKisR2mSadUTm8/iUf
 crJwOZBZTTxuj1oT7zQM5ZJXVNBr1izcM3S3DbFATbL7otG3jCIg8zA062sjb7YbstimVsDxA6
 Rs3sx3prirTgEtiHMQRFQrwhXX9YWCMKva45diHan7h45Atxqy+u8x0a6nX7c/CMHbliHFVEzf
 4N9nHXAC4QpNT2f4VEUBPuYb
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 15:36:30 -0700
IronPort-SDR: X33yYaYMxpsToeON4OEUkKvCX776+YEBVwm+2M8pM5JywoKIYwSSrzTfBcO1FwJJrv3wXT59qG
 FpARQIckRfFNKasimKxHK076DWqudd6BMd6RbtrhnQaqqtzHxv9KE4nhH3xogynio5L+wcDycF
 +iZSatBttb00L7FKyU6rZ7oJhFnbICcDyGLAmD6ABj/369lBVpecttFZaUmB9IA8S9ZHSIHcE2
 j2pweK8mIixbsZIfDlsQWLlVRgddHOjYILBLT2VPWsKIXlXXlE797JHPQ2NZDBM7UWGoV4qU3F
 JDg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 16:19:31 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Lhfwg0vFTz1Rwnl
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:19:31 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657581565; x=1660173566; bh=0CE4i3QQ+tcOrjmsv56y1y0+cov8yGaiZFH
        ifys4wtw=; b=ofC0K8B6JoYa5I5h6wzNbABLHBfu2EjYw6ugx4HaqFEwKl1SkCk
        26qLHN4vryppAwVHZafhtj0sqf8rNoELO7BjqWRg/zxKJs8q9IOf6Ua02K9aoeg9
        9AkdYQWIHaKGT16XB+KSAyTWvyC60fhREtR61VAgGjEv/56ix9frlLooWDEksgi/
        2427WwkN1/5lVXSrNnrEpkPjEHoTxWRNU/+EAlUC1mOo7ty64xqi/PRY5N2EBM3I
        vCoNluPjRpDV8edZGgbdmBIwhqOJeCAO6b/Br9+fJCXQfCvnQjbOAnXgAHFsEsIp
        WbX6OfIFhSu9H8bKzagft3w672ZlSpDLkSQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VWouxUz-Svwt for <linux-scsi@vger.kernel.org>;
        Mon, 11 Jul 2022 16:19:25 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LhfwX6lkcz1RtVk;
        Mon, 11 Jul 2022 16:19:24 -0700 (PDT)
Message-ID: <625056aa-0604-d1a9-e1a1-0efef70a5de1@opensource.wdc.com>
Date:   Tue, 12 Jul 2022 08:19:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/3] scsi_debug: Make the READ CAPACITY response compliant
 with ZBC
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-3-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220711230051.15372-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/22 08:00, Bart Van Assche wrote:
> From ZBC-1:
> * RC BASIS = 0: The RETURNED LOGICAL BLOCK ADDRESS field indicates the
>   highest LBA of a contiguous range of zones that are not sequential write
>   required zones starting with the first zone.
> * RC BASIS = 1: The RETURNED LOGICAL BLOCK ADDRESS field indicates the LBA
>   of the last logical block on the logical unit.
> 
> The current scsi_debug READ CAPACITY response does not comply with the above
> if there are one or more sequential write required zones. Hence this patch.
> 
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Fixes: 64e14ece0700 ("scsi: scsi_debug: Implement ZBC host-aware emulation")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_debug.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 5a8efc328fb5..c5f4af774078 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -304,6 +304,7 @@ struct sdebug_dev_info {
>  	unsigned int nr_exp_open;
>  	unsigned int nr_closed;
>  	unsigned int max_open;
> +	unsigned int rc_basis:2;
>  	ktime_t create_ts;	/* time since bootup that this device was created */
>  	struct sdeb_zone_state *zstate;
>  };
> @@ -1901,6 +1902,8 @@ static int resp_readcap16(struct scsi_cmnd *scp,
>  
>  	arr[15] = sdebug_lowest_aligned & 0xff;
>  
> +	arr[12] |= devip->rc_basis << 4;

Note that I think this entire patch could be reduced to just doing this:

	if (devip->zmodel == BLK_ZONED_HM) {
		/* Set RC BASIS = 1 */
		arr[12] |= 0x01 << 4;
	}

No ?

> +
>  	if (have_dif_prot) {
>  		arr[12] = (sdebug_dif - 1) << 1; /* P_TYPE */
>  		arr[12] |= 1; /* PROT_EN */
> @@ -5107,10 +5110,12 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
>  			zsp->z_size =
>  				min_t(u64, devip->zsize, capacity - zstart);
>  		} else if ((zstart & (devip->zsize - 1)) == 0) {
> -			if (devip->zmodel == BLK_ZONED_HM)
> +			if (devip->zmodel == BLK_ZONED_HM) {
>  				zsp->z_type = ZBC_ZTYPE_SWR;
> -			else
> +				devip->rc_basis = 1;
> +			} else {
>  				zsp->z_type = ZBC_ZTYPE_SWP;
> +			}
>  			zsp->z_cond = ZC1_EMPTY;
>  			zsp->z_wp = zsp->z_start;
>  			zsp->z_size =


-- 
Damien Le Moal
Western Digital Research
