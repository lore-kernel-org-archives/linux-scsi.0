From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Sat, 29 Mar 2003 11:04:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030329190407.GA1483@beaverton.ibm.com>
References: <20030325100704.GC3868@beaverton.ibm.com> <1048613872.2070.12.camel@mulgrave> <20030325184530.GA1202@beaverton.ibm.com> <1048618939.1790.29.camel@mulgrave> <20030325232920.GB2692@beaverton.ibm.com> <1048779761.1789.21.camel@mulgrave> <20030328173253.A32352@one-eyed-alien.net> <1048948992.21525.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048948992.21525.1.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Fri, 2003-03-28 at 19:32, Matthew Dharm wrote:
> > Well, Linus wants this to work for usb-storage more short-term than
> > long-term....
> 
> Well, I think Mike's given us everything you need.  We can use the
> set_device_offline to alter the remove-single-device path to offline the
> device, wait for the returning I/Os to complete or error and then remove
> the device.
> 
> You can then trigger this from your hotplug scripts.

I believe we still need to fixup scsi_remove_host to not fail (i.e
return void) and call "hostt->release" when the ref count on the host
goes to zero. (I believe this was a point that started us on this thread
of work as the usb implementation was one device per host).

I have a work in progress patch that ensures that all scsi hosts have a
sysfs struct device even if the driver is not converted to the driver
model which allows scsi_devices to be true children of a scsi_host
struct device. This should allow the usage of kobject ref counting for
scsi_hosts. I am still working on plugging the holes in this support
hopefully I will have something out to the list soon.

-andmike
--
Michael Anderson
andmike@us.ibm.com

