Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C3CC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiGECj7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiGECj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:39:58 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F4F12742
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656988797; x=1688524797;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=76dpMhf7+ALfZDOaNq1izucr4zB/Vi7DG75jhXxoFXg=;
  b=a8yo7AV4LQ4e9M/7Oyo5xX5tuLWn4slhTS5ZlEvlElx5fzBZ/mMX1YOS
   WYz0KcPlUsd8KZ+ukso5r4KxFTctP8uXWaOWz+YSg1rYVu27OLqiJvfv+
   lZ5jB4/twayojY4zNA8JHEbSSpClV9ShcrzbMn+eGjPgtbJL1CITNEBLh
   SGEPKcdffnF+EGKyHRwzW49hRNG3xQ7Ya2F3aeyX5pqSf2dJ4JgRBdmRK
   GlPcdrZpcqdtJLYNpTQtWhr6Ej1q79m3WRSHs55KrLma50/UvSsLjyglW
   SGdarb4hPV8A2WAbIOU44iB1pCxqfb0SO8miKDrxhNgUvVuVP+lc9h3KI
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="203466458"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:39:56 +0800
IronPort-SDR: +3G6pdVclKoi9WQVDsWROxrJSXzXGcP7ZviNch1R4p2+38cUe9q5efqgvYK2XlaQvzQcgQhlJq
 ZNB6KIjvMuSnkl/266ICR7QNQG0r5qXaVqk+V/7lVAiJ+vegcmW4Ju4AnYD/n4GkRJLPvepAr1
 gZfjUPuY+1uJJiIrtRteaKUhZ3k1cEaUb6OO2lx42IC7RUkORvZHFXxhCz6inPHOApD68uATx4
 Y26wJTSdN12CDZ8aMYNivVncqame2o4lalGQKWxjdKI/TBYfV4ZlO7sdRoivAbu2eIobAy9JBt
 LiRVgdVML7en+3rCfwsGEZI5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 18:57:15 -0700
IronPort-SDR: MGKMc2IhX3uOgD746qdIynbjy/7+rcprhgxa5BrTjo1kAmHYUAeExCHlM02VnYRIvrPWgflxSj
 uMJf2M1W+nnrBOEfFIMuy0zSBIghO4b+ljBt61XOok/LewhsuqZ9yFOdkoXU54KLdC479D2XX2
 2nvOm9OZzt8JsUBnYCISEpPvf0wJRq7/xZflrtEiNd7LT/+Z7GMHN1BuzKUziEWXO0gEeCzpqG
 7qdsGRMHbDdh7RIJq7TVehhgDOLj04dYolkLmceX1xaePMa2wPy7CQOhzLi+19mlQiGbEuwSbK
 pRA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:39:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRj82N1Vz1RwqM
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:39:56 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656988795; x=1659580796; bh=76dpMhf7+ALfZDOaNq1izucr4zB/Vi7DG75
        jhXxoFXg=; b=VSY0ELQVkD6r3eKYtH/37TiJOqFm8hz/xFBkqaXImabgPK2ZdQY
        vOG8i6j2tEs1ikP209S6UdmWk/4SF1YefC20UUtKm42LyLNBS0GL23I6ZV4XoCLq
        /FJw/usWppw2iqo0tkrfdvaivhOG5YsIbUqkv3JsGh/YA4yUNNsGYMnMB9tv/O25
        t2r2jObHmJkwqQV5zIOiMrU0jQEAjMmfDNiWoit7iVpzUfLhd8PGhS65UGRxesuP
        YNceuVAB5aqScsAyJUMILA1+baUDg4F04K9iGAwDjQFpe/WHCP+NFLiIVIl3N2kI
        E5J5Ttwuls5cTLJ3JfgKbdPnTbyVYbxBy2A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id J3cskUIYJZZb for <linux-scsi@vger.kernel.org>;
        Mon,  4 Jul 2022 19:39:55 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRj614KWz1RtVk;
        Mon,  4 Jul 2022 19:39:53 -0700 (PDT)
Message-ID: <a71ac62a-9fcd-5282-9c4d-17348dff18c5@opensource.wdc.com>
Date:   Tue, 5 Jul 2022 11:39:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 05/17] block: export blkdev_zone_mgmt_all
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-6-hch@lst.de>
 <9e815a0b-0d60-730a-51f8-6ba749b5c60e@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <9e815a0b-0d60-730a-51f8-6ba749b5c60e@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/5/22 11:31, Damien Le Moal wrote:
> On 7/4/22 21:44, Christoph Hellwig wrote:
>> Export blkdev_zone_mgmt_all so that the nvme target can use it instead
>> of duplicating the functionality.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Actually, looking again at this, if we generalize
blkdev_zone_reset_all_emulated() into blkdev_zone_mgmt_all(), we should
not allocate the need_reset bitmap if op is not reset. And the emulation
for open/close/finish all is a bit tricky as we have to look at the
current state of the zones, so we still need the report. The bitmat should
this be something like "do_op" and the bits in it set using a helper for
the zone depending on the op. Then using that function as is in nvmet will
work. Otherwise, as-is, I think it will break something in nvmet.

> 
>> ---
>>  block/blk-zoned.c      | 10 +++++-----
>>  include/linux/blkdev.h |  2 ++
>>  2 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index 90a5c9cc80ab3..7fbe395fa51fc 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -185,8 +185,8 @@ static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
>>  	}
>>  }
>>  
>> -static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>> -					  gfp_t gfp_mask)
>> +int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
>> +			 gfp_t gfp_mask)
>>  {
>>  	struct request_queue *q = bdev_get_queue(bdev);
>>  	sector_t capacity = get_capacity(bdev->bd_disk);
>> @@ -213,8 +213,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>>  			continue;
>>  		}
>>  
>> -		bio = blk_next_bio(bio, bdev, 0, REQ_OP_ZONE_RESET | REQ_SYNC,
>> -				   gfp_mask);
>> +		bio = blk_next_bio(bio, bdev, 0, op | REQ_SYNC, gfp_mask);
>>  		bio->bi_iter.bi_sector = sector;
>>  		sector += zone_sectors;
>>  
>> @@ -231,6 +230,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>>  	kfree(need_reset);
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(blkdev_zone_mgmt_all);
>>  
>>  static int blkdev_zone_reset_all(struct block_device *bdev, gfp_t gfp_mask)
>>  {
>> @@ -295,7 +295,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>>  	 */
>>  	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity) {
>>  		if (!blk_queue_zone_resetall(q))
>> -			return blkdev_zone_reset_all_emulated(bdev, gfp_mask);
>> +			return blkdev_zone_mgmt_all(bdev, op, gfp_mask);
>>  		return blkdev_zone_reset_all(bdev, gfp_mask);
>>  	}
>>  
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 270cd0c552924..b9baee910b825 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -302,6 +302,8 @@ unsigned int blkdev_nr_zones(struct gendisk *disk);
>>  extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>>  			    sector_t sectors, sector_t nr_sectors,
>>  			    gfp_t gfp_mask);
>> +int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
>> +			 gfp_t gfp_mask);
>>  int blk_revalidate_disk_zones(struct gendisk *disk,
>>  			      void (*update_driver_data)(struct gendisk *disk));
>>  
> 
> 


-- 
Damien Le Moal
Western Digital Research
