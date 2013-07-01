From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v12 5/6] Avoid that scsi_device_set_state() triggers a
 race
Date: Mon, 01 Jul 2013 17:17:24 +0200
Message-ID: <51D19D84.2070701@acm.org>
References: <51CC5176.90609@acm.org> <51CC52A5.2010204@acm.org> <1372690195.2385.20.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:34665 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GAPR3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 11:17:29 -0400
In-Reply-To: <1372690195.2385.20.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On 07/01/13 16:49, James Bottomley wrote:
> On Thu, 2013-06-27 at 16:56 +0200, Bart Van Assche wrote:
>> Make concurrent invocations of scsi_device_set_state() safe.
>
> Firstly, I don't understand from this where you think the races are.
> Secondly, shouldn't this be the device lock? and thirdly, if we accept
> that locking is required, encapsulate it in the function: Having the
> callers manage locking is asking for trouble.  The latter may require a
> new lock for the state to avoid entanglement.

Today there is no guarantee that scsi_device_set_state() calls are 
serialized, so two scsi_device_set_state() invocations may be in 
progress concurrently. It is e.g. possible that both calls report 
"device state has been changed successfully" to their callers although 
only one of these two state changes will be effective due to the race.

At the time I wrote this patch I think there was a caller that invoked 
scsi_device_set_state() with the host lock held. Hence my choice for the 
host lock. However, I can't find that caller anymore. So the suggestion 
to use the device lock instead makes sense to me. I'll double check 
whether there are no callers of that function that already hold the 
device lock.

Bart.
