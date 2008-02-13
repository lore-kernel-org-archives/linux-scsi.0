From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Wed, 13 Feb 2008 11:03:45 -0600
Message-ID: <1202922226.3109.36.camel@localhost.localdomain>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com>
	 <1202917468.3109.5.camel@localhost.localdomain>
	 <47B312B3.3010200@panasas.com>  <47B31BDE.2030408@panasas.com>
	 <1202921122.3109.31.camel@localhost.localdomain>
	 <47B31FC2.4040206@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46163 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933807AbYBMREB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 12:04:01 -0500
In-Reply-To: <47B31FC2.4040206@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sven =?ISO-8859-1?Q?K=F6hler?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>

On Wed, 2008-02-13 at 18:50 +0200, Boaz Harrosh wrote:
> On Wed, Feb 13 2008 at 18:45 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Wed, 2008-02-13 at 18:33 +0200, Boaz Harrosh wrote:
> >> On Wed, Feb 13 2008 at 17:54 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>> On Wed, Feb 13 2008 at 17:44 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >>>> On Tue, 2008-02-12 at 19:40 +0200, Boaz Harrosh wrote:
> >>>>> -	gdth_flush(ha);
> >>>>> -
> >>>> This piece doesn't look right.  gdth_flush() forces the internal cache
> >>>> to disk backing.  If you remove it, you're taking the chance that the
> >>>> machine will be powered off without a writeback which can cause data
> >>>> corruption.
> >>>>
> >>>> James
> >>>>
> >>> Yes. 
> >>> I have more problems reported, with exit, and am just sending one more patch that puts
> >>> this back in. Which was tested.
> >>>
> >>> So I will resend this one plus one new one.
> >>>
> >>> Boaz
> >>>
> >> The gdth driver would do a register_reboot_notifier(&gdth_notifier);
> >> to a gdth_halt() function, which would then redo half of what gdth_exit
> >> does, and wrongly so, and crash.  
> >>
> >> Are we guaranteed in todays kernel that modules .exit function be called
> >> on an halt or reboot? If so then there is no need for duplications and
> >> the gdth_halt() should go.
> > 
> > No.  The __exit section is actually discardable if you promise never to
> > remove the module.
> > 
> I don't understand please explain. 
> What does a driver need to do if it needs a consistent shutdown retine?
> module or built in? unload or shutdown?

It needs to register a reboot notifier, which gdth does.

However, the notifier is only called on reboot, so it also needs to
clean up correctly on module exit as well.

The alternative for GDTH would be to process the SCSI SYNCHRONIZE CACHE
command.  That's done by a shutdown notifier from sd, so the correct
thing would always get done; however it does mean the driver has to be
in a condition to process the last sync cache command.

For the quick fix, just keep the current infrastructure and put back the
gdth_flush() command where it can be effective.

James


