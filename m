From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/9] srpt: chain RDMA READ/WRITE requests
Date: Tue, 17 Nov 2015 17:17:35 -0800
Message-ID: <564BD1AF.60200@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0053.outbound.protection.outlook.com ([157.56.111.53]:20832
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751702AbbKRBRk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 20:17:40 -0500
In-Reply-To: <1447422410-20891-5-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
> -		ret = ib_post_send(ch->qp, &wr.wr, &bad_wr);
> -		if (ret)
> -			break;
> +		if (i == n_rdma - 1) {
> +			/* only get completion event for the last rdma read */
> +			if (dir == DMA_TO_DEVICE)
> +				wr->wr.send_flags = IB_SEND_SIGNALED;
> +			wr->wr.next = NULL;
> +		} else {
> +			wr->wr.next = &ioctx->rdma_ius[i + 1].wr;
> +		}
>   	}
>
> +	ret = ib_post_send(ch->qp, &ioctx->rdma_ius->wr, &bad_wr);
>   	if (ret)
>   		pr_err("%s[%d]: ib_post_send() returned %d for %d/%d\n",
>   				 __func__, __LINE__, ret, i, n_rdma);

Hello Christoph,

Chaining RDMA requests is a great idea. But it seems to me that this 
patch is based on the assumption that posting multiple RDMA requests 
either succeeds as a whole or fails as a whole. Sorry but I'm not sure 
that the verbs API guarantees this. In the ib_srpt driver a QP can be 
changed at any time into the error state and there might be drivers that 
report an immediate failure in that case. I think even when chaining 
RDMA requests that we still need a mechanism to wait until ongoing RDMA 
transfers have finished if some but not all RDMA requests have been posted.

Bart.
