Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B41C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbiGECzD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiGECzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:55:02 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E894D6F
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656989701; x=1688525701;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1y6wAypb2e7pXog7C7mFRuD3grgqGrQRog8SU6seADI=;
  b=bOklNhmbS4pBRMZGSBL7FRkPm15RKDVQitZH7BoHZb8/KPpDK2gAOqqo
   jE0IKX1EYm5vsDJuNjnYoDE1Ai1mkIw+UIIhh1etm0byp0FNUpCOB3FJd
   lbQZOqG9DPG8GUqSA0rTD4VjslpvIEfKMeX1Bebga1UOkKKMy5fDirgug
   KNPLiYzOoSrR8kyjLLdzovo+OD9utl8CFeFNuO4Cv3z3FzkzAwHXnXepO
   w7yB7tYW41UB5x0NP/WjrMY6jsQE55R2EJb5M9em6dqJO/MDqq4Zj/EiF
   uEOmgc3VcB2Oo2v4bbMmo92V+xpQyWZiXZ8Oo3NG1JQcaOxm/qK9RLtzd
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="205520954"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:55:00 +0800
IronPort-SDR: PHi+mOY/kAdqFdy6X5eVXS/NIGlDIMmkzqOsnIcbNji3cij42Tlb099lATp2WuQf0hKcLNvOE6
 /0Bh4onk864JJiqYONq0QWHCTk8VkkENv57F+Fd0dCF3gzvC/ieOB2poPrVwd6my+4WqNBIivr
 kYkqelWKPtDuEV8EH/jAF5/nG6+0Vxcg2G/1ZsjDNhyEXJSbjObWUlpZlVUB0DqUhkUiw/mX/8
 pWgt56sglSjtHnlGCSvEq5ETTSmJu7BI28vQ4nPEDseF7f8CMKbg/L+tl7udd8xD9qrP23evAO
 gnRS+srfWZfhxjBWCrGo9cFO
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:16:51 -0700
IronPort-SDR: cwyKTSgGgWSl7hKEusslDrPYk8QbukXNh+UFf66urfWjGrlXWmx089LJPFW8JPWPJvfm+u0x8a
 NNpZJmST6Ao8jCx20av7fYjw7CtklKX+k5zLHWBcvRXXI3DhFj7Dg+NJO/f4Kd3KTT8qj4NyuA
 9piZwkMtRjHo+h/eu3SyfF5hBMxQP/SLSVoq8sO0iAy1M+MP9kWDApkK66IpzlJIjI1GsUB2Hk
 gLCV5FCn+H1K6+GwaYHr5KEX0VRg5ykna8bSOYmBYzNqDfvAtXesHW/OpaB2MRU+OI4D9IwCDo
 8/c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:55:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcS2W6rcZz1Rwqy
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:54:59 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656989699; x=1659581700; bh=1y6wAypb2e7pXog7C7mFRuD3grgqGrQRog8
        SU6seADI=; b=ajSE4pQESPSpjDj92KGRa6Ue0IELvkjnqKFeY7hE9S1kmQo1tW0
        LyBdWz0Kh9uY5d1m/VdR5V4c2ZHSZRz54+LP8bbt4v51rYCV2xMboLtELOMO1FZW
        CFmOrLE/GSeukmUDozhBMlM5lpTcXWy0nFgn+asMpFwupUTet5EvQk4L0XZlxBQ5
        5rhGgHRdDhYE/1zCdfin8lQGBxr2BdOezRRYrDFAmta/inoTT5/cHdu3yOf8+G3G
        Tz4VEGLAP9YUs8Dza8UjPuHpHY0t3rBHpXAUXiDEhF2pgDf088hoiO/4iAZbkPWx
        tYtGJlBkF44FcfsY1xFjy8ynO+hT6RL24yA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8eXfEZy_EPlo for <linux-scsi@vger.kernel.org>;
        Mon,  4 Jul 2022 19:54:59 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcS2V2zgZz1RtVk;
        Mon,  4 Jul 2022 19:54:58 -0700 (PDT)
Message-ID: <535739b6-ee61-eccb-1dfc-3c57eab21cea@opensource.wdc.com>
Date:   Tue, 5 Jul 2022 11:54:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 15/17] dm-zoned: cleanup dmz_fixup_devices
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-16-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-16-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/4/22 21:44, Christoph Hellwig wrote:
> Use the bdev based helpers where applicable and move the zoned_dev
> into the scope where it is actually used.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/md/dm-zoned-target.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 6ba6ef44b00e2..95b132b52f332 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -764,8 +764,7 @@ static void dmz_put_zoned_device(struct dm_target *ti)
>  static int dmz_fixup_devices(struct dm_target *ti)
>  {
>  	struct dmz_target *dmz = ti->private;
> -	struct dmz_dev *reg_dev, *zoned_dev;
> -	struct request_queue *q;
> +	struct dmz_dev *reg_dev = NULL;
>  	sector_t zone_nr_sectors = 0;
>  	int i;
>  
> @@ -780,31 +779,32 @@ static int dmz_fixup_devices(struct dm_target *ti)
>  			return -EINVAL;
>  		}
>  		for (i = 1; i < dmz->nr_ddevs; i++) {
> -			zoned_dev = &dmz->dev[i];
> +			struct dmz_dev *zoned_dev = &dmz->dev[i];
> +			struct block_device *bdev = zoned_dev->bdev;
> +
>  			if (zoned_dev->flags & DMZ_BDEV_REGULAR) {
>  				ti->error = "Secondary disk is not a zoned device";
>  				return -EINVAL;
>  			}
> -			q = bdev_get_queue(zoned_dev->bdev);
>  			if (zone_nr_sectors &&
> -			    zone_nr_sectors != blk_queue_zone_sectors(q)) {
> +			    zone_nr_sectors != bdev_zone_sectors(bdev)) {
>  				ti->error = "Zone nr sectors mismatch";
>  				return -EINVAL;
>  			}
> -			zone_nr_sectors = blk_queue_zone_sectors(q);
> +			zone_nr_sectors = bdev_zone_sectors(bdev);
>  			zoned_dev->zone_nr_sectors = zone_nr_sectors;
> -			zoned_dev->nr_zones = bdev_nr_zones(zoned_dev->bdev);
> +			zoned_dev->nr_zones = bdev_nr_zones(bdev);
>  		}
>  	} else {
> -		reg_dev = NULL;
> -		zoned_dev = &dmz->dev[0];
> +		struct dmz_dev *zoned_dev = &dmz->dev[0];
> +		struct block_device *bdev = zoned_dev->bdev;
> +
>  		if (zoned_dev->flags & DMZ_BDEV_REGULAR) {
>  			ti->error = "Disk is not a zoned device";
>  			return -EINVAL;
>  		}
> -		q = bdev_get_queue(zoned_dev->bdev);
> -		zoned_dev->zone_nr_sectors = blk_queue_zone_sectors(q);
> -		zoned_dev->nr_zones = bdev_nr_zones(zoned_dev->bdev);
> +		zoned_dev->zone_nr_sectors = bdev_zone_sectors(bdev);
> +		zoned_dev->nr_zones = bdev_nr_zones(bdev);
>  	}
>  
>  	if (reg_dev) {


-- 
Damien Le Moal
Western Digital Research
