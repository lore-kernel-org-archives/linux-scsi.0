From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 17/18] srp_transport: Add transport layer recovery support
Date: Mon, 16 Jul 2012 16:07:33 -0600
Message-ID: <500490A5.7020202@cs.wisc.edu>
References: <3109536.qySrY1Ts3e@asus> <2536946.Diyz1JQnfo@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34866 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab2GPWH4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2012 18:07:56 -0400
In-Reply-To: <2536946.Diyz1JQnfo@asus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, dillowda@ornl.gov

On 01/14/2012 05:56 AM, Bart Van Assche wrote:
> Add the necessary functions in the SRP transport module to allow
> an SRP initiator driver to implement transport layer recovery.
> This includes:
> - A ping mechanism to check whether the transport layer is still
>   operational.
> - Support for implementing fast_io_fail_tmo, the time that should
>   elapse after having detected a transport layer problem and
>   before failing I/O.
> - Support for implementing dev_loss_tmo, the time that should
>   elapse after having detected a transport layer problem and
>   before removing a remote port.
> 

I was updating my iscsi dev loss patch when I saw this is still not merged.

Not sure about the ping code, but I think the dev loss tmo and fast io
fail related stuff should go to scsi_transport_template. We can then add
some common code to start the timers/delayed_work_queues, stop them,
set/get the value from sysfs, etc that all the transport classes can
then call.

For the srp code to use this patch, it was not clear to me what happens
if dev_loss_tmo fires, but then the port comes back online. It looks
like the target and its devices get deleted like with FC when the
dev_loss_tmo fires. Is there something to automatically re-add the
path/port/target when the issue is resolved? Was it on the patches that
did not make the list (I only saw 6 patches out of 18 on linux-scsi) or
do we have some userspace daemon that figures out when
paths/ports/targets come back?

Also I think the patch that has ib_srp call srp_start_tl_fail_timers and
srp_block_rport did not make the list.

For the ping code, does it use TUR because there is not a transport way
to test the path/port/transport/interconnect?
