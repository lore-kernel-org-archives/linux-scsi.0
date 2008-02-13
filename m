From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Wed, 13 Feb 2008 11:33:55 -0600
Message-ID: <1202924035.3109.48.camel@localhost.localdomain>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com>
	 <1202917468.3109.5.camel@localhost.localdomain>
	 <47B312B3.3010200@panasas.com>  <47B31BDE.2030408@panasas.com>
	 <1202921122.3109.31.camel@localhost.localdomain>
	 <47B31FC2.4040206@panasas.com>
	 <1202922226.3109.36.camel@localhost.localdomain>
	 <47B32680.5020405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47385 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759962AbYBMReD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 12:34:03 -0500
In-Reply-To: <47B32680.5020405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sven =?ISO-8859-1?Q?K=F6hler?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>

On Wed, 2008-02-13 at 19:18 +0200, Boaz Harrosh wrote:
> On Wed, Feb 13 2008 at 19:03 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > It needs to register a reboot notifier, which gdth does.
> > 
> > However, the notifier is only called on reboot, so it also needs to
> > clean up correctly on module exit as well.
> > 
> > The alternative for GDTH would be to process the SCSI SYNCHRONIZE CACHE
> 
> Why would we think that the controller does not support this command
> is it not in the mandatory section of the standard?

Um, because the controller isn't a SCSI device.  It's an emulated device
which means the SCSI comands are processed in the driver.  It does look
like the driver<->HBA communication is some sort of translated dialect
of SCSI.

> > command.  That's done by a shutdown notifier from sd, so the correct
> > thing would always get done; however it does mean the driver has to be
> > in a condition to process the last sync cache command.
> 
> Why would it not be ready? what do other drivers do?
> The drivers is ready until the very last module's .exit. Is that good
> enough?

shutdown is called as part of device removal and module unload ...
usually from scsi_remove_host().  So you can't tear down command
processing before that point.

> > 
> > For the quick fix, just keep the current infrastructure and put back the
> > gdth_flush() command where it can be effective.
> > 
> 
> Just did. But if needed I would prefer to emulate the SCSI SYNCHRONIZE CACHE
> command and not that boot notifier thing. Please advise.

I think such a change, though desirable, would be too large to count as
a bug fix.

James


