From: Greg KH <greg@kroah.com>
Subject: Re: Question on "embedded" classes
Date: Mon, 27 Jun 2005 16:29:48 -0700
Message-ID: <20050627232948.GA24904@kroah.com>
References: <42C0897A.8010705@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262098AbVF0Xd1@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42C0897A.8010705@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 27, 2005 at 07:19:22PM -0400, Luben Tuikov wrote:
> Hi,
> 
> I was wondering what the reason was for allowing
> class and classdev to only be at level 3 and level
> 4 respectively of sysfs (/ is level 0)?
> 
> 1) Some devices would not have any relevance
> ouside the scope of the "parent" device.
> 2) "Hooking" them all at /sys/class/ level
> would create quite a lot of symlinks (and with
> cryptic names in order to reference the proper
> "parent" device in the same directory).
> 
> E.g. Some devices, like SAS host adapters, have "devices
> inside devices" and I'd like to represent this in
> sysfs.
> 
> /sys/class/sas          (a class)
> /sys/class/sas/ha0/     (a classdev)
> /sys/class/sas/ha1/     (a classdev)
> 
> /sys/class/sas/ha0/device -> symlink to PCI device
> /sys/class/sas/ha0/device_name    (text attribute)
> 
> /sys/class/sas/ha0/phys/     (a class)
> /sys/class/sas/ha0/phys/0/   (a classdev)

Nope, this is not allowed.

Classes are not allowed to have children classes.
class devices can not have children, be they class_device or a class.

That is the reason you are getting oopses :)

thanks,

greg k-h
