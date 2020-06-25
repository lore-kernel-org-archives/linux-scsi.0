Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EF1C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 15:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6852D2082F
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 15:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405802AbgFYPbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 11:31:36 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2361 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405780AbgFYPbf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Jun 2020 11:31:35 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 6EE7C49C8CF4A5AC2D09;
        Thu, 25 Jun 2020 16:31:34 +0100 (IST)
Received: from [127.0.0.1] (10.47.7.104) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 25 Jun
 2020 16:31:33 +0100
Subject: Re: [PATCH 08/22] scsi: implement reserved command handling
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Don Brace <don.brace@microchip.de>,
        Bart van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>
References: <20200625140124.17201-1-hare@suse.de>
 <20200625140124.17201-9-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8074064c-a2ea-2084-cd1a-60bf51af6844@huawei.com>
Date:   Thu, 25 Jun 2020 16:30:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200625140124.17201-9-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.7.104]
X-ClientProxiedBy: lhreml724-chm.china.huawei.com (10.201.108.75) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25/06/2020 15:01, Hannes Reinecke wrote:
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
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_lib.c  | 10 +++++++++-
>   include/scsi/scsi_host.h | 11 +++++++++++
>   2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index bd378e1bd3fc..a752806af70b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1887,7 +1887,9 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   	else
>   		tag_set->ops = &scsi_mq_ops_no_commit;
>   	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
> -	tag_set->queue_depth = shost->can_queue;
> +	tag_set->queue_depth =
> +		shost->can_queue + shost->nr_reserved_cmds;
> +	tag_set->reserved_tags = shost->nr_reserved_cmds;
>   	tag_set->cmd_size = cmd_size;
>   	tag_set->numa_node = NUMA_NO_NODE;
>   	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
> @@ -1910,6 +1912,9 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>    * @op_flags: request allocation flags
>    *
>    * Allocates a SCSI command for internal LLDD use.
> + * If 'nr_reserved_commands' is spectified by the host the

/s/spectified/specified/

I suppose making this usable by drivers which don't set 
nr_reserved_commands is helpful (if not slightly strange). In that we 
can move drivers which don't use rq->tag currently - like pm8001 - to 
use it, and not have to worry about guessing some nr_reserved_commands 
to specify.

> + * command will be allocated from the reserved tag pool;
> + * otherwise the normal tag pool will be used.
>    */
>   struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>   					int data_direction, int op_flags)
> @@ -1919,6 +1924,9 @@ struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>   	blk_mq_req_flags_t flags = 0;
>   	unsigned int op = REQ_INTERNAL | op_flags;
>   
> +	if (sdev->host->nr_reserved_cmds)
> +		flags = BLK_MQ_REQ_RESERVED; > +
>   	op |= (data_direction == DMA_TO_DEVICE) ?
>   		REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN;
>   	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 46ef8cccc982..b94938e87e3a 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -590,6 +590,11 @@ struct Scsi_Host {
>   	unsigned short max_cmd_len;
>   
>   	int this_id;
> +
> +	/*
> +	 * Number of commands this host can handle at the same time.
> +	 * This excludes reserved commands as specified by nr_reserved_cmds.
> +	 */
>   	int can_queue;
>   	short cmd_per_lun;
>   	short unsigned int sg_tablesize;
> @@ -606,6 +611,12 @@ struct Scsi_Host {
>   	 * is nr_hw_queues * can_queue.

If we are going to go this way, then could you update the comment on 
Scsi_Host.nr_hw_queues here? Currently we have "it is assumed that each 
hardware queue has a depth of can_queue..."

Thanks,
John

>   	 */
>   	unsigned nr_hw_queues;
> +
> +	/*
> +	 * Number of reserved commands to allocate, if any.
> +	 */
> +	unsigned nr_reserved_cmds;
> +


