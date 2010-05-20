From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 5/7] lpfc 8.3.13: BSG management fixes
Date: Thu, 20 May 2010 20:41:43 +0900
Message-ID: <20100520204408L.fujita.tomonori@lab.ntt.co.jp>
References: <4BED5E97.1060909@emulex.com>
	<20100517152627C.fujita.tomonori@lab.ntt.co.jp>
	<4BF42F71.2020106@emulex.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60261 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab0ETLl4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2010 07:41:56 -0400
In-Reply-To: <4BF42F71.2020106@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Wed, 19 May 2010 14:35:29 -0400
James Smart <james.smart@emulex.com> wrote:

> 
> 
> FUJITA Tomonori wrote:
> > The tricky part is, when a sas LLD frees a remote port, there might be
> > some user-space applications that still open a bsg device. So you
> > can't call blk_cleanup_queue() at that time.
> > 
> > You might hit the similar problem to the commit
> > 93c20a59af4624aedf53f8320606b355aa951bc1. The following fix works?
> 
> It is similar to this problem....   There is an application with the bsg 
> device open, but no request outstanding, when a request is made to the driver 
> to unload.  The driver detaches, with the transport calling 
> bsg_unregister_queue() (which succeeds happily) and the driver fully unloads.
> 
> But, at some point the app does do a bsg request.
> 
> However - things are all messed up at this point...   the bd->queue is no 
> longer valid as the owner of the queue (the transport) has returned the memory 
> to the kernel.

That's the root problem that the patch fixes?

blk_put_queue() frees a queue. So the owner can't call blk_put_queue()
as long as there are still applications that open the bsg device of
the queue.


> Depending on what else is allocating, it may be used by 
> something else.  Thus you get extremely weird/bad behavior when the queue is 
> referenced later in the bsg request processing.
> 
> I don't know how the patch, which changes when blk_cleanup_queue() is done, 

The patch is supposed to call blk_put_queue() when the last
application closes the bsg device (that guarantees that no more
requests come via the queue).

The release function pointer in bsg_register_queue() is supposed to be
called when the the last application closes the bsg device.


> would fix things, as the larger issue of the queue structure possibly being 
> realloc'd by someone else is the killer.  I did test it in our scenario, and 
> it failed too.

Oh, sorry. Seems that I miss something...

Can you tell me how I can reproduce your scenario?


> If I have identified this issue properly (agree ?) I see a couple of options:
> a) Set bd->queue pointer to NULL on bsg_unregister_queue(). Then add checks in 
> the file op calls.
> 
> b) Track opens against the queue, and fail the deregister if open count > 0. 
> Rather ugly as the interface is a void right now, and the callers need to deal 
> with it too. I know in the fc_transport, we're ill equipped to deal with the 
> deregister failing and trying to remove it sometime later.
> 
> c) Is all we need to do is take another parent reference in bsg_open, and 
> remove it in bsg_release ?  Given the multiple pieces that must play well on 
> this, I'm not sure it really works.
> 
> Insight appreciated...
> 
> -- james s
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
