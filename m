From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v12 5/6] Avoid that scsi_device_set_state() triggers a
 race
Date: Mon, 1 Jul 2013 16:52:55 +0000
Message-ID: <1372697574.2385.34.camel@dabdike>
References: <51CC5176.90609@acm.org> <51CC52A5.2010204@acm.org>
	 <1372690195.2385.20.camel@dabdike> <51D19D84.2070701@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:40523 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3GAQxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 12:53:10 -0400
In-Reply-To: <51D19D84.2070701@acm.org>
Content-Language: en-US
Content-ID: <D1D89EAC8C7A5A4EB13BDBDD7699A53D@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On Mon, 2013-07-01 at 17:17 +0200, Bart Van Assche wrote:
> On 07/01/13 16:49, James Bottomley wrote:
> > On Thu, 2013-06-27 at 16:56 +0200, Bart Van Assche wrote:
> >> Make concurrent invocations of scsi_device_set_state() safe.
> >
> > Firstly, I don't understand from this where you think the races are.
> > Secondly, shouldn't this be the device lock? and thirdly, if we accept
> > that locking is required, encapsulate it in the function: Having the
> > callers manage locking is asking for trouble.  The latter may require a
> > new lock for the state to avoid entanglement.
> 
> Today there is no guarantee that scsi_device_set_state() calls are 
> serialized, so two scsi_device_set_state() invocations may be in 
> progress concurrently. It is e.g. possible that both calls report 
> "device state has been changed successfully" to their callers although 
> only one of these two state changes will be effective due to the race.

We could say the above about a significant fraction of the functions in
the kernel; it's not a reason to add fine grained locking to them all.

I want to know what the actual races you're trying to fix are; what
causes them and, in particular, is adding yet another fine grained lock
going to mitigate them effectively or should they be mediated in a
different way.

James

