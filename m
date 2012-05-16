From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [dm-devel] multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Wed, 16 May 2012 22:34:35 +0200
Message-ID: <4FB40F5B.6070200@itwm.fraunhofer.de>
References: <4FB39D78.9020300@itwm.fraunhofer.de>  <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com>  <4FB3B9DE.1050903@itwm.fraunhofer.de> <4FB3C75F.3070903@cs.wisc.edu>  <4FB3CDC5.9040608@itwm.fraunhofer.de> <1337187813.21009.14.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60618 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965867Ab2EPUei (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 16:34:38 -0400
In-Reply-To: <1337187813.21009.14.camel@frustration.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>

On 05/16/2012 07:03 PM, David Dillow wrote:
> On Wed, 2012-05-16 at 11:54 -0400, Bernd Schubert wrote:
>> 2) Low SRP command queues. Is there a reason why 
>> SRP_RQ_SHIFT/SRP_RQ_SIZE and their depend values such as SRP_RQ_SIZE are 
>> so small?
> 
> That's a decision that has been around since the beginning of the driver
> as far as I can tell. It looks to be a balance between device needs and
> memory usage, and it can certainly be raised -- I've run locally with
> SRP_RQ_SHIFT set to 7 (shost.can_queue 126) and I'm sure 8 would be no
> problem, either. I didn't see a performance improvement on my workload,
> but may you will.

Ah, thanks a lot! In the past I tested the DDN S2A and figured out a
queue size of 16 per device provides optimal performance. So with
typically 7 primary devices per Server that makes 112, so SRP_RQ_SHIFT=7
is perfectly fine. But then with another typical configuration of 14
devices per server and with the current multipath-busy strategy, you
already should see a performance drop.
Right now I'm running tests on a NetApp and don't know yet optimal
parameters.  So I set the queue size to the maximum, but didn't expect
such multipath issues...

> 
> Because we take the minimum of our initiator queue depth and the initial
> credits from the target (each req consumes a credit), going higher than
> 8 doesn't buy us much, as I don't know off-hand of any target that gives
> out more than 256 credits.
> 
> The memory used for the command ring will vary depending on the value of
> SRP_RQ_SHIFT and the number of s/g entries allows to be put in the
> command. 255 s/g entries requires an 8 KB allocation for each request
> (~4200 bytes), so we currently require 512 KB of buffers for the send
> queue for each target. Going to 8 will require 2 MB max per target,
> which probably isn't a real issue.
> 
> There's also a response ring with an allocation size that depends on the
> target, but those should be pretty small buffers, say 1 KB * (1 <<
> SRP_RQ_SHIFT).
> 

Maybe we should covert the entire parameter to a module option? I will
look into it tomorrow.
And unless someone already comes up with a dm-mpath patch, I will try to
fix the first. I think I will simply always allow a few requests per
prio-group. Lets see if this gets accepted.


Thanks,
Bernd


PS: Thanks a lot for your ib-srp large IO patches you already sent last
year! I just noticed those last week.
