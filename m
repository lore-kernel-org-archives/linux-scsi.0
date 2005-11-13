From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 5/10] convert st to use scsi_execute_async
Date: Sun, 13 Nov 2005 20:08:45 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0511131950170.17356@kai.makisara.local>
References: <1131444404.23111.66.camel@max> <Pine.LNX.4.63.0511121859070.10335@kai.makisara.local>
 <43763E94.40406@cs.wisc.edu> <43764861.6030408@cs.wisc.edu>
 <Pine.LNX.4.63.0511130938570.15153@kai.makisara.local> <437772EA.7080100@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:57218 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751261AbVKMSIo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 13:08:44 -0500
In-Reply-To: <437772EA.7080100@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, Douglas Gilbert <dougg@torque.net>

On Sun, 13 Nov 2005, Doug Ledford wrote:

> Kai Makisara wrote:
> > On Sat, 12 Nov 2005, Mike Christie wrote:
> 
> I noticed that these patches still have the same bug that the 2.4 kernel st
> driver has, namely the holding of the st's SCSI request struct until
> write_behind_check is called.  This behavior is responsible for at least two
> bugs with tape systems under 2.4 that we've fixed.  The first bug is that if
> you perform a write to a tape device that involves an async write behind
> request, then attempt to access the device via the sg mechanism without
> performing any intervening read or ioctl commands on the st device, the sg
> access will hang.  This only happens on SCSI controllers that set the
> cmd_per_lun value == 1 (eg. mptscsih).  In order to replicate this problem you
> need one application writing to the tape device, then pausing, then something
> as simple as attempting to do an INQUIRY to the tape while the writer is
> paused causes the hang.  This happens at least with NetBackup, possibly with
> others as well.  The second bug is related to multiple tape usage on the same
> system.  It only happens on x86_64, not i686, but with multiple tapes in use
> the system eventually attempts to dma map a null pointer resulting in a BUG().
> I didn't root cause the dma mapping issue, but I did verify that once the
> initial bug was fixed, the dma mapping bug went away as well (either because
> whatever race window existed was reduced to so small that we no longer hit it
> or the problem was in fact fixed).  The patch we used to solve the problem is
> attached.  As a side note, holding on to a command without any upper bound on
> when it will be released is simply a *bad* idea.  Get the information you need
> from the command and free it.
> 

You are complaining about one feature and reporting a possible bug without 
much information. It seems that you (RedHat) have been sitting on this 
report for a long time and have shipped the fix for your own clients only. 
Not very nice!

Originally there was a reason why the SCSI request struct was held until 
write_behind_check. The reason was to execute minimum amount of code in 
interrupt context. For a very long time, scsi_done has been called outside 
interrupt and this reason is not valid any more. The reason why this has 
not changed is that nobody has asked for it.

I don't see any reason why the change you suggest should not be done. Does 
anyone else? If nobody complains, I will do the change for 2.6.16.

The dma bug you are talking about is interesting but I don't have any idea 
why it is happening. Releasing the SCSI request earlier should not have 
anything to do with that.

Mixing sg access with ULD operation is almost always a bad idea.

Thanks for the report and fix.

-- 
Kai
