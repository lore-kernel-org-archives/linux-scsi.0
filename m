Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864F4C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 23:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiGKXPG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiGKXPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 19:15:05 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1882585D70
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657581304; x=1689117304;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gdUWSjRbdYf9JQjewquLoGySB8ue+2IX1SbOZl2l7Uk=;
  b=JgaGBvrWuMko+7nN2DFr8xWbGawurtJnOxHNBtSWc81JmrmPYIEzAguV
   +aUE6HhUI9And3sBUGMA+pcOWuWpQPeWvghOs1Np5JkIVyE4JsC3n7wA7
   pBomGJB9Wih+/R1V3vjNOtnz2it7X/P0+A7QpKdA3o17X1ktrSODJHljA
   J35SkqMMrL92k31d2N2Co2wK22zpUdZk3ukaNLO+IGmF2QFlSh/BmHf7L
   LiqhVZ2lijgt1DoppjdohkGU2sM1AudhkNOB6EXKOkH3rMAgbBFMG52LV
   oD4Hwd7VzSBC607eo4W0fOOsk6ByztmxPd1ajVl3YQduEaFu2i3k384Nb
   A==;
X-IronPort-AV: E=Sophos;i="5.92,264,1650902400"; 
   d="scan'208";a="317561081"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2022 07:14:44 +0800
IronPort-SDR: ftGgrahcWxUXnGKEQgMQTwk+R2/tD2EsVA5VffZuUfdgZNNOiLgvyj7gWLtQwQQC6ZflvNK1OY
 cjVmrf31ETEse5msOo+/gUUaPuQEjYx37GQnlDFAPruwe61i6RdztBnqFnnQcZi+dpOkvfsj0L
 PJmJ33KeZzozG+pDZK4B9KZG3KaCPXXAsSuN/hLAmEcdmyRwgcrfWB0pj3rjFzoL9XWwvCUUSh
 7ODqlNKsFHiTgTrohxoZtNlGdM/6x4vg6ygZbNbJDRUieZNxXWeEXnj7gCokkMNnSOl2PNygaW
 ToaT2OSpn8345lvO8f/qoxaj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 15:36:21 -0700
IronPort-SDR: zHAO4hCtPa+gO/uMkeLs0/WC/ngHJN+XFv24JGUjJxF2sezB0i/S1K+2NkOZZGmLuzdxz0ZME6
 wpPwvOFmgl7arFml96KkhdME4hHbDHB6t9wEbXkhX4ozdpr9MhSI18FuBllPpT+PVmv2fWAvS6
 b5LPw3knATlKYt5Pwu7TLeQCwR6rtQlYSVBQtMSq6PUtLgvYdOQJq4rvH65xjcfCII7RU2z8rX
 ZjTLWNBEciQ6t0S+XElr7w9IQxX1snM6aQ90mAY+Fsvv1pbAnEf9R+gAoNwCyDON54M90lwew5
 Wpk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 16:14:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Lhfq82xT3z1Rw4L
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:14:44 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657581279; x=1660173280; bh=gdUWSjRbdYf9JQjewquLoGySB8ue+2IX1Sb
        OZl2l7Uk=; b=SK39yT5BN06xeaQFyr5PQtyqJBC8F0/ZnVx3j4DSdzbJfd0Sf11
        X+KE0NEUJCKwC4k55CWdev12N+vuI3iRoY/hT/HeXBFQDJVeOOds4bPxbMgY9i22
        ny/f0fQLx8kwjvvCUQCaAme6jM6aKPUESSSpm4lrJEa82ozvE5gCgRNrG+kFdKAe
        GmoC3tfUySqrbEaklyqaca4ESlo4I8sS469yZQgS0qdxr0sie0mdWScuYdsnMYuI
        bW7AfQPVjSn/FAEFdT7/GAalnblKRAgV2ATNkssFFBOawn0qFf7nDVuWNuCzBNqX
        n/eiZUpkzKz3RfMuXt/9ZBVgTQZyrgTHy0A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sqfeI2Vj40aT for <linux-scsi@vger.kernel.org>;
        Mon, 11 Jul 2022 16:14:39 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Lhfq22SS2z1RtVk;
        Mon, 11 Jul 2022 16:14:38 -0700 (PDT)
Message-ID: <82a10f9f-ee82-8fe6-a557-183129ef596f@opensource.wdc.com>
Date:   Tue, 12 Jul 2022 08:14:37 +0900
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

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
