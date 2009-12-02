From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: PATCH [1/1]: sd_remove() hangs waiting on async_synchronize of
 unrelated threads
Date: Wed, 02 Dec 2009 10:35:19 -0500
Message-ID: <1259768119.5430.59.camel@mulgrave.site>
References: <4B158E7B.3040708@sgi.com>
	 <1259704166.11762.516.camel@mulgrave.site>  <4B15989C.80108@sgi.com>
	 <1259707816.11762.539.camel@mulgrave.site>  <4B167942.400@sgi.com>
	 <1259765040.5430.19.camel@mulgrave.site>  <4B168541.4050502@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZLBPfU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 10:35:20 -0500
In-Reply-To: <4B168541.4050502@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Jeremy Higdon <jeremy@sgi.com>, James Smart <James.Smart@Emulex.Com>

On Wed, 2009-12-02 at 09:18 -0600, Michael Reed wrote:
> James Bottomley wrote:
> > On Wed, 2009-12-02 at 08:27 -0600, Michael Reed wrote:
> >> James Bottomley wrote:
> >>> The problem isn't removal per se ... it's the fact that remove can't
> >>> complete until any async pieces remaining from probe have run. 
> >> Yes, I understand that.  I didn't realize that the sd_probe resulted in any
> >> async work other than sd_probe_async().  It does complicate serialization
> >> at removal.
> >>
> >> I'll try to capture the "motivation" from within my fibre channel centric world
> >> for the change and see if anyone's got some ideas on how to resolve the issue.
> > 
> > OK ... actually describing the problem would be helpful.  The async
> > schedule is only in sd_remove() to guard against add/remove races ...
> > usually when we do removal, the async probing parts should be long
> > finished so I don't understand why you think we would be waiting for
> > stuff.
> 
> It appears that the async_synchronize_full() waits for all async threads
> from whatever source.  The issue arises when there is sd_probe_async() 
> work active for other luns.

Ah ... I'm afraid trying to fix that currently can't be done.  The
reason why we do a global synchronise is so that even with the async
pieces, everything shows up in-order (so the luns get sequentially
lettered in the sd<X> space).

Unfortunately, we're not yet to the point where we can expect devices to
show up entirely randomly on each boot and have the user cope.  Even
though udev can help with this, there are still too many non-udev or
simply just /dev/sd<X> using systems out there to dump the sequential
scan order just yet.

> Lots and LOTS of luns can delay the sd_probe_async work.  I've got
> over 7000 total luns on my test system via 13 different FC host adapters.
> What runs quickly on a small system can take a while on this config.
> Add fibre channel link up / down events or fabric changes can cause
> fc_remote_port_delete() and fc_remote_port_add() calls (and associated
> target scans), the time needed to process these events can exceed the
> device removal timeout resulting in removes while scan is still running
> and there's lots of async work pending.

Is the problem one of thread/work scheduling?  As in we just have too
much work to do and the scheduler isn't coping? ... figures comparing
what goes on with the fully sync case would be helpful.

> I'll try to provide a more detailed problem description later today.
> (I knew I should have saved those backtraces....)
> 
> Thanks for your help in explaining the issues associated with the patch.

You're welcome,

James


