From: Greg KH <greg@kroah.com>
Subject: Re: devices with more than one node
Date: Thu, 15 Jan 2004 15:21:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040115232104.GA23253@kroah.com>
References: <20040113193842.GA29887@suse.de> <20040113194631.GA3818@kroah.com> <20040113211122.GA28100@suse.de> <20040113212058.GA2595@kroah.com> <20040113150147.A9902@beaverton.ibm.com> <20040113231813.GA7409@kroah.com> <1074042776.4004979822819@wwws.torque.net> <20040114030847.GG4339@linnie.riede.org> <4006499A.4070302@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:38824 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S265143AbUAOXVP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 18:21:15 -0500
Content-Disposition: inline
In-Reply-To: <4006499A.4070302@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: wrlk@riede.org, linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi

On Thu, Jan 15, 2004 at 06:04:42PM +1000, Douglas Gilbert wrote:
> Willem Riede wrote:
> >On 2004.01.13 20:12, dougg@torque.net wrote:
> >
> >>Quoting Greg KH <greg@kroah.com>:
> >>
> >>
> >>>For scsi generic you should create a scsi generic class (scsi_generic?)
> >>>and create the individual sg devices in that directory (feel free to use
> >>>the simple_class.c code that is currently in the -mm tree if you want,
> >>>it makes it much simpler)
> >>
> >>Does any device use the simple_class.c code yet?
> >
> >
> >I did in osst, see 
> >http://marc.theaimsgroup.com/?l=linux-kernel&m=107275923222124&w=2
> 
> Here is an sg patch against lk 2.6.1-mm2 that uses
> simple_add_class_device() as suggested by Greg and
> demonstrated by Willem in osst. The patch will apply
> clean against the sg driver in lk 2.6.1 but will not
> compile as the mm series defines simple_add_class_device().

Nice, this looks much better, thanks.

> So this patch is not meant to be placed in the mainline
> kernel yet. It is for Kai and Willem to consider and
> for others to critique.
> 
> The cdev stuff is still in place (and I assume Greg
> will soon be removing its sysfs visibility).

I will.

> The symlinks
> that Greg objected to (in /sys/cdev/major/sg* directories)
> have been dropped. A reverse symlink called "generic" has
> been redirected from the scsi device to the corresponding
> /sys/class/scsi_generic/sg<n> directory.

That's nice.

> To test it I modded scsi_debug to fake OnStream tape
> drives and ran a 2.6.1-mm2 kernel. The attached
> output of "cd /sys/class; tree scsi* osst" is instructive.
> Two peculiar entries are:
>     scsi_generic/sg0/driver -> ../../../bus/scsi/drivers/osst
>     scsi_generic/sg1/driver -> ../../../bus/scsi/drivers/osst
> 
> This symlink only appears if the osst driver is loaded
> _before_ the sg driver! It is also left dangling by
> "rmmod osst". It seems that sysfs is still not happy
> with multiple drivers controlling the one device.

The driver model does not allow this, and probably will not in the
future.

Just keep sg as a "class", like this patch does.  That should fix your
issues, right?

> The scsi subsystem solution to this is to relegate sg to be a sysfs
> "non" driver. Hence sg has no entry under
> /sys/bus/scsi/drivers and thus no obvious place to
> put its driver parameters. Sg driver parameters could be
> placed in the /sys/class/scsi_generic directory (with
> class_create_file() ). Suggestions?

That's a good place for them.  Unfortunatly the changes I made to the
class_simple.c code does not provide you the ability to do this.  If you
want to do this (and I think it is a good idea) you will have to write
your own class code (like the usb_host class code).

Hope this helps,

greg k-h
