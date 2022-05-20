Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2E6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 23:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354109AbiETXal (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 19:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354081AbiETXak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 19:30:40 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559E71A7D18
        for <linux-scsi@vger.kernel.org>; Fri, 20 May 2022 16:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653089439; x=1684625439;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mC23Js+fgQ42aR1x1h3Crwa5qeNduvEcgjySjZ6gkSE=;
  b=Cdhxwvv8UENU76yQZk09raIt7JYswpWr96ncTec/7notDTqY+D/fe+B2
   HALPCE5QjC/MEjVA8BV2VUKx3OWOjANOA9cShaRhXOp19LsSVA+EO9/0g
   RY2kn7reYeQ1/aRxcjJ/KADtHor+M0cw8jl+OwBPN2ncno/YR7BQYwA5H
   N+dku+bqcPo68+WknCVLT4WHTmhF0Qqn8j5D0WBUGK8PvzvFmYvb086YV
   +XHbUC4HoGGvx9lOLMMXXmpWc+TW5Nu93kcrMBePzVT1r1rg+Zdw+5Do9
   RGX2DzyIOH/b3voLbQjCJo3dwCMkNQ3t/6xdI77Tv+y+YNXT4gSgux8vD
   A==;
X-IronPort-AV: E=Sophos;i="5.91,240,1647273600"; 
   d="scan'208";a="199759571"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 May 2022 07:30:36 +0800
IronPort-SDR: h3d1+Yi+7K6YiPcYJcEQ2oWJm5APhQLIwT9+yRvHj/+pCCeQDcZgo6rB0Nr3tnsXWST2uF6Y2J
 m7f06ze97g/miEgwPhJAojm+3jhEejhdm7BlL/gJH0kFWvqzspJSQVHLakbC8uUK5RqwMG4Ev3
 Wpki1giUnWchqwE3GOfjrEStMFI9KmxzZbIEh+Bs6nZ84IqsqHaZEx5k7AJ9vX1qc84O532Hoi
 /osIMty+fEVvnWiJ/ZSlbet0oe2xuJ2EOvNm7QyTpHYqaiOvRg7XBYQqFCznDsXcwx71k2yeZz
 YSnzXPMUSpiHOe5zokc032K5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 May 2022 15:53:19 -0700
IronPort-SDR: H/zVt4WSjVq07MTOZuPvZ6pgEq5HhoOv3V7idTacY+y1H87KuZKzrl05DbmfrbhgZxupzvE9a+
 SDOqA1wKEu6yqP6Y2VXglphoRYHJJFj+vf6m0eVhJEk5VyfUezIH4XTaGjF3HvuO7wTGdRoO2f
 c3raBB6eOuanCAlm+ZsBw4non/aqobnuzNISoleOMrNU+uhYign2OBL43tojVri+ZyWlLQWiab
 325nkkY2e1LPl1vStleicZHcYyqIlFkeyq9hiQ8/DDWvH3HbeexX6tjq2TqGI0EkWgXQLCqDww
 LW8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 May 2022 16:30:36 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L4jdR4K2fz1SVp4
        for <linux-scsi@vger.kernel.org>; Fri, 20 May 2022 16:30:35 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1653089434; x=1655681435; bh=mC23Js+fgQ42aR1x1h3Crwa5qeNduvEcgjy
        SjZ6gkSE=; b=Nk8Hxo8+XR7/VqUuVjQ5LqiJPLj5h7vTFa/tWJg11fe3HCm13hn
        b70LJIxRTW43v6GNhZEwLiDvFaFUAxs5i/nG5e8PxJF5WO463aNgJ+xmnTYRjBd7
        RySZ5jWJQqmIkDz+LEeoz6rIgGGNzuDQvDMbRxWGmyyV/cFJpPkw7DHXKHdH+Lft
        6PpNvvml7iiRSpRAP8MLMUrxTHuF/uloCDy+a6pQuQj/F8pwNU+gx8m5uBoht8hf
        0vnnpYuYTOx/aDHe1k3AR1MO/x4gSoAgX7Cjl4VgQeD74fncW/Y75z2TrB7/CZMp
        nZEBM0HcRilBjsU7QQ79PFhTR/8WUDihf0A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kHjLfWZ5ci3U for <linux-scsi@vger.kernel.org>;
        Fri, 20 May 2022 16:30:34 -0700 (PDT)
Received: from [10.225.163.51] (unknown [10.225.163.51])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L4jdM62rXz1Rvlc;
        Fri, 20 May 2022 16:30:31 -0700 (PDT)
Message-ID: <e65e7329-67e3-016f-e213-86e51b8021d6@opensource.wdc.com>
Date:   Sat, 21 May 2022 08:30:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 3/4] scsi: core: Cap shost max_sectors according to DMA
 optimum mapping limits
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, liyihang6@hisilicon.com,
        chenxiang66@hisilicon.com, thunder.leizhen@huawei.com
References: <1653035003-70312-1-git-send-email-john.garry@huawei.com>
 <1653035003-70312-4-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1653035003-70312-4-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/22 17:23, John Garry wrote:
> Streaming DMA mappings may be considerably slower when mappings go through
> an IOMMU and the total mapping length is somewhat long. This is because the
> IOMMU IOVA code allocates and free an IOVA for each mapping, which may
> affect performance.
> 
> For performance reasons set the request_queue max_sectors from
> dma_opt_mapping_size(), which knows this mapping limit.
> 
> In addition, the shost->max_sectors is repeatedly set for each sdev in
> __scsi_init_queue(). This is unnecessary, so set once when adding the
> host.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hosts.c    | 5 +++++
>  drivers/scsi/scsi_lib.c | 4 ----
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index f69b77cbf538..a3ae6345473b 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -225,6 +225,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>  				   shost->can_queue);
>  
> +	if (dma_dev->dma_mask) {
> +		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
> +				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
> +	}

Nit: you could drop the curly brackets here.

> +
>  	error = scsi_init_sense_cache(shost);
>  	if (error)
>  		goto fail;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8d18cc7e510e..2d43bb8799bd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1884,10 +1884,6 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>  		blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
>  	}
>  
> -	if (dev->dma_mask) {
> -		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
> -				dma_max_mapping_size(dev) >> SECTOR_SHIFT);
> -	}
>  	blk_queue_max_hw_sectors(q, shost->max_sectors);
>  	blk_queue_segment_boundary(q, shost->dma_boundary);
>  	dma_set_seg_boundary(dev, shost->dma_boundary);

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
