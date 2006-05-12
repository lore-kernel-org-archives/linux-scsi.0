From: Andrew Morton <akpm@osdl.org>
Subject: git-acpi breakage, sym2
Date: Thu, 11 May 2006 23:10:05 -0700
Message-ID: <20060511231005.0bce3384.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, "Brown, Len" <len.brown@intel.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <willy@debian.org>
List-Id: linux-scsi@vger.kernel.org


The latest
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git#test
kills my very vanilla P4 box.

Without:

Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 15 devices
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:02: ioport range 0x400-0x47f could not be reserved
pnp: 00:02: ioport range 0x500-0x53f has been reserved
pnp: 00:02: ioport range 0x800-0x87f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: fc900000-fe9fffff
  PREFETCH window: e4500000-f46fffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: fea00000-feafffff
  PREFETCH window: f4700000-f47fffff


With:

Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00f2500
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x1e2a, dseg 0xf0000
PnPBIOS: 18 nodes reported by PnP BIOS; 18 recorded by driver
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2440] at 0000:00:1f.0
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 1!
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 2!
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 2!
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 2!
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 2!
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 2!
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 2!
PCI BIOS passed nonexistent PCI bus 0!
PCI BIOS passed nonexistent PCI bus 2!
PCI BIOS passed nonexistent PCI bus 0!
pnp: 00:09: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:09: ioport range 0xcf8-0xcff has been reserved
pnp: 00:0b: ioport range 0x800-0x87f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: fc900000-fe9fffff
  PREFETCH window: e4500000-f46fffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: fea00000-feafffff
  PREFETCH window: f4700000-f47fffff
NET: Registered protocol family 2


So I'll temporarily drop that patch, along with the enormous shower of
still-unmerged other acpi patches which are probably dependent upon it.  A
swift fix would be really appreciated...



The above bug appears to trigger a scsi or sym2 bug.  With git-acpi.patch
present I get

sym0: <895> rev 0x2 at pci 0000:02:0c.0 irq 9
sym0: Symbios NVRAM, ID 7, Fast-40, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
 target0:0:0: Multiple LUNs disabled in NVRAM
 0:0:0:0: ABORT operation started.
 0:0:0:0: ABORT operation timed-out.
 0:0:0:0: DEVICE RESET operation started.
 0:0:0:0: DEVICE RESET operation timed-out.
 0:0:0:0: BUS RESET operation started.
 0:0:0:0: BUS RESET operation timed-out.
 0:0:0:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:0:0: HOST RESET operation timed-out.
 0:0:0:0: scsi: Device offlined - not ready after error recovery
 0:0:1:0: ABORT operation started.
 0:0:1:0: ABORT operation timed-out.
 0:0:1:0: DEVICE RESET operation started.
 0:0:1:0: DEVICE RESET operation timed-out.
 0:0:1:0: BUS RESET operation started.
 0:0:1:0: BUS RESET operation timed-out.
 0:0:1:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:1:0: HOST RESET operation timed-out.
 0:0:1:0: scsi: Device offlined - not ready after error recovery
 0:0:2:0: ABORT operation started.
 0:0:2:0: ABORT operation timed-out.
 0:0:2:0: DEVICE RESET operation started.
 0:0:2:0: DEVICE RESET operation timed-out.
 0:0:2:0: BUS RESET operation started.
 0:0:2:0: BUS RESET operation timed-out.
 0:0:2:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.

ad infinitum.  How come?
