From: Greg KH <greg@kroah.com>
Subject: Re: [PATCHv2] qla2xxx: Correct compilation issues when
 CONFIG_MOUDLES=n.
Date: Tue, 15 Sep 2009 08:33:12 -0700
Message-ID: <20090915153312.GB22774@kroah.com>
References: <20090908182541.GB44157@plap4-2.local>
 <20090911175341.GH710@plap4-2.local>
 <1252708951.13282.151.camel@mulgrave.site>
 <20090912000742.GB12098@plap4-2.local>
 <20090912001752.GC12098@plap4-2.local>
 <20090912003808.GD12098@plap4-2.local>
 <20090912005446.GA11691@kroah.com>
 <20090912025623.GA14824@plap4-2.local>
 <20090912043333.GA12349@kroah.com>
 <1252765807.4238.74.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1252765807.4238.74.camel@mulgrave.site>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Sep 12, 2009 at 09:30:07AM -0500, James Bottomley wrote:
> On Fri, 2009-09-11 at 21:33 -0700, Greg KH wrote:
> > On Fri, Sep 11, 2009 at 07:56:23PM -0700, Andrew Vasquez wrote:
> > > On Fri, 11 Sep 2009, Greg KH wrote:
> > > 
> > > > On Fri, Sep 11, 2009 at 05:38:08PM -0700, Andrew Vasquez wrote:
> > > > > Randy Dunlap noted:
> > > > > 
> > > > >   when CONFIG_MODULES=n:
> > > > > 
> > > > > 	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> > > > > 
> > > > >   in
> > > > > 
> > > > > 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> > > > > 		KOBJ_CHANGE, envp);
> > > > > 
> > > > > Trigger kobject event on the 'struct device' hanging off the pci_dev.
> > > > 
> > > > Um, why?  What are you trying to do here?  kobject change should not be
> > > > for a device, or a "normal" kobject.
> > > > 
> > > > What do you expect userspace to do with this?  Where have you documented
> > > > it?
> > > 
> > > The purpose was described here:
> > > 
> > > 	http://article.gmane.org/gmane.linux.scsi/54155
> > > 
> > > Basically we'd like to instruct user-space to retrieve a blob of data
> > > automatically.
> > 
> > Hm, like a firmware object perhaps?
> > 
> > > Original implementation used the kboject hanging off
> > > the module which does not exist when CONFIG_MODULES=n.  It was
> > > suggested that perhaps an alternative would be to use 'struct device'
> > > kobj.  Any tips on how to trigger such a driver-specific event,
> > > perhaps a dedicated kobject exported by the driver itself???
> > 
> > Why not use the firmware interface for it, that is what it is designed
> > for, and you will not have to craft any new udev rules.
> 
> The data is going the wrong way to use the current firmware interface,
> which is designed to load data from userspace into the kernel.  For this
> interface, we want the data to go the other way (i.e. the kernel has a
> blob of dump data it would like userspace to save if it can).

Ick.

> I'd be amenable to updating the firmware interface to do this, but it
> looks like adding a completely new codepath, which it's not clear even
> belongs there.

Well, I don't think it deserves a kobject change event, as that means
something a bit different to userspace today, right?

Either way, I see no documentation being added to the Documentation/ABI/
directory describing what is happening here, that needs to be added at
the least.

thanks,

greg k-h
