From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sat, 17 May 2003 12:59:59 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.52.0305171248460.4436@kai.makisara.local>
References: <20030516182039.A7369@lst.de> <20030516235718.GA3260@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:28669 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261326AbTEQJrS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 05:47:18 -0400
In-Reply-To: <20030516235718.GA3260@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Fri, 16 May 2003, Mike Anderson wrote:

> Christoph Hellwig [hch@lst.de] wrote:
> > Upper drivers now use the LDM ->probe/->remove callbacks and the
...
> I ran your patch and I dead locked on st_probe. This is due to the code
> in st_probe and osst_probe that do device registers on the
> sdev_driverfs_dev.bus which is the bus that the probe is being called
> from already. I had an old patch that removed these before due the driver
> model requirement that objects on the device list must be of one type.
> At the time I did not have a place to move these attributes.
>
> We now have /bus/scsi/drivers/{uld} for driver attributes. We also could
> create a class for other attributes if needed. We can also use udev for
> the creation of special nodes.
>
> ftp://ftp.kernel.org/pub/linux/utils/kernel/hotplug/
>
> In the short term is the st and osst maintainers are ok with it we could
> remove them and then create them in there proper home.
>
I don't mind removal of the mt* files. I tested in 2.5.69-bk11 a
modification to st that was essentially what Christoph has just
posted. No problems there (i.e., tape found and works ok, sysfs shows
the tape as SCSI device).

However, when I add to this Christoph's patch to change probing, I don't
find any tapes any more. What I did was to first modprobe aic7xxx.
According to dmesg, the device was found:

(scsi2:A:5): 10.000MB/s transfers (10.000MHz, offset 8)
  Vendor: HP        Model: C1533A            Rev: 9608
  Type:   Sequential-Access                  ANSI SCSI revision: 02
Attached scsi generic sg0 at scsi2, channel 0, id 5, lun 0,  type 1

It did not appear in /sysfs/bus/scsi/devices (the system disk and the
cdrom were there):

# tree /sysfs/bus/scsi/devices/
/sysfs/bus/scsi/devices/
|-- 0:0:0:0 -> ../../../devices/pci0/00:1e.0/02:02.0/host0/0:0:0:0
`-- 1:0:0:0 -> ../../../devices/ide-scsi/host1/1:0:0:0

Modprobing st did not result in any messages (each attached tape causes
one line to be printed). The tape device does not exist:

# mt status
/dev/nst0: No such device or address

-- 
Kai

