Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B9DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiGEC7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiGEC7N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:59:13 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE92FCF
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656989951; x=1688525951;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=c1YXb43PV8tICjE/oGwgecht68Scc3uuiii3avgEI3c=;
  b=S6FReQfdgUHuZC2TtciDhQvKpiZonCvx/g6dvB8JPXavSOUZ54TZgsE6
   E0IreQ97v8PPeI/TnNBJ7aaEMt+aiNX8vgnpBVHFlZUeZeMx/g7JrU9qL
   i/TtzOxkouZ8McapL+SBs1jp+ri3xkgc1YLsR/BGhDO6KACmd2tZxPl8+
   +UbfQjtHzdj4pfGvvc4N5pTj3Eadihy9C4dAiiQ0HSb9/iGgujXDCs3a7
   0UcKp70quzsdLD4Z/VO0yS40E8ipIpQYkdGAyCCkUTVqBQMGFt5flvatB
   AWyIo2FBUxtMpuKfkTXy3xQrhRB5ieLUcKr5rl3+5ScXO+ZxFQCi6uaza
   w==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="209701494"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:59:09 +0800
IronPort-SDR: FUk7rzC8+6631I5cvDQA7EepSnjoXWkQD3T/nq/JmxfSDTUX1wCGU8iH9M533YUAyva+bl/VC3
 bo//PiT38b1AyX3m8cdLPAcxG2QC7NARO702C9fIfiOPW6QoVHqPorUVliPzkAk69Pf/D5XqFX
 gHvOsGrm9ub+ZCAWaDIGpr/DuYRK6B8CQBUHTZWSQjAHff1hDBDKuAtx7q79uOvRSor+eA467u
 g8I+nT+o7B+jgMueWm1EsEPvwOo+7b5Sxd7Z74+2Qvso+N94LHOWwraRRU2EP5iaFLaM6fl+S8
 m9eQEoBri4o8oWUi5kdLT3cg
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:21:01 -0700
IronPort-SDR: uoVpBjwPlrML331Cil6FbKZ6ZBSmDd96n0gRhpM5NXlmibck4r5tIf50DFiXu6+4vro3BLc8Kn
 LoP88oX8zF69KjFOeHe3p+kOg/T1r0IRcy60stw4XkLF8Y85o/BsOaJfL5eJJdQrMiwWhIp0un
 KJDhOhS6qIbRiDZq0Q3xtvx3ht8e3lYtMONTuX/9cuapjZ1bZdu8moyGN3hwZXFMc3HoC41tJ+
 r9cRtJZ/a6+JtTwrjKhZYuYB/i6B0GHMh2B5PrZ9BTElJgj2Em8frTV326BUSgI7wYoBpO+VTn
 DVo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:59:10 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcS7K0W98z1Rwry
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:59:09 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656989947; x=1659581948; bh=c1YXb43PV8tICjE/oGwgecht68Scc3uuiii
        3avgEI3c=; b=IVaR2vEhrjV+lmZxCKkMpY6SyTZwkCphL7dI7bw88ebISuYLAwB
        FB/B48mJstv09e3EIJkfu7LBQT9zjYdBm4vJBAfQeLkbTh50WLMBE95X2XmFfKnE
        t0kEx8NZON/a1MMpgBLIRioZlvJbk5QPwE2bqXQQaECsGCIb0+sQBi+aMAVeqRme
        RzR45PEjgXrh2RDs5q01y4XjQdw7qGmUfEotTIhpyfYuxIYTNstA7MTLdGfQwZDl
        5lgbXYBZT+bpGvHSEcKzgsdjPGEtjOe//r5Rx13RaIMRkg9b+M8QHBbXD17d4Vin
        zty2gCzCdupT/i1OYPqHiusc0TdvcCTocoQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JISP9CUFsoeG for <linux-scsi@vger.kernel.org>;
        Mon,  4 Jul 2022 19:59:07 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcS7F5f7pz1RtVk;
        Mon,  4 Jul 2022 19:59:05 -0700 (PDT)
Message-ID: <1b7c08a5-f0e0-f5cb-7575-e9d3b79fec99@opensource.wdc.com>
Date:   Tue, 5 Jul 2022 11:59:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 17/17] block: move zone related fields to struct gendisk
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-18-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-18-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/4/22 21:45, Christoph Hellwig wrote:
> Move the zone related fields that are currently stored in
> struct request_queue to struct gendisk as these are part of the highlevel
> block layer API and are only used for non-passthrough I/O that requires
> the gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  block/blk-mq-debugfs-zoned.c   |  6 +--
>  block/blk-sysfs.c              |  2 +-
>  block/blk-zoned.c              | 45 ++++++++---------
>  drivers/block/null_blk/zoned.c |  2 +-
>  drivers/md/dm-zone.c           | 74 +++++++++++++--------------
>  drivers/nvme/host/multipath.c  |  2 +-
>  drivers/nvme/target/zns.c      |  2 +-
>  drivers/scsi/sd_zbc.c          |  2 +-
>  include/linux/blk-mq.h         |  8 +--
>  include/linux/blkdev.h         | 91 ++++++++++++++++------------------
>  10 files changed, 110 insertions(+), 124 deletions(-)
> 
> diff --git a/block/blk-mq-debugfs-zoned.c b/block/blk-mq-debugfs-zoned.c
> index 038cb627c8689..a77b099c34b7a 100644
> --- a/block/blk-mq-debugfs-zoned.c
> +++ b/block/blk-mq-debugfs-zoned.c
> @@ -11,11 +11,11 @@ int queue_zone_wlock_show(void *data, struct seq_file *m)
>  	struct request_queue *q = data;
>  	unsigned int i;
>  
> -	if (!q->seq_zones_wlock)
> +	if (!q->disk->seq_zones_wlock)
>  		return 0;
>  
> -	for (i = 0; i < q->nr_zones; i++)
> -		if (test_bit(i, q->seq_zones_wlock))
> +	for (i = 0; i < q->disk->nr_zones; i++)
> +		if (test_bit(i, q->disk->seq_zones_wlock))
>  			seq_printf(m, "%u\n", i);
>  
>  	return 0;
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 5ce72345ac666..c0303026752d5 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -325,7 +325,7 @@ static ssize_t queue_zoned_show(struct request_queue *q, char *page)
>  
>  static ssize_t queue_nr_zones_show(struct request_queue *q, char *page)
>  {
> -	return queue_var_show(blk_queue_nr_zones(q), page);
> +	return queue_var_show(disk_nr_zones(q->disk), page);
>  }
>  
>  static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index ee8752f083a94..4826083ce9a48 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -57,10 +57,10 @@ EXPORT_SYMBOL_GPL(blk_zone_cond_str);
>   */
>  bool blk_req_needs_zone_write_lock(struct request *rq)
>  {
> -	if (!rq->q->seq_zones_wlock)
> +	if (blk_rq_is_passthrough(rq))
>  		return false;
>  
> -	if (blk_rq_is_passthrough(rq))
> +	if (!rq->q->disk->seq_zones_wlock)
>  		return false;
>  
>  	switch (req_op(rq)) {
> @@ -77,7 +77,7 @@ bool blk_req_zone_write_trylock(struct request *rq)
>  {
>  	unsigned int zno = blk_rq_zone_no(rq);
>  
> -	if (test_and_set_bit(zno, rq->q->seq_zones_wlock))
> +	if (test_and_set_bit(zno, rq->q->disk->seq_zones_wlock))
>  		return false;
>  
>  	WARN_ON_ONCE(rq->rq_flags & RQF_ZONE_WRITE_LOCKED);
> @@ -90,7 +90,7 @@ EXPORT_SYMBOL_GPL(blk_req_zone_write_trylock);
>  void __blk_req_zone_write_lock(struct request *rq)
>  {
>  	if (WARN_ON_ONCE(test_and_set_bit(blk_rq_zone_no(rq),
> -					  rq->q->seq_zones_wlock)))
> +					  rq->q->disk->seq_zones_wlock)))
>  		return;
>  
>  	WARN_ON_ONCE(rq->rq_flags & RQF_ZONE_WRITE_LOCKED);
> @@ -101,9 +101,9 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_lock);
>  void __blk_req_zone_write_unlock(struct request *rq)
>  {
>  	rq->rq_flags &= ~RQF_ZONE_WRITE_LOCKED;
> -	if (rq->q->seq_zones_wlock)
> +	if (rq->q->disk->seq_zones_wlock)
>  		WARN_ON_ONCE(!test_and_clear_bit(blk_rq_zone_no(rq),
> -						 rq->q->seq_zones_wlock));
> +						 rq->q->disk->seq_zones_wlock));
>  }
>  EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
>  
> @@ -189,7 +189,7 @@ static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
>  int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
>  			 gfp_t gfp_mask)
>  {
> -	struct request_queue *q = bdev_get_queue(bdev);
> +	struct gendisk *disk = bdev->bd_disk;
>  	sector_t capacity = bdev_nr_sectors(bdev);
>  	sector_t zone_sectors = bdev_zone_sectors(bdev);
>  	unsigned long *need_reset;
> @@ -197,19 +197,18 @@ int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
>  	sector_t sector = 0;
>  	int ret;
>  
> -	need_reset = blk_alloc_zone_bitmap(q->node, q->nr_zones);
> +	need_reset = blk_alloc_zone_bitmap(disk->queue->node, disk->nr_zones);
>  	if (!need_reset)
>  		return -ENOMEM;
>  
> -	ret = bdev->bd_disk->fops->report_zones(bdev->bd_disk, 0,
> -				q->nr_zones, blk_zone_need_reset_cb,
> -				need_reset);
> +	ret = disk->fops->report_zones(disk, 0, disk->nr_zones,
> +				       blk_zone_need_reset_cb, need_reset);
>  	if (ret < 0)
>  		goto out_free_need_reset;
>  
>  	ret = 0;
>  	while (sector < capacity) {
> -		if (!test_bit(blk_queue_zone_no(q, sector), need_reset)) {
> +		if (!test_bit(disk_zone_no(disk, sector), need_reset)) {
>  			sector += zone_sectors;
>  			continue;
>  		}
> @@ -452,12 +451,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>  
>  void disk_free_zone_bitmaps(struct gendisk *disk)
>  {
> -	struct request_queue *q = disk->queue;
> -
> -	kfree(q->conv_zones_bitmap);
> -	q->conv_zones_bitmap = NULL;
> -	kfree(q->seq_zones_wlock);
> -	q->seq_zones_wlock = NULL;
> +	kfree(disk->conv_zones_bitmap);
> +	disk->conv_zones_bitmap = NULL;
> +	kfree(disk->seq_zones_wlock);
> +	disk->seq_zones_wlock = NULL;
>  }
>  
>  struct blk_revalidate_zone_args {
> @@ -607,9 +604,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>  	blk_mq_freeze_queue(q);
>  	if (ret > 0) {
>  		blk_queue_chunk_sectors(q, args.zone_sectors);
> -		q->nr_zones = args.nr_zones;
> -		swap(q->seq_zones_wlock, args.seq_zones_wlock);
> -		swap(q->conv_zones_bitmap, args.conv_zones_bitmap);
> +		disk->nr_zones = args.nr_zones;
> +		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
> +		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
>  		if (update_driver_data)
>  			update_driver_data(disk);
>  		ret = 0;
> @@ -634,9 +631,9 @@ void disk_clear_zone_settings(struct gendisk *disk)
>  	disk_free_zone_bitmaps(disk);
>  	blk_queue_flag_clear(QUEUE_FLAG_ZONE_RESETALL, q);
>  	q->required_elevator_features &= ~ELEVATOR_F_ZBD_SEQ_WRITE;
> -	q->nr_zones = 0;
> -	q->max_open_zones = 0;
> -	q->max_active_zones = 0;
> +	disk->nr_zones = 0;
> +	disk->max_open_zones = 0;
> +	disk->max_active_zones = 0;
>  	q->limits.chunk_sectors = 0;
>  	q->limits.zone_write_granularity = 0;
>  	q->limits.max_zone_append_sectors = 0;
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index e62c52e964259..64b06caab9843 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -170,7 +170,7 @@ int null_register_zoned_dev(struct nullb *nullb)
>  			return ret;
>  	} else {
>  		blk_queue_chunk_sectors(q, dev->zone_size_sects);
> -		q->nr_zones = bdev_nr_zones(nullb->disk->part0);
> +		nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
>  	}
>  
>  	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 842c31019b513..2b89cde30c9e9 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -139,13 +139,11 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
>  
>  void dm_cleanup_zoned_dev(struct mapped_device *md)
>  {
> -	struct request_queue *q = md->queue;
> -
> -	if (q) {
> -		kfree(q->conv_zones_bitmap);
> -		q->conv_zones_bitmap = NULL;
> -		kfree(q->seq_zones_wlock);
> -		q->seq_zones_wlock = NULL;
> +	if (md->disk) {
> +		kfree(md->disk->conv_zones_bitmap);
> +		md->disk->conv_zones_bitmap = NULL;
> +		kfree(md->disk->seq_zones_wlock);
> +		md->disk->seq_zones_wlock = NULL;
>  	}
>  
>  	kvfree(md->zwp_offset);
> @@ -179,31 +177,31 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
>  				 void *data)
>  {
>  	struct mapped_device *md = data;
> -	struct request_queue *q = md->queue;
> +	struct gendisk *disk = md->disk;
>  
>  	switch (zone->type) {
>  	case BLK_ZONE_TYPE_CONVENTIONAL:
> -		if (!q->conv_zones_bitmap) {
> -			q->conv_zones_bitmap =
> -				kcalloc(BITS_TO_LONGS(q->nr_zones),
> +		if (!disk->conv_zones_bitmap) {
> +			disk->conv_zones_bitmap =
> +				kcalloc(BITS_TO_LONGS(disk->nr_zones),
>  					sizeof(unsigned long), GFP_NOIO);
> -			if (!q->conv_zones_bitmap)
> +			if (!disk->conv_zones_bitmap)
>  				return -ENOMEM;
>  		}
> -		set_bit(idx, q->conv_zones_bitmap);
> +		set_bit(idx, disk->conv_zones_bitmap);
>  		break;
>  	case BLK_ZONE_TYPE_SEQWRITE_REQ:
>  	case BLK_ZONE_TYPE_SEQWRITE_PREF:
> -		if (!q->seq_zones_wlock) {
> -			q->seq_zones_wlock =
> -				kcalloc(BITS_TO_LONGS(q->nr_zones),
> +		if (!disk->seq_zones_wlock) {
> +			disk->seq_zones_wlock =
> +				kcalloc(BITS_TO_LONGS(disk->nr_zones),
>  					sizeof(unsigned long), GFP_NOIO);
> -			if (!q->seq_zones_wlock)
> +			if (!disk->seq_zones_wlock)
>  				return -ENOMEM;
>  		}
>  		if (!md->zwp_offset) {
>  			md->zwp_offset =
> -				kvcalloc(q->nr_zones, sizeof(unsigned int),
> +				kvcalloc(disk->nr_zones, sizeof(unsigned int),
>  					 GFP_KERNEL);
>  			if (!md->zwp_offset)
>  				return -ENOMEM;
> @@ -228,7 +226,7 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
>   */
>  static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>  {
> -	struct request_queue *q = md->queue;
> +	struct gendisk *disk = md->disk;
>  	unsigned int noio_flag;
>  	int ret;
>  
> @@ -236,7 +234,7 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>  	 * Check if something changed. If yes, cleanup the current resources
>  	 * and reallocate everything.
>  	 */
> -	if (!q->nr_zones || q->nr_zones != md->nr_zones)
> +	if (!disk->nr_zones || disk->nr_zones != md->nr_zones)
>  		dm_cleanup_zoned_dev(md);
>  	if (md->nr_zones)
>  		return 0;
> @@ -246,17 +244,17 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>  	 * operations in this context are done as if GFP_NOIO was specified.
>  	 */
>  	noio_flag = memalloc_noio_save();
> -	ret = dm_blk_do_report_zones(md, t, 0, q->nr_zones,
> +	ret = dm_blk_do_report_zones(md, t, 0, disk->nr_zones,
>  				     dm_zone_revalidate_cb, md);
>  	memalloc_noio_restore(noio_flag);
>  	if (ret < 0)
>  		goto err;
> -	if (ret != q->nr_zones) {
> +	if (ret != disk->nr_zones) {
>  		ret = -EIO;
>  		goto err;
>  	}
>  
> -	md->nr_zones = q->nr_zones;
> +	md->nr_zones = disk->nr_zones;
>  
>  	return 0;
>  
> @@ -301,7 +299,7 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>  	 * correct value to be exposed in sysfs queue/nr_zones.
>  	 */
>  	WARN_ON_ONCE(queue_is_mq(q));
> -	q->nr_zones = bdev_nr_zones(md->disk->part0);
> +	md->disk->nr_zones = bdev_nr_zones(md->disk->part0);
>  
>  	/* Check if zone append is natively supported */
>  	if (dm_table_supports_zone_append(t)) {
> @@ -466,26 +464,26 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md, unsigned int z
>  	}
>  }
>  
> -static inline void dm_zone_lock(struct request_queue *q,
> -				unsigned int zno, struct bio *clone)
> +static inline void dm_zone_lock(struct gendisk *disk, unsigned int zno,
> +				struct bio *clone)
>  {
>  	if (WARN_ON_ONCE(bio_flagged(clone, BIO_ZONE_WRITE_LOCKED)))
>  		return;
>  
> -	wait_on_bit_lock_io(q->seq_zones_wlock, zno, TASK_UNINTERRUPTIBLE);
> +	wait_on_bit_lock_io(disk->seq_zones_wlock, zno, TASK_UNINTERRUPTIBLE);
>  	bio_set_flag(clone, BIO_ZONE_WRITE_LOCKED);
>  }
>  
> -static inline void dm_zone_unlock(struct request_queue *q,
> -				  unsigned int zno, struct bio *clone)
> +static inline void dm_zone_unlock(struct gendisk *disk, unsigned int zno,
> +				  struct bio *clone)
>  {
>  	if (!bio_flagged(clone, BIO_ZONE_WRITE_LOCKED))
>  		return;
>  
> -	WARN_ON_ONCE(!test_bit(zno, q->seq_zones_wlock));
> -	clear_bit_unlock(zno, q->seq_zones_wlock);
> +	WARN_ON_ONCE(!test_bit(zno, disk->seq_zones_wlock));
> +	clear_bit_unlock(zno, disk->seq_zones_wlock);
>  	smp_mb__after_atomic();
> -	wake_up_bit(q->seq_zones_wlock, zno);
> +	wake_up_bit(disk->seq_zones_wlock, zno);
>  
>  	bio_clear_flag(clone, BIO_ZONE_WRITE_LOCKED);
>  }
> @@ -520,7 +518,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  	struct dm_io *io = tio->io;
>  	struct dm_target *ti = tio->ti;
>  	struct mapped_device *md = io->md;
> -	struct request_queue *q = md->queue;
>  	struct bio *clone = &tio->clone;
>  	struct orig_bio_details orig_bio_details;
>  	unsigned int zno;
> @@ -536,7 +533,7 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  
>  	/* Lock the target zone */
>  	zno = bio_zone_no(clone);
> -	dm_zone_lock(q, zno, clone);
> +	dm_zone_lock(md->disk, zno, clone);
>  
>  	orig_bio_details.nr_sectors = bio_sectors(clone);
>  	orig_bio_details.op = bio_op(clone);
> @@ -546,7 +543,7 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  	 * both valid, and if the bio is a zone append, remap it to a write.
>  	 */
>  	if (!dm_zone_map_bio_begin(md, zno, clone)) {
> -		dm_zone_unlock(q, zno, clone);
> +		dm_zone_unlock(md->disk, zno, clone);
>  		return DM_MAPIO_KILL;
>  	}
>  
> @@ -570,12 +567,12 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  		sts = dm_zone_map_bio_end(md, zno, &orig_bio_details,
>  					  *tio->len_ptr);
>  		if (sts != BLK_STS_OK)
> -			dm_zone_unlock(q, zno, clone);
> +			dm_zone_unlock(md->disk, zno, clone);
>  		break;
>  	case DM_MAPIO_REQUEUE:
>  	case DM_MAPIO_KILL:
>  	default:
> -		dm_zone_unlock(q, zno, clone);
> +		dm_zone_unlock(md->disk, zno, clone);
>  		sts = BLK_STS_IOERR;
>  		break;
>  	}
> @@ -592,7 +589,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  {
>  	struct mapped_device *md = io->md;
> -	struct request_queue *q = md->queue;
>  	struct gendisk *disk = md->disk;
>  	struct bio *orig_bio = io->orig_bio;
>  	unsigned int zwp_offset;
> @@ -651,5 +647,5 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  				zwp_offset - bio_sectors(orig_bio);
>  	}
>  
> -	dm_zone_unlock(q, zno, clone);
> +	dm_zone_unlock(disk, zno, clone);
>  }
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index ccf9a6da8f6e1..f26640ccb9555 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -830,7 +830,7 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
>  				   ns->head->disk->queue);
>  #ifdef CONFIG_BLK_DEV_ZONED
>  	if (blk_queue_is_zoned(ns->queue) && ns->head->disk)
> -		ns->head->disk->queue->nr_zones = ns->queue->nr_zones;
> +		ns->head->disk->nr_zones = ns->disk->nr_zones;
>  #endif
>  }
>  
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index c9b2ce06ca93e..385f2fe2792ff 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -57,7 +57,7 @@ bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
>  	 * zones, reject the device. Otherwise, use report zones to detect if
>  	 * the device has conventional zones.
>  	 */
> -	if (ns->bdev->bd_disk->queue->conv_zones_bitmap)
> +	if (ns->bdev->bd_disk->conv_zones_bitmap)
>  		return false;
>  
>  	ret = blkdev_report_zones(ns->bdev, 0, bdev_nr_zones(ns->bdev),
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index b4106f8997342..b8c97456506ac 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -855,7 +855,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
>  
>  	if (sdkp->zone_info.zone_blocks == zone_blocks &&
>  	    sdkp->zone_info.nr_zones == nr_zones &&
> -	    disk->queue->nr_zones == nr_zones)
> +	    disk->nr_zones == nr_zones)
>  		goto unlock;
>  
>  	flags = memalloc_noio_save();
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 43aad0da3305d..1b0b753609975 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -1123,12 +1123,12 @@ void blk_dump_rq_flags(struct request *, char *);
>  #ifdef CONFIG_BLK_DEV_ZONED
>  static inline unsigned int blk_rq_zone_no(struct request *rq)
>  {
> -	return blk_queue_zone_no(rq->q, blk_rq_pos(rq));
> +	return disk_zone_no(rq->q->disk, blk_rq_pos(rq));
>  }
>  
>  static inline unsigned int blk_rq_zone_is_seq(struct request *rq)
>  {
> -	return blk_queue_zone_is_seq(rq->q, blk_rq_pos(rq));
> +	return disk_zone_is_seq(rq->q->disk, blk_rq_pos(rq));
>  }
>  
>  bool blk_req_needs_zone_write_lock(struct request *rq);
> @@ -1150,8 +1150,8 @@ static inline void blk_req_zone_write_unlock(struct request *rq)
>  
>  static inline bool blk_req_zone_is_write_locked(struct request *rq)
>  {
> -	return rq->q->seq_zones_wlock &&
> -		test_bit(blk_rq_zone_no(rq), rq->q->seq_zones_wlock);
> +	return rq->q->disk->seq_zones_wlock &&
> +		test_bit(blk_rq_zone_no(rq), rq->q->disk->seq_zones_wlock);
>  }
>  
>  static inline bool blk_req_can_dispatch_to_zone(struct request *rq)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f1eca3f5610eb..547eb07848741 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -164,6 +164,29 @@ struct gendisk {
>  #ifdef  CONFIG_BLK_DEV_INTEGRITY
>  	struct kobject integrity_kobj;
>  #endif	/* CONFIG_BLK_DEV_INTEGRITY */
> +
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	/*
> +	 * Zoned block device information for request dispatch control.
> +	 * nr_zones is the total number of zones of the device. This is always
> +	 * 0 for regular block devices. conv_zones_bitmap is a bitmap of nr_zones
> +	 * bits which indicates if a zone is conventional (bit set) or
> +	 * sequential (bit clear). seq_zones_wlock is a bitmap of nr_zones
> +	 * bits which indicates if a zone is write locked, that is, if a write
> +	 * request targeting the zone was dispatched.
> +	 *
> +	 * Reads of this information must be protected with blk_queue_enter() /
> +	 * blk_queue_exit(). Modifying this information is only allowed while
> +	 * no requests are being processed. See also blk_mq_freeze_queue() and
> +	 * blk_mq_unfreeze_queue().
> +	 */
> +	unsigned int		nr_zones;
> +	unsigned int		max_open_zones;
> +	unsigned int		max_active_zones;
> +	unsigned long		*conv_zones_bitmap;
> +	unsigned long		*seq_zones_wlock;
> +#endif /* CONFIG_BLK_DEV_ZONED */
> +
>  #if IS_ENABLED(CONFIG_CDROM)
>  	struct cdrom_device_info *cdi;
>  #endif
> @@ -469,31 +492,6 @@ struct request_queue {
>  
>  	unsigned int		required_elevator_features;
>  
> -#ifdef CONFIG_BLK_DEV_ZONED
> -	/*
> -	 * Zoned block device information for request dispatch control.
> -	 * nr_zones is the total number of zones of the device. This is always
> -	 * 0 for regular block devices. conv_zones_bitmap is a bitmap of nr_zones
> -	 * bits which indicates if a zone is conventional (bit set) or
> -	 * sequential (bit clear). seq_zones_wlock is a bitmap of nr_zones
> -	 * bits which indicates if a zone is write locked, that is, if a write
> -	 * request targeting the zone was dispatched. All three fields are
> -	 * initialized by the low level device driver (e.g. scsi/sd.c).
> -	 * Stacking drivers (device mappers) may or may not initialize
> -	 * these fields.
> -	 *
> -	 * Reads of this information must be protected with blk_queue_enter() /
> -	 * blk_queue_exit(). Modifying this information is only allowed while
> -	 * no requests are being processed. See also blk_mq_freeze_queue() and
> -	 * blk_mq_unfreeze_queue().
> -	 */
> -	unsigned int		nr_zones;
> -	unsigned long		*conv_zones_bitmap;
> -	unsigned long		*seq_zones_wlock;
> -	unsigned int		max_open_zones;
> -	unsigned int		max_active_zones;
> -#endif /* CONFIG_BLK_DEV_ZONED */
> -
>  	int			node;
>  #ifdef CONFIG_BLK_DEV_IO_TRACE
>  	struct blk_trace __rcu	*blk_trace;
> @@ -670,63 +668,59 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
>  }
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
> -static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
> +static inline unsigned int disk_nr_zones(struct gendisk *disk)
>  {
> -	return blk_queue_is_zoned(q) ? q->nr_zones : 0;
> +	return blk_queue_is_zoned(disk->queue) ? disk->nr_zones : 0;
>  }
>  
> -static inline unsigned int blk_queue_zone_no(struct request_queue *q,
> -					     sector_t sector)
> +static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>  {
> -	if (!blk_queue_is_zoned(q))
> +	if (!blk_queue_is_zoned(disk->queue))
>  		return 0;
> -	return sector >> ilog2(q->limits.chunk_sectors);
> +	return sector >> ilog2(disk->queue->limits.chunk_sectors);
>  }
>  
> -static inline bool blk_queue_zone_is_seq(struct request_queue *q,
> -					 sector_t sector)
> +static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
>  {
> -	if (!blk_queue_is_zoned(q))
> +	if (!blk_queue_is_zoned(disk->queue))
>  		return false;
> -	if (!q->conv_zones_bitmap)
> +	if (!disk->conv_zones_bitmap)
>  		return true;
> -	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);
> +	return !test_bit(disk_zone_no(disk, sector), disk->conv_zones_bitmap);
>  }
>  
>  static inline void disk_set_max_open_zones(struct gendisk *disk,
>  		unsigned int max_open_zones)
>  {
> -	disk->queue->max_open_zones = max_open_zones;
> +	disk->max_open_zones = max_open_zones;
>  }
>  
>  static inline void disk_set_max_active_zones(struct gendisk *disk,
>  		unsigned int max_active_zones)
>  {
> -	disk->queue->max_active_zones = max_active_zones;
> +	disk->max_active_zones = max_active_zones;
>  }
>  
>  static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
>  {
> -	return bdev->bd_disk->queue->max_open_zones;
> +	return bdev->bd_disk->max_open_zones;
>  }
>  
>  static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
>  {
> -	return bdev->bd_disk->queue->max_active_zones;
> +	return bdev->bd_disk->max_active_zones;
>  }
>  
>  #else /* CONFIG_BLK_DEV_ZONED */
> -static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
> +static inline unsigned int disk_nr_zones(struct gendisk *disk)
>  {
>  	return 0;
>  }
> -static inline bool blk_queue_zone_is_seq(struct request_queue *q,
> -					 sector_t sector)
> +static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
>  {
>  	return false;
>  }
> -static inline unsigned int blk_queue_zone_no(struct request_queue *q,
> -					     sector_t sector)
> +static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>  {
>  	return 0;
>  }
> @@ -734,6 +728,7 @@ static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
>  {
>  	return 0;
>  }
> +
>  static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
>  {
>  	return 0;
> @@ -902,14 +897,12 @@ const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
>  
>  static inline unsigned int bio_zone_no(struct bio *bio)
>  {
> -	return blk_queue_zone_no(bdev_get_queue(bio->bi_bdev),
> -				 bio->bi_iter.bi_sector);
> +	return disk_zone_no(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
>  }
>  
>  static inline unsigned int bio_zone_is_seq(struct bio *bio)
>  {
> -	return blk_queue_zone_is_seq(bdev_get_queue(bio->bi_bdev),
> -				     bio->bi_iter.bi_sector);
> +	return disk_zone_is_seq(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
>  }
>  
>  /*


-- 
Damien Le Moal
Western Digital Research
