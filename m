Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015AFC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 09:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8FB22067D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 09:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgGHJlC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 05:41:02 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2438 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726445AbgGHJlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jul 2020 05:41:02 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id A0F6E7A5A049C2C2CC33;
        Wed,  8 Jul 2020 10:41:00 +0100 (IST)
Received: from [127.0.0.1] (10.210.171.111) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Wed, 8 Jul 2020
 10:40:59 +0100
Subject: Re: [PATCH 13/21] scsi: implement reserved command handling
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>
References: <20200703130122.111448-1-hare@suse.de>
 <20200703130122.111448-14-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b03c1256-8255-5e7f-dda3-df036aaef812@huawei.com>
Date:   Wed, 8 Jul 2020 10:39:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200703130122.111448-14-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.111]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/07/2020 14:01, Hannes Reinecke wrote:
> Quite some drivers are using management commands internally, which
> typically use the same hardware tag pool (ie they are being allocated
> from the same hardware resources) as the 'normal' I/O commands.
> These commands are set aside before allocating the block-mq tag bitmap,
> so they'll never show up as busy in the tag map.
> The block-layer, OTOH, already has 'reserved_tags' to handle precisely
> this situation.
> So this patch adds a new field 'nr_reserved_cmds' to the SCSI host
> template to instruct the block layer to set aside a tag space for these
> management commands by using reserved tags.
> 

Apart from (a good few) comments:

Reviewed-by: John Garry <john.garry@huawei.com>

> Signed-off-by: Hannes Reinecke <hare@suse.de> > ---
>   drivers/scsi/hosts.c     |  3 +++
>   drivers/scsi/scsi_lib.c  | 10 +++++++++-
>   include/scsi/scsi_host.h | 22 +++++++++++++++++++++-
>   3 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 7ec91c3a66ca..db91b045a4ce 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -466,6 +466,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>   	if (sht->virt_boundary_mask)
>   		shost->virt_boundary_mask = sht->virt_boundary_mask;
>   
> +	if (sht->nr_reserved_cmds)
> +		shost->nr_reserved_cmds = sht->nr_reserved_cmds;
> +
>   	device_initialize(&shost->shost_gendev);
>   	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
>   	shost->shost_gendev.bus = &scsi_bus_type;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1d5c1b9a1203..1362f4f17dfd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1887,7 +1887,9 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   	else
>   		tag_set->ops = &scsi_mq_ops_no_commit;
>   	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
> -	tag_set->queue_depth = shost->can_queue;
> +	tag_set->queue_depth =
> +		shost->can_queue + shost->nr_reserved_cmds;

I think that this can fit on a single line without exceeding 80 characters

> +	tag_set->reserved_tags = shost->nr_reserved_cmds;
>   	tag_set->cmd_size = cmd_size;
>   	tag_set->numa_node = NUMA_NO_NODE;
>   	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
> @@ -1910,6 +1912,9 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>    * @op_flags: request allocation flags
>    *
>    * Allocates a SCSI command for internal LLDD use.
> + * If 'nr_reserved_commands' is spectified by the host the

again, please check spellings

> + * command will be allocated from the reserved tag pool;
> + * otherwise the normal tag pool will be used.
>    */
>   struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>   	enum dma_data_direction data_direction, int op_flags)
> @@ -1919,6 +1924,9 @@ struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>   	blk_mq_req_flags_t flags = 0;
>   	unsigned int op = REQ_INTERNAL | op_flags;
>   
> +	if (sdev->host->nr_reserved_cmds)
> +		flags = BLK_MQ_REQ_RESERVED;

Previously I mentioned that '|=' is nicer - not sure if it was missed or 
dismissed, so mentioning it again just in case

> +
>   	op |= (data_direction == DMA_TO_DEVICE) ?
>   		REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN;
>   	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 4919a66565d6..c4d0d26c880e 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -342,10 +342,19 @@ struct scsi_host_template {
>   	/*
>   	 * This determines if we will use a non-interrupt driven
>   	 * or an interrupt driven scheme.  It is set to the maximum number
> -	 * of simultaneous commands a single hw queue in HBA will accept.
> +	 * of simultaneous commands a single hw queue in HBA will accept
> +	 * excluding internal commands.
>   	 */
>   	int can_queue;
>   
> +	/*
> +	 * This determines how many commands the HBA will set aside
> +	 * for internal commands. This number will be added to
> +	 * @can_queue to calcumate the maximum number of simultaneous

check spelling of calculate

> +	 * commands sent to the host.
> +	 */
> +	int nr_reserved_cmds;

We have can_queue file in the scsi_host sysfs folder - I wonder if it is 
also worth adding a file for this?

> +
>   	/*

