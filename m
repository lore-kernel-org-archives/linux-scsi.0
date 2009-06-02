From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: no errors allowed during async probing
Date: Tue, 02 Jun 2009 15:20:48 -0500
Message-ID: <1243974048.6342.1.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.0906021436300.3228-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49797 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbZFBUUv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2009 16:20:51 -0400
In-Reply-To: <Pine.LNX.4.44L0.0906021436300.3228-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2009-06-02 at 14:41 -0400, Alan Stern wrote:
> On Tue, 2 Jun 2009, James Bottomley wrote:
> 
> > On Tue, 2009-06-02 at 14:05 -0400, Alan Stern wrote:
> > > This patch (as1252) fixes a bug in the sd probing code.  When the
> > > probe routine was split up into a synchronous and an asynchronous
> > > part, too much was put into the asynchronous part.  It's important
> > > that all the possible failure modes occur synchronously, so that the
> > > driver core knows whether the probe was successful even before the
> > > async part is complete.
> > > 
> > > Another bug is that device removal has to wait for the async probing
> > > to finish!  The patch addresses both bugs, by moving some code back
> > > from sd_probe_async() to sd_probe() and by adding a call to
> > > async_synchronize_full() at the start of sd_remove().
> > > 
> > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > This is pretty much line by line identical to the patch I already
> > posted, isn't it?  If not, help me understand what's different.
> 
> It is the same except for the very end, where you realized that you had 
> forgotten to wait for the async_synchronize_full() to complete before 
> calling dev_get_drvdata().  If you ever posted a corrected version of 
> the patch, I never saw it.

It's in my internal tree ... I didn't repost for something that trivial.

> My intention wasn't to steal your thunder or anything like that.  It
> was just to get a final, correct version of the patch into circulation
> for people to test and for merging.  I had (and still have!) no way of 
> knowing whether you ever finished the patch or merged it into any git 
> trees -- it isn't currently in scsi-misc.

Yes, I haven't quite decided ... It's a bug, but it doesn't look like
it's likely to be tripped in the ordinary course of events, so I was
hesitating about putting it in the last rc-fixes tree.  Of course, if it
turns out to fix the device_del() oops that would change things
entirely.

James


