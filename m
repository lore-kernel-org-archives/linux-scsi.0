From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 15:02:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2DA75C.3000800@splentec.com>
References: <10426732153816@kroah.com> <200301210150.55286.oliver@neukum.name> <3E2D8E78.4050405@splentec.com> <200301212000.29832.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
> Am Dienstag, 21. Januar 2003 19:16 schrieb Luben Tuikov:
> 
>>
>>When the Low Level Device Driver (LLDD), being the transport portal,
>>notices that the device is going away or has gone away from the
>>``fabric'' (wlg), it will fire a device-gone event with the kernel.
>>*Not* necessarily with SCSI Core, in fact I'd rather it didn't,
>>but with a well defined kernel entry for device-gone events.
> 
> 
> Well, we are in feature freeze. I see no alternative but to notify
> the mid layer. Who else but the mid layer knows what a physical device
> is logically associated with?

Yes, we're in  feature freeze.  I realize this and the fact
that this may be 2.7 work, but it's nevetheless worth
to brainstorm the issue.

I think one needs to notify at a higher level -- (some) decision making
may/will be made there. SCSI Core will be notified eventually, or maybe
right away. For all we know, the policy of removing a device could
be to just go into SCSI Core with the removal -- but the point is
that you need to notify at a higher level.

In due time, SCSI Core has no problem with a device disappearing.
As I mentioned already, the event will ``bubble down'' to SCSI Core,
at some point or immediately.

> 
>>At the same time the LLDD will start returning TARGET gone, or
>>whatever is appropriate to newly queued commands, and error out
>>all internally queued commands (if it does it's own queuing).
>>(I've seen this work nicely on mount and read/write(2) and fsck.)
> 
> 
> Right.

I've been saying (repeating) this for my last 3-4 emails.  Glad to
hear we've come to some kind of agreement. :-)

>>I.e. the ``synchronization'' has started already by the LLDD erroring
>>out commands, new and queued.
>>
>>All the while the kernel has started higher level cleaning up,
>>decrementing ref counts, etc, stuff which may not be so easy to be
>>cleaned up just by LLDD returning TARGET error.  Even though,
> 
> 
> You cannot really make anything depend on errors returned, because
> there simply may not be any commands queued. You can make it a

Exactly.  The more reason to have a notification even at a higher
level, because *if* you had users and whatnot using the device
then you'd want to let them/it know.  You need a higher level hook.
I can see a ton of uses for such a higher level hook.

> requirement for an LLDD to return all commands in flight with an error,
> but you can do little with these errors. Basically you have to treat them

As I've said, I've seen this method work nicely with mount and
fsck -- they time out almost right away, with different errors
of course, but LLDD returns TARGET error all the while.

So, either way (users or none), a higher level hook would seem
like a more general approach.

> like uncorrectable errors, except maybe for the error code returned to
> user space. But the processing of the disconnect itself should be triggered
> by the LLDD's notification, because it's the only indication of an unplug
> event you are sure to get.

I think this is the first thing I mentioned yesterday when I wrote
``transport initiated event''.

>>good design dictates that complete cleaning up should happen just
>>by the LLDD returning TARGET error (e.g. on mount), we *have* to allow
>>for this immediate high level entry point (as I mentioned above)
>>notification, which will be kind of ``meeting place'' for events like this.
> 
> 
> That I don't understand. It would seem to me to be cleanest to have just
> one path to process a disconnect event.

I also think that there should be one path: LLDD starts returning
TARGET error and all the while cleaning up has started from the top.

>>Depending on what needs to be done at those ``higher'' levels, the
>>event will eventually bubble down to the SCSI Core with something like
>>scsi_remove_device() which will do slave_destroy() in the driver.
>>
>>The point is that at that point in time, it will be *safe* to do
>>scsi_remove_device() as all ULP have alreay been notified, and they've
>>relinquished their use of the LLD (Low Level Device), thus the safety.
> 
> 
> But there can be no users of the LLDD at this point. There can of
> course be references to devices and hosts, but not really uses.

The more reason for a higher level hook -- you see, it generalizes
the cases of users and no users using the device -- you have it covered
both ways.  See my comments above.

> After we have done a notification of the event the first things to do
> are to make further opening of the device fail and make sure no more
> commands are sent to the device. Likewise all queued commands have
> returned with an error. So at this point it's impossible to use an unplugged
> device.

So here I take it you agree with me.

>>But there's no such thing as ``waiting around indefinitely'' or
>>``blocking wait'' as you've suggested in some of your emails.
>>
>>Even if this UL entry point doesn't do anything, ref counts should
>>go to zero, after all users error out on this device, at which point
>>the user can remove the device from *the system* by hand/old method
>>through proc or whatever finalizes for 2.6.
> 
> 
> You cannot be sure that reference counts will go to zero ever.
> You can be sure that they won't increase as you can fail any operation that
> would cause them to increase, but you cannot force userland to close its fds.
> And waiting for somebody to remove a device is wrong. It's gone physically.
> There's no choice but to remove it. The refcounts can tell you when to free
> data structures associated with devices, but what else do you want them to do?

A agree with all this.  What I was saying is the flexibility of the policy.
Yes, it is correct that we cannot force userland to close its fd's.
Just as you cannot force a parent process to collect child exit status :-) .
(Idea!)

I'm glad to see we're coming to an agreement.

-- 
Luben




