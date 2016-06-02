From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 09/14] scsi: Implement scsi_mq_resize_tags()
Date: Thu, 2 Jun 2016 08:58:43 -0700
Message-ID: <9a7dfdaa-a56a-3739-0f54-dbee72954aa8@sandisk.com>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
 <1464878356-42407-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0080.outbound.protection.outlook.com ([157.56.110.80]:23232
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751455AbcFBP6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 11:58:55 -0400
In-Reply-To: <1464878356-42407-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 06/02/2016 07:39 AM, Hannes Reinecke wrote:
> +int scsi_mq_resize_tags(struct Scsi_Host *shost, int max_tags)
> +{
> +	return blk_mq_resize_tag_set(&shost->tag_set, max_tags);
> +}
> +EXPORT_SYMBOL_GPL(scsi_mq_resize_tags);

What is the meaning of the max_tags argument? Does it include the 
reserved tag count or not? If not, shouldn't the number of reserved tags 
be added before calling blk_mq_resize_tag_set()? Please document the 
meaning of the max_tags argument.

Please also consider choosing a name for this function that is more 
consistent with the function names used in the block layer e.g. 
scsi_mq_update_tag_depth().

Thanks,

Bart.
