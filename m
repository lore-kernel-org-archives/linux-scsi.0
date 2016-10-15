From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi: allow LLDDs to expose the queue mapping to
 blk-mq
Date: Sat, 15 Oct 2016 13:46:12 +0200
Message-ID: <cc8bc425-e931-c3a8-4b53-32b59d5e7be5@suse.de>
References: <1476521241-32765-1-git-send-email-hch@lst.de>
 <1476521241-32765-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55547 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753144AbcJOLqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 15 Oct 2016 07:46:15 -0400
In-Reply-To: <1476521241-32765-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com, don.brace@microsemi.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On 10/15/2016 10:47 AM, Christoph Hellwig wrote:
> Just hand through the blk-mq map_queues method in the host template.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq-cpumap.c    |  1 +
>  drivers/scsi/scsi_lib.c  | 10 ++++++++++
>  include/scsi/scsi_host.h |  8 ++++++++
>  3 files changed, 19 insertions(+)
>
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 19b1d9c..8e61e86 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -87,6 +87,7 @@ int blk_mq_map_queues(struct blk_mq_tag_set *set)
>  	free_cpumask_var(cpus);
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(blk_mq_map_queues);
>
>  /*
>   * We have no quick way of doing reverse lookups. This is only used at
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2cca9cf..f23ec24 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1990,6 +1990,15 @@ static void scsi_exit_request(void *data, struct request *rq,
>  	kfree(cmd->sense_buffer);
>  }
>
> +static int scsi_map_queues(struct blk_mq_tag_set *set)
> +{
> +	struct Scsi_Host *shost = container_of(set, struct Scsi_Host, tag_set);
> +
> +	if (shost->hostt->map_queues)
> +		return shost->hostt->map_queues(shost);
> +	return blk_mq_map_queues(set);
> +}
> +
>  static u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
>  {
>  	struct device *host_dev;
> @@ -2082,6 +2091,7 @@ static struct blk_mq_ops scsi_mq_ops = {
>  	.timeout	= scsi_timeout,
>  	.init_request	= scsi_init_request,
>  	.exit_request	= scsi_exit_request,
> +	.map_queues	= scsi_map_queues,
>  };
>
>  struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 7e4cd53..36680f1 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -278,6 +278,14 @@ struct scsi_host_template {
>  	int (* change_queue_depth)(struct scsi_device *, int);
>
>  	/*
> +	 * This functions lets the driver expose the queue mapping
> +	 * to the block layer.
> +	 *
> +	 * Status: OPTIONAL
> +	 */
> +	int (* map_queues)(struct Scsi_Host *shost);
> +
> +	/*
>  	 * This function determines the BIOS parameters for a given
>  	 * harddisk.  These tend to be numbers that are made up by
>  	 * the host adapter.  Parameters:
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
