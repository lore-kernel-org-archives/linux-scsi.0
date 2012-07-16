From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 17/18] srp_transport: Add transport layer recovery
 support
Date: Mon, 16 Jul 2012 18:28:30 -0400
Message-ID: <1342477710.25927.10.camel@frustration.ornl.gov>
References: <3109536.qySrY1Ts3e@asus> <2536946.Diyz1JQnfo@asus>
	 <500490A5.7020202@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta02.ornl.gov ([128.219.14.62]:29331 "EHLO mta02.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab2GPWiB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2012 18:38:01 -0400
In-Reply-To: <500490A5.7020202@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>

On Mon, 2012-07-16 at 18:07 -0400, Mike Christie wrote:
> On 01/14/2012 05:56 AM, Bart Van Assche wrote:
> > Add the necessary functions in the SRP transport module to allow
> > an SRP initiator driver to implement transport layer recovery.
>
> I was updating my iscsi dev loss patch when I saw this is still not merged.

Yes, I got part way into doing a rework of Bart's code before I got
sidetracked on another project. Cognizant of the looming merge window,
I'm desperately trying to get back to it. 

> Not sure about the ping code, but I think the dev loss tmo and fast io
> fail related stuff should go to scsi_transport_template. We can then add
> some common code to start the timers/delayed_work_queues, stop them,
> set/get the value from sysfs, etc that all the transport classes can
> then call.

Good idea, I'll look into doing this as part of it.

> For the srp code to use this patch, it was not clear to me what happens
> if dev_loss_tmo fires, but then the port comes back online. It looks
> like the target and its devices get deleted like with FC when the
> dev_loss_tmo fires. Is there something to automatically re-add the
> path/port/target when the issue is resolved? Was it on the patches that
> did not make the list (I only saw 6 patches out of 18 on linux-scsi) or
> do we have some userspace daemon that figures out when
> paths/ports/targets come back?

There is srp_daemon, which performs this task.

> For the ping code, does it use TUR because there is not a transport way
> to test the path/port/transport/interconnect?

Yes, SRP does not have a way to test connectivity on a transport level
ala iSCSI NOPs. I'm not at all inclined to add the ping functionality to
the SRP initiator, as I see it as duplicative of the existing multipathd
functionality in userspace, and it can kill the entire nexus even if
only one LUN is having issues.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


