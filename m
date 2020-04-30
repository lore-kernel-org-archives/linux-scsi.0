Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1257FC83000
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 14:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED11B206D9
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 14:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgD3OQc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 10:16:32 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2135 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726743AbgD3OQc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 10:16:32 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id B75065EE7C5E96BC1BFE;
        Thu, 30 Apr 2020 15:16:28 +0100 (IST)
Received: from [127.0.0.1] (10.47.0.178) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 30 Apr
 2020 15:16:27 +0100
Subject: Re: [PATCH RFC v3 01/41] scsi: add 'nr_reserved_cmds' field to the
 SCSI host template
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-2-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9655eb3f-b2e3-7c9e-f2ee-1587c13df875@huawei.com>
Date:   Thu, 30 Apr 2020 15:15:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-2-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.0.178]
X-ClientProxiedBy: lhreml731-chm.china.huawei.com (10.201.108.82) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/04/2020 14:18, Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> Quite a lot of drivers are using management commands internally, which
> typically use the same hardware tag pool (ie they are being allocated
> from the same hardware resources) as the 'normal' I/O commands.
> These commands are set aside before allocating the block-mq tag bitmap,
> so they'll never show up as busy in the tag map.
> The block-layer, OTOH, already has 'reserved_tags' to handle precisely
> this situation.
> So this patch adds a new field 'nr_reserved_cmds' to the SCSI host
> template to instruct the block layer to set aside a tag space for these
> management commands by using reserved_tags.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

It may be worth adding this field to scsi_host_template. And we should 
also prob mention this in Documentation/scsi/scsi_mid_low_api.txt

Apart from that, thanks:

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/scsi_lib.c  | 1 +
>   include/scsi/scsi_host.h | 6 ++++++
>   2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 47835c4b4ee0..5358f553f526 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1885,6 +1885,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   		shost->tag_set.ops = &scsi_mq_ops_no_commit;
>   	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
>   	shost->tag_set.queue_depth = shost->can_queue;
> +	shost->tag_set.reserved_tags = shost->nr_reserved_cmds;
>   	shost->tag_set.cmd_size = cmd_size;
>   	shost->tag_set.numa_node = NUMA_NO_NODE;
>   	shost->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 822e8cda8d9b..37bb7d74e4c4 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -599,6 +599,12 @@ struct Scsi_Host {
>   	 * is nr_hw_queues * can_queue.
>   	 */
>   	unsigned nr_hw_queues;
> +
> +	/*
> +	 * Number of commands to reserve, if any.
> +	 */
> +	unsigned nr_reserved_cmds;
> +
>   	unsigned active_mode:2;
>   	unsigned unchecked_isa_dma:1;
>   
> 

