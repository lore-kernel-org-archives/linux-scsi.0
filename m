From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 09:47:23 -0500
Message-ID: <496F4C7B.2030707@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1642 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763142AbZAOOr0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 09:47:26 -0500
In-Reply-To: <496E7993.70307@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Tony Battersby wrote:
>   
>> Stefan Richter wrote:
>>     
>>> If "some other CPU can find a reference to the
>>> object" after the reference count dropped to zero, then the problem is
>>> IMO clear and simple:
>>>
>>> Some site did not increase the refcount when it should.
>>>   
>>>       
>> The original code makes it possible to find the object and get
>> information about it right up until the point that the destructor is
>> called.  However, adding a reference just for this purpose would prevent
>> the object from ever being freed.
>>     
>
> No, why?
>
> There is a list or idr with pointers to your objects?  As long as the
> list contains a pointer to object A, this list needs to own one
> reference count to A.  Right after A was deregistered from the list, A's
> reference count is decremented on behalf of the list.
>
> If some site looks objects up in that list and uses the objects, it
> increases the refcount of such an object while it accesses the list.
> When done with the object, it decrements the object's refcount on this
> site's behalf.
>
> Eventually, some site will have been the last one to put away a pointer
> to the object.  Then, and only then, the kref goes down to zero and the
> destructor is executed.
>
>   
>> Removing the ability to get
>> information about closed fds or deleted devices that still have
>> outstanding commands changes the user-visible behavior,
>>     
>
> I'm not saying you are to remove such an ability; I'm just saying that
> as long as any site is ably to get to an object, the refcount of the
> object can't be zero.  Bring it down to zero _after_ you made the object
> invisible to others.
>   

Here is an example the way my patch does it:

open fd: kref_init(): refcount = 1
send command: kref_get(): refcount 1 -> 2
close fd: kref_put(): refcount 2 -> 1
/proc access begin: idr_find(); kref_get_not_zero(): refcount 1 -> 2
/proc access end: kref_put(): refcount 2 -> 1
command completes: kref_put(): refcount 1 -> 0: idr_remove()

Here is the alternative:

open fd: kref_init(): refcount = 1
send command: kref_get(): refcount 1 -> 2
close fd: idr_remove(); kref_put(): refcount 2 -> 1
/proc access begin: idr_find(): *** NOT FOUND ***
command completes: kref_put(): refcount 1 -> 0

The only obvious places to remove the idr are either from the destructor
(as done by my patch) or from close (which is what you are probably
thinking).  If you do it from close, /proc no longer gives information
about fds that have been closed but still have commands pending.  I
don't see an obvious way to remove the idr from the command completion
path before kref_put(), since there can be multiple commands
outstanding, and we want to leave the idr in place until the last
command completes.

Most users of kref would do the idr_remove() from close(), since the
object doesn't stay around long enough afterward for it to matter. 
However, some sg commands can take minutes to complete (or sometimes
never complete unless the user explicitly takes action to abort them). 
While there are outstanding commands, the sg module cannot be unloaded,
and re-opening the sg device and trying to send more commands may hang
if the old commands need to be aborted first.  It is nice to have some
way of telling the user why rmmod sg fails and why newly-sent commands
don't complete.

Tony
