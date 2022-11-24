Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A26DC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Nov 2022 01:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiKXBkd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 20:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKXBkc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 20:40:32 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DEFD02D1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2022 17:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669254029; x=1700790029;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h8Ap5RoCVoF9g4JVuQUMI49lLYWEvYz81WaaV6s2ssQ=;
  b=eBfXMsRhW+VQYNx/NiEcIeLeeZhuSMZEcqMD2NEQndFG125VXwndCXPb
   NKYOXTjOwhsdPj406JKON71atyc1qcy2BVWXOYrQF3j8ODeVYGEV8bJIc
   lK5jNSAyA+0LnIXd3zoRMroi0QxYbQUuFCOiQAb4Qy5m1NyZAwcEOIL5m
   cJzkD8sD1Qb2MdPUPDDZRArJh4E/hFiIBYsmlycXBZfqOI0o9euo0eWIK
   /lIeJ8X51tF7f31fPR+758ZaecW5uTr3MX3rOWYCwu7G5kBNqCfHMSK77
   LqKm+BNiuwUmcIDyWoMZgZ0plYDBwPFWGjh5TUblDKyFSPSTxZ8n6SaAe
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,189,1665417600"; 
   d="scan'208";a="217345683"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Nov 2022 09:40:29 +0800
IronPort-SDR: Gn6P0LYc+pBKpl/wjBnXwTyq/pMM72Wm9Dk8apIzp4UWioPeBSHpfS6HK/4hxUoWzgJr/6RWSx
 Mdqyv+c0NHQYehGve9C9xzQwE+RRY48Ca93Ml+ZqQOB3mmmY8AxUuqQjMirdJNYUOrSlzVBfEa
 zEcmOAn3BUA6qoTm/c34DcnH8IMlJUfifEsz/7N6/7pCQnb7Uqas+Wntknl+99i1xRKDf787ex
 J6uKj/iSIJUx4rtCaWxN5HVX3vOgANqFBcHVRv+m6cXMNJCsz9/W+1AtiT4CipdBMCcQQb0NFK
 fOw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Nov 2022 16:59:16 -0800
IronPort-SDR: mGZ3PrIelblht05oTWNnR98IODvxWVM8ABIJa9TUrLt/Vk9bgXkl7NRflH2FnHQSehg5nTv+qP
 4/kcpb0HSzOnhUhdZW/me91szfAlRiLKPbgs0xOJU8bjrsYGNmskGOlU/jvYBjiQved/5ML7L4
 VOWSrYRsIPVZ5d6NT0LR35i+w7//heV1ATGsEi4tPHQzzHOpLrUYdoK2Mvts6hOx5c4A35AYi/
 QK7GOiVRsVeKgR05Jvo5fi15d1SBywMfk+41+XjxsGuImF220BS/es0doBiqIo+WEk7bvpjl6a
 D2U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Nov 2022 17:40:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NHgg15S1tz1Rwrq
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2022 17:40:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1669254028; x=1671846029; bh=h8Ap5RoCVoF9g4JVuQUMI49lLYWEvYz81Wa
        aV6s2ssQ=; b=W4xyKMm02RrKrtqP+Yg90HJSHpu2Oms0fIyo4EofvsUr2CaGB/O
        wLU5xKdB8AOsi0q0GMBEtEpJnRwaq7d6ieAiUnJXYgtCkB5cjpa4FFTETudMPmMi
        oN7Jgx9keH31vGLk2HY45x1ojJnU+AxcDcydiDk3Ys7BtNl98tEObzJZdi2xqKWb
        sqJwuO/6qKCk85RNcBitI5Csjp9DLwvL0VaEcdcFHE9KLwKs6TmOMW5hvCwDFy59
        tXAQ3uc1I2VmTWIViyPDRswpzYU0dV5hSJ84QytcYe71ljAscJ60x9RkDZWIY7aj
        cSIhuWM6Fey8Eqf5temoYvzZJQHxSiXUCKA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6bHds08ee3yc for <linux-scsi@vger.kernel.org>;
        Wed, 23 Nov 2022 17:40:28 -0800 (PST)
Received: from [10.225.163.55] (unknown [10.225.163.55])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NHgfz22DKz1RvLy;
        Wed, 23 Nov 2022 17:40:27 -0800 (PST)
Message-ID: <32feb681-e858-1a0c-b91d-3f0d85615a6d@opensource.wdc.com>
Date:   Thu, 24 Nov 2022 10:40:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 8/8] null_blk: Support configuring the maximum segment
 size
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
References: <20221123205740.463185-1-bvanassche@acm.org>
 <20221123205740.463185-9-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221123205740.463185-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/22 05:57, Bart Van Assche wrote:
> Add support for configuring the maximum segment size.
> 
> Add support for segments smaller than the page size.
> 
> This patch enables testing segments smaller than the page size with a
> driver that does not call blk_rq_map_sg().
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Chaitanya Kulkarni <kch@nvidia.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/block/null_blk/main.c     | 20 +++++++++++++++++---
>  drivers/block/null_blk/null_blk.h |  1 +
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index 1f154f92f4c2..bc811ab52c4a 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -157,6 +157,10 @@ static int g_max_sectors;
>  module_param_named(max_sectors, g_max_sectors, int, 0444);
>  MODULE_PARM_DESC(max_sectors, "Maximum size of a command (in 512B sectors)");
>  
> +static unsigned int g_max_segment_size = 1UL << 31;

1UL is unsigned long be this var is unsigned int. Why not simply use
UINT_MAX here ? You prefer the 2GB value ? If yes, then may be at least
change that to "1U << 31", no ?

> +module_param_named(max_segment_size, g_max_segment_size, int, 0444);
> +MODULE_PARM_DESC(max_segment_size, "Maximum size of a segment in bytes");
> +
>  static unsigned int nr_devices = 1;
>  module_param(nr_devices, uint, 0444);
>  MODULE_PARM_DESC(nr_devices, "Number of devices to register");
> @@ -409,6 +413,7 @@ NULLB_DEVICE_ATTR(home_node, uint, NULL);
>  NULLB_DEVICE_ATTR(queue_mode, uint, NULL);
>  NULLB_DEVICE_ATTR(blocksize, uint, NULL);
>  NULLB_DEVICE_ATTR(max_sectors, uint, NULL);
> +NULLB_DEVICE_ATTR(max_segment_size, uint, NULL);
>  NULLB_DEVICE_ATTR(irqmode, uint, NULL);
>  NULLB_DEVICE_ATTR(hw_queue_depth, uint, NULL);
>  NULLB_DEVICE_ATTR(index, uint, NULL);
> @@ -532,6 +537,7 @@ static struct configfs_attribute *nullb_device_attrs[] = {
>  	&nullb_device_attr_queue_mode,
>  	&nullb_device_attr_blocksize,
>  	&nullb_device_attr_max_sectors,
> +	&nullb_device_attr_max_segment_size,
>  	&nullb_device_attr_irqmode,
>  	&nullb_device_attr_hw_queue_depth,
>  	&nullb_device_attr_index,
> @@ -610,7 +616,8 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
>  	return snprintf(page, PAGE_SIZE,
>  			"badblocks,blocking,blocksize,cache_size,"
>  			"completion_nsec,discard,home_node,hw_queue_depth,"
> -			"irqmode,max_sectors,mbps,memory_backed,no_sched,"
> +			"irqmode,max_sectors,max_segment_size,mbps,"
> +			"memory_backed,no_sched,"
>  			"poll_queues,power,queue_mode,shared_tag_bitmap,size,"
>  			"submit_queues,use_per_node_hctx,virt_boundary,zoned,"
>  			"zone_capacity,zone_max_active,zone_max_open,"
> @@ -673,6 +680,7 @@ static struct nullb_device *null_alloc_dev(void)
>  	dev->queue_mode = g_queue_mode;
>  	dev->blocksize = g_bs;
>  	dev->max_sectors = g_max_sectors;
> +	dev->max_segment_size = g_max_segment_size;
>  	dev->irqmode = g_irqmode;
>  	dev->hw_queue_depth = g_hw_queue_depth;
>  	dev->blocking = g_blocking;
> @@ -1214,6 +1222,8 @@ static int null_transfer(struct nullb *nullb, struct page *page,
>  	unsigned int valid_len = len;
>  	int err = 0;
>  
> +	WARN_ONCE(len > dev->max_segment_size, "%u > %u\n", len,
> +		  dev->max_segment_size);
>  	if (!is_write) {
>  		if (dev->zoned)
>  			valid_len = null_zone_valid_read_len(nullb,
> @@ -1249,7 +1259,8 @@ static int null_handle_rq(struct nullb_cmd *cmd)
>  
>  	spin_lock_irq(&nullb->lock);
>  	rq_for_each_segment(bvec, rq, iter) {
> -		len = bvec.bv_len;
> +		len = min(bvec.bv_len, nullb->dev->max_segment_size);
> +		bvec.bv_len = len;
>  		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
>  				     op_is_write(req_op(rq)), sector,
>  				     rq->cmd_flags & REQ_FUA);
> @@ -1276,7 +1287,8 @@ static int null_handle_bio(struct nullb_cmd *cmd)
>  
>  	spin_lock_irq(&nullb->lock);
>  	bio_for_each_segment(bvec, bio, iter) {
> -		len = bvec.bv_len;
> +		len = min(bvec.bv_len, nullb->dev->max_segment_size);
> +		bvec.bv_len = len;
>  		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
>  				     op_is_write(bio_op(bio)), sector,
>  				     bio->bi_opf & REQ_FUA);
> @@ -2088,6 +2100,7 @@ static int null_add_dev(struct nullb_device *dev)
>  	nullb->q->queuedata = nullb;
>  	blk_queue_flag_set(QUEUE_FLAG_NONROT, nullb->q);
>  	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, nullb->q);
> +	blk_queue_flag_set(QUEUE_FLAG_SUB_PAGE_SEGMENTS, nullb->q);
>  
>  	mutex_lock(&lock);
>  	rv = ida_simple_get(&nullb_indexes, 0, 0, GFP_KERNEL);
> @@ -2106,6 +2119,7 @@ static int null_add_dev(struct nullb_device *dev)
>  	dev->max_sectors = min_t(unsigned int, dev->max_sectors,
>  				 BLK_DEF_MAX_SECTORS);
>  	blk_queue_max_hw_sectors(nullb->q, dev->max_sectors);
> +	blk_queue_max_segment_size(nullb->q, dev->max_segment_size);

Should we keep the ability to use the kernel default value as the default
here ?
E.g.

	if (dev->max_segment_size)
		blk_queue_max_segment_size(nullb->q,
				dev->max_segment_size);

If yes, then g_max_segment_size initial value should be 0, meaning "kernel
default".

>  
>  	if (dev->virt_boundary)
>  		blk_queue_virt_boundary(nullb->q, PAGE_SIZE - 1);
> diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
> index 94ff68052b1e..6784ee9f5fda 100644
> --- a/drivers/block/null_blk/null_blk.h
> +++ b/drivers/block/null_blk/null_blk.h
> @@ -102,6 +102,7 @@ struct nullb_device {
>  	unsigned int queue_mode; /* block interface */
>  	unsigned int blocksize; /* block size */
>  	unsigned int max_sectors; /* Max sectors per command */
> +	unsigned int max_segment_size; /* Max size of a single DMA segment. */
>  	unsigned int irqmode; /* IRQ completion handler */
>  	unsigned int hw_queue_depth; /* queue depth */
>  	unsigned int index; /* index of the disk, only valid with a disk */

-- 
Damien Le Moal
Western Digital Research

