From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi sysfs update (upper 2/3)
Date: Thu, 7 Nov 2002 20:13:11 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108041311.GE1292@beaverton.ibm.com>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107182947.B15350@sgi.com> <20021107164152.GD1292@beaverton.ibm.com> <20021108012047.A17391@infradead.org> <20021108022158.GD1292@beaverton.ibm.com> <3DCB30BC.7040703@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DCB30BC.7040703@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> Mike,
> I have put scsi_debug's parameters under /bus/scsi/drivers
> and scsi_debug obviously isn't an upper layer driver. Also
> I would be tempted to put mid level parameters there (if
> there were any). Where else should driver parameters be
> placed for drivers that have no association with any
> other bus?
> 

Putting driver related attributes under your driver is not wrong.  In
the patch I sent out I created an artifical bus for scsi_debug. The bus
looks similar to a PCI bus. It needs some extensions to allow for
adding multiple adapters. This allows scsi_debug to more accurately
simulate a pci or other bus adapter. It is also registering as a
scsi-host class of drivers.

I have attached an out of an example tree below. I cut a lot of devices
to make it fit, but you should still be able to see the layout.


> There is also the conundrum of driver parameters for
> something like advansys that has one host on ISA, another
> on PCMCIA and a third on PCI (unlikely but possible).

This might be a better question for Patrick Mochel, but I believe there
is nothing that would prevent the driver from registering multiple
driver objects on each of the associated buses.

-andmike
--
Michael Anderson
andmike@us.ibm.com

.
|-- bus
|   |-- pci
|   |   |-- devices
|   |   |   |-- 01:03.0 -> ../../../devices/pci1/01:03.0
|   |   |   |-- 01:03.1 -> ../../../devices/pci1/01:03.1
|   |   `-- drivers
|   |       |-- aic7xxx
|   |       |   |-- 01:03.0 -> ../../../../devices/pci1/01:03.0
|   |       |   `-- 01:03.1 -> ../../../../devices/pci1/01:03.1
|   |-- scsi
|   |   |-- devices
|   |   |   |-- 3:0:0:0 -> ../../../devices/pci1/01:03.1/3:0:0:0
|   |   |   |-- 3:0:0:0:gen -> ../../../devices/pci1/01:03.1/3:0:0:0/3:0:0:0:gen
|   |   |   |-- 3:0:4:0 -> ../../../devices/pci1/01:03.1/3:0:4:0
|   |   |   |-- 3:0:4:0:gen -> ../../../devices/pci1/01:03.1/3:0:4:0/3:0:4:0:gen
|   |   |   |-- 4:0:0:0 -> ../../../devices/scsi_dbg_fake/02:05.0/4:0:0:0
|   |   |   |-- 4:0:0:0:gen -> ../../../devices/scsi_dbg_fake/02:05.0/4:0:0:0/4:0:0:0:gen
|   |   `-- drivers
|   |       |-- sd
|   |       |   |-- 3:0:0:0 -> ../../../../devices/pci1/01:03.1/3:0:0:0
|   |       |   |-- 3:0:4:0 -> ../../../../devices/pci1/01:03.1/3:0:4:0
|   |       |   |-- 3:0:5:0 -> ../../../../devices/pci1/01:03.1/3:0:5:0
|   |       |   |-- 4:0:0:0 -> ../../../../devices/scsi_dbg_fake/02:05.0/4:0:0:0
|   |       |-- sg
|   |       |   |-- 3:0:0:0:gen -> ../../../../devices/pci1/01:03.1/3:0:0:0/3:0:0:0:gen
|   |       |   |-- 3:0:4:0:gen -> ../../../../devices/pci1/01:03.1/3:0:4:0/3:0:4:0:gen
|   |       |   |-- 4:0:0:0:gen -> ../../../../devices/scsi_dbg_fake/02:05.0/4:0:0:0/4:0:0:0:gen
|   |-- scsi_dbg_fake
|   |   |-- devices
|   |   |   `-- 02:05.0 -> ../../../devices/scsi_dbg_fake/02:05.0
|   |   `-- drivers
|   |       `-- scsi_debug
|   |           `-- 02:05.0 -> ../../../../devices/scsi_dbg_fake/02:05.0
|-- class
|   `-- scsi-host
|       |-- devices
|       |   `-- 0 -> ../../../devices/scsi_dbg_fake/02:05.0
|       `-- drivers
|-- devices
|   |-- scsi_dbg_fake
|   |   `-- 02:05.0
|   |       `-- 4:0:0:0
|   |           |-- 4:0:0:0:gen
|   |           `-- block -> ../../../../block/sdd

