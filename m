From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 5/7] lpfc 8.3.13: BSG management fixes
Date: Wed, 19 May 2010 14:35:29 -0400
Message-ID: <4BF42F71.2020106@emulex.com>
References: <20100514183051S.fujita.tomonori@lab.ntt.co.jp>	<4BED5428.8090703@emulex.com>	<4BED5E97.1060909@emulex.com> <20100517152627C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56783 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752294Ab0ESSfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2010 14:35:51 -0400
In-Reply-To: <20100517152627C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>



FUJITA Tomonori wrote:
> The tricky part is, when a sas LLD frees a remote port, there might be
> some user-space applications that still open a bsg device. So you
> can't call blk_cleanup_queue() at that time.
> 
> You might hit the similar problem to the commit
> 93c20a59af4624aedf53f8320606b355aa951bc1. The following fix works?

It is similar to this problem....   There is an application with the bsg 
device open, but no request outstanding, when a request is made to the driver 
to unload.  The driver detaches, with the transport calling 
bsg_unregister_queue() (which succeeds happily) and the driver fully unloads.

But, at some point the app does do a bsg request.

However - things are all messed up at this point...   the bd->queue is no 
longer valid as the owner of the queue (the transport) has returned the memory 
to the kernel. Depending on what else is allocating, it may be used by 
something else.  Thus you get extremely weird/bad behavior when the queue is 
referenced later in the bsg request processing.

I don't know how the patch, which changes when blk_cleanup_queue() is done, 
would fix things, as the larger issue of the queue structure possibly being 
realloc'd by someone else is the killer.  I did test it in our scenario, and 
it failed too.

If I have identified this issue properly (agree ?) I see a couple of options:
a) Set bd->queue pointer to NULL on bsg_unregister_queue(). Then add checks in 
the file op calls.

b) Track opens against the queue, and fail the deregister if open count > 0. 
Rather ugly as the interface is a void right now, and the callers need to deal 
with it too. I know in the fc_transport, we're ill equipped to deal with the 
deregister failing and trying to remove it sometime later.

c) Is all we need to do is take another parent reference in bsg_open, and 
remove it in bsg_release ?  Given the multiple pieces that must play well on 
this, I'm not sure it really works.

Insight appreciated...

-- james s

