From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 03/10] SCSI: fcoe: convert to use BUS_ATTR_WO
Date: Tue, 22 Jan 2019 15:22:28 +0100
Message-ID: <20190122142228.GA18225@kroah.com>
References: <20181221075442.17109-1-gregkh@linuxfoundation.org>
 <20181221075442.17109-4-gregkh@linuxfoundation.org>
 <1545406185.2765.8.camel@linux.ibm.com>
 <5691ac07-ec5d-893f-09e4-ff1acd889abd@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5691ac07-ec5d-893f-09e4-ff1acd889abd@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jejb@linux.ibm.com>, linux-kernel@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 28, 2018 at 01:50:53PM +0100, Hannes Reinecke wrote:
> On 12/21/18 4:29 PM, James Bottomley wrote:
> > [scsi list cc added]
> > On Fri, 2018-12-21 at 08:54 +0100, Greg Kroah-Hartman wrote:
> > > We are trying to get rid of BUS_ATTR() and the usage of that in the
> > > fcoe driver can be trivially converted to use BUS_ATTR_WO(), so use
> > > that instead.
> > > 
> > > At the same time remove a unneeded EXPORT_SYMBOL() marking for the
> > > sysfs callback function we are renaming, no idea of how that got into
> > > the tree...
> > 
> > The EXPORT_SYMBOL removal is fine, but
> > 
> > [...]
> > > --- a/include/scsi/libfcoe.h
> > > +++ b/include/scsi/libfcoe.h
> > > @@ -405,10 +405,8 @@ int fcoe_transport_attach(struct fcoe_transport
> > > *ft);
> > >   int fcoe_transport_detach(struct fcoe_transport *ft);
> > > 
> > >   /* sysfs store handler for ctrl_control interface */
> > > -ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
> > > -			       const char *buf, size_t count);
> > > -ssize_t fcoe_ctlr_destroy_store(struct bus_type *bus,
> > > -				const char *buf, size_t count);
> > > +ssize_t ctlr_create_store(struct bus_type *bus, const char *buf,
> > > size_t count);
> > > +ssize_t ctlr_destroy_store(struct bus_type *bus, const char *buf,
> > > size_t count);
> > 
> > You're really damaging our prefix namespace here.  It looks like the
> > ctlr_ name is a farly recent addition for sysfs (only myra/b) use it in
> > SCSI but it's inviting symbol clashes.
> > 
> Hmm. I was under the impression that all sysfs functions from myrb/myrs are
> local, hence I would not need to prefix them.
> If this isn't the case I definitely will be fixing them.
> 
> But in any case, if possible any sysfs function should be local to the
> driver; no-one else should ever attempt to use them.
> And we should be making it so if that's not the case.

This is all in the same "driver", just that the driver is spread out
over multiple files.

James, thanks for the fixup, I'll go respin this and break this up into
two patches and resend in a bit.

thanks,

greg k-h
