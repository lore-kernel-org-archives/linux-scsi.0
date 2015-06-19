From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 01/20] [SCSI] mpt3sas: Added Combined Reply Queue feature to extend up-to 96 MSIX vector support
Date: Fri, 19 Jun 2015 10:57:44 -0400
Message-ID: <yq1vbejd9uf.fsf@sermon.lab.mkp.net>
References: <1434711346-9970-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbbFSO6e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 10:58:34 -0400
In-Reply-To: <1434711346-9970-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 19 Jun 2015 16:25:46 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, jthumshirn@suse.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth,

It's fine that you outline the 96 / 12 = 8 layout in the patch
description. But that relationship is not made clear when reading the
code. Please add a comment describing why things are set up this way.

> @@ -1009,8 +1009,15 @@ _base_interrupt(int irq, void *bus_id)
>  	}
>  
>  	wmb();
> -	writel(reply_q->reply_post_host_index | (msix_index <<
> -	    MPI2_RPHI_MSIX_INDEX_SHIFT), &ioc->chip->ReplyPostHostIndex);
> +	if (ioc->msix96_vector) {
> +		writel(reply_q->reply_post_host_index | ((msix_index  & 7) <<
> +			MPI2_RPHI_MSIX_INDEX_SHIFT),
> +				ioc->replyPostRegisterIndex[msix_index/8]);
> +	} else {
> +		writel(reply_q->reply_post_host_index | (msix_index <<
> +			MPI2_RPHI_MSIX_INDEX_SHIFT),
> +				&ioc->chip->ReplyPostHostIndex);
> +	}

Too many brackets. Why don't you do:

	index = reply_q->reply_post_host_index |
		((msix_index & 7) << MPI_RPHI_MSIX_INDEX_SHIFT);

	if (ioc->msix96_vector)
		writel(index, ioc->replyPostRegisterIndex[msix_index / 8]);
	else
        	writel(index, &ioc->chip->ReplyPostHostIndex);

> +	if (ioc->msix96_vector && ioc->reply_queue_count > 8) {
> +		/* If this is an 96 vector supported device,
> +		set up ReplyPostIndex addresses */

Bad comment formatting.

> +		ioc->replyPostRegisterIndex = kcalloc(12,
> +			sizeof(resource_size_t *), GFP_KERNEL);
[...]
> +		for (i = 0; i < 12; i++) {

Make 12 a constant or at the very least a variable with a comment.

> +			ioc->replyPostRegisterIndex[i] = (resource_size_t *)
> +				((u8 *)&ioc->chip->Doorbell +
> +				MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET +
> +				(i * 0x10));

0x10 - Another magic constant.

> @@ -4522,8 +4554,16 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
>  
>  	/* initialize reply post host index */
>  	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
> -		writel(reply_q->msix_index << MPI2_RPHI_MSIX_INDEX_SHIFT,
> -		    &ioc->chip->ReplyPostHostIndex);
> +		if (ioc->msix96_vector) {
> +			writel((reply_q->msix_index & 7)<<
> +			   MPI2_RPHI_MSIX_INDEX_SHIFT,
> +			   ioc->replyPostRegisterIndex[reply_q->msix_index/8]);
> +		} else {
> +			writel(reply_q->msix_index <<
> +				MPI2_RPHI_MSIX_INDEX_SHIFT,
> +					&ioc->chip->ReplyPostHostIndex);
> +		}
> +

Too many brackets.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
