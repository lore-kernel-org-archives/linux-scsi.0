Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A174C63798
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 07:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50B01223B0
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 07:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgKTHUt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 02:20:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:47420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgKTHUt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 02:20:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95218AC0C;
        Fri, 20 Nov 2020 07:20:47 +0000 (UTC)
Subject: Re: [PATCH 32/78] block: remove set_device_ro
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20201116145809.410558-1-hch@lst.de>
 <20201116145809.410558-33-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d1beca65-cd8e-57ff-e7d7-6347cb6344b4@suse.de>
Date:   Fri, 20 Nov 2020 08:20:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-33-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/20 3:57 PM, Christoph Hellwig wrote:
> Fold set_device_ro into its only remaining caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/genhd.c         | 7 -------
>   block/ioctl.c         | 2 +-
>   include/linux/genhd.h | 1 -
>   3 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 8c350fecfe8bfe..b0f0b0cac9aa7f 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1843,13 +1843,6 @@ static void set_disk_ro_uevent(struct gendisk *gd, int ro)
>   	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
>   }
>   
> -void set_device_ro(struct block_device *bdev, int flag)
> -{
> -	bdev->bd_part->policy = flag;
> -}
> -
> -EXPORT_SYMBOL(set_device_ro);
> -
>   void set_disk_ro(struct gendisk *disk, int flag)
>   {
>   	struct disk_part_iter piter;
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 96cb4544736468..04255dc5f3bff3 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -371,7 +371,7 @@ static int blkdev_roset(struct block_device *bdev, fmode_t mode,
>   		if (ret)
>   			return ret;
>   	}
> -	set_device_ro(bdev, n);
> +	bdev->bd_part->policy = n;
>   	return 0;
>   }
>   
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 4b22bfd9336e1a..8427ad8bef520d 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -304,7 +304,6 @@ extern void del_gendisk(struct gendisk *gp);
>   extern struct gendisk *get_gendisk(dev_t dev, int *partno);
>   extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
>   
> -extern void set_device_ro(struct block_device *bdev, int flag);
>   extern void set_disk_ro(struct gendisk *disk, int flag);
>   
>   static inline int get_disk_ro(struct gendisk *disk)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
