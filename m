Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C664DEE49A4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 04:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjHVEGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 00:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjHVEF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 00:05:56 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9438411D;
        Mon, 21 Aug 2023 21:05:54 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id A49B675E08;
        Tue, 22 Aug 2023 04:05:53 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 824E760924;
        Tue, 22 Aug 2023 04:05:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id fan7TSPOtEei; Tue, 22 Aug 2023 04:05:52 +0000 (UTC)
Received: from [192.168.48.17] (host-104-157-193-42.dyn.295.ca [104.157.193.42])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id DF676600C3;
        Tue, 22 Aug 2023 04:05:50 +0000 (UTC)
Message-ID: <c2344a58-43ca-8587-e4af-66265720ef4b@interlog.com>
Date:   Tue, 22 Aug 2023 00:05:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v10 09/18] scsi: scsi_debug: Add the preserves_write_order
 module parameter
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-10-bvanassche@acm.org>
Content-Language: en-CA
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20230818193546.2014874-10-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-08-18 15:34, Bart Van Assche wrote:
> Zone write locking is not used for zoned devices if the block driver
> reports that it preserves the order of write commands. Make it easier to
> test not using zone write locking by adding support for setting the
> driver_preserves_write_order flag.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 9c0af50501f9..1ea4925d2c2f 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -832,6 +832,7 @@ static int dix_reads;
>   static int dif_errors;
>   
>   /* ZBC global data */
> +static bool sdeb_preserves_write_order;
>   static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed disks */
>   static int sdeb_zbc_zone_cap_mb;
>   static int sdeb_zbc_zone_size_mb;
> @@ -5138,9 +5139,13 @@ static struct sdebug_dev_info *find_build_dev_info(struct scsi_device *sdev)
>   
>   static int scsi_debug_slave_alloc(struct scsi_device *sdp)
>   {
> +	struct request_queue *q = sdp->request_queue;
> +
>   	if (sdebug_verbose)
>   		pr_info("slave_alloc <%u %u %u %llu>\n",
>   		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
> +	if (sdeb_preserves_write_order)
> +		q->limits.driver_preserves_write_order = true;
>   	return 0;
>   }
>   
> @@ -5755,6 +5760,8 @@ module_param_named(statistics, sdebug_statistics, bool, S_IRUGO | S_IWUSR);
>   module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
>   module_param_named(submit_queues, submit_queues, int, S_IRUGO);
>   module_param_named(poll_queues, poll_queues, int, S_IRUGO);
> +module_param_named(preserves_write_order, sdeb_preserves_write_order, bool,
> +		   S_IRUGO);
>   module_param_named(tur_ms_to_ready, sdeb_tur_ms_to_ready, int, S_IRUGO);
>   module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
>   module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
> @@ -5812,6 +5819,8 @@ MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
>   MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
>   MODULE_PARM_DESC(no_rwlock, "don't protect user data reads+writes (def=0)");
>   MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
> +MODULE_PARM_DESC(preserves_write_order,
> +		 "Whether or not to inform the block layer that this driver preserves the order of WRITE commands (def=0)");
>   MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
>   MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
>   MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");

