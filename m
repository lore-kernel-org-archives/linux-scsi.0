From: Michael Reed <mdr@sgi.com>
Subject: Re: qla2xxx: Conditionally disable automatic queue full tracking
Date: Thu, 01 Oct 2009 19:19:04 -0500
Message-ID: <4AC546F8.7060507@sgi.com>
References: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com> <4ABB8572.5050902@sgi.com> <67E59C8B-0E12-44EA-983C-38634993DF5A@qlogic.com> <4ABBC53F.9090203@sgi.com> <3E1B3796-029F-4DBE-A414-0358AB257E93@qlogic.com> <4ABBDE68.2020903@sgi.com> <ABA38BF9-3910-45E9-8C2B-C860FD862D59@qlogic.com> <4AC3A21F.8070705@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:37374 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754141AbZJBATC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2009 20:19:02 -0400
In-Reply-To: <4AC3A21F.8070705@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, LinuxSCSI <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "vasu.dev@intel.com" <vasu.dev@intel.com>, Jeremy Higdon <jeremy@sgi.com>



Mike Christie wrote:
> On 09/29/2009 08:34 PM, Giridhar Malavali wrote:
>> 3) From your previous mail, I understand that you don't require a
>> combined limit per target. Say the total queue depth for all LUN's on a
>> particular target should not exceed some threshold.
>>
> 
> James Smart had done this patch
> http://marc.info/?l=linux-scsi&m=121070114018354&w=2
> where it sets the starget->can_queue based on info we get from vendors. 
> The patch did not get merged. JamesB does not want the 
> starget->can_queue to be static, and wants code like the queue full 
> tracking code which dynamically ramps the device queue depth up and down.

Agree.  Some amount of dynamic management of queue full seems desirable.
I believe any such dynamic management needs to acknowledge that it
exists in a multi-initiator environment, i.e., might get a QUEUE_FULL
with no other commands outstanding.

> 
> I am not sure if JamesB meant that he wants to ramp down the 
> starget->can_queue based on getting a QEUEU_FULL though. I thought he 
> just meant he wants it to be dynamic. 

What does "be dynamic" mean if not adjusted based upon a target's
response to scsi commands?

> If I am right, then I think we 
> could use JamesS's patch to set an initial starget->can_queue and add 
> another field for a max value. Then we could add some code that ramps 
> down/up based on something like command completion time or throughput or 
> some other value.

We don't necessarily need or want can_queue set by a value encoded into
a kernel table.  Some of our raid devices' can_queue values vary based
upon the firmware they are running.  A static table would, at best, be a
decent starting point.  At worst, it could dramatically over-commit the
target.  Our raid devices' max can_queue is either per raid controller
or per host port.

Whatever path we go down, I view having a user programmable upper bound
as a requirement.

> 
> If JamesS did mean that he wanted to ramp down the starget->can_queue 
> based on QUEUE_FULLs then JamesS and JamesB do not agree on that and we 
> are stuck.

I don't consider ramp up/down of starget->can_queue a requirement.
But I also don't consider its presence a problem.

Our requirements are pretty simple: the ability to limit the number
of commands queued to a target or lun in a multi-initiator environment
such that no individual initiator can fully consume the resources
of the target/lun.  I.e., we want a user programmable upper bound
on all queue_depth and can_queue adjustments.  (Yes, I've stated this
a few times.  :)


Mike



