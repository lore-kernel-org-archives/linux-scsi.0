From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Illustration of warning explosion silliness
Date: Wed, 27 Sep 2006 21:48:42 -0400
Message-ID: <451B29FA.7020502@garzik.org>
References: <20060928005830.GA25694@havoc.gtf.org> <20060927183507.5ef244f3.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:2003 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965181AbWI1Bsp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 21:48:45 -0400
In-Reply-To: <20060927183507.5ef244f3.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

Andrew Morton wrote:
> On Wed, 27 Sep 2006 20:58:30 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> The following patch (DO NOT APPLY) illustrates why
>> device_for_each_child() should not be marked with __must_check.
>>
>> The function returns the return value of the actor function, and ceases
>> iteration upon error.
>>
>> However, _every_ case in drivers/scsi has a hardcoded return value,
>> illustrating how it is quite valid to not check the return value of this
>> function.
>>
> 
> What does "has a hardcoded return value" mean?

Reference the sentence before that.  The return value of the actor 
passed to device_for_each_child() is always either zero (for some 
actors) or one (for another actor).  In all cases, it is never variable.


> AFICT the problem here is that (for example) (going up the call stack in
> the callee->caller direction):
> 
> scsi_internal_device_block() returns an error code
> 
> but device_block() drops that on the floor
> 
> so target_block() drops it on the floor too
> 
> so scsi_target_block() drops it on the floor too
> 
> 
> It's a small matter of (correct kernel) programming to correctly propagate
> the scsi_internal_device_block() error code all the way back out of
> scsi_target_block().
> 
> It all looks rather sloppy?

Quite sloppy.  But that doesn't change the fact that 
device_for_each_child()'s actor _may_ hardcode the return value.  It's a 
valid usage model for that function.

If you are doing a simple collection of data -- adding items to a 
preallocating list or bitmap -- or doing a search, as with 
__remove_child() in drivers/scsi/scsi_sysfs.c, the return value can be 
quite useless.

The usage model should not be _forced_ upon the caller, since it might 
not be needed.

	Jeff


