From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: 2.6.28-rc2 - strange (redundant) sysfs paths for SCSI
Date: Thu, 30 Oct 2008 22:17:03 +0100
Message-ID: <ac3eb2510810301417i60d6e68cv8b9545c29db8018a@mail.gmail.com>
References: <200810292105.40220.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:6595 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbYJ3VR1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 17:17:27 -0400
In-Reply-To: <200810292105.40220.arvidjaar@mail.ru>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 19:05, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> Running with PATA driver:
>
> /sys/devices/pci0000:00/0000:00:04.0/host0/scsi_host/host0
> /sys/devices/pci0000:00/0000:00:04.0/host0/target0:0:0/0:0:0:0
>
> well, in both cases at least one component is redundant?

Yes, it's a duplication. Ideally all the scsi_* class devices would
just offer their attributes at the "real" devices, the bus devices,
and not exist at all. But it's that way for a long time now, and they
can not just be removed. One possible solution could be to create the
attributes of the class devices at the "real" devices, and keep
compatibility symlinks from the class directory to the "real" device.

> Also the intermediate nodes (scsi_host and target0:0:0) do not seem
> to contain any useful information at all?

The target represents a main scsi device object and is expected to be
there. It's part of the specification, and the way scsi works. You can
have multiple targets per host and below the target the devices. All
that might not really make sense for ATA drives mapped to scsi, but
that's not a problem scsi could solve. :)

As mentioned a few lines above, the scsi_host class device "host0" is
already represented as the host bus device "host0" and is a
duplication, that's correct. Same is true for the scsi_device class
device.

The actual directory named "scsi_host" is just the glue the
driver-core creates for all class devices which have a bus device as a
parent. It's not created by scsi. The same thing like your pci
ethernet card is a "pci*" device and the "eth0" device, which is a
child of the pci device, lives in a subdir, always called after the
subsytem, "net". That way network devices can get almost any name
without conflicting with an attribute name of the parent device.
People complained, that they couldn't rename their network interface
to "irq". :)

> I noticed this because kernel installer in Mandriva started to
> complaint about host* and target* device nodes under /sys/bus/scsi/devices:

Yeah, users of sysfs are always required to check what the type of
device they retrieve. It must always be allowed to add new stuff to
existing directories. The host and target devices belong to the scsi
bus and got added a while ago. In the past, they have been created in
the device tree only, without a subsystem attached, and with no events
to userspace, which isn't a good thing to do.

> lrwxrwxrwx 1 root root 0 2008-10-29 19:58 0:0:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host0/target0:0:0/0:0:0:0/
> lrwxrwxrwx 1 root root 0 2008-10-29 19:58 1:0:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host1/target1:0:0/1:0:0:0/
> lrwxrwxrwx 1 root root 0 2008-10-29 19:58 host0 -> ../../../devices/pci0000:00/0000:00:04.0/host0/
> lrwxrwxrwx 1 root root 0 2008-10-29 19:58 host1 -> ../../../devices/pci0000:00/0000:00:04.0/host1/
> lrwxrwxrwx 1 root root 0 2008-10-29 19:58 target0:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host0/target0:0:0/
> lrwxrwxrwx 1 root root 0 2008-10-29 19:58 target1:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host1/target1:0:0/
>
> It is really not quite clear what use they have.

That looks all totally fine. The only things one could argue about are
the 1:1 duplicated class devices scsi_device and scsi_host, which you
don't even see in this listing, because they are class devices.

Kay
