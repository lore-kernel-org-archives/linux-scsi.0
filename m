From: Douglas Gilbert <dougg@torque.net>
Subject: Re: fdisk on scsi disks in 2.5.21
Date: Tue, 11 Jun 2002 08:40:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D05EFC7.10C17B08@torque.net>
References: <3D054432.88C5BE59@torque.net> <3D059893.60206@evision-ventures.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Martin Dalecki <dalecki@evision-ventures.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Martin Dalecki wrote:
> 
> Douglas Gilbert wrote:
> > $ fdisk -l /dev/sda
> >
> > Disk /dev/sda: 1 heads, 35843670 sectors, 1 cylinders
> > Units = cylinders of 35843670 * 512 bytes
> >
> >    Device Boot    Start       End    Blocks   Id  System
> > /dev/sda1   *         1         1     32098+  83  Linux
> > Partition 1 has different physical/logical beginnings (non-Linux?):
> >      phys=(0, 1, 1) logical=(0, 0, 64)
> > Partition 1 has different physical/logical endings:
> >      phys=(3, 254, 63) logical=(0, 0, 64260)
> > Partition 1 does not end on cylinder boundary:
> >      phys=(3, 254, 63) should be (3, 0, 35843670)
> > /dev/sda2             1         1    168682+  83  Linux
> > Partition 2 has different physical/logical beginnings (non-Linux?):
> >      phys=(4, 0, 1) logical=(0, 0, 64261)
> > Partition 2 has different physical/logical endings:
> >      phys=(24, 254, 63) logical=(0, 0, 401625)
> > Partition 2 does not end on cylinder boundary:
> >      phys=(24, 254, 63) should be (24, 0, 35843670)
> > ....
> >
> > One head, one cylinder and lots of sectors??
> > I put some debug in drivers/scsi/scsicam.c and it doesn't
> > seem like it was called.
> >
> > Is my fdisk (from RH 7.2) too old?
> 
> No please: Just please don't look at ide-scsi in 2.5.21
> without applying IDE  patch number 86.

$ cat /proc/scsi/scsi 
Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SEAGATE  Model: ST318451LW       Rev: 0003
  Type:   Direct-Access                    ANSI SCSI revision: 03

This disk i(/dev/sda) is an Ultra 160 (SPI) connected to 
a Tekram DC-309U3W controller.

The reported problem occurs with all disks seen by the scsi
subsystem in lk 2.5.21 that I have tested including usb mass
storage and ieee1394 sbp2. I am not aware of any ATA disks
that support ATAPI and hence could be used with ide-scsi
driver (if it didn't crash in 2.5.21).

My guess is that there is a problem in the block (or genhd)
subsystem.

Doug Gilbert
