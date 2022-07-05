Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D5BC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiGECmA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiGECmA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:42:00 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A57912777
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656988919; x=1688524919;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eLFQwSzFJECaf6OosUXPb3bAWqxxfdqOwKldJTt0WWA=;
  b=pvTVpN1bcmrV+k/8zrEOTwr9/KJTYYVGbxBQXNk5/j+FioXjQ6oa53xt
   PjpCjDW9RDLotCy+ArAAfJIy4eYkr+ZaG3mWqtNaS+l7kn54yMlUCmz3n
   J8VORwwXB9cnnbkQFScAqzFuSNiNou89KpFrtHNR/SDIV2xshMHaFruyA
   zC4SYjo7BRdVuyM+j3ASgz8nFDS4UgLHLQcGotgaxJBi1vuE+Mmm5mewZ
   5nrpNlgRVFkk6z/Pxrx8LWUqO4c0ht1wCvJlqQ4RPxP75bODq/QlG81oN
   sRuJVszjvlbv57P+fBFrr6FmCpsdUJ3JxDAmyrC8QO8Xqid2Amw9CxTqt
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="309130058"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:41:58 +0800
IronPort-SDR: yoMQCHaTOPg7jIkrdrVzeCCTOoISyI8w0igpOHuPAjipZrNPvcUGh3et9sLrkRKsWGIAOdmVzs
 Tbv62rdMSk6O5TewtMamdHJQ9AV1GM7rILGZEGOxKN0w1t5FBGZCGc2XGflYWUc7VxMe+XqNUV
 BTPkVfG4K9mUx1pWRugHmaa0/x2lh0g5ivdZbJDWSnymnFVGGE1mOH1er0OCtLZr2KHOl3tRnz
 ZbJ96LRhVMVemv23JGo9djgLQHtfO8Fxxo0BbhBiXO9WRZZw/4zoq6z64ztKVQ0oQwhLFozsD7
 wbESO5Fqhw6bKK/1yjbbtUX4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:03:49 -0700
IronPort-SDR: ksInpa9omGjzqNRhq7YFAI7N38XuGVC9tfINjRH6TJh5qg+7Dn8rYE793hLty/ioNH+1bZmQQA
 1en4/0GKFeHq5Fs/tBR4aJp4A46VQBbaO3qq5mGyL71sC6p1B0pVSEK1Ovq02H3gLgUFgRcU2x
 RjCv2OpPHSi9SOnfShbSjUO5PvAv7sI9ps2nLgrY8kf07HT9m6be7bGVEVHc30OD3P8hrmV1rl
 3c3OlmTmf9Julqz6m8055So57oyMvys0pL6WhMagn4PTrXQNUaOwaLVowLAwjdmzka85XxEL7N
 gC8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:41:58 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRlV0bTwz1Rw4L
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:41:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656988917; x=1659580918; bh=eLFQwSzFJECaf6OosUXPb3bAWqxxfdqOwKl
        dJTt0WWA=; b=LxNrLO6ZbhFAEyfNq/L4fgqsvZQ2q8/DaqYFxH1c3UdTOPTE1r5
        7l/q3VK5nUDxITXFtViV5NQBYZ37l6jLhNJiEokGXl9mH/iQ6YtBEcrPYx1GKuCx
        huC8gnq5XN9+Qbjxix/p6z7sl5bD2f6NyMovHjXKZkHhA9IF37hNwGl4oLgxMgko
        cENFGIVP2uLj7rt1UtxGAJa+/ey8TEnbEUXLHMi/3RZvTSHPxUuu8luydePeF+Ga
        5PiVtNhx8ZweXEoOvw1fkTwnPOguw488PeZdw2302XHTcJETVehzzN18n9/D8gUt
        GC5xZaBbhqWaTWyWdI3I99yYZLTLcpqeB+Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qlDVhgWjlA-u for <linux-scsi@vger.kernel.org>;
        Mon,  4 Jul 2022 19:41:57 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRlS47xBz1RtVk;
        Mon,  4 Jul 2022 19:41:56 -0700 (PDT)
Message-ID: <fe0c09f3-0c0c-0527-88aa-21e13d91a23c@opensource.wdc.com>
Date:   Tue, 5 Jul 2022 11:41:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-10-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/4/22 21:44, Christoph Hellwig wrote:
> Switch to a gendisk based API in preparation for moving all zone related
> fields from the request_queue to the gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  block/blk-settings.c | 2 +-
>  block/blk-zoned.c    | 4 +++-
>  block/blk.h          | 4 ++--
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 35b7bba306a83..8bb9eef5310eb 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -946,7 +946,7 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
>  		blk_queue_zone_write_granularity(q,
>  						queue_logical_block_size(q));
>  	} else {
> -		blk_queue_clear_zone_settings(q);
> +		disk_clear_zone_settings(disk);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(disk_set_zoned);
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 7fbe395fa51fc..5a97b48102221 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -622,8 +622,10 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>  }
>  EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
>  
> -void blk_queue_clear_zone_settings(struct request_queue *q)
> +void disk_clear_zone_settings(struct gendisk *disk)
>  {
> +	struct request_queue *q = disk->queue;
> +
>  	blk_mq_freeze_queue(q);
>  
>  	blk_queue_free_zone_bitmaps(q);
> diff --git a/block/blk.h b/block/blk.h
> index 58ad50cacd2d5..7482a3a441dd9 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -406,10 +406,10 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
>  void blk_queue_free_zone_bitmaps(struct request_queue *q);
> -void blk_queue_clear_zone_settings(struct request_queue *q);
> +void disk_clear_zone_settings(struct gendisk *disk);
>  #else
>  static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
> -static inline void blk_queue_clear_zone_settings(struct request_queue *q) {}
> +static inline void disk_clear_zone_settings(struct gendisk *disk) {}
>  #endif
>  
>  int blk_alloc_ext_minor(void);


-- 
Damien Le Moal
Western Digital Research
