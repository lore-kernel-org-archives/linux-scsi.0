From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCHv2] qla2xxx: Correct compilation issues when
 CONFIG_MOUDLES=n.
Date: Fri, 11 Sep 2009 19:56:23 -0700
Message-ID: <20090912025623.GA14824@plap4-2.local>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
 <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
 <20090908182541.GB44157@plap4-2.local>
 <20090911175341.GH710@plap4-2.local>
 <1252708951.13282.151.camel@mulgrave.site>
 <20090912000742.GB12098@plap4-2.local>
 <20090912001752.GC12098@plap4-2.local>
 <20090912003808.GD12098@plap4-2.local>
 <20090912005446.GA11691@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46712 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbZILC4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 22:56:20 -0400
Content-Disposition: inline
In-Reply-To: <20090912005446.GA11691@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>

On Fri, 11 Sep 2009, Greg KH wrote:

> On Fri, Sep 11, 2009 at 05:38:08PM -0700, Andrew Vasquez wrote:
> > Randy Dunlap noted:
> > 
> >   when CONFIG_MODULES=n:
> > 
> > 	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> > 
> >   in
> > 
> > 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> > 		KOBJ_CHANGE, envp);
> > 
> > Trigger kobject event on the 'struct device' hanging off the pci_dev.
> 
> Um, why?  What are you trying to do here?  kobject change should not be
> for a device, or a "normal" kobject.
> 
> What do you expect userspace to do with this?  Where have you documented
> it?

The purpose was described here:

	http://article.gmane.org/gmane.linux.scsi/54155

Basically we'd like to instruct user-space to retrieve a blob of data
automatically. Original implementation used the kboject hanging off
the module which does not exist when CONFIG_MODULES=n.  It was
suggested that perhaps an alternative would be to use 'struct device'
kobj.  Any tips on how to trigger such a driver-specific event,
perhaps a dedicated kobject exported by the driver itself???

> confused,

anch'io...

Thanks, AV
