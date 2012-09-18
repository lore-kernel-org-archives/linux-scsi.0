From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v2 1/4] scsi: introduce sync_before_stop flag
Date: Tue, 18 Sep 2012 16:31:38 +0800
Message-ID: <20120918083138.GA1792@mint-spring.sh.intel.com>
References: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
 <1347951631-1592-2-git-send-email-aaron.lu@intel.com>
 <1347955015.2388.0.camel@dabdike.int.hansenpartnership.com>
 <20120918080915.GA1740@mint-spring.sh.intel.com>
 <1347956420.2388.9.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab2IRIbm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 04:31:42 -0400
Content-Disposition: inline
In-Reply-To: <1347956420.2388.9.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Oliver Neukum <oneukum@suse.de>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org

On Tue, Sep 18, 2012 at 09:20:20AM +0100, James Bottomley wrote:
> On Tue, 2012-09-18 at 16:09 +0800, Aaron Lu wrote:
> > On Tue, Sep 18, 2012 at 08:56:55AM +0100, James Bottomley wrote:
> > > On Tue, 2012-09-18 at 15:00 +0800, Aaron Lu wrote:
> > > > When scsi device received stop command, it will take care of its
> > > > internal cache before enters stopped power condition. This command is
> > > > translated to standby immediate in libata-scsi, but standby doesn't
> > > > imply flush cache for ATA device, so to issue stop command to ATA
> > > > device, an additional flush cache has to be issued.
> > > > 
> > > > Introduce this flag so that when we are to stop the ATA disk in scsi
> > > > disk driver, also flush its internal cache.
> > > > 
> > > > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > > > ---
> > > >  include/scsi/scsi_device.h | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> > > > index 4712aa1..26c3621 100644
> > > > --- a/include/scsi/scsi_device.h
> > > > +++ b/include/scsi/scsi_device.h
> > > > @@ -160,6 +160,7 @@ struct scsi_device {
> > > >  	unsigned ready_to_power_off:1;	/* Device is ready to be powered off */
> > > >  	unsigned powered_off:1;	/* Device is powered off */
> > > >  	unsigned may_power_off:1; /* Power off is allowed by user */
> > > > +	unsigned sync_before_stop:1; /* Sync cache before stop */
> > > 
> > > Why do you need this?
> > > 
> > > Surely it's all conditioned on the WCE flag.  If WCE isn't set, the
> > > cache is write through (or uncached) and there's no need for a sync
> > > before power down.
> > 
> > The set of this flag doesn't mean we will sync cache for sure.
> > 
> > It's only meaningful when WCE is set, and in that case, it means when we
> > are to send a stop command to the device, do we need to send an
> > additional flush cache command first?
> 
> Then surely it indicates support for ACPI power down and it's wrongly
> named?

It's generic ATA requirement that before standby, cache has to be
flushed and unlike scsi, standby does not imply cache flush.

> 
> > In sd_suspend, the cache will be synchronized when:
> > 1 For devices do not support start_stop, always;
> > 2 For devices support start_stop, if it is standard scsi device, never;
> >   and if it is an ata device(reflected by this newly introduced flag),
> >   always.
> 
> This doesn't look right to me.  I think it's probably just a layering
> violation.  For sd, we need to use the standard SCSI commands.  That
> means we treat power states as the SCSI standard says.  The fact that
> ATA devices may be required to translate START_STOP_UNIT with STANDBY as
> a flush followed by one of the ATA standby commands.  This is very
> important: if we construct a libata SATL that doesn't conform to the
> standards, things will eventually explode when we try to interact with
> devices with their own internal SATL (like the LSI card, or various USB
> devices) because eventually we'll make one unexpected interaction too
> many.

I agree that it is better handled in libata's SALT, I tried to do this
but didn't find a good way so I introduced this flag. The SALT is 1-1
mapping, I'm not sure how to handle this 1-2 mapping.

I'll check this again to see how to do it there.

Thanks for your comments.

-Aaron
