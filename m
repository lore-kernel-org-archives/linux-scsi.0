From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: scsi "target1:0:0"
Date: Tue, 16 Nov 2004 17:55:53 +0100
Message-ID: <1100624154.8606.122.camel@localhost.localdomain>
References: <1100622096.8606.104.camel@localhost.localdomain>
	 <1100622800.2574.41.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from soundwarez.org ([217.160.171.123]:35023 "EHLO soundwarez.org")
	by vger.kernel.org with ESMTP id S262027AbUKPQzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 11:55:36 -0500
In-Reply-To: <1100622800.2574.41.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-11-16 at 10:33 -0600, James Bottomley wrote:
> On Tue, 2004-11-16 at 10:21, Kay Sievers wrote:
> > We got an additional directory in the /devices directory which
> > changed:
> >   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host1/1:0:0:0
> > 
> > to:
> >   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host1/target1:0:0/1:0:0:0
> > 
> > The inserted "target1:0:0" is _not_ backed by any "bus" or "class" device
> > and therefore breaks the logic of HAL to bring the devices together by
> > its parent. (We also don't get hotplug events for the "target*" device at
> > creation time)
> 
> Could you explain what specific problem this causes.  You do get a
> hotplug for the LUNs; a target is simply an additional node in the tree.

We sit there with the hald daemon and listen to sysfs add/remove events.
We need an event for every /sys/devices/ devices to get a unbroken chain
of devices we can sort together until we reach a root device. This is
how _all_ devices in sysfs are working and scsi was before the change.

> > Is this intentional and we can not expected a straight chain of devices
> > anymore like it always was? Shouldn't there be a "class" device to have
> > it consistent again.
> 
> Essentially yes. a target is simply a LUN container.  It has no real
> existence (it's created when the first lun is encountered and destroyed
> when the last LUN is removed).  It's job is really to hold parameters
> that apply to all LUNs.

Yes, that is fine. But if you don't want to add "class" support for
"target*" they should have at least a "bus" associated to emit hotplug
events on creation time. Here is what udevinfo prints. There should be
no device in the middle of a chain without a "bus" I think:

device '/sys/block/sda/sda1':
    SYSFS{dev}="8:1"

device chain '/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host2/target2:0:0/2:0:0:0':
    BUS="scsi"
    ID="2:0:0:0"

device chain '/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host2/target2:0:0':
    BUS=""
    ID="target2:0:0"

device chain '/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host2':
    BUS=""
    ID="host2"

device chain '/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0':
    BUS="usb"
    ID="3-1:1.0"

device chain '/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1':
    BUS="usb"
    ID="3-1"

device chain '/sys/devices/pci0000:00/0000:00:1d.1/usb3':
    BUS="usb"
    ID="usb3"

device chain '/sys/devices/pci0000:00/0000:00:1d.1':
    BUS="pci"
    ID="0000:00:1d.1"

device chain '/sys/devices/pci0000:00':
    BUS=""
    ID="pci0000:00"
    SYSFS{detach_state}="0"

Thanks,
Kay


