From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Wed, 16 Jul 2003 07:53:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030716055356.GP833@suse.de>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net> <3F14AD10.3010300@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:6535 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S270140AbTGPFjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 01:39:09 -0400
Content-Disposition: inline
In-Reply-To: <3F14AD10.3010300@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Mark Haverkamp <markh@osdl.org>, Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jul 16 2003, Nick Piggin wrote:
> Thanks Mark, great. It looks fine.
> 
> 
> >Daniel McNeil and I have been debugging a hang with the aacraid driver
> >using the as I/O scheduler.  We found that scsi_request_fn would
> >de-queue a request and later re-queued it.  This left the
> >as_data->nr_dispatched variable in an inconsistent state (it was never
> >being decremented back to zero).  We added a call to
> >elv_completed_request to clean up the state before re-adding the
> >request.  This has fixed our hang problem.  The linux-scsi list is being
> >copied for review of the scsi_lib.c change.
> >
> >===== drivers/scsi/scsi_lib.c 1.99 vs edited =====
> >--- 1.99/drivers/scsi/scsi_lib.c	Sun Jun 29 18:14:44 2003
> >+++ edited/drivers/scsi/scsi_lib.c	Tue Jul 15 15:47:45 2003
> >@@ -1215,6 +1215,7 @@
> >	spin_lock_irq(q->queue_lock);
> >	if (blk_rq_tagged(req))
> >		blk_queue_end_tag(q, req);
> >+	elv_completed_request(q, req);
> >	__elv_add_request(q, req, 0, 0);
> >	sdev->device_busy--;
> >	if(sdev->device_busy == 0)

Ehm no not really. The request isn't completed here, it looks more like
a hack to keep AS happy. We ought to make a more generic solution to
this problem, other drivers could run into it as well.

-- 
Jens Axboe

