From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Sat, 28 Aug 2004 09:31:19 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408280922540.7958@kai.makisara.local>
References: <3DD91260-F839-11D8-A52F-00039398BB5E@ieee.org> <41300511.2060303@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep22-0.kolumbus.fi ([193.229.0.60]:63331 "EHLO
	fep22-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S267231AbUH1GbW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 02:31:22 -0400
In-Reply-To: <41300511.2060303@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

On Sat, 28 Aug 2004, Douglas Gilbert wrote:

> Pat LaVarre wrote:
> > Doug G:
> > 
> >  > so deferred errors can
> >  > be ignored in many contexts
> > 
> > Any hope of Linux always reporting that deferred errors have occurred, 
> > at least via dmesg if not in a critical dialog?
> 
> I certainly hope so. One small change I made in my patch
> yesterday was to pass deferred errors back to the block
> SG_IO code.
> 
Block SG_IO seems to be a collection of serious bugs and/or
misfeatures ;-)

...
> > A deferred error, in the context of sense data ((bytes[0] & x7F) != x70) 
> > is usually a purportedly rare and therefore interesting catastrophe of 
> > some kind, yes?  A failure to write seen while flushing cache.  A 
> > failure to eject after obediently faking "immediate"ly good status.  Etc.
> > 
> >  > http://marc.theaimsgroup.com/?l=linux-scsi&m=109359716220586
> 
> Perhaps deferred errors should be picked up at the lowest
> level of the midlevel, logged and ignored at higher levels
> unless they are going back to a pass through interface.
> 
The severity of deferred errors depends on the device. The tapes seem to 
again be an exception from the mainstream. Streaming tape drives have to 
use largish internal buffers. This means that, for instance, write errors 
often are deferred errors. The possibilities to report this error to the 
user are limited but that is another thing (basically the driver can only 
suggest to the user that the tape head is in an uknown position).

So, I hope that there will be also in future a possibility for a driver to 
receive deferred errors and preferably without too much noise.

-- 
Kai
