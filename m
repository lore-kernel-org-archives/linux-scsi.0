Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E518C43215
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 10:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D8642243E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 10:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfKTKF3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:05:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:33848 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbfKTKF3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 05:05:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A30BBF9D;
        Wed, 20 Nov 2019 10:05:26 +0000 (UTC)
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
Date:   Wed, 20 Nov 2019 11:05:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191118103117.978-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 11:31 AM, Ming Lei wrote:
> SCSI core uses the atomic variable of sdev->device_busy to track
> in-flight IO requests dispatched to this scsi device. IO request may be
> submitted from any CPU, so the cost for maintaining the shared atomic
> counter can be very big on big NUMA machine with lots of CPU cores.
> 
> sdev->queue_depth is usually used for two purposes: 1) improve IO merge;
> 2) fair IO request scattered among all LUNs.
> 
> blk-mq already provides fair request allocation among all active shared
> request queues(LUNs), see hctx_may_queue().
> 
> NVMe doesn't have such per-request-queue(namespace) queue depth, so it
> is reasonable to ignore the limit for SCSI SSD too. Also IO merge won't
> play big role for reaching top SSD performance.
> 
> With this patch, big cost for tracking in-flight per-LUN requests via
> atomic variable can be saved.
> 
> Given QUEUE_FLAG_NONROT is read in IO path, we have to freeze queue
> before changing this flag.
> 
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bart.vanassche@wdc.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-sysfs.c       | 14 +++++++++++++-
>  drivers/scsi/scsi_lib.c | 24 ++++++++++++++++++------
>  drivers/scsi/sd.c       |  4 ++++
>  3 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index fca9b158f4a0..9cc0dd5f88a1 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -281,6 +281,18 @@ QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
>  QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
>  #undef QUEUE_SYSFS_BIT_FNS
>  
> +static ssize_t queue_store_nonrot_freeze(struct request_queue *q,
> +		const char *page, size_t count)
> +{
> +	size_t ret;
> +
> +	blk_mq_freeze_queue(q);
> +	ret = queue_store_nonrot(q, page, count);
> +	blk_mq_unfreeze_queue(q);
> +
> +	return ret;
> +}
> +
>  static ssize_t queue_zoned_show(struct request_queue *q, char *page)
>  {
>  	switch (blk_queue_zoned_model(q)) {
> @@ -642,7 +654,7 @@ static struct queue_sysfs_entry queue_write_zeroes_max_entry = {
>  static struct queue_sysfs_entry queue_nonrot_entry = {
>  	.attr = {.name = "rotational", .mode = 0644 },
>  	.show = queue_show_nonrot,
> -	.store = queue_store_nonrot,
> +	.store = queue_store_nonrot_freeze,
>  };
>  
>  static struct queue_sysfs_entry queue_zoned_entry = {
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 62a86a82c38d..72655a049efd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -354,7 +354,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>  	if (starget->can_queue > 0)
>  		atomic_dec(&starget->target_busy);
>  
> -	atomic_dec(&sdev->device_busy);
> +	if (!blk_queue_nonrot(sdev->request_queue))
> +		atomic_dec(&sdev->device_busy);
>  }
>  
>  static void scsi_kick_queue(struct request_queue *q)
> @@ -410,7 +411,8 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
>  
>  static inline bool scsi_device_is_busy(struct scsi_device *sdev)
>  {
> -	if (atomic_read(&sdev->device_busy) >= sdev->queue_depth)
> +	if (!blk_queue_nonrot(sdev->request_queue) &&
> +			atomic_read(&sdev->device_busy) >= sdev->queue_depth)
>  		return true;
>  	if (atomic_read(&sdev->device_blocked) > 0)
>  		return true;
> @@ -1283,8 +1285,12 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
>  				  struct scsi_device *sdev)
>  {
>  	unsigned int busy;
> +	bool bypass = blk_queue_nonrot(sdev->request_queue);
>  
> -	busy = atomic_inc_return(&sdev->device_busy) - 1;
> +	if (!bypass)
> +		busy = atomic_inc_return(&sdev->device_busy) - 1;
> +	else
> +		busy = 0;
>  	if (atomic_read(&sdev->device_blocked)) {
>  		if (busy)
>  			goto out_dec;
> @@ -1298,12 +1304,16 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
>  				   "unblocking device at zero depth\n"));
>  	}
>  
> +	if (bypass)
> +		return 1;
> +
>  	if (busy >= sdev->queue_depth)
>  		goto out_dec;
>  
>  	return 1;
>  out_dec:
> -	atomic_dec(&sdev->device_busy);
> +	if (!bypass)
> +		atomic_dec(&sdev->device_busy);
>  	return 0;
>  }
>  
> @@ -1624,7 +1634,8 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
>  	struct request_queue *q = hctx->queue;
>  	struct scsi_device *sdev = q->queuedata;
>  
> -	atomic_dec(&sdev->device_busy);
> +	if (!blk_queue_nonrot(sdev->request_queue))
> +		atomic_dec(&sdev->device_busy);
>  }
>  
>  static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
> @@ -1731,7 +1742,8 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	case BLK_STS_OK:
>  		break;
>  	case BLK_STS_RESOURCE:
> -		if (atomic_read(&sdev->device_busy) ||
> +		if ((!blk_queue_nonrot(sdev->request_queue) &&
> +		     atomic_read(&sdev->device_busy)) ||
>  		    scsi_device_blocked(sdev))
>  			ret = BLK_STS_DEV_RESOURCE;
>  		break;
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 0744c34468e1..c3d47117700d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2927,7 +2927,9 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
>  	rot = get_unaligned_be16(&buffer[4]);
>  
>  	if (rot == 1) {
> +		blk_mq_freeze_queue(q);
>  		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> +		blk_mq_unfreeze_queue(q);
>  		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
>  	}
>  
> @@ -3123,7 +3125,9 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		 * cause this to be updated correctly and any device which
>  		 * doesn't support it should be treated as rotational.
>  		 */
> +		blk_mq_freeze_queue(q);
>  		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
> +		blk_mq_unfreeze_queue(q);
>  		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
>  
>  		if (scsi_device_supports_vpd(sdp)) {
> 
Hmm.

I must admit I patently don't like this explicit dependency on
blk_nonrot(). Having a conditional counter is just an open invitation to
getting things wrong...

I would far prefer if we could delegate any queueing decision to the
elevators, and completely drop the device_busy flag for all devices.
But I do see that this might not be easy to do, nor necessarily
something which others agree on.
So alternatively, can't we make this a per-host flag, instead of having
it per device characteristic?

I'm just thinking of a storage array with a massive cache; it's anyone's
guess if 'nonrot' is set there, but at the same time these things can be
fast, so they might be profiting from dropping the device_busy counter
there, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
