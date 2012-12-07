From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v6 10/13] Make scsi_remove_host() wait for device removal
Date: Fri, 07 Dec 2012 08:41:52 +0100
Message-ID: <50C19DC0.8040000@acm.org>
References: <50B60619.4080406@acm.org> <50B608C1.6080803@acm.org> <20121202134515.GJ15930@mtj.dyndns.org> <50BC619F.7060707@acm.org> <20121203161510.GA19802@htj.dyndns.org> <50BCD59C.2020909@acm.org> <20121203164257.GE19802@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:37018 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab2LGHl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2012 02:41:56 -0500
In-Reply-To: <20121203164257.GE19802@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On 12/03/12 17:42, Tejun Heo wrote:
> On Mon, Dec 03, 2012 at 05:38:52PM +0100, Bart Van Assche wrote:
>> It is indeed possible to invoke complete() only if the device list
>> became empty with the host state equal to SHOST_CANCEL,
>> SHOST_CANCEL_RECOVERY, SHOST_DEL or SHOST_DEL_RECOVERY and in
>
> We can test this with !scsi_host_scan_allowed(), right?
>
>> scsi_remove_host() to wait for that completion only if the device
>> list was not empty before the host state was changed into one of the
>> four mentioned states. Do you really prefer this approach over the
>> approach in the patch at the start of this thread ?
>
> Maybe I'm missing something but if possible completion tends to be
> much simpler than using waitqueue directly.  I *think* that's the case
> here.  Am I missing something?

Hello Tejun,

You are right that it should be possible to use a completion in this 
context instead of a wait queue. However, I'm not enthusiast about using 
a completion for this patch because it would mean introducing several 
additional if-statements. Such if-statements would make this patch even 
harder to test then it already is now.

Note: all your other review comments should have been addressed in v7 of 
this patch series.

Bart.

