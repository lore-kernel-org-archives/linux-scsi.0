Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A0EC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbiGECcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiGECcC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:32:02 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736C0227
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656988321; x=1688524321;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ro+fI82nD1IGiNFuAK6LUHDwCz2uvuI1Aih9ZqsmmTw=;
  b=BDTCTB2fTr9uE2TF0kJFxImRtNQ1h7EMunetiubSz/dzdxGJnaM4GfHv
   hcptOrwR5ekZNFvePa2Re/a9RXj3rwsqv74sPXFgn6tU29zlTUyc3k7WG
   Ljld1R2khD4dzu+fOazg1f1SIR0/hSNqBGLbuqQcReVukJn8OQlH6RLeY
   VZPGzkYffp2pZR1JY53KqvLptbtaUSNEAPnrcVbk0xBHs7DCgW4M2MJ4o
   1x9/TY9ckRsNpksgTo3t2Go7dFCeY8ivUEnrAxOnAvCh835UgPO2HGDCu
   +Htkckln6MV5gwOX/MuBDfrqVMPu1i1/0tVOryEjAoXoikUpT+cnXAjRF
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="203465755"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:32:00 +0800
IronPort-SDR: Gp+DdUFc3/SEPvJfdNAGGFgrzgewbQjwh3tr6JloSL95Xr2yDGIvWtH0Z1iI1zyV+5eSEZt9Za
 uhGxtHmrX3N5aOJ8XFj5LHrGtg8QnngSIsbn6ZTACGhlDsB/PqV1mh1D7nUYh2lrDjy5/TVqFX
 HS+8klS3ZNmNy/I763wVRe7z/7LiU0j1HJOfrcSx3/naY+d11MeHinCFPTXiRkqAjMBKAfK2LJ
 NBKI+O5QS6PaAMC8ce44y1PCA0AjcrsYcCrVvBYEo0Z0DSBvvUSaFh1exyzwsJmz4C1ynIhiJM
 ADK2mQ1vx5Dy15YWsK6WCDjQ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 18:49:19 -0700
IronPort-SDR: fyn667v+MXbXQZuKdx7aHXo7xwguc/HjLvUdUjcG6rWsXJohjdAo+zOQnfl21DufxwrorojJtv
 6+hT3g9IRfLh/ySmEYrXdCLCd0BcTnkOjvSZjSSim0S7oDn2+DypT8eKe48XDcPYjjHCD/pNv+
 4CXIvmvVaaGoMyGjtvNOWBYl4jV+UucZlGtwyeNSfvy6d0coI/XeOtfB0R426U6fKNHAtcM/Pp
 fT/RFd5HY6jzGnaEBBH0Qf3+WG4pxbB9kr9fue/B++ZIUSN2J1fy46HAVPs32vudX64z4baQDc
 8M4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:32:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRX04yQ3z1Rw4L
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:32:00 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656988320; x=1659580321; bh=Ro+fI82nD1IGiNFuAK6LUHDwCz2uvuI1Aih
        9ZqsmmTw=; b=E5si8k2AyrL9p+0u2wPVEH9uM3pJyLDKNMYvqS466EiGZ7b8VQB
        Gb7Iy6h91Um4fbaue0VXVzRShIykbnYeMZvnb0bxB8zYCtpzUrAjwtYgn7KT4mmq
        w2zTI8JvTz+HT4F0gPIrfPyrHTbIGKHiVf5t31RyJvGffCAOhmbdeeyf1o0kTdLj
        lJ4Fh/bBLjt4LSpdng5pQRsC8rebZ3TnSbPRmIizfLfBp3vLt503L0IQAg7BryG3
        tCYgfcbvIbno2pSFTz0V4SYjsIt5ctML2m4WttC3NQ5aT85/DsjznkS0LsLpru2v
        7MWgNzCTA7jMlsE8ue0OR8OyDB8cIgKXfqw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ksRSg5S6sjLC for <linux-scsi@vger.kernel.org>;
        Mon,  4 Jul 2022 19:32:00 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRWz1GBQz1RtVk;
        Mon,  4 Jul 2022 19:31:58 -0700 (PDT)
Message-ID: <9e815a0b-0d60-730a-51f8-6ba749b5c60e@opensource.wdc.com>
Date:   Tue, 5 Jul 2022 11:31:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 05/17] block: export blkdev_zone_mgmt_all
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-6-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/4/22 21:44, Christoph Hellwig wrote:
> Export blkdev_zone_mgmt_all so that the nvme target can use it instead
> of duplicating the functionality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  block/blk-zoned.c      | 10 +++++-----
>  include/linux/blkdev.h |  2 ++
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 90a5c9cc80ab3..7fbe395fa51fc 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -185,8 +185,8 @@ static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
>  	}
>  }
>  
> -static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
> -					  gfp_t gfp_mask)
> +int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
> +			 gfp_t gfp_mask)
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	sector_t capacity = get_capacity(bdev->bd_disk);
> @@ -213,8 +213,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>  			continue;
>  		}
>  
> -		bio = blk_next_bio(bio, bdev, 0, REQ_OP_ZONE_RESET | REQ_SYNC,
> -				   gfp_mask);
> +		bio = blk_next_bio(bio, bdev, 0, op | REQ_SYNC, gfp_mask);
>  		bio->bi_iter.bi_sector = sector;
>  		sector += zone_sectors;
>  
> @@ -231,6 +230,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>  	kfree(need_reset);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(blkdev_zone_mgmt_all);
>  
>  static int blkdev_zone_reset_all(struct block_device *bdev, gfp_t gfp_mask)
>  {
> @@ -295,7 +295,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  	 */
>  	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity) {
>  		if (!blk_queue_zone_resetall(q))
> -			return blkdev_zone_reset_all_emulated(bdev, gfp_mask);
> +			return blkdev_zone_mgmt_all(bdev, op, gfp_mask);
>  		return blkdev_zone_reset_all(bdev, gfp_mask);
>  	}
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 270cd0c552924..b9baee910b825 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -302,6 +302,8 @@ unsigned int blkdev_nr_zones(struct gendisk *disk);
>  extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  			    sector_t sectors, sector_t nr_sectors,
>  			    gfp_t gfp_mask);
> +int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
> +			 gfp_t gfp_mask);
>  int blk_revalidate_disk_zones(struct gendisk *disk,
>  			      void (*update_driver_data)(struct gendisk *disk));
>  


-- 
Damien Le Moal
Western Digital Research
