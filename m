From: Wolfgang Schnitker <wolfgang.schnitker@gmx.de>
Subject: mvsas driver missing PCI-IDs on ASUS Mobo
Date: Sun, 23 Jul 2017 19:17:25 +0200
Message-ID: <e6820f95-4757-3079-32a2-0c29f1f52924@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Resent-Message-ID: <kddsG8tioBI.A.sBH.3oNdZB@bendel>
List-URL: <https://lists.debian.org/debian-kernel/>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Archive: https://lists.debian.org/msgid-search/e6820f95-4757-3079-32a2-0c29f1f52924@gmx.de
To: taggart@debian.org, debian-kernel@lists.debian.org, linux-scsi@vger.kernel.org, ben@decadent.org.uk
List-Id: linux-scsi@vger.kernel.org

Dear SCSI Linux developers,

I have a machine with ASUS ([    0.000000] DMI: System manufacturer
System Product Name/P7H55-M/USB3, BIOS 1105    04/25/2011)

with a marvell SCSI chipset.

I am running Debian stretch amd64  (Linux winni2 4.9.0-3-amd64 #1 SMP
Debian 4.9.30-2+deb9u2 (2017-06-26) x86_64 GNU/Linux)


You can run Marvell  in IDE Mode, then the chipset will be reported as
an IDE Controller. PCI Id 1043:83ba / 1b4b:91a0

lspci -nnv -s 04:00.0
04:00.0 IDE interface [0101]: Marvell Technology Group Ltd. 88SE912x
SATA 6Gb/s Controller [IDE mode] [1b4b:91a0] (rev 12) (prog-if 8f
[Master SecP SecO PriP PriO])
    Subsystem: ASUSTeK Computer Inc. 88SE912x SATA 6Gb/s Controller [IDE
mode] [1043:83ba]
    Flags: bus master, fast devsel, latency 0, IRQ 32
    I/O ports at ec00 [size=8]
    I/O ports at e880 [size=4]
    I/O ports at e800 [size=8]
    I/O ports at e480 [size=4]
    I/O ports at e400 [size=16]
    Memory at f7fff000 (32-bit, non-prefetchable) [size=2K]
    Expansion ROM at f7fe0000 [disabled] [size=64K]
    Capabilities: [40] Power Management version 3
    Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit-
    Capabilities: [70] Express Legacy Endpoint, MSI 00
    Capabilities: [100] Advanced Error Reporting
    Kernel driver in use: ahci
    Kernel modules: ahci, pata_marvell, ata_generic

You can run it as an AHCI device  PCI Id 1b4b:9120 and 1043:83ba

lspci -nnv -s 04:00.0
04:00.0 SATA controller [0106]: Marvell Technology Group Ltd. 88SE9120
SATA 6Gb/s Controller [1b4b:9120] (rev 12) (prog-if 01 [AHCI 1.0])
    Subsystem: ASUSTeK Computer Inc. 88SE9120 SATA 6Gb/s Controller
[1043:83ba]
    Flags: bus master, fast devsel, latency 0, IRQ 32
    I/O ports at ec00 [size=8]
    I/O ports at e880 [size=4]
    I/O ports at e800 [size=8]
    I/O ports at e480 [size=4]
    I/O ports at e400 [size=16]
    Memory at f7fff000 (32-bit, non-prefetchable) [size=2K]
    Expansion ROM at f7fe0000 [disabled] [size=64K]
    Capabilities: [40] Power Management version 3
    Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit-
    Capabilities: [70] Express Legacy Endpoint, MSI 00
    Capabilities: [100] Advanced Error Reporting
    Kernel driver in use: ahci
    Kernel modules: ahci

>From my point of view at least the AHCI mode should be driven by the
mvsas driver.

Please add it to the marvell list of devices.

Thanks.
