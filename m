Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC06CC43461
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C62DE208CA
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgICQmz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 12:42:55 -0400
Received: from smtp.infotech.no ([82.134.31.41]:54122 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbgICQmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Sep 2020 12:42:54 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2DFDF20418E;
        Thu,  3 Sep 2020 18:42:51 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pOZvjK18dPVh; Thu,  3 Sep 2020 18:42:49 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id ECA4F20417A;
        Thu,  3 Sep 2020 18:42:47 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [RFC] add io_uring support in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Philip Wong <philip.wong@broadcom.com>
References: <CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <f006b12d-ea59-27d9-7766-6d4039487714@interlog.com>
Date:   Thu, 3 Sep 2020 12:42:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-03 12:14 p.m., Kashyap Desai wrote:
> Currently io_uring support is only available in the block layer.
> This RFC is to extend support of mq_poll in the scsi layer.
> 
> megaraid_sas and mpt3sas driver will be immediate users of this interface.
> Both the drivers can use mq_poll only if it has exposed more than one
> nr_hw_queues.

Perhaps you could add some comments in scsi_host.h about what the
    int (* mq_poll)(struct Scsi_Host *shost, unsigned int queue_num);

callback should do. And you could implement it in the scsi_debug
driver which should have all the other hooks as it is part 15 of
the shared host tag support patchset.

> Waiting for below changes to enable shared host tag support.
> 
> https://patchwork.kernel.org/cover/11724429/

I'm testing this at the moment. So far so good.

Doug Gilbert

> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>   drivers/scsi/scsi_lib.c  | 16 ++++++++++++++++
>   include/scsi/scsi_cmnd.h |  1 +
>   include/scsi/scsi_host.h |  3 +++
>   3 files changed, 20 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 780cf084e366..7a3c59d2dfcc 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1802,6 +1802,19 @@ static void scsi_mq_exit_request(struct
> blk_mq_tag_set *set, struct request *rq,
>                                 cmd->sense_buffer);
>   }
> 
> +
> +static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
> +{
> +       struct request_queue *q = hctx->queue;
> +       struct scsi_device *sdev = q->queuedata;
> +       struct Scsi_Host *shost = sdev->host;
> +
> +       if (shost->hostt->mq_poll)
> +               return shost->hostt->mq_poll(shost, hctx->queue_num);
> +
> +       return 0;
> +}
> +
>   static int scsi_map_queues(struct blk_mq_tag_set *set)
>   {
>          struct Scsi_Host *shost = container_of(set, struct Scsi_Host, tag_set);
> @@ -1869,6 +1882,7 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit = {
>          .cleanup_rq     = scsi_cleanup_rq,
>          .busy           = scsi_mq_lld_busy,
>          .map_queues     = scsi_map_queues,
> +       .poll           = scsi_mq_poll,
>   };
> 
> 
> @@ -1897,6 +1911,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
>          .cleanup_rq     = scsi_cleanup_rq,
>          .busy           = scsi_mq_lld_busy,
>          .map_queues     = scsi_map_queues,
> +       .poll           = scsi_mq_poll,
>   };
> 
>   struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
> @@ -1929,6 +1944,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>          else
>                  tag_set->ops = &scsi_mq_ops_no_commit;
>          tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
> +       tag_set->nr_maps = shost->nr_maps ? : 1;
>          tag_set->queue_depth = shost->can_queue;
>          tag_set->cmd_size = cmd_size;
>          tag_set->numa_node = NUMA_NO_NODE;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index e76bac4d14c5..5844374a85b1 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -9,6 +9,7 @@
>   #include <linux/types.h>
>   #include <linux/timer.h>
>   #include <linux/scatterlist.h>
> +#include <scsi/scsi_host.h>
>   #include <scsi/scsi_device.h>
>   #include <scsi/scsi_request.h>
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 701f178b20ae..d34602c68d0b 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -269,6 +269,8 @@ struct scsi_host_template {
>           * Status: OPTIONAL
>           */
>          int (* map_queues)(struct Scsi_Host *shost);
> +
> +       int (* mq_poll)(struct Scsi_Host *shost, unsigned int queue_num);
> 
>          /*
>           * Check if scatterlists need to be padded for DMA draining.
> @@ -610,6 +612,7 @@ struct Scsi_Host {
>           * the total queue depth is can_queue.
>           */
>          unsigned nr_hw_queues;
> +       unsigned nr_maps;
>          unsigned active_mode:2;
>          unsigned unchecked_isa_dma:1;
> 

