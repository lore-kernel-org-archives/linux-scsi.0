From: Nick Piggin <piggin@cyberone.com.au>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Wed, 16 Jul 2003 11:40:32 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F14AD10.3010300@cyberone.com.au>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dialup-228.156.221.203.acc50-nort-cbr.comindico.com.au ([203.221.156.228]:18180
	"EHLO chimp.local.net") by vger.kernel.org with ESMTP
	id S270009AbTGPBZz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2003 21:25:55 -0400
In-Reply-To: <1058310172.981.7.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

Thanks Mark, great. It looks fine.


>Daniel McNeil and I have been debugging a hang with the aacraid driver
>using the as I/O scheduler.  We found that scsi_request_fn would
>de-queue a request and later re-queued it.  This left the
>as_data->nr_dispatched variable in an inconsistent state (it was never
>being decremented back to zero).  We added a call to
>elv_completed_request to clean up the state before re-adding the
>request.  This has fixed our hang problem.  The linux-scsi list is being
>copied for review of the scsi_lib.c change.
>
>===== drivers/scsi/scsi_lib.c 1.99 vs edited =====
>--- 1.99/drivers/scsi/scsi_lib.c	Sun Jun 29 18:14:44 2003
>+++ edited/drivers/scsi/scsi_lib.c	Tue Jul 15 15:47:45 2003
>@@ -1215,6 +1215,7 @@
> 	spin_lock_irq(q->queue_lock);
> 	if (blk_rq_tagged(req))
> 		blk_queue_end_tag(q, req);
>+	elv_completed_request(q, req);
> 	__elv_add_request(q, req, 0, 0);
> 	sdev->device_busy--;
> 	if(sdev->device_busy == 0)
>
>  
>

