Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CE5C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiGECm1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiGECm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:42:26 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636081277D
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656988945; x=1688524945;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2wSTglPxExF3q9V48KFVckZugab/uZjKO2SeFC9RfmI=;
  b=isQ2h/Dm1OHSDZbApQeF9uBNbU7PKvDfrtKqurQz2aB/uM4hv8o4+ujd
   2pizEs7X1R4WIhvtHIV3HUdJWRs85H5lOiRAeoPLjFBDPh+t3D7wmQRMT
   Ghyq3TwiZj00ZZn3zsMb1zQJsKPrTXYMUNp/6jfInFxLRwR7PtkoYkwqY
   1X9qks9SFUWGoxefAxF8JBNAl0g7UOR6bS/hIbhpbjv8bGO4Oxn5D+Jjt
   tIvzTdskf9C2CRh+onUYYtNQ0JKiXv69Qt56kVk15KJU47o+Ip4WMUig8
   QPvEet4Dc1DqFOo8C7Mkam4FlSYDckTtF7fB4bhCRJZzeMbreFCmPTjoz
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="205520276"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:42:19 +0800
IronPort-SDR: RRDCH7hRzfrAO0w+ho9FVP30Zjt40FEx1IBFtADn+Wf2b8bR4LxXLuP+Rmc2xkIPOUGp7pGpfq
 x72348Rlh8QF3KGELlOh3cuLzpFvpWy+2yvnqra2K9DznfRuwPR3adrkiBhyGiBkm32zD4GCnb
 Uy/z48OBLonwj0vG4Kozqwkqw07pxWXGUyoI7L5hRUoO467KLrfEFfzWf9oewA/uZJpmvPGBLS
 gGIT+/ECtUZsdXARmS6dMNxlgwqNwbmjX3+FmzLprPKRgGMHN//007eI+Y0WZUH5D8w5FFXqWb
 c9SQ0SLjMgnpqskTjx1YDBoM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 18:59:39 -0700
IronPort-SDR: fiw1oKKt/MosFTyBrHJWDkVmDxR1TYn3FtRS3IYVDRDhgT+QlkeDFo788ZSbrh6WRga7YE+kn5
 HSOVQXFUd1pqv/01cQJluC5x6QVXChVvYsVpyJkXx4eUKt2gZL75SxzDcYYFJlZ6QK341DgC4i
 daBkPFXyzNieRN5vgfAk4GOmxbt8wiK5jToc6rXFbFlykBIbZbmMeEJY83Uk/OQVrCfzawvWqg
 Sxo7CI160hrCW86eVppBhb1p+zKafVgXry6o5/6oetfCDelULFmDzwb9lJ3Z1uaIbSPXh7cxcQ
 VPA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:42:20 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRlv4Phrz1RwqM
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:42:19 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656988939; x=1659580940; bh=2wSTglPxExF3q9V48KFVckZugab/uZjKO2S
        eFC9RfmI=; b=FhilygavoFIJwURqIZIJu1RX+UW9fB3hWYD8CVRA93ld508a8WD
        9tvR5ICW5QEmOmErD1h7SU2mJlrlGCNkMAfJ4wTaQ8LuVAbeVUW6A5bar1olpmj6
        JEmIMn59dKSOWiwEdsLRslTtqTbzkCmDRUzJ6tpxWhcGwZiIviWhzHD97HRSSBK8
        i9kmnnmfwu9uWo99PFPrb+sesnxyI0i3A9wsRaQmt0Ro8/Hmrum30ybpvpOkFs1q
        dHGwvMjw1NXO5gpEgsUXsaCtczOgu/TSlu3eU+gkyvxdu+X0bb9a2LVrSkbOKii+
        q5JYoeDlibeVluzqnVc937BRE+dCvP/0z+w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JsXQwY2qa2bt for <linux-scsi@vger.kernel.org>;
        Mon,  4 Jul 2022 19:42:19 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRlt1FH1z1RtVk;
        Mon,  4 Jul 2022 19:42:18 -0700 (PDT)
Message-ID: <1b49bf54-4272-b550-b1f8-4f5a46e2575a@opensource.wdc.com>
Date:   Tue, 5 Jul 2022 11:42:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 10/17] block: pass a gendisk to
 blk_queue_free_zone_bitmaps
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-11-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-11-hch@lst.de>
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
>  block/blk-zoned.c | 8 +++++---
>  block/blk.h       | 4 ++--
>  block/genhd.c     | 2 +-
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 5a97b48102221..9085f9fb3ab42 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -449,8 +449,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>  	return ret;
>  }
>  
> -void blk_queue_free_zone_bitmaps(struct request_queue *q)
> +void disk_free_zone_bitmaps(struct gendisk *disk)
>  {
> +	struct request_queue *q = disk->queue;
> +
>  	kfree(q->conv_zones_bitmap);
>  	q->conv_zones_bitmap = NULL;
>  	kfree(q->seq_zones_wlock);
> @@ -612,7 +614,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>  		ret = 0;
>  	} else {
>  		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
> -		blk_queue_free_zone_bitmaps(q);
> +		disk_free_zone_bitmaps(disk);
>  	}
>  	blk_mq_unfreeze_queue(q);
>  
> @@ -628,7 +630,7 @@ void disk_clear_zone_settings(struct gendisk *disk)
>  
>  	blk_mq_freeze_queue(q);
>  
> -	blk_queue_free_zone_bitmaps(q);
> +	disk_free_zone_bitmaps(disk);
>  	blk_queue_flag_clear(QUEUE_FLAG_ZONE_RESETALL, q);
>  	q->required_elevator_features &= ~ELEVATOR_F_ZBD_SEQ_WRITE;
>  	q->nr_zones = 0;
> diff --git a/block/blk.h b/block/blk.h
> index 7482a3a441dd9..b71e22c97d773 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -405,10 +405,10 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
>  #endif
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
> -void blk_queue_free_zone_bitmaps(struct request_queue *q);
> +void disk_free_zone_bitmaps(struct gendisk *disk);
>  void disk_clear_zone_settings(struct gendisk *disk);
>  #else
> -static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
> +static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
>  static inline void disk_clear_zone_settings(struct gendisk *disk) {}
>  #endif
>  
> diff --git a/block/genhd.c b/block/genhd.c
> index d0bdeb93e922c..9d30f159c59ac 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1165,7 +1165,7 @@ static void disk_release(struct device *dev)
>  
>  	disk_release_events(disk);
>  	kfree(disk->random);
> -	blk_queue_free_zone_bitmaps(disk->queue);
> +	disk_free_zone_bitmaps(disk);
>  	xa_destroy(&disk->part_tbl);
>  
>  	disk->queue->disk = NULL;


-- 
Damien Le Moal
Western Digital Research
