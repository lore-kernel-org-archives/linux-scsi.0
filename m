From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/2] blk-mq: Avoid memory reclaim when remapping queues
Date: Tue, 15 Nov 2016 14:51:30 -0800
Message-ID: <39a42839-b877-21b7-aa85-314cf499e234@sandisk.com>
References: <1479151478-19725-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1479151478-19725-2-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1479151478-19725-2-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-block-owner@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, axboe@fb.com
Cc: linux-block@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/14/2016 11:24 AM, Gabriel Krisman Bertazi wrote:
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1597,7 +1597,7 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
>  	INIT_LIST_HEAD(&tags->page_list);
>
>  	tags->rqs = kzalloc_node(set->queue_depth * sizeof(struct request *),
> -				 GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY,
> +				 GFP_NOWAIT | __GFP_NOWARN | __GFP_NORETRY,
>  				 set->numa_node);
>  	if (!tags->rqs) {
>  		blk_mq_free_tags(tags);

Hello Gabriel,

I don't think that GFP_NOWAIT is acceptable in this context. Have you 
tried GFP_NOIO instead of GFP_NOWAIT?

Bart.
