Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC90C25B67
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 00:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjJXAOB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 20:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJXAOB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 20:14:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D19D10C;
        Mon, 23 Oct 2023 17:13:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91E0C433C8;
        Tue, 24 Oct 2023 00:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698106439;
        bh=ATPML55R7+fiiOOFxhRtqd0G4bkZYOEyzEHjP0fnRuI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LX00oD6Ogif2k+OO7cnFuIbQGVKoZx/tdTJmevwNOgKml4fuJqSEvlugmzb60+fT5
         QchB9SMRjkpJpHPpq1Po+KBDy1QMuJHyyFH1vZ56Je5vddSKSuNpG0dXPLboyU+gat
         QSi7FxHEdQBt3iNPFcz35nHKU38Q0YX3vxuYCSIJ2JOYKxl7d4QZXAEA26uCbWVAfk
         8xYGdcd18CWrRnXAtsNctLkR9R+3hIO8skNSL874/sS1PZzpWhF7utVIiHcAfsLWpQ
         dMYVYomFZBH/dT/kie+dgEE07kcpopetT3n8VMLC5eNRvw1AE/RkvAxb5qEzzWcvYe
         kcZvDWDXHkWaw==
Message-ID: <b65486b6-c1de-43e3-ba45-d9a4034c48d5@kernel.org>
Date:   Tue, 24 Oct 2023 09:13:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 12/19] scsi: scsi_debug: Add the preserves_write_order
 module parameter
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-13-bvanassche@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231023215638.3405959-13-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/23 06:54, Bart Van Assche wrote:
> Zone write locking is not used for zoned devices if the block driver
> reports that it preserves the order of write commands. Make it easier to
> test not using zone write locking by adding support for setting the
> driver_preserves_write_order flag.
> 
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_debug.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 9c0af50501f9..1ea4925d2c2f 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -832,6 +832,7 @@ static int dix_reads;
>  static int dif_errors;
>  
>  /* ZBC global data */
> +static bool sdeb_preserves_write_order;
>  static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed disks */
>  static int sdeb_zbc_zone_cap_mb;
>  static int sdeb_zbc_zone_size_mb;
> @@ -5138,9 +5139,13 @@ static struct sdebug_dev_info *find_build_dev_info(struct scsi_device *sdev)
>  
>  static int scsi_debug_slave_alloc(struct scsi_device *sdp)
>  {
> +	struct request_queue *q = sdp->request_queue;
> +
>  	if (sdebug_verbose)
>  		pr_info("slave_alloc <%u %u %u %llu>\n",
>  		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
> +	if (sdeb_preserves_write_order)
> +		q->limits.driver_preserves_write_order = true;

Nit: this could simply be:

	q->limits.driver_preserves_write_order = sdeb_preserves_write_order;

>  	return 0;
>  }
>  
> @@ -5755,6 +5760,8 @@ module_param_named(statistics, sdebug_statistics, bool, S_IRUGO | S_IWUSR);
>  module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
>  module_param_named(submit_queues, submit_queues, int, S_IRUGO);
>  module_param_named(poll_queues, poll_queues, int, S_IRUGO);
> +module_param_named(preserves_write_order, sdeb_preserves_write_order, bool,
> +		   S_IRUGO);
>  module_param_named(tur_ms_to_ready, sdeb_tur_ms_to_ready, int, S_IRUGO);
>  module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
>  module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
> @@ -5812,6 +5819,8 @@ MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
>  MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
>  MODULE_PARM_DESC(no_rwlock, "don't protect user data reads+writes (def=0)");
>  MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
> +MODULE_PARM_DESC(preserves_write_order,
> +		 "Whether or not to inform the block layer that this driver preserves the order of WRITE commands (def=0)");
>  MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
>  MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
>  MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");

Otherwise, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

