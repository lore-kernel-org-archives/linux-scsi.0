From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] SCSI EH document
Date: Mon, 29 Aug 2005 09:55:29 -0400
Message-ID: <431313D1.7090107@adaptec.com>
References: <20050826035326.GA13392@htj.dyndns.org> <430F8AE0.7080806@pobox.com> <4312D213.9000402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:27781 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750931AbVH2N4N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 09:56:13 -0400
In-Reply-To: <4312D213.9000402@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Bottomley@steeleye.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org

On 08/29/05 05:14, Tejun Heo wrote:
>>Both all the list-heads need to be cleared, otherwise there may be list 
>>corruption next time the element is added to the list_head.
>>
> 
> 
>   scmd->eh_entry is never used as list head.  It's always used as list 
> entry.  So, technically, it needs not be cleared, I think.  No?  The 
> problem we had was w/ shost->eh_cmd_q not being cleared.

In your "strategy" routine:

	...
	spin_lock_irqsave(shost->host_lock, flags);
	list_splice_init(&shost->eh_cmd_q, &error_q);
	spin_unlock_irqrestore(shost->host_lock, flags);
	...

	loop {
		...
		list_del_init(&cmd->eh_entry);
		...
	}

A good policy to follow is:
	1. Never leave prev/next pointing somewhere where
		- you don't belong, or
		- where you don't know existance is in place.
	2. Someone (memory release?) may do:
		if (!list_empty(cmd->eh_entry))
			Refuse to free the memory.
	Which is often the case to check if the object belongs to
	a list. (You shouldn't have to do this but case pointed only for
	illustrational purposes.)

   Luben

