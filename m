From: Michael Ulbrich <mul@rentapacs.de>
Subject: qlogic and FC to SCSI bridge
Date: Sat, 28 Sep 2002 00:27:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D94DB64.C230016@rentapacs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I'm trying to use a Compaq Fibre Channel Tape Controller II as a FC to
SCSI bridge assuming that it provides general SCSI bridging
functionality and is not limited (as the name might imply) to SCSI
tape devices. The FCTC has two wide differential SCSI busses. For
testing purposes I connected one harddisk to one of the busses.

The host bus adapter is a qlogic 2100 in a linux box running RH 7.3 with
the Qlogic driver qla2xxx updated to version 6.1b5 - to my knowledge the
latest version from qlogic.

During boot the qla ROM BIOS detects the device connected to the FCTC:

> QLogic Corporation
> QLA2000,QLA2100 PCI Fibre Channel ROM BIOS Version 1.37
> ...
>
> Press <ALT-Q> for Fast!UTIL
>
> ISP2000/2100 Firmware Version 1.15.37
> QLogic Adapter isung IRQ number 10
>
> Device Device Adapter Loop Loop Vendor    Product    Product
> Number Type   Number   ID  LUN    ID        ID       Revision
>  82   Disk     0      125  7    Quantum   XP34361WD  HP10

Booting with qla2100.o version 6.1b5 gives the following result:

> kernel: qla2x00_set_info starts at address = e082e060
> kernel: PCI: Found IRQ 10 for device 01:02.0
> kernel: qla2x00: Found  VID=1077 DID=2100 SSVID=1077 SSDID=1
> kernel: scsi0: Found a QLA2100  @ bus 1, device 0x2, irq 10, iobase 0xb800
> kernel: scsi(0): Allocated 4096 SRB(s)
> kernel: scsi(0): Configure NVRAM parameters...
> kernel: scsi(0): 64 Bit PCI Addressing Enabled
> kernel: scsi(0): Verifying loaded RISC code...
> kernel: scsi(0): Verifying chip...
> kernel: scsi(0): LIP reset occurred
> kernel: scsi(0): Waiting for LIP to complete...
> kernel: scsi(0): LIP occurred.
> kernel: scsi(0): LOOP UP detected
> kernel: scsi0: Topology - (Loop), Host Loop address 0x0
> kernel: scsi0 : QLogic QLA2100 PCI to Fibre Channel Host Adapter: bus 1 device 2 irq 10
> kernel:         Firmware version:  1.19.24, Driver version 6.1b5

Using the qlogic driver (ver. 5.31.RH1) from the RH 7.3 distribution
results in (this module lists as scsi(3) since it's loaded into the
running system after scsi(0) has been removed, scsi(1,2) are two onboard
HAs driven by sym53c8xx):

> kernel: PCI: Found IRQ 10 for device 01:02.0
> kernel: qla2x00: Found  VID=1077 DID=2100 SSVID=1077 SSDID=1
> kernel: scsi3: Found a QLA2100  @ bus 1, device 0x2, irq 10, iobase 0xb800
> kernel: scsi(3): Configure NVRAM parameters...
> kernel: qla2x00: 64 Bit PCI Addressing Enabled
> kernel: scsi(3): Verifying loaded RISC code...
> kernel: scsi(3): Verifying chip...
> kernel: scsi(3): LIP reset occurred
> kernel: scsi(3): Waiting for LIP to complete...
> kernel: scsi(3): LIP occurred.
> kernel: scsi(3): LOOP UP detected
> kernel: scsi3: Topology - (Loop), Host Loop address  0x0
> kernel: scsi-qla00-adapter-port=210000e08b0073ca\;
> kernel: scsi-qla00-tgt-000-di-00-node=100000e00201a2df\;
> kernel: scsi-qla00-tgt-000-di-00-port=100000e00201a2df\;
> kernel: scsi-qla00-tgt-000-di-00-control=00\;
> kernel: scsi-qla00-tgt-000-di-00-preferred=ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\;
> kernel: scsi3 : QLogic QLA2100 PCI to Fibre Channel Host Adapter: bus 1 device 2 irq 10
> kernel:         Firmware version:  1.19.16, Driver version 5.31.RH1

In both cases the device attached to the SCSI bridge is not recognized
by the qlogic driver. The older driver gives obviously some additional
(debugging?) output. The kernel is configured with
CONFIG_SCSI_MULTI_LUN=y.

Maybe someone on this list knows what I'm doing wrong or can give some
hints in which direction to proceed. Any ideas that might help are
greatly appreciated.

TIA ... Michael
