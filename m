From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 5/10] convert st to use scsi_execute_async
Date: Sun, 13 Nov 2005 14:49:49 -0500
Message-ID: <437798DD.7000208@redhat.com>
References: <1131444404.23111.66.camel@max> <Pine.LNX.4.63.0511121859070.10335@kai.makisara.local> <43763E94.40406@cs.wisc.edu> <43764861.6030408@cs.wisc.edu> <Pine.LNX.4.63.0511130938570.15153@kai.makisara.local> <437772EA.7080100@redhat.com> <Pine.LNX.4.63.0511131950170.17356@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45502 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750977AbVKMTh0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 14:37:26 -0500
In-Reply-To: <Pine.LNX.4.63.0511131950170.17356@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, Douglas Gilbert <dougg@torque.net>

Kai Makisara wrote:
> On Sun, 13 Nov 2005, Doug Ledford wrote:
> 
> 
>>Kai Makisara wrote:
>>
>>>On Sat, 12 Nov 2005, Mike Christie wrote:
>>
>>I noticed that these patches still have the same bug that the 2.4 kernel st
>>driver has, namely the holding of the st's SCSI request struct until
>>write_behind_check is called.  This behavior is responsible for at least two
>>bugs with tape systems under 2.4 that we've fixed.  The first bug is that if
>>you perform a write to a tape device that involves an async write behind
>>request, then attempt to access the device via the sg mechanism without
>>performing any intervening read or ioctl commands on the st device, the sg
>>access will hang.  This only happens on SCSI controllers that set the
>>cmd_per_lun value == 1 (eg. mptscsih).  In order to replicate this problem you
>>need one application writing to the tape device, then pausing, then something
>>as simple as attempting to do an INQUIRY to the tape while the writer is
>>paused causes the hang.  This happens at least with NetBackup, possibly with
>>others as well.  The second bug is related to multiple tape usage on the same
>>system.  It only happens on x86_64, not i686, but with multiple tapes in use
>>the system eventually attempts to dma map a null pointer resulting in a BUG().
>>I didn't root cause the dma mapping issue, but I did verify that once the
>>initial bug was fixed, the dma mapping bug went away as well (either because
>>whatever race window existed was reduced to so small that we no longer hit it
>>or the problem was in fact fixed).  The patch we used to solve the problem is
>>attached.  As a side note, holding on to a command without any upper bound on
>>when it will be released is simply a *bad* idea.  Get the information you need
>>from the command and free it.
>>
> 
> 
> You are complaining about one feature and reporting a possible bug without 
> much information.

I was going to put in a simple reproducer, but the reproducer was based 
on code from someone else and I don't know the redistribution status of 
it since it wasn't my bug report.

> It seems that you (RedHat) have been sitting on this 
> report for a long time and have shipped the fix for your own clients only. 
> Not very nice!

Not true at all.  The fix hasn't even shipped yet except in a HOTFIX 
kernel, it will be released in our next update.

> Originally there was a reason why the SCSI request struct was held until 
> write_behind_check. The reason was to execute minimum amount of code in 
> interrupt context. For a very long time, scsi_done has been called outside 
> interrupt and this reason is not valid any more.

For 2.4 that's not entirely true.  The old error handler drivers in 2.4 
still do their work in interrupt context, and the driver I referenced, 
mptscsih, is an old error handler driver.

> The reason why this has 
> not changed is that nobody has asked for it.
> 
> I don't see any reason why the change you suggest should not be done. Does 
> anyone else? If nobody complains, I will do the change for 2.6.16.
> 
> The dma bug you are talking about is interesting but I don't have any idea 
> why it is happening. Releasing the SCSI request earlier should not have 
> anything to do with that.

I never isolated it down to a root cause.  I suspect the more NUMA like 
nature of x86_64 compared to i686 SMP has something to do with it.

> Mixing sg access with ULD operation is almost always a bad idea.

Maybe.  If you are talking about doing an sg write operation while also 
doing st writes, then yeah, that's bad.  But there's no inherent reason 
that something like INQUIRY or some status command can't be intermixed 
into the overall command stream via sg, and I would consider it a bug in 
the core scsi layer if it didn't handle that properly.

> Thanks for the report and fix.

No problem.


-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford

