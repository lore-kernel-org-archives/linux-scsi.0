From: Tejun Heo <htejun@gmail.com>
Subject: Re: Current plans for SDEV_EVT_* and friends
Date: Tue, 1 Feb 2011 16:29:11 +0100
Message-ID: <20110201152911.GQ14211@htj.dyndns.org>
References: <4D481ED2.1060109@suse.de>
 <20110201145903.GO14211@htj.dyndns.org>
 <4D4826EE.3030906@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39956 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab1BAP3Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2011 10:29:16 -0500
Received: by fxm20 with SMTP id 20so6923097fxm.19
        for <linux-scsi@vger.kernel.org>; Tue, 01 Feb 2011 07:29:15 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4D4826EE.3030906@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Richard Sharpe <realrichardsharpe@gmail.com>, kay.sievers@vrfy.org

On Tue, Feb 01, 2011 at 04:29:50PM +0100, Hannes Reinecke wrote:
> > So, I think using the block layer DISK_EVENT_* would be the right way
> > to do it, but what kind of events do you have on mind?
> > 
> Well, partially.
> 
> DISK_EVENT_* is of course the right way to got if we're dealing with
> events which _can_ be mapped onto a gendisk.
> However, not all SCSI LUNs do have this mapping (eg LUNs not
> associated with any device driver) and not all events affect a
> single LUN. Some classes of events actually relate to the entire
> target, which would require us to call back into the SCSI host itself.
> Case in point: REPORT LUN DATA CHANGED, for which we would need to
> rescan the host.
> 
> So we basically have to have another set of events in the SCSI
> layer, some of which map to the existing DISK_EVENT_*, and some don't.
> Of course I can go ahead and create my own set of events, but that
> would nearly amount to code duplication.
> Hence the idea of re-using SDEV_EVT_*
> Or I'll be renaming them to SDEV_EVENT_* to be in-line with your
> DISK_EVENT_* thing and to avoid confusion with the previous
> implementation.

Hmmm... I suppose it really depends on each event.  If the userland
can't make much use of it, there's no point in doing the plumbing.  I
think the best way to proceed would be listing what events are there
and which actions need to be taken.

Both SDEV_EVT_* and DISK_EVENT_* are primarily concerned about
exporting the events to userland so that udev (or something similar)
can take action accordingly.  If there are events which make sense
that way, it would probably be best to add new disk events; otherwise,
they probably best remain as SCSI internal events.

-- 
tejun
