From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: Suspending SCSI devices and buses
Date: Fri, 20 Aug 2004 11:53:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41261E65.8010504@optonline.net>
References: <Pine.LNX.4.44L0.0408201048030.1063-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pegasus.allegientsystems.com ([208.251.178.236]:44301 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S267507AbUHTPxK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 11:53:10 -0400
In-Reply-To: <Pine.LNX.4.44L0.0408201048030.1063-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> I don't know to what extent the sd driver detects and handles power-on or 
> media change events.  I'm also not sure how much point there is in trying 
> to distinguish them.  If you can't tell whether the medium was changed 
> while the power was off, you should assume that it was for safety's 
> sake.  Shucks, the entire drive may have been cold-swapped.

True, but users could cold-swap a non-removable drive too, and I don't 
think we should make the same assumptions there. Users expect resume 
from suspend to be fast, so needlessly invalidating all our buffer cache 
is silly.

Point being that we should probably do something about removable drives, 
but a hardcoded invalidate on resume is overkill.

> 
> 
>>Approach #1:
>>* Continue to do the unconditional spinup, but only for devices that are 
>>already mounted.
>>This may miss some media change events, but if we really can't 
>>distinguish power-on from media change, maybe that's somebody else's 
>>problem if the device was already mounted. (Changing mounted media is 
>>the user's fault.)
> 
> 
> It doesn't matter whose fault it is; if a mounted medium is changed the
> driver should be careful to invalidate the existing file references so
> that the new medium isn't corrupted and the errors can be propagated back
> up to the user.  That's how it seems to me, anyway -- existing kernel 
> policy might be different.  How does the floppy driver handle these 
> things?

Historically, not very well. If you eject a floppy before all dirty 
buffers are flushed, there's not much we can do for you, even if you 
realize your mistake and put the original disk back you're still 
screwed. Luckily we should flush buffers before suspend, so this may 
mitigate...

Also check out fs/block_dev.c and note the printk "VFS: busy inodes on 
changed media." I don't know that we deal with that condition too well. 
Strangely, I could swear that I've seen this message from the kernel, 
but the comment claims that it's only called during mount/open...


>>(Hmm, what about devices that are opened for read/write but not mounted?)
> 
> 
> IMHO they should be treated equivalently.  Neither the new medium nor the
> I/O stream should be allowed to get corrupted.  Does sd.c even know 
> whether or not an open file handle refers to a mounted volume?

A mounted fs has more complexities than a block device that is only 
opened by userspace. For the latter case we can invalidate all buffers 
and after that the only question is how aggressive to be about passing 
errors up to userspace. For a mounted fs we may have to deal with busy 
inodes and I don't know how well the VFS layer deals with that. So there 
may yet turn out to be a reason to handle them differently.

> Or test _during_ spin-up.  But note that not all Unit Attentions are bad.
> Anyway the driver should already be checking for UAs that indicate
> power-on or media change (but I don't know whether it actually does so).

True. But we currently don't make the distinction between good/bad UA's. 
If we introduce the distinction, we need to be careful about 
regressions. Currently the default is that all UA's are "bad" (trigger a 
media change.) It may make the most sense to keep that as the default 
and only exclude certain additional sense codes that are known to be 
good. In order for those exceptions to be added, someone might have to 
complain about it first, since I'm not sure we can make that change 
without a testcase ;)

> 
> For that matter, the driver doesn't seem to care very much about 
> PREVENT-ALLOW MEDIUM REMOVAL.  Sure, it issues the PREVENT command when 
> the device is opened, but it doesn't recognize that the drive forgets the 
> prevent/allow state whenever it is reset.
> 
> Also remember, some devices can't be spun up and actively dislike the 
> START-STOP UNIT command (to the point of crashing when they receive it).  
> I mention this just to make your life more difficult.  :-)

I'm aware of that. That's why I'm using the rescan code, since it knows 
about this issue and attempts to TEST UNIT READY first.

It's certainly annoying since START STOP UNIT is extended to specify 
power-management states in the newer SBC standard. :( Maybe it would 
work to just stick with the power control mode parameters from the SPC 
standard, though...

> 
> Alan Stern
> 
> P.S.: Slightly off-topic for this thread...  Why does sd.c probe for
> write-protect only on devices with removable media?  Some fixed-media
> devices can also be write-protected.
> 
> 

