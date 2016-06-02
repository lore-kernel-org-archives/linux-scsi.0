From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 08/14] blk-mq: add blk_mq_resize_tag_set()
Date: Thu, 2 Jun 2016 08:55:34 -0700
Message-ID: <209b9148-0fe8-77c0-95ed-f163597e633a@sandisk.com>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
 <1464878356-42407-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0086.outbound.protection.outlook.com ([207.46.100.86]:62871
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752210AbcFBPzq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 11:55:46 -0400
In-Reply-To: <1464878356-42407-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@fb.com>

On 06/02/2016 07:39 AM, Hannes Reinecke wrote:
> +int blk_mq_resize_tag_set(struct blk_mq_tag_set *set, int new_tags)
> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; i < set->nr_hw_queues; i++) {
> +		if (!set->tags[i])
> +			continue;
> +		ret = blk_mq_tag_update_depth(set->tags[i], new_tags);
> +		if (ret)
> +			break;
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(blk_mq_resize_tag_set);

(+Jens)

This code does not change the size of the bitmaps allocated by 
bt_alloc() so I think the word "resize" in the function name is 
misleading. How about using the name blk_mq_update_depth()? Have you 
considered a more clear name for the "new_tags" argument, e.g. tdepth? 
Please document that this argument represents the sum of the regular and 
reserved tags. Additionally, I don't think it is safe to call this 
function while I/O is in progress. Please either add code to stop and 
restart I/O inside this function or document this clearly.

Thanks,

Bart.
