From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2.5 3/6] scsi_debug: add multiple queue support
Date: Wed, 4 May 2016 15:32:40 -0700
Message-ID: <572A7888.6000804@sandisk.com>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-4-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0082.outbound.protection.outlook.com ([157.56.111.82]:26400
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752330AbcEDWcp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2016 18:32:45 -0400
In-Reply-To: <1462070687-12689-4-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

On 04/30/2016 07:44 PM, Douglas Gilbert wrote:
> +static struct sdebug_queue *get_queue(void)
> +{
> +	struct sdebug_queue *sqp = sdebug_q_arr;
> +
> +	return sqp + (raw_smp_processor_id() % submit_queues);
> +}

Does this function have the same purpose as blk_mq_map_queue()? If so, 
why has this function been introduced instead of using blk_mq_map_queue()?

> @@ -5001,6 +5158,10 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   	bool has_wlun_rl;
>
>   	scsi_set_resid(scp, 0);
> +	if (sdebug_statistics) {
> +		sqp = get_queue();
> +		atomic_inc(&sqp->cmnd_count);
> +	}

Why does scsi_debug_queuecommand() call get_queue() instead of 
blk_mq_unique_tag() and blk_mq_unique_tag_to_hwq() which is what other 
scsi-mq drivers do?

Is the role of the sqp->cmnd_count counter identical to that of 
blk_mq_hw_ctx.queued? If so, can sqp->cmnd_count be left out and can 
blk_mq_hw_ctx.queued be used instead?

> @@ -5168,6 +5328,16 @@ static int sdebug_driver_probe(struct device * dev)
> +	if (sdebug_mq_available && (submit_queues > 1))
> +		hpnt->nr_hw_queues = submit_queues;

There is already a submit_queues < 1 check in scsi_debug_init(). Is the 
submit_queues > 1 check in sdebug_driver_probe() needed?

Bart.
