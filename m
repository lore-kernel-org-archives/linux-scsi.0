Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F71DC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350175AbhK2TVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:21:18 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:23634 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380066AbhK2TTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Nov 2021 14:19:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1638213360; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=RScI3Hhu2IHWULTsGJc57d5MH8nBdwIsssHjRze0B6U=; b=g0rZGCFWJ+G7LNM1DlQcPS4pQTYnn9K9jVUB7MN3ZxHrQcvIJCNht0dhaiTJroCYwLcjh444
 EC7Inq3/ngqEAQQFXZFznCWuwnPkQugmFWX31rf21uU1iDfGPjMe1Zv5hiUKVhdsg0qKbSET
 0Cz+Q5i/Zq20HUh7RXR2brth/IM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 61a526ef6bacc185a5c1db81 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 29 Nov 2021 19:15:59
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 61AD5C4314E; Mon, 29 Nov 2021 19:15:58 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 763CEC43637;
        Mon, 29 Nov 2021 19:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 763CEC43637
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <2288f0b8-fa55-2020-b210-b5e7d06d6a4b@codeaurora.org>
Date:   Mon, 29 Nov 2021 11:15:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 03/15] scsi: implement reserved command handling
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-4-hare@suse.de>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <20211125151048.103910-4-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/2021 7:10 AM, Hannes Reinecke wrote:
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
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/hosts.c     |  3 +++
>   drivers/scsi/scsi_lib.c  |  9 ++++++++-
>   include/scsi/scsi_host.h | 22 +++++++++++++++++++++-
>   3 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index a539fa2fb221..8ee7a7279b6b 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -482,6 +482,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
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
> index 6fbd36c9c416..e8f1025d0ed8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1939,7 +1939,9 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   		tag_set->ops = &scsi_mq_ops_no_commit;
>   	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
>   	tag_set->nr_maps = shost->nr_maps ? : 1;
> -	tag_set->queue_depth = shost->can_queue;
> +	tag_set->queue_depth =
> +		shost->can_queue + shost->nr_reserved_cmds;
> +	tag_set->reserved_tags = shost->nr_reserved_cmds;
>   	tag_set->cmd_size = cmd_size;
>   	tag_set->numa_node = NUMA_NO_NODE;
>   	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
> @@ -1964,6 +1966,9 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>    * @nowait: do not wait for command allocation to succeed.
>    *
>    * Allocates a SCSI command for internal LLDD use.
> + * If 'nr_reserved_commands' is spectified by the host the
> + * command will be allocated from the reserved tag pool;
> + * otherwise the normal tag pool will be used.
>    */
>   struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>   	int data_direction, bool nowait)
> @@ -1973,6 +1978,8 @@ struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>   	blk_mq_req_flags_t flags = 0;
>   	int op;
>   
> +	if (sdev->host->nr_reserved_cmds)
> +		flags |= BLK_MQ_REQ_RESERVED;
>   	if (nowait)
>   		flags |= BLK_MQ_REQ_NOWAIT;
>   	op = (data_direction == DMA_TO_DEVICE) ?
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 6f49a8940dc4..7512d97aceb4 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -367,10 +367,19 @@ struct scsi_host_template {
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
> +	 * commands sent to the host.
> +	 */
> +	int nr_reserved_cmds;
> +
>   	/*
>   	 * In many instances, especially where disconnect / reconnect are
>   	 * supported, our host also has an ID on the SCSI bus.  If this is
> @@ -608,6 +617,11 @@ struct Scsi_Host {
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
> @@ -626,6 +640,12 @@ struct Scsi_Host {
>   	 */
>   	unsigned nr_hw_queues;
>   	unsigned nr_maps;
> +
> +	/*
> +	 * Number of reserved commands to allocate, if any.
> +	 */
> +	unsigned nr_reserved_cmds;
> +
>   	unsigned active_mode:2;
>   
>   	/*
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
