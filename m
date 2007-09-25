From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 4/9] mpt fusion: error recovery improvements, andsynchronizing internal commands
Date: Mon, 24 Sep 2007 19:26:04 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709D92A4@NAMAIL4.ad.lsil.com>
References: <1190475519.3347.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35450 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbXIYB0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 21:26:09 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1190475519.3347.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Saturday, September 22, 2007 9:39 AM,  James Bottomley wrote:
> 
> Well, I'll put this in this time.  However, it contains a 
> whole slew of
> pointless changes like this:
> 
> 
> > -                       mdelay (10);
> > +                       udelay (10000);
> 
> and
> 
> > -               mdelay(1);
> > +               udelay(1000);
> 
> Which is going to excite the janitors into a frenzy of replace udelay
> with mdelay patches, which I can well do without ... please don't do
> this type of change unless there's some actual reason for it.
> 

I recall the reason for this change.  I found that medlay called during
interrupt context didn't work well, whereas udelay did.  Oringally when
mpt_fault_reset_work was added, this code was called using timers, which
as you know, is called as part of softirq bottom half handler.  Since
then, we converted mpt_fault_reset_work to being called using user
context work task, so really its a non-issue I guess.
