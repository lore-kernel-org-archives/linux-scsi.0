From: Martin Dalecki <dalecki@evision-ventures.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 18:30:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D12032C.7040105@evision-ventures.com>
References: <Pine.LNX.4.44.0206200816380.8012-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

U=BFytkownik Linus Torvalds napisa=B3:

> Yes, but that's not enough. Other people are still asking for physica=
l
> location, so let's try to fix two things with _one_ generic interface=
 that
> is at least agnostic to how a device is connected to the kernel..


=46irst and foremost please allow me to state that I support
entierly the view of Linus that we should try to be as much
as possible device type agnostic for generic functionality
like detection of partitions on block devices. Thats all what
operating systems are about: abstraction of hardware interfaces.
But:

1. There was the mistake of using different major numbers
for SCSI and IDE/ATAPI devices. (disk and CD-ROM are the most striking)=
=2E

2. Then came devfs along and promised to slove this problem.
    But people still complained about not beeing ablve to boot, after
    I changed the registration name for IDE devices from "ide" to "ata"=
=2E
    This showed nicely that devfs doesn't cut it. It's useless for
    the purpose of unification of access methods apparently.

3. Now comes driverfs, which is basically a Solaris driver tree clone a=
nd
    *repeats* the same errors as 1. and 2.:


  ./
=2E/bus
=2E/bus/usb
=2E/bus/usb/drivers
=2E/bus/usb/devices
=2E/bus/usb/devices/002001
=2E..
=2E/bus/usb/devices/001000
=2E/bus/pci
=2E/bus/pci/drivers
=2E/bus/pci/drivers/parport_pc
=2E.
=2E/bus/pci/drivers/usb-uhci-hcd
=2E/bus/pci/drivers/e100
=2E/bus/pci/devices
=2E/bus/pci/devices/00:0c.1
=2E..
=2E/bus/pci/devices/00:00.0

1. The /drivers information is useless. modutils are maintining they
own information. For some jet unknow reason they manage to
maintain te hierarchy entierly in user space.

The bus suffix. is useless for any purpose I can imagine.
Which kind of view is the above supposed to present?

=2E/root

2. What is this root prefix good for?!
=2E/root/pci0

3. Solaris is separating the name and enumeration part by @ for
good reaons.

=2E/root/pci0/00:0c.1
=2E/root/pci0/00:0c.1/resources

4. resources? What is the semantics of this supposed to be?
IO ranges, memmory mappings? Whatever. This is jet another
ASCI view for data which is too specific and should be only
maintained by the drivers itself internaly as it is.
Since it's not used now it will open jet another room
for arbitrary formating and random useless entires problems in the futu=
re.
Much like the mess in /proc only repeated for every single device on th=
e
system.

=2E/root/pci0/00:0c.1/irq

5. This is showing that the resources file above is useless, becouse
I would rather love to consider irq as a resource.

=2E/root/pci0/00:0c.1/power
=2E/root/pci0/00:0c.1/name

6. The /name is entierly redundant logically to the fact that we
have already a unique path to the device. For "pretty" printing
we have userspace. For PCI it's for example repeating the
ID info found already by lspci.

=2E/root/pci0/00:07.2/usb_bus

7. What is the _bus? suffix good for? How does this releate
to the /bus hierarchy?

=2E/root/pci0/00:07.2/usb_bus/00

9. Contrary to PCI we enumerate the busses apparently
by one dir level and not a suffix on the usb prefix.

=2E/root/pci0/00:07.1/ata@00
=2E/root/pci0/00:07.1/ata@00/sd@0,0
=2E/root/pci0/00:07.1/ata@00/sd@0,0/power
=2E/root/pci0/00:07.1/ata@00/sd@0,0/name
=2E/root/pci0/00:07.1/ata@00/power
=2E/root/pci0/00:07.1/ata@00/name

Here I'm trying to fit the whole in some kind of
physical view. I did sneak in the sd instead of
hd in the futile hope that SCSI will pick up the same
name. And I buy in to the idea of separating
the enumeratin for the naming by a @.
This way one has only to enumerate the
dir only and no room for possible ambiguity is present.
But it was entierly behind me how to fit this
in to the sheme other sd@4,0:h,raw
OS-es are using. And finally how would one fit this in to the
partitioning shemes? For the system aprtitions are simply
block devices hanging off the corresponding block device.

However we can see that the driver filesystem is
inconsistant on the kind of enumeration it should
provide. See the colon in sd@0,0 and the whole subdir
crazyness... So do we distingish different devices by a subdir?
Or do we do it by an unique enumeration suffix?

And last but not least: I still don't see any kind
of abstraction there which would allow to easly enumerate
for example all disks in the system.

However a simple major number range for disks 1 to 16000 would
be ideal. And I bet that at some (not too distant) day we will
simple have to reassign those numbers and be done.

Really people please let you inspire:

=2E/pci@1f,4000/scsi@3/sd@9,0:f
=2E/pci@1f,4000/scsi@3/sd@9,0:h,raw
=2E/pci@1f,4000/scsi@3/sd@a,0:a
=2E/pci@1f,4000/scsi@3/sd@a,0:b
=2E/pci@1f,4000/scsi@3/sd@a,0:c
=2E/pci@1f,4000/scsi@3/sd@a,0:a,raw
=2E/pci@1f,4000/scsi@3/sd@a,0:b,raw

And just lets avoid the mistakes in the above.
I love the ,raw part for example instead of some
root mapping to completely different major numbers.



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
