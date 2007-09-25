From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 4/9] mpt fusion: error recovery improvements,
	andsynchronizing internal commands
Date: Tue, 25 Sep 2007 12:34:47 -0500
Message-ID: <1190741687.3345.30.camel@localhost.localdomain>
References: <664A4EBB07F29743873A87CF62C26D709D92A4@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60558 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751214AbXIYRet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 13:34:49 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D709D92A4@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2007-09-24 at 19:26 -0600, Moore, Eric wrote:
> On Saturday, September 22, 2007 9:39 AM,  James Bottomley wrote:
> > 
> > Well, I'll put this in this time.  However, it contains a 
> > whole slew of
> > pointless changes like this:
> > 
> > 
> > > -                       mdelay (10);
> > > +                       udelay (10000);
> > 
> > and
> > 
> > > -               mdelay(1);
> > > +               udelay(1000);
> > 
> > Which is going to excite the janitors into a frenzy of replace udelay
> > with mdelay patches, which I can well do without ... please don't do
> > this type of change unless there's some actual reason for it.
> > 
> 
> I recall the reason for this change.  I found that medlay called during
> interrupt context didn't work well, whereas udelay did.  Oringally when
> mpt_fault_reset_work was added, this code was called using timers, which
> as you know, is called as part of softirq bottom half handler.  Since
> then, we converted mpt_fault_reset_work to being called using user
> context work task, so really its a non-issue I guess.

That shouldn't have happened ... if you look (include/linux/delay.h)
mdelay is implemented in terms of udelay, so the behaviour should be the
same.

There is a technical difference, though.  Because udelay is busy waiting
in a calculated processor loop, it can overflow for large values (and
large is defined to be anything > 1000) mdelay() is careful to call
udelay multiple times to avoid the potential overflow.

James



