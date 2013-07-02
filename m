From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v12 5/6] Avoid that scsi_device_set_state() triggers a
 race
Date: Tue, 02 Jul 2013 08:42:08 +0200
Message-ID: <51D27640.2020607@acm.org>
References: <51CC5176.90609@acm.org> <51CC52A5.2010204@acm.org>  <1372690195.2385.20.camel@dabdike> <51D19D84.2070701@acm.org> <1372697574.2385.34.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:44996 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3GBGmN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jul 2013 02:42:13 -0400
In-Reply-To: <1372697574.2385.34.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On 07/01/13 18:52, James Bottomley wrote:
> On Mon, 2013-07-01 at 17:17 +0200, Bart Van Assche wrote:
>> On 07/01/13 16:49, James Bottomley wrote:
>>> On Thu, 2013-06-27 at 16:56 +0200, Bart Van Assche wrote:
>>>> Make concurrent invocations of scsi_device_set_state() safe.
>>>
>>> Firstly, I don't understand from this where you think the races are.
>>> Secondly, shouldn't this be the device lock? and thirdly, if we accept
>>> that locking is required, encapsulate it in the function: Having the
>>> callers manage locking is asking for trouble.  The latter may require a
>>> new lock for the state to avoid entanglement.
>>
>> Today there is no guarantee that scsi_device_set_state() calls are
>> serialized, so two scsi_device_set_state() invocations may be in
>> progress concurrently. It is e.g. possible that both calls report
>> "device state has been changed successfully" to their callers although
>> only one of these two state changes will be effective due to the race.
>
> We could say the above about a significant fraction of the functions in
> the kernel; it's not a reason to add fine grained locking to them all.
>
> I want to know what the actual races you're trying to fix are; what
> causes them and, in particular, is adding yet another fine grained lock
> going to mitigate them effectively or should they be mediated in a
> different way.

Since this patch is something I came up with as the result of source 
reading maybe I should defer this patch to a later time such that it 
doesn't slow down acceptance of this patch series.

Bart.

