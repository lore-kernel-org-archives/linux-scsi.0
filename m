From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: devices with more than one node
Date: Fri, 16 Jan 2004 01:59:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116095934.GA1855@beaverton.ibm.com>
References: <20040113193842.GA29887@suse.de> <20040113194631.GA3818@kroah.com> <20040113211122.GA28100@suse.de> <20040113212058.GA2595@kroah.com> <20040113150147.A9902@beaverton.ibm.com> <20040113231813.GA7409@kroah.com> <1074042776.4004979822819@wwws.torque.net> <20040114030847.GG4339@linnie.riede.org> <4006499A.4070302@torque.net> <20040115232104.GA23253@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:43434 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265340AbUAPJzK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 04:55:10 -0500
Content-Disposition: inline
In-Reply-To: <20040115232104.GA23253@kroah.com>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Douglas Gilbert <dougg@torque.net>, wrlk@riede.org, linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi

Greg KH [greg@kroah.com] wrote:
> > To test it I modded scsi_debug to fake OnStream tape
> > drives and ran a 2.6.1-mm2 kernel. The attached
> > output of "cd /sys/class; tree scsi* osst" is instructive.
> > Two peculiar entries are:
> >     scsi_generic/sg0/driver -> ../../../bus/scsi/drivers/osst
> >     scsi_generic/sg1/driver -> ../../../bus/scsi/drivers/osst
> > 
> > This symlink only appears if the osst driver is loaded
> > _before_ the sg driver! It is also left dangling by
> > "rmmod osst". It seems that sysfs is still not happy
> > with multiple drivers controlling the one device.
> 
> The driver model does not allow this, and probably will not in the
> future.
> 
> Just keep sg as a "class", like this patch does.  That should fix your
> issues, right?
> 

Greg a clarification check. There is a scsi_device class already that sg
registers an interface with. The interface of scsi_device class is used
to add / remove the scsi_generic simple class devices and this is ok to
keep doing (not that there is another easy way to do this since sg does not
bind).

> > The scsi subsystem solution to this is to relegate sg to be a sysfs
> > "non" driver. Hence sg has no entry under
> > /sys/bus/scsi/drivers and thus no obvious place to
> > put its driver parameters. Sg driver parameters could be
> > placed in the /sys/class/scsi_generic directory (with
> > class_create_file() ). Suggestions?
> 
> That's a good place for them.  Unfortunatly the changes I made to the
> class_simple.c code does not provide you the ability to do this.  If you
> want to do this (and I think it is a good idea) you will have to write
> your own class code (like the usb_host class code).
> 

Another option that should work is that sg could register as a
scsi_driver and use bus_match to ensure it never binds. The only
difference between the other upper level drivers would be the links to
the devices in bus/scsi/driver/sg would not exist like other upper level
drivers. You would have a place though for driver attributes.

-andmike
--
Michael Anderson
andmike@us.ibm.com

