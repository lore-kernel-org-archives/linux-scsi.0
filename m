From: Willem Riede <wrlk@riede.org>
Subject: Re: devices with more than one node
Date: Sun, 18 Jan 2004 17:08:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040118220802.GA25501@linnie.riede.org>
References: <20040113193842.GA29887@suse.de> <20040113194631.GA3818@kroah.com> <20040113211122.GA28100@suse.de> <20040113212058.GA2595@kroah.com> <20040113150147.A9902@beaverton.ibm.com> <20040113231813.GA7409@kroah.com> <1074042776.4004979822819@wwws.torque.net> <20040114030847.GG4339@linnie.riede.org> <4006499A.4070302@torque.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:467 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S264238AbUARWIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 17:08:04 -0500
Content-Disposition: inline
In-Reply-To: <4006499A.4070302@torque.net> (from dougg@torque.net on Thu, Jan 15, 2004 at 03:04:42 -0500)
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi

On 2004.01.15 03:04, Douglas Gilbert wrote:
> 
> To test it I modded scsi_debug to fake OnStream tape
> drives and ran a 2.6.1-mm2 kernel. The attached
> output of "cd /sys/class; tree scsi* osst" is instructive.
> Two peculiar entries are:
>      scsi_generic/sg0/driver -> ../../../bus/scsi/drivers/osst
>      scsi_generic/sg1/driver -> ../../../bus/scsi/drivers/osst
> 
> This symlink only appears if the osst driver is loaded
> _before_ the sg driver! It is also left dangling by
> "rmmod osst". 

I see the same with real OnStream tape drives.
It appears that when an upper level driver like osst is
(un)loaded, your (sg) attach doesn't get a chance to
reconsider...

By the way, I notice that st produces links in scsi_device
that osst doesn't - 0:0:3:0 and 3:0:0:0 are OnStream drives:

scsi_device
|-- 0:0:3:0
|   `-- device -> ../../../devices/pci0000:00/0000:00:0e.0/host0/0:0:3:0
|-- 0:0:6:0
|   `-- device -> ../../../devices/pci0000:00/0000:00:0e.0/host0/0:0:6:0
|-- 1:0:0:0
|   |-- device -> ../../../devices/pci0000:00/0000:00:0e.1/host1/1:0:0:0
|   `-- driver -> ../../../bus/scsi/drivers/sd
|-- 1:0:1:0
|   |-- device -> ../../../devices/pci0000:00/0000:00:0e.1/host1/1:0:1:0
|   `-- driver -> ../../../bus/scsi/drivers/sd
|-- 2:0:0:0
|   |-- device -> ../../../devices/pci0000:00/0000:00:07.1/ide0/0.1/host2/2:0:0:0
|   `-- driver -> ../../../bus/scsi/drivers/st
|-- 3:0:0:0
|   `-- device -> ../../../devices/pci0000:00/0000:00:07.1/ide1/1.0/host3/3:0:0:0
`-- 4:0:0:0
    |-- device -> ../../../devices/pci0000:00/0000:00:07.1/ide1/1.1/host4/4:0:0:0
    `-- driver -> ../../../bus/scsi/drivers/st

Should I emulate what st does to create these entries?

Thanks, Willem Riede.

