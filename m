From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: BUG 2.6.24-rc3-mm2 -- Hang in mpt driver [?] with async scsi scan
Date: Fri, 30 Nov 2007 16:11:38 -0500
Message-ID: <1196457099.5316.32.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:4969 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXK3VTl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Nov 2007 16:19:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@steeleye.com, Eric.Moore@lsil.com

I'm seeing a hang on my HP ia64 NUMA platform with the subject kernel.
I think it's in the mpt driver--only because I see the message "mptspi:
ioc#: mpt_config failed" when it hangs.  The system actually did come up
once with async scan enabled--I think.  Possibly, I booted a kernel w/o
async scan, but I don't think so.  I have several [pieces of] console
logs below and an excerpt from the .config showing the generic driver
and scsi config.  I've tried to minimize the extraneous info to keep
this message as small as possible.  Still, it's pretty large. 

"files attached":
1) excerpt from .config
2) Common head of console boot log.  ~ same for boot that succeeded and
one that hung.  
3) tail of console boot log for successful boot -- you can see all of
the scsi buses/devices [platform has a lot of internal scsi buses w/
nothing attached].
4) tail of console boot log for hang.
5) what I could capture of console log with mpt debug output enabled.

Let me know if you need more info or would like me to test something.

Lee

1) .config excerpt
#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
CONFIG_IDE=y
CONFIG_IDE_MAX_HWIFS=4
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEFLOPPY=y
CONFIG_BLK_DEV_IDESCSI=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=m
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SGIIOC4=y
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SRP=m
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=m
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y


------------------------------------------------
2) common "head" of console logs
Linux version 2.6.24-rc3-mm2+kame-mc-fix+async (lts@gwydyr.zko.hp.com) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-52)) #18 SMP Fri Nov 30 10:32:44 EST 2007
EFI v1.10 by HP: SALsystab=0x701fce5a970 ACPI 2.0=0x701fd250000 HCDP=0x701fd276070 SMBIOS=0x1fffe000
booting generic kernel on platform hpzx1
PCDP: v3 at 0x701fd276070
Early serial console at MMIO 0xf0000018000 (options '9600n8')
console [uart8250] enabled
ACPI: RSDP 701FD250000, 0024 (r2     HP)
ACPI: XSDT 701FD2761B8, 008C (r1     HP   rx8620        0   HP        0)
ACPI: FACP 701FD275C38, 00F4 (r3     HP   rx8620        0   HP        0)
ACPI: DSDT 701FD2503F0, 257F5 (r2     HP  CELL000        0   HP        0)
ACPI: FACS 701FD250028, 0040
ACPI: SPCR 701FD250068, 0050 (r1     HP   rx8620        0   HP        0)
ACPI: DBGP 701FD2500B8, 0034 (r1     HP   rx8620        0   HP        0)
ACPI: APIC 701FD2501A0, 024C (r1     HP   rx8620        0   HP        0)
ACPI: SLIT 701FD275D30, 0045 (r1     HP   rx8620        0   HP        0)
ACPI: CPEP 701FD275D78, 00AC (r1     HP   rx8620        0   HP        0)
ACPI: SRAT 701FD275E28, 0248 (r1     HP   rx8620        0   HP        0)
ACPI: SPMI 701FD275BE8, 0050 (r4     HP   rx8620        0   HP        0)
ACPI: OEMD 701FD250128, 0074 (r1     HP   rx8620        0   HP        0)
ACPI: HPET 701FD2500F0, 0038 (r1     HP   rx8620        0   HP        0)
ACPI: SSDT 701FD2762B0, 249E6 (r2     HP  CELL001        0   HP        0)
ACPI: SSDT 701FD29AC98, 2AE0 (r2     HP  CELL002        0   HP        0)
ACPI: SSDT 701FD29D778, 2AE0 (r2     HP  CELL003        0   HP        0)
Number of logical nodes in system = 5
Number of memory chunks in system = 7
warning: skipping physical page 0
warning: skipping physical page 0
Entering add_active_range(4, 0, 32767) 0 entries of 12800 used
Entering add_active_range(0, 469794816, 470281216) 1 entries of 12800 used
Entering add_active_range(1, 478150656, 478196943) 2 entries of 12800 used
Entering add_active_range(1, 478196944, 478670848) 3 entries of 12800 used
Entering add_active_range(2, 486539264, 487059456) 4 entries of 12800 used
Entering add_active_range(3, 494927872, 495447893) 5 entries of 12800 used
Entering add_active_range(3, 495447920, 495447952) 6 entries of 12800 used
Entering add_active_range(3, 495447968, 495448054) 7 entries of 12800 used
warning: skipping physical page 0
Initial ramdisk at: 0xe0000761fad55000 (2280473 bytes)
SAL 3.20: HP Orca/IPF version 6.44
SAL Platform features: None
SAL: AP wakeup using external interrupt vector 0xff
ACPI: Local APIC address C0000000FEE00000
GSI 16 (level, low) -> CPU 0 (0x0000) vector 48
16 CPUs available, 16 CPUs total
MCA related initialization done
warning: skipping physical page 0
sizeof(struct page) = 64
Zone PFN ranges:
  DMA             0 ->   262144
  Normal     262144 -> 495448064
Movable zone start PFN for each node
early_node_map[8] active PFN ranges
    4:        0 ->    32767
    0: 469794816 -> 470281216
    1: 478150656 -> 478196943
    1: 478196944 -> 478670848
    2: 486539264 -> 487059456
    3: 494927872 -> 495447893
    3: 495447920 -> 495447952
    3: 495447968 -> 495448054
On node 0 totalpages: 486400
  DMA zone: 0 pages used for memmap
  Normal zone: 1900 pages used for memmap
  Normal zone: 484500 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
On node 1 totalpages: 520191
  DMA zone: 0 pages used for memmap
  Normal zone: 2032 pages used for memmap
  Normal zone: 518159 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
On node 2 totalpages: 520192
  DMA zone: 0 pages used for memmap
  Normal zone: 2032 pages used for memmap
  Normal zone: 518160 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
On node 3 totalpages: 520139
  DMA zone: 0 pages used for memmap
  Normal zone: 2031 pages used for memmap
  Normal zone: 518108 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
On node 4 totalpages: 32767
  DMA zone: 127 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 32640 pages, LIFO batch:7
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
SMP: Allowing 16 CPUs, 0 hotplug CPUs
Built 5 zonelists in Zone order, mobility grouping on.  Total pages: 2071567
Policy zone: Normal
Kernel command line: BOOT_IMAGE=scsi3:\EFI\redhat\vmlinuz-2.6.24-rc3-mm2+kame-mc-fix+async  debug root=LABEL=RHEL5GA1 ro
PID hash table entries: 4096 (order: 12, 32768 bytes)
CPU 0: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
Console: colour dummy device 80x25
Memory: 33114752k/33261040k available (7023k code, 160272k reserved, 3136k data, 688k init)
SLUB: Unable to allocate memory from node 4
SLUB: Allocating a useless per node structure in order to be able to continue
SLUB: Genslabs=14, HWalign=128, Order=0-2, MinObjects=8, CPUs=16, Nodes=256
Calibrating delay loop... 2244.60 BogoMIPS (lpj=1122304)
Dentry cache hash table entries: 4194304 (order: 11, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 10, 16777216 bytes)
Mount-cache hash table entries: 1024
Initializing cgroup subsys memory
sizeof(mem_cgroup)=10368 bytes
sizeof(page_cgroup)=40 bytes
ACPI: Core revision 20070126
Boot processor id 0x0/0x0
Fixed BSP b0 value from CPU 1
CPU 1: synchronized ITC with CPU 0 (last diff 1 cycles, maxerr 535 cycles)
CPU 1: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 2: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 1889 cycles)
CPU 2: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 3: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 1889 cycles)
CPU 3: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 4: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 2623 cycles)
CPU 4: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 5: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 2623 cycles)
CPU 5: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 6: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 2623 cycles)
CPU 6: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 7: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 2623 cycles)
CPU 7: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 8: synchronized ITC with CPU 0 (last diff 4 cycles, maxerr 2623 cycles)
CPU 8: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 9: synchronized ITC with CPU 0 (last diff 3 cycles, maxerr 2626 cycles)
CPU 9: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 10: synchronized ITC with CPU 0 (last diff 3 cycles, maxerr 2626 cycles)
CPU 10: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 11: synchronized ITC with CPU 0 (last diff 3 cycles, maxerr 2626 cycles)
CPU 11: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 12: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 2624 cycles)
CPU 12: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 13: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 2624 cycles)
CPU 13: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 14: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 2624 cycles)
CPU 14: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
CPU 15: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 2624 cycles)
CPU 15: base freq=200.000MHz, ITC ratio=15/2, ITC freq=1500.000MHz+/-375ppm
Brought up 16 CPUs
Total of 16 processors activated (35913.72 BogoMIPS).
sizeof(task)=3200 bytes
sizeof(mm)=752 bytes
sizeof(vma)=176 bytes
sizeof(anon_vma)=24 bytes
sizeof(page)=64 bytes
sizeof(inode)=552 bytes
sizeof(nodemask)=32 bytes
sizeof(mempolicy)=72 bytes
sizeof(zone)=2560 bytes
sizeof(zonelist)=7800 bytes
sizeof(pg_data_t)=54656 bytes
CPU0 attaching sched-domain:
 domain 0: span 00000000,0000000f
  groups: 00000000,00000001 00000000,00000002 00000000,00000004 00000000,00000008
  domain 1: span 00000000,0000ffff
   groups: 00000000,0000000f 00000000,000000f0 00000000,00000f00 00000000,0000f000
CPU1 attaching sched-domain:
 domain 0: span 00000000,0000000f
  groups: 00000000,00000002 00000000,00000004 00000000,00000008 00000000,00000001
  domain 1: span 00000000,0000ffff
   groups: 00000000,0000000f 00000000,000000f0 00000000,00000f00 00000000,0000f000
CPU2 attaching sched-domain:
 domain 0: span 00000000,0000000f
  groups: 00000000,00000004 00000000,00000008 00000000,00000001 00000000,00000002
  domain 1: span 00000000,0000ffff
   groups: 00000000,0000000f 00000000,000000f0 00000000,00000f00 00000000,0000f000
CPU3 attaching sched-domain:
 domain 0: span 00000000,0000000f
  groups: 00000000,00000008 00000000,00000001 00000000,00000002 00000000,00000004
  domain 1: span 00000000,0000ffff
   groups: 00000000,0000000f 00000000,000000f0 00000000,00000f00 00000000,0000f000
CPU4 attaching sched-domain:
 domain 0: span 00000000,000000f0
  groups: 00000000,00000010 00000000,00000020 00000000,00000040 00000000,00000080
  domain 1: span 00000000,0000ffff
   groups: 00000000,000000f0 00000000,00000f00 00000000,0000f000 00000000,0000000f
CPU5 attaching sched-domain:
 domain 0: span 00000000,000000f0
  groups: 00000000,00000020 00000000,00000040 00000000,00000080 00000000,00000010
  domain 1: span 00000000,0000ffff
   groups: 00000000,000000f0 00000000,00000f00 00000000,0000f000 00000000,0000000f
CPU6 attaching sched-domain:
 domain 0: span 00000000,000000f0
  groups: 00000000,00000040 00000000,00000080 00000000,00000010 00000000,00000020
  domain 1: span 00000000,0000ffff
   groups: 00000000,000000f0 00000000,00000f00 00000000,0000f000 00000000,0000000f
CPU7 attaching sched-domain:
 domain 0: span 00000000,000000f0
  groups: 00000000,00000080 00000000,00000010 00000000,00000020 00000000,00000040
  domain 1: span 00000000,0000ffff
   groups: 00000000,000000f0 00000000,00000f00 00000000,0000f000 00000000,0000000f
CPU8 attaching sched-domain:
 domain 0: span 00000000,00000f00
  groups: 00000000,00000100 00000000,00000200 00000000,00000400 00000000,00000800
  domain 1: span 00000000,0000ffff
   groups: 00000000,00000f00 00000000,0000f000 00000000,0000000f 00000000,000000f0
CPU9 attaching sched-domain:
 domain 0: span 00000000,00000f00
  groups: 00000000,00000200 00000000,00000400 00000000,00000800 00000000,00000100
  domain 1: span 00000000,0000ffff
   groups: 00000000,00000f00 00000000,0000f000 00000000,0000000f 00000000,000000f0
CPU10 attaching sched-domain:
 domain 0: span 00000000,00000f00
  groups: 00000000,00000400 00000000,00000800 00000000,00000100 00000000,00000200
  domain 1: span 00000000,0000ffff
   groups: 00000000,00000f00 00000000,0000f000 00000000,0000000f 00000000,000000f0
CPU11 attaching sched-domain:
 domain 0: span 00000000,00000f00
  groups: 00000000,00000800 00000000,00000100 00000000,00000200 00000000,00000400
  domain 1: span 00000000,0000ffff
   groups: 00000000,00000f00 00000000,0000f000 00000000,0000000f 00000000,000000f0
CPU12 attaching sched-domain:
 domain 0: span 00000000,0000f000
  groups: 00000000,00001000 00000000,00002000 00000000,00004000 00000000,00008000
  domain 1: span 00000000,0000ffff
   groups: 00000000,0000f000 00000000,0000000f 00000000,000000f0 00000000,00000f00
CPU13 attaching sched-domain:
 domain 0: span 00000000,0000f000
  groups: 00000000,00002000 00000000,00004000 00000000,00008000 00000000,00001000
  domain 1: span 00000000,0000ffff
   groups: 00000000,0000f000 00000000,0000000f 00000000,000000f0 00000000,00000f00
CPU14 attaching sched-domain:
 domain 0: span 00000000,0000f000
  groups: 00000000,00004000 00000000,00008000 00000000,00001000 00000000,00002000
  domain 1: span 00000000,0000ffff
   groups: 00000000,0000f000 00000000,0000000f 00000000,000000f0 00000000,00000f00
CPU15 attaching sched-domain:
 domain 0: span 00000000,0000f000
  groups: 00000000,00008000 00000000,00001000 00000000,00002000 00000000,00004000
  domain 1: span 00000000,0000ffff
   groups: 00000000,0000f000 00000000,0000000f 00000000,000000f0 00000000,00000f00
net_namespace: 144 bytes
DMI present.
NET: Registered protocol family 16
ACPI: bus type pci registered
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOSAPIC for interrupt routing
ACPI: PCI Root Bridge [L000] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.N000.S000.IOC0.L000._PRT]
ACPI: PCI Root Bridge [L001] (0000:1c)
ACPI: PCI Interrupt Routing Table [\_SB_.N000.S000.IOC0.L001._PRT]
ACPI: PCI Root Bridge [L002] (0000:38)
ACPI: PCI Interrupt Routing Table [\_SB_.N000.S000.IOC0.L002._PRT]
ACPI: PCI Root Bridge [L004] (0000:54)
ACPI: PCI Interrupt Routing Table [\_SB_.N000.S000.IOC0.L004._PRT]
ACPI: PCI Root Bridge [L006] (0000:70)
ACPI: PCI Interrupt Routing Table [\_SB_.N000.S000.IOC0.L006._PRT]
ACPI: PCI Root Bridge [L008] (0000:8c)
ACPI: PCI Interrupt Routing Table [\_SB_.N000.S000.IOC1.L008._PRT]
ACPI: PCI Root Bridge [L010] (0000:a9)
ACPI: PCI Interrupt Routing Table [\_SB_.N000.S000.IOC1.L010._PRT]
ACPI: PCI Root Bridge [L012] (0000:c6)
ACPI: PCI Interrupt Routing Table [\_SB_.N000.S000.IOC1.L012._PRT]
ACPI: PCI Root Bridge [L014] (0000:e3)
ACPI: PCI Interrupt Routing Table [\_SB_.N000.S000.IOC1.L014._PRT]
ACPI: PCI Root Bridge [L000] (0001:00)
ACPI: PCI Interrupt Routing Table [\_SB_.N001.S016.IOC0.L000._PRT]
ACPI: PCI Root Bridge [L001] (0001:1c)
ACPI: PCI Interrupt Routing Table [\_SB_.N001.S016.IOC0.L001._PRT]
ACPI: PCI Root Bridge [L002] (0001:38)
ACPI: PCI Interrupt Routing Table [\_SB_.N001.S016.IOC0.L002._PRT]
ACPI: PCI Root Bridge [L004] (0001:54)
ACPI: PCI Interrupt Routing Table [\_SB_.N001.S016.IOC0.L004._PRT]
ACPI: PCI Root Bridge [L006] (0001:70)
ACPI: PCI Interrupt Routing Table [\_SB_.N001.S016.IOC0.L006._PRT]
ACPI: PCI Root Bridge [L008] (0001:8c)
ACPI: PCI Interrupt Routing Table [\_SB_.N001.S016.IOC1.L008._PRT]
ACPI: PCI Root Bridge [L010] (0001:a9)
ACPI: PCI Interrupt Routing Table [\_SB_.N001.S016.IOC1.L010._PRT]
ACPI: PCI Root Bridge [L012] (0001:c6)
ACPI: PCI Interrupt Routing Table [\_SB_.N001.S016.IOC1.L012._PRT]
ACPI: PCI Root Bridge [L014] (0001:e3)
ACPI: PCI Interrupt Routing Table [\_SB_.N001.S016.IOC1.L014._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
GSI 17 (level, low) -> CPU 1 (0x0400) vector 49
pnp: PnP ACPI: found 42 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
IOC: sx1000 0.1 HPA 0xf8020002000 IOVA space 1024Mb at 0x80000000
IOC: sx1000 0.1 HPA 0xf8020003000 IOVA space 1024Mb at 0x80000000
IOC: sx1000 0.1 HPA 0xf8120002000 IOVA space 1024Mb at 0x80000000
IOC: sx1000 0.1 HPA 0xf8120003000 IOVA space 1024Mb at 0x80000000
Time: itc clocksource has been installed.
NET: Registered protocol family 2
IP route cache hash table entries: 1048576 (order: 9, 8388608 bytes)
TCP established hash table entries: 524288 (order: 9, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 6, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2208kB freed
perfmon: version 2.0 IRQ 238
perfmon: Itanium 2 PMU detected, 16 PMCs, 18 PMDs, 4 counters (47 bits)
PAL Information Facility v0.5
perfmon: added sampling format default_format
perfmon_default_smpl: default_format v2.0 registered
audit: initializing netlink socket (disabled)
audit(1196441413.350:1): initialized
Total HugeTLB memory allocated, 0
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
GSI 18 (edge, low) -> CPU 2 (0x0800) vector 50
GSI 19 (edge, low) -> CPU 3 (0x0c00) vector 51
GSI 20 (edge, low) -> CPU 0 (0x0000) vector 52
hpet0: at MMIO 0xffffc002000, IRQs 50, 51, 52
hpet0: 3 64-bit timers, 250000000 Hz
GSI 122 (edge, low) -> CPU 5 (0x0401) vector 53
GSI 123 (edge, low) -> CPU 6 (0x0801) vector 54
GSI 124 (edge, low) -> CPU 7 (0x0c01) vector 55
hpet1: at MMIO 0xffffc082000, IRQs 53, 54, 55
hpet1: 3 64-bit timers, 250000000 Hz
GSI 226 (edge, low) -> CPU 8 (0x0002) vector 56
GSI 227 (edge, low) -> CPU 9 (0x0402) vector 57
GSI 228 (edge, low) -> CPU 10 (0x0802) vector 58
hpet2: at MMIO 0xffffc102000, IRQs 56, 57, 58
hpet2: 3 64-bit timers, 250000000 Hz
GSI 234 (edge, low) -> CPU 15 (0x0c03) vector 59
GSI 235 (edge, low) -> CPU 12 (0x0003) vector 60
GSI 236 (edge, low) -> CPU 13 (0x0403) vector 61
hpet3: at MMIO 0xffffc182000, IRQs 59, 60, 61
hpet3: 3 64-bit timers, 250000000 Hz
EFI Time Services Driver v0.4
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
GSI 29 (level, low) -> CPU 2 (0x0800) vector 62
ACPI: PCI Interrupt 0000:00:00.0[A] -> GSI 29 (level, low) -> IRQ 62
0000:00:00.0: ttyS0 at MMIO 0xf000001d000 (irq = 62) is a 16550A
ACPI: PCI Interrupt 0000:00:00.1[A] -> GSI 29 (level, low) -> IRQ 62
0000:00:00.1: ttyS1 at MMIO 0xf0000018000 (irq = 62) is a 16550A
console handover: boot [uart8250] -> real [ttyS1]
0000:00:00.1: ttyS2 at MMIO 0xf0000018010 (irq = 62) is a 16550A
0000:00:00.1: ttyS3 at MMIO 0xf0000018038 (irq = 62) is a 16550A
GSI 133 (level, low) -> CPU 7 (0x0c01) vector 63
ACPI: PCI Interrupt 0001:00:00.0[A] -> GSI 133 (level, low) -> IRQ 63
Couldn't register serial port 0001:00:00.0: -28
ACPI: PCI Interrupt 0001:00:00.1[A] -> GSI 133 (level, low) -> IRQ 63
Couldn't register serial port 0001:00:00.1: -28
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
tg3.c:v3.86 (November 9, 2007)
GSI 28 (level, low) -> CPU 0 (0x0000) vector 64
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 28 (level, low) -> IRQ 64
eth0: Tigon3 [partno(A7109-60001) rev 0105 PHY(5701)] (PCI:33MHz:64-bit) 10/100/1000Base-T Ethernet 00:30:6e:4b:2a:44
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[76ff2d0f] dma_mask[64-bit]
GSI 132 (level, low) -> CPU 5 (0x0401) vector 65
ACPI: PCI Interrupt 0001:00:01.0[A] -> GSI 132 (level, low) -> IRQ 65
eth1: Tigon3 [partno(A7109-60001) rev 0105 PHY(5701)] (PCI:33MHz:64-bit) 10/100/1000Base-T Ethernet 00:30:6e:4b:9a:f9
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[0]
eth1: dma_rwctrl[76ff2d0f] dma_mask[64-bit]
console [netcon0] enabled
netconsole: network logging started

--------------------------------------------------
3) tail of successful boot [async scan + scsi log + mpt log configured]
   a reboot of this kernel hanged w/ same "foot print" as in #4 below.

<snip "head">
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ide-floppy driver 0.99.newide
GSI 24 (level, low) -> CPU 2 (0x0800) vector 66
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 24 (level, low) -> IRQ 66
sym0: <1010-66> rev 0x1 at pci 0000:00:02.0 irq 66
sym0: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
GSI 25 (level, low) -> CPU 3 (0x0c00) vector 67
ACPI: PCI Interrupt 0000:00:02.1[B] -> GSI 25 (level, low) -> IRQ 67
sym1: <1010-66> rev 0x1 at pci 0000:00:02.1 irq 67
sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym1: open drain IRQ line driver, using on-chip SRAM
sym1: using LOAD/STORE-based firmware.
sym1: handling phase mismatch from SCRIPTS.
sym1: SCSI BUS has been reset.
scsi1 : sym-2.2.3
GSI 26 (level, low) -> CPU 0 (0x0000) vector 68
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 26 (level, low) -> IRQ 68
sym2: <1010-66> rev 0x1 at pci 0000:00:03.0 irq 68
sym2: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym2: open drain IRQ line driver, using on-chip SRAM
sym2: using LOAD/STORE-based firmware.
sym2: handling phase mismatch from SCRIPTS.
sym2: SCSI BUS has been reset.
scsi2 : sym-2.2.3
GSI 27 (level, low) -> CPU 1 (0x0400) vector 69
ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 27 (level, low) -> IRQ 69
sym3: <1010-66> rev 0x1 at pci 0000:00:03.1 irq 69
sym3: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym3: open drain IRQ line driver, using on-chip SRAM
sym3: using LOAD/STORE-based firmware.
sym3: handling phase mismatch from SCRIPTS.
sym3: SCSI BUS has been reset.
scsi3 : sym-2.2.3
GSI 128 (level, low) -> CPU 6 (0x0801) vector 70
ACPI: PCI Interrupt 0001:00:02.0[A] -> GSI 128 (level, low) -> IRQ 70
sym4: <1010-66> rev 0x1 at pci 0001:00:02.0 irq 70
sym4: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym4: open drain IRQ line driver, using on-chip SRAM
sym4: using LOAD/STORE-based firmware.
sym4: handling phase mismatch from SCRIPTS.
sym4: SCSI BUS has been reset.
scsi4 : sym-2.2.3
GSI 129 (level, low) -> CPU 7 (0x0c01) vector 71
ACPI: PCI Interrupt 0001:00:02.1[B] -> GSI 129 (level, low) -> IRQ 71
sym5: <1010-66> rev 0x1 at pci 0001:00:02.1 irq 71
sym5: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym5: open drain IRQ line driver, using on-chip SRAM
sym5: using LOAD/STORE-based firmware.
sym5: handling phase mismatch from SCRIPTS.
sym5: SCSI BUS has been reset.
scsi5 : sym-2.2.3
GSI 130 (level, low) -> CPU 4 (0x0001) vector 72
ACPI: PCI Interrupt 0001:00:03.0[A] -> GSI 130 (level, low) -> IRQ 72
sym6: <1010-66> rev 0x1 at pci 0001:00:03.0 irq 72
sym6: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym6: open drain IRQ line driver, using on-chip SRAM
sym6: using LOAD/STORE-based firmware.
sym6: handling phase mismatch from SCRIPTS.
sym6: SCSI BUS has been reset.
scsi6 : sym-2.2.3
GSI 131 (level, low) -> CPU 5 (0x0401) vector 73
ACPI: PCI Interrupt 0001:00:03.1[B] -> GSI 131 (level, low) -> IRQ 73
sym7: <1010-66> rev 0x1 at pci 0001:00:03.1 irq 73
sym7: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym7: open drain IRQ line driver, using on-chip SRAM
sym7: using LOAD/STORE-based firmware.
sym7: handling phase mismatch from SCRIPTS.
sym7: SCSI BUS has been reset.
scsi7 : sym-2.2.3
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
GSI 43 (level, low) -> CPU 2 (0x0800) vector 74
ACPI: PCI Interrupt 0000:38:01.0[A] -> GSI 43 (level, low) -> IRQ 74
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
scsi8 : ioc0: LSI53C1030 C0, FwRev=01032341h, Ports=1, MaxQ=255, IRQ=74
GSI 44 (level, low) -> CPU 3 (0x0c00) vector 75
ACPI: PCI Interrupt 0000:38:01.1[B] -> GSI 44 (level, low) -> IRQ 75
mptbase: ioc1: Initiating bringup
ioc1: LSI53C1030 C0: Capabilities={Initiator,Target}
scsi 8:0:0:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:0: Beginning Domain Validation
scsi9 : ioc1: LSI53C1030 C0, FwRev=01032341h, Ports=1, MaxQ=255, IRQ=75
 target8:0:0: Ending Domain Validation
 target8:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 8:0:1:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:1: Beginning Domain Validation
 target8:0:1: Ending Domain Validation
 target8:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 8:0:2:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:2: Beginning Domain Validation
 target8:0:2: Ending Domain Validation
 target8:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 8:0:3:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:3: Beginning Domain Validation
 target8:0:3: Ending Domain Validation
 target8:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 8:0:4:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:4: Beginning Domain Validation
mice: PS/2 mouse device common for all mice
EFI Variables Facility v0.08 2004-May-17
scsi 9:0:0:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:0: Beginning Domain Validation
 target9:0:0: Ending Domain Validation
 target9:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:1:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:1: Beginning Domain Validation
scsi 1:0:2:0: CD-ROM            HP       DVD-ROM 305      1.01 PQ: 0 ANSI: 2
 target1:0:2: Beginning Domain Validation
 target1:0:2: asynchronous
 target1:0:2: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 16)
 target1:0:2: Domain Validation skipping write tests
 target1:0:2: Ending Domain Validation
 target9:0:1: Ending Domain Validation
 target9:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:2:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:2: Beginning Domain Validation
 target9:0:2: Ending Domain Validation
 target9:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:3:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:3: Beginning Domain Validation
 target9:0:3: Ending Domain Validation
 target9:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:4:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:4: Beginning Domain Validation
 target9:0:4: Ending Domain Validation
 target9:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:5:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:5: Beginning Domain Validation
 target9:0:5: Ending Domain Validation
 target9:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:8:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:8: Beginning Domain Validation
 target9:0:8: Ending Domain Validation
 target9:0:8: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
 target8:0:4: Ending Domain Validation
 target8:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 8:0:5:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:5: Beginning Domain Validation
 target8:0:5: Ending Domain Validation
 target8:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 2:0:6:0: Direct-Access     HP 36.4G ST336753LC       HPC3 PQ: 0 ANSI: 3
 target2:0:6: tagged command queuing enabled, command queue depth 16.
 target2:0:6: Beginning Domain Validation
 target2:0:6: asynchronous
 target2:0:6: wide asynchronous
 target2:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
 target2:0:6: Domain Validation skipping write tests
 target2:0:6: Ending Domain Validation
scsi 8:0:8:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:8: Beginning Domain Validation
 target8:0:8: Ending Domain Validation
 target8:0:8: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
scsi: waiting for bus probes to complete ...
scsi 0:0:6:0: Direct-Access     HP 36.4G ST336753LC       HPC3 PQ: 0 ANSI: 3
 target0:0:6: tagged command queuing enabled, command queue depth 16.
 target0:0:6: Beginning Domain Validation
 target0:0:6: asynchronous
 target0:0:6: wide asynchronous
 target0:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
 target0:0:6: Domain Validation skipping write tests
 target0:0:6: Ending Domain Validation
scsi 8:0:15:0: Processor         COMPAQ   PROLIANT 4L7E*DB 2.14 PQ: 0 ANSI: 2
 target8:0:15: Beginning Domain Validation
 target8:0:15: Ending Domain Validation
 target8:0:15: asynchronous
sd 0:0:6:0: [sda] 71132960 512-byte hardware sectors (36420 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: d3 00 10 08
sd 0:0:6:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:6:0: [sda] 71132960 512-byte hardware sectors (36420 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: d3 00 10 08
sd 0:0:6:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9 sda10
sd 0:0:6:0: [sda] Attached SCSI disk
sd 2:0:6:0: [sdb] 71132960 512-byte hardware sectors (36420 MB)
sd 2:0:6:0: [sdb] Write Protect is off
sd 2:0:6:0: [sdb] Mode Sense: d3 00 10 08
sd 2:0:6:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 2:0:6:0: [sdb] 71132960 512-byte hardware sectors (36420 MB)
sd 2:0:6:0: [sdb] Write Protect is off
sd 2:0:6:0: [sdb] Mode Sense: d3 00 10 08
sd 2:0:6:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8 sdb9 sdb10
sd 2:0:6:0: [sdb] Attached SCSI disk
sd 8:0:0:0: [sdc] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:0:0: [sdc] Write Protect is off
sd 8:0:0:0: [sdc] Mode Sense: e7 00 10 08
sd 8:0:0:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:0:0: [sdc] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:0:0: [sdc] Write Protect is off
sd 8:0:0:0: [sdc] Mode Sense: e7 00 10 08
sd 8:0:0:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdc: sdc1 sdc2 sdc3
sd 8:0:0:0: [sdc] Attached SCSI disk
sd 8:0:1:0: [sdd] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:1:0: [sdd] Write Protect is off
sd 8:0:1:0: [sdd] Mode Sense: e7 00 10 08
sd 8:0:1:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:1:0: [sdd] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:1:0: [sdd] Write Protect is off
sd 8:0:1:0: [sdd] Mode Sense: e7 00 10 08
sd 8:0:1:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdd: sdd1 sdd2 sdd3
sd 8:0:1:0: [sdd] Attached SCSI disk
sd 8:0:2:0: [sde] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:2:0: [sde] Write Protect is off
sd 8:0:2:0: [sde] Mode Sense: e7 00 10 08
sd 8:0:2:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:2:0: [sde] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:2:0: [sde] Write Protect is off
sd 8:0:2:0: [sde] Mode Sense: e7 00 10 08
sd 8:0:2:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sde:<4>GPT:disk_guids don't match.
GPT:partition_entry_array_crc32 values don't match: 0x413661e0 != 0x36c03570
GPT: Use GNU Parted to correct GPT errors.
 sde1 sde2 sde3
sd 8:0:2:0: [sde] Attached SCSI disk
sd 8:0:3:0: [sdf] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:3:0: [sdf] Write Protect is off
sd 8:0:3:0: [sdf] Mode Sense: e7 00 10 08
sd 8:0:3:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:3:0: [sdf] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:3:0: [sdf] Write Protect is off
sd 8:0:3:0: [sdf] Mode Sense: e7 00 10 08
sd 8:0:3:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdf: sdf1 sdf2 sdf3
sd 8:0:3:0: [sdf] Attached SCSI disk
sd 8:0:4:0: [sdg] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:4:0: [sdg] Write Protect is off
sd 8:0:4:0: [sdg] Mode Sense: e7 00 10 08
sd 8:0:4:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:4:0: [sdg] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:4:0: [sdg] Write Protect is off
sd 8:0:4:0: [sdg] Mode Sense: e7 00 10 08
sd 8:0:4:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdg: sdg1 sdg2 sdg3
sd 8:0:4:0: [sdg] Attached SCSI disk
sd 8:0:5:0: [sdh] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:5:0: [sdh] Write Protect is off
sd 8:0:5:0: [sdh] Mode Sense: e7 00 10 08
sd 8:0:5:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:5:0: [sdh] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:5:0: [sdh] Write Protect is off
sd 8:0:5:0: [sdh] Mode Sense: e7 00 10 08
sd 8:0:5:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdh: sdh1 sdh2 sdh3
sd 8:0:5:0: [sdh] Attached SCSI disk
sd 8:0:8:0: [sdi] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:8:0: [sdi] Write Protect is off
sd 8:0:8:0: [sdi] Mode Sense: e7 00 10 08
sd 8:0:8:0: [sdi] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:8:0: [sdi] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:8:0: [sdi] Write Protect is off
sd 8:0:8:0: [sdi] Mode Sense: e7 00 10 08
sd 8:0:8:0: [sdi] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdi:<6>sd 8:0:8:0: [sdi] Sense Key : 0x1 [current] 
sd 8:0:8:0: [sdi] ASC=0x5d ASCQ=0x32
 sdi1
sd 8:0:8:0: [sdi] Attached SCSI disk
sd 9:0:0:0: [sdj] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:0:0: [sdj] Write Protect is off
sd 9:0:0:0: [sdj] Mode Sense: e7 00 10 08
sd 9:0:0:0: [sdj] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:0:0: [sdj] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:0:0: [sdj] Write Protect is off
sd 9:0:0:0: [sdj] Mode Sense: e7 00 10 08
sd 9:0:0:0: [sdj] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdj: sdj1
sd 9:0:0:0: [sdj] Attached SCSI disk
sd 9:0:1:0: [sdk] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:1:0: [sdk] Write Protect is off
sd 9:0:1:0: [sdk] Mode Sense: e7 00 10 08
sd 9:0:1:0: [sdk] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:1:0: [sdk] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:1:0: [sdk] Write Protect is off
sd 9:0:1:0: [sdk] Mode Sense: e7 00 10 08
sd 9:0:1:0: [sdk] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdk: sdk1
sd 9:0:1:0: [sdk] Attached SCSI disk
sd 9:0:2:0: [sdl] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:2:0: [sdl] Write Protect is off
sd 9:0:2:0: [sdl] Mode Sense: e7 00 10 08
sd 9:0:2:0: [sdl] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:2:0: [sdl] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:2:0: [sdl] Write Protect is off
sd 9:0:2:0: [sdl] Mode Sense: e7 00 10 08
sd 9:0:2:0: [sdl] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdl: sdl1
sd 9:0:2:0: [sdl] Attached SCSI disk
sd 9:0:3:0: [sdm] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:3:0: [sdm] Write Protect is off
sd 9:0:3:0: [sdm] Mode Sense: e7 00 10 08
sd 9:0:3:0: [sdm] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:3:0: [sdm] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:3:0: [sdm] Write Protect is off
sd 9:0:3:0: [sdm] Mode Sense: e7 00 10 08
sd 9:0:3:0: [sdm] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdm: sdm1
sd 9:0:3:0: [sdm] Attached SCSI disk
sd 9:0:4:0: [sdn] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:4:0: [sdn] Write Protect is off
sd 9:0:4:0: [sdn] Mode Sense: e7 00 10 08
sd 9:0:4:0: [sdn] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:4:0: [sdn] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:4:0: [sdn] Write Protect is off
sd 9:0:4:0: [sdn] Mode Sense: e7 00 10 08
sd 9:0:4:0: [sdn] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdn: sdn1
sd 9:0:4:0: [sdn] Attached SCSI disk
sd 9:0:5:0: [sdo] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:5:0: [sdo] Write Protect is off
sd 9:0:5:0: [sdo] Mode Sense: e7 00 10 08
sd 9:0:5:0: [sdo] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:5:0: [sdo] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:5:0: [sdo] Write Protect is off
sd 9:0:5:0: [sdo] Mode Sense: e7 00 10 08
sd 9:0:5:0: [sdo] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdo: sdo1 sdo2 sdo3
sd 9:0:5:0: [sdo] Attached SCSI disk
sd 9:0:8:0: [sdp] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:8:0: [sdp] Write Protect is off
sd 9:0:8:0: [sdp] Mode Sense: e7 00 10 08
sd 9:0:8:0: [sdp] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:8:0: [sdp] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:8:0: [sdp] Write Protect is off
sd 9:0:8:0: [sdp] Mode Sense: e7 00 10 08
sd 9:0:8:0: [sdp] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdp: sdp1
sd 9:0:8:0: [sdp] Attached SCSI disk
Freeing unused kernel memory: 688kB freed
<snip> - init scripts, ...

---------------------------------------------------------
4) tail of hung boot [async scan; !scsi logging, +mpt logging]

<snip "head">
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ide-floppy driver 0.99.newide
GSI 24 (level, low) -> CPU 2 (0x0800) vector 66
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 24 (level, low) -> IRQ 66
sym0: <1010-66> rev 0x1 at pci 0000:00:02.0 irq 66
sym0: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
GSI 25 (level, low) -> CPU 3 (0x0c00) vector 67
ACPI: PCI Interrupt 0000:00:02.1[B] -> GSI 25 (level, low) -> IRQ 67
sym1: <1010-66> rev 0x1 at pci 0000:00:02.1 irq 67
sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym1: open drain IRQ line driver, using on-chip SRAM
sym1: using LOAD/STORE-based firmware.
sym1: handling phase mismatch from SCRIPTS.
sym1: SCSI BUS has been reset.
scsi1 : sym-2.2.3
GSI 26 (level, low) -> CPU 0 (0x0000) vector 68
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 26 (level, low) -> IRQ 68
sym2: <1010-66> rev 0x1 at pci 0000:00:03.0 irq 68
sym2: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym2: open drain IRQ line driver, using on-chip SRAM
sym2: using LOAD/STORE-based firmware.
sym2: handling phase mismatch from SCRIPTS.
sym2: SCSI BUS has been reset.
scsi2 : sym-2.2.3
GSI 27 (level, low) -> CPU 1 (0x0400) vector 69
ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 27 (level, low) -> IRQ 69
sym3: <1010-66> rev 0x1 at pci 0000:00:03.1 irq 69
sym3: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym3: open drain IRQ line driver, using on-chip SRAM
sym3: using LOAD/STORE-based firmware.
sym3: handling phase mismatch from SCRIPTS.
sym3: SCSI BUS has been reset.
scsi3 : sym-2.2.3
GSI 128 (level, low) -> CPU 6 (0x0801) vector 70
ACPI: PCI Interrupt 0001:00:02.0[A] -> GSI 128 (level, low) -> IRQ 70
sym4: <1010-66> rev 0x1 at pci 0001:00:02.0 irq 70
sym4: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym4: open drain IRQ line driver, using on-chip SRAM
sym4: using LOAD/STORE-based firmware.
sym4: handling phase mismatch from SCRIPTS.
sym4: SCSI BUS has been reset.
scsi4 : sym-2.2.3
GSI 129 (level, low) -> CPU 7 (0x0c01) vector 71
ACPI: PCI Interrupt 0001:00:02.1[B] -> GSI 129 (level, low) -> IRQ 71
sym5: <1010-66> rev 0x1 at pci 0001:00:02.1 irq 71
sym5: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym5: open drain IRQ line driver, using on-chip SRAM
sym5: using LOAD/STORE-based firmware.
sym5: handling phase mismatch from SCRIPTS.
sym5: SCSI BUS has been reset.
scsi5 : sym-2.2.3
GSI 130 (level, low) -> CPU 4 (0x0001) vector 72
ACPI: PCI Interrupt 0001:00:03.0[A] -> GSI 130 (level, low) -> IRQ 72
sym6: <1010-66> rev 0x1 at pci 0001:00:03.0 irq 72
sym6: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym6: open drain IRQ line driver, using on-chip SRAM
sym6: using LOAD/STORE-based firmware.
sym6: handling phase mismatch from SCRIPTS.
sym6: SCSI BUS has been reset.
scsi6 : sym-2.2.3
GSI 131 (level, low) -> CPU 5 (0x0401) vector 73
ACPI: PCI Interrupt 0001:00:03.1[B] -> GSI 131 (level, low) -> IRQ 73
sym7: <1010-66> rev 0x1 at pci 0001:00:03.1 irq 73
sym7: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym7: open drain IRQ line driver, using on-chip SRAM
sym7: using LOAD/STORE-based firmware.
sym7: handling phase mismatch from SCRIPTS.
sym7: SCSI BUS has been reset.
scsi7 : sym-2.2.3
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
GSI 43 (level, low) -> CPU 2 (0x0800) vector 74
ACPI: PCI Interrupt 0000:38:01.0[A] -> GSI 43 (level, low) -> IRQ 74
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
scsi8 : ioc0: LSI53C1030 C0, FwRev=01032341h, Ports=1, MaxQ=255, IRQ=74
GSI 44 (level, low) -> CPU 3 (0x0c00) vector 75
ACPI: PCI Interrupt 0000:38:01.1[B] -> GSI 44 (level, low) -> IRQ 75
mptbase: ioc1: Initiating bringup
scsi 8:0:0:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:0: Beginning Domain Validation
 target8:0:0: mptspi: ioc0: mpt_config failed
 target8:0:0: Domain Validation Initial Inquiry Failed
 target8:0:0: Ending Domain Validation
 target8:0:0: mptspi: ioc0: mpt_config failed
 target8:0:0: asynchronous
 target8:0:0: mptspi: ioc0: mpt_config failed
ioc1: LSI53C1030 C0: Capabilities={Initiator,Target}
scsi9 : ioc1: LSI53C1030 C0, FwRev=01032341h, Ports=1, MaxQ=255, IRQ=75
scsi 1:0:2:0: CD-ROM            HP       DVD-ROM 305      1.01 PQ: 0 ANSI: 2
 target1:0:2: Beginning Domain Validation
 target1:0:2: asynchronous
 target1:0:2: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 16)
 target1:0:2: Domain Validation skipping write tests
 target1:0:2: Ending Domain Validation
mice: PS/2 mouse device common for all mice
EFI Variables Facility v0.08 2004-May-17
scsi 9:0:0:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:0: Beginning Domain Validation
 target9:0:0: Ending Domain Validation
 target9:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:1:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:1: Beginning Domain Validation
 target9:0:1: Ending Domain Validation
 target9:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:2:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:2: Beginning Domain Validation
 target9:0:2: Ending Domain Validation
 target9:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:3:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:3: Beginning Domain Validation
scsi 0:0:6:0: Direct-Access     HP 36.4G ST336753LC       HPC3 PQ: 0 ANSI: 3
 target0:0:6: tagged command queuing enabled, command queue depth 16.
 target0:0:6: Beginning Domain Validation
 target0:0:6: asynchronous
 target0:0:6: wide asynchronous
 target0:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
 target0:0:6: Domain Validation skipping write tests
 target0:0:6: Ending Domain Validation
 target9:0:3: Ending Domain Validation
 target9:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 9:0:4:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:4: Beginning Domain Validation
 target9:0:4: Ending Domain Validation
 target9:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
scsi 2:0:6:0: Direct-Access     HP 36.4G ST336753LC       HPC3 PQ: 0 ANSI: 3
 target2:0:6: tagged command queuing enabled, command queue depth 16.
 target2:0:6: Beginning Domain Validation
 target2:0:6: asynchronous
 target2:0:6: wide asynchronous
 target2:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
 target2:0:6: Domain Validation skipping write tests
 target2:0:6: Ending Domain Validation
scsi 9:0:5:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:5: Beginning Domain Validation
 target9:0:5: Ending Domain Validation
 target9:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
scsi 9:0:8:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:8: Beginning Domain Validation
scsi: waiting for bus probes to complete ...
 target9:0:8: Ending Domain Validation
 target9:0:8: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
sd 0:0:6:0: [sda] 71132960 512-byte hardware sectors (36420 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: d3 00 10 08
sd 0:0:6:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:6:0: [sda] 71132960 512-byte hardware sectors (36420 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: d3 00 10 08
sd 0:0:6:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9 sda10
sd 0:0:6:0: [sda] Attached SCSI disk
sd 2:0:6:0: [sdb] 71132960 512-byte hardware sectors (36420 MB)
sd 2:0:6:0: [sdb] Write Protect is off
sd 2:0:6:0: [sdb] Mode Sense: d3 00 10 08
sd 2:0:6:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 2:0:6:0: [sdb] 71132960 512-byte hardware sectors (36420 MB)
sd 2:0:6:0: [sdb] Write Protect is off
sd 2:0:6:0: [sdb] Mode Sense: d3 00 10 08
sd 2:0:6:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8 sdb9 sdb10
sd 2:0:6:0: [sdb] Attached SCSI disk

<hangs here...>


---------------------------------------------------------
5) very verbose mpt debug output.  I just hacked the MPT_CHECK_LOGGING()
macro to print everything.

< more of same had scrolled out of terminal buffer>

mptscsih: ioc0: ScsiDone (mf=E000070182A06580,mr=0000000000000000,sc=E00007018297C180,idx=164)
scsi 8:0:3:0: CDB: cdb[0]=0x3b: 3b 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A065E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a065e2 req_idx=165 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A065E0 idx=165
mptbase: ioc0: Got TURBO reply req_idx=000e00a5
mptscsih: ioc0: ScsiDone (mf=E000070182A065E0,mr=0000000000000000,sc=E00007018297C180,idx=165)
scsi 8:0:3:0: CDB: cdb[0]=0x3c: 3c 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06640
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06642 req_idx=166 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06640 idx=166
mptbase: ioc0: Got TURBO reply req_idx=000e00a6
mptscsih: ioc0: ScsiDone (mf=E000070182A06640,mr=0000000000000000,sc=E00007018297C180,idx=166)
scsi 8:0:3:0: CDB: cdb[0]=0x3b: 3b 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A066A0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a066a2 req_idx=167 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A066A0 idx=167
mptbase: ioc0: Got TURBO reply req_idx=000e00a7
mptscsih: ioc0: ScsiDone (mf=E000070182A066A0,mr=0000000000000000,sc=E00007018297C180,idx=167)
scsi 8:0:3:0: CDB: cdb[0]=0x3c: 3c 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06700
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06702 req_idx=168 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06700 idx=168
mptbase: ioc0: Got TURBO reply req_idx=000e00a8
mptscsih: ioc0: ScsiDone (mf=E000070182A06700,mr=0000000000000000,sc=E00007018297C180,idx=168)
 target8:0:3: Ending Domain Validation
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06760
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: mf_dma_addr=82a06762 req_idx=169 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01BD0 req_idx=a9 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06760,mr=E000070182A01BD0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=3 Read = 0x207f08c7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RTI PCOMP )
 target8:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A067C0
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: mf_dma_addr=82a067c2 req_idx=170 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01C20 req_idx=aa cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A067C0,mr=E000070182A01C20)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=3 Read = 0x207f08c7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RTI PCOMP )
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06820
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06822 req_idx=171 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06820 idx=171
mptbase: ioc0: Got non-TURBO reply=E000070182A01C70 req_idx=ab cb_idx=e Function=0
mptscsih: ioc0: ScsiDone (mf=E000070182A06820,mr=E000070182A01C70,sc=E00007018297C180,idx=171)
mptscsih: ioc0:   sc->underflow={report ERR if < 00h bytes xfer'd}
mptscsih: ioc0:   ActBytesXferd=10h
mptspi: ioc0: id=4 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06880
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06882 req_idx=172 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01CC0 req_idx=ac cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06880,mr=E000070182A01CC0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A068E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a068e2 req_idx=173 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A068E0 idx=173
mptbase: ioc0: Got TURBO reply req_idx=000e00ad
mptscsih: ioc0: ScsiDone (mf=E000070182A068E0,mr=0000000000000000,sc=E00007018297C180,idx=173)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06940
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06942 req_idx=174 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06940 idx=174
mptbase: ioc0: Got TURBO reply req_idx=000e00ae
mptscsih: ioc0: ScsiDone (mf=E000070182A06940,mr=0000000000000000,sc=E00007018297C180,idx=174)
scsi 8:0:4:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
mptspi: ioc0: Enabling QAS due to byte56=02 on id=4!
mptscsih: ioc0: device @ E000070182970000, channel=0, id=4, lun=0
mptscsih: ioc0: sdtr 1 wdtr 1 ppr 1 inq length=96
mptscsih: ioc0: Queue depth=64, tflags=9
mptscsih: ioc0: negoFlags=0, maxOffset=7f, SyncFactor=8
mptscsih: ioc0: tagged 1, simple 1, ordered 0
mptspi: ioc0: id=4 min_period=0x08 max_offset=0x7f max_width=1
 target8:0:4: Beginning Domain Validation
mptspi: ioc0: id=4 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A069A0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a069a2 req_idx=175 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01D10 req_idx=af cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A069A0,mr=E000070182A01D10)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06A00
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06a02 req_idx=176 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01D60 req_idx=b0 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06A00,mr=E000070182A01D60)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06A60
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06a62 req_idx=177 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06A60 idx=177
mptbase: ioc0: Got TURBO reply req_idx=000e00b1
mptscsih: ioc0: ScsiDone (mf=E000070182A06A60,mr=0000000000000000,sc=E00007018297C180,idx=177)
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06AC0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06ac2 req_idx=178 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06AC0 idx=178
mptbase: ioc0: Got TURBO reply req_idx=000e00b2
mptscsih: ioc0: ScsiDone (mf=E000070182A06AC0,mr=0000000000000000,sc=E00007018297C180,idx=178)
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06B20
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06b22 req_idx=179 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06B20 idx=179
mptbase: ioc0: Got TURBO reply req_idx=000e00b3
mptscsih: ioc0: ScsiDone (mf=E000070182A06B20,mr=0000000000000000,sc=E00007018297C180,idx=179)
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06B80
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06b82 req_idx=180 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06B80 idx=180
mptbase: ioc0: Got TURBO reply req_idx=000e00b4
mptscsih: ioc0: ScsiDone (mf=E000070182A06B80,mr=0000000000000000,sc=E00007018297C180,idx=180)
mptspi: ioc0: id=4 Requested = 0x20000a00 ( Wide  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06BE0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06be2 req_idx=181 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01DB0 req_idx=b5 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06BE0,mr=E000070182A01DB0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06C40
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06c42 req_idx=182 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06C40 idx=182
mptbase: ioc0: Got TURBO reply req_idx=000e00b6
mptscsih: ioc0: ScsiDone (mf=E000070182A06C40,mr=0000000000000000,sc=E00007018297C180,idx=182)
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06CA0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06ca2 req_idx=183 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06CA0 idx=183
mptbase: ioc0: Got TURBO reply req_idx=000e00b7
mptscsih: ioc0: ScsiDone (mf=E000070182A06CA0,mr=0000000000000000,sc=E00007018297C180,idx=183)
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A06D00
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a06d02 req_idx=184 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A06D00 idx=184
mptbase: ioc0: Got TURBO reply req_idx=000e00b8
mptscsih: ioc0: ScsiDone (mf=E000070182A06D00,mr=0000000000000000,sc=E00007018297C180,idx=184)
mptspi: ioc0: id=4 Requested = 0x207f0a00 ( Wide  factor = 0x0a @ offset = 0x7f )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06D60
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06d62 req_idx=185 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01E00 req_idx=b9 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06D60,mr=E000070182A01E00)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x207f0803 ( Wide  factor = 0x08 @ offset = 0x7f IU DT )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06DC0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06dc2 req_idx=186 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01E50 req_idx=ba cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06DC0,mr=E000070182A01E50)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x207f0807 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06E20
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06e22 req_idx=187 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01EA0 req_idx=bb cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06E20,mr=E000070182A01EA0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x207f0807 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06E80
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06e82 req_idx=188 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01EF0 req_idx=bc cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06E80,mr=E000070182A01EF0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x207f0827 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RDSTRM )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06EE0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06ee2 req_idx=189 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01F40 req_idx=bd cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06EE0,mr=E000070182A01F40)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x207f0837 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06F40
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06f42 req_idx=190 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01F90 req_idx=be cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06F40,mr=E000070182A01F90)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x207f0877 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A06FA0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a06fa2 req_idx=191 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A01FE0 req_idx=bf cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A06FA0,mr=E000070182A01FE0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x207f08f7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI PCOMP )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07000
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07002 req_idx=192 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02030 req_idx=c0 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07000,mr=E000070182A02030)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x207f08f7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI PCOMP )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07060
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07062 req_idx=193 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02080 req_idx=c1 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07060,mr=E000070182A02080)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Requested = 0x207f08f7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI PCOMP )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A070C0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a070c2 req_idx=194 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A020D0 req_idx=c2 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A070C0,mr=E000070182A020D0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07120
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07122 req_idx=195 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07120 idx=195
mptbase: ioc0: Got TURBO reply req_idx=000e00c3
mptscsih: ioc0: ScsiDone (mf=E000070182A07120,mr=0000000000000000,sc=E00007018297C180,idx=195)
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07180
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07182 req_idx=196 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07180 idx=196
mptbase: ioc0: Got TURBO reply req_idx=000e00c4
mptscsih: ioc0: ScsiDone (mf=E000070182A07180,mr=0000000000000000,sc=E00007018297C180,idx=196)
scsi 8:0:4:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A071E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a071e2 req_idx=197 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A071E0 idx=197
mptbase: ioc0: Got TURBO reply req_idx=000e00c5
mptscsih: ioc0: ScsiDone (mf=E000070182A071E0,mr=0000000000000000,sc=E00007018297C180,idx=197)
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07240
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: mf_dma_addr=82a07242 req_idx=198 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02120 req_idx=c6 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07240,mr=E000070182A02120)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Read = 0x207f08c7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RTI PCOMP )
scsi 8:0:4:0: CDB: cdb[0]=0x0: 00 00 00 00 00 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A072A0
mptbase: ioc0: mf_dma_addr=82a072a2 req_idx=199 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A072A0 idx=199
mptbase: ioc0: Got non-TURBO reply=E000070182A02170 req_idx=c7 cb_idx=e Function=0
mptscsih: ioc0: ScsiDone (mf=E000070182A072A0,mr=E000070182A02170,sc=E00007018297C180,idx=199)
scsi 8:0:4:0: CDB: cdb[0]=0x0: 00 00 00 00 00 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07300
mptbase: ioc0: mf_dma_addr=82a07302 req_idx=200 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07300 idx=200
mptbase: ioc0: Got TURBO reply req_idx=000e00c8
mptscsih: ioc0: ScsiDone (mf=E000070182A07300,mr=0000000000000000,sc=E00007018297C180,idx=200)
scsi 8:0:4:0: CDB: cdb[0]=0x3c: 3c 0b 00 00 00 00 00 00 04 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07360
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07362 req_idx=201 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07360 idx=201
mptbase: ioc0: Got TURBO reply req_idx=000e00c9
mptscsih: ioc0: ScsiDone (mf=E000070182A07360,mr=0000000000000000,sc=E00007018297C180,idx=201)
scsi 8:0:4:0: CDB: cdb[0]=0x3b: 3b 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A073C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a073c2 req_idx=202 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A073C0 idx=202
mptbase: ioc0: Got TURBO reply req_idx=000e00ca
mptscsih: ioc0: ScsiDone (mf=E000070182A073C0,mr=0000000000000000,sc=E00007018297C180,idx=202)
scsi 8:0:4:0: CDB: cdb[0]=0x3c: 3c 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07420
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07422 req_idx=203 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07420 idx=203
mptbase: ioc0: Got TURBO reply req_idx=000e00cb
mptscsih: ioc0: ScsiDone (mf=E000070182A07420,mr=0000000000000000,sc=E00007018297C180,idx=203)
scsi 8:0:4:0: CDB: cdb[0]=0x3b: 3b 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07480
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07482 req_idx=204 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07480 idx=204
mptbase: ioc0: Got TURBO reply req_idx=000e00cc
mptscsih: ioc0: ScsiDone (mf=E000070182A07480,mr=0000000000000000,sc=E00007018297C180,idx=204)
scsi 8:0:4:0: CDB: cdb[0]=0x3c: 3c 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A074E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a074e2 req_idx=205 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A074E0 idx=205
mptbase: ioc0: Got TURBO reply req_idx=000e00cd
mptscsih: ioc0: ScsiDone (mf=E000070182A074E0,mr=0000000000000000,sc=E00007018297C180,idx=205)
scsi 8:0:4:0: CDB: cdb[0]=0x3b: 3b 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07540
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07542 req_idx=206 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07540 idx=206
mptbase: ioc0: Got TURBO reply req_idx=000e00ce
mptscsih: ioc0: ScsiDone (mf=E000070182A07540,mr=0000000000000000,sc=E00007018297C180,idx=206)
scsi 8:0:4:0: CDB: cdb[0]=0x3c: 3c 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A075A0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a075a2 req_idx=207 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A075A0 idx=207
mptbase: ioc0: Got TURBO reply req_idx=000e00cf
mptscsih: ioc0: ScsiDone (mf=E000070182A075A0,mr=0000000000000000,sc=E00007018297C180,idx=207)
 target8:0:4: Ending Domain Validation
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07600
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: mf_dma_addr=82a07602 req_idx=208 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A021C0 req_idx=d0 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07600,mr=E000070182A021C0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Read = 0x207f08c7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RTI PCOMP )
 target8:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07660
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: mf_dma_addr=82a07662 req_idx=209 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02210 req_idx=d1 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07660,mr=E000070182A02210)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=4 Read = 0x207f08c7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RTI PCOMP )
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A076C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a076c2 req_idx=210 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A076C0 idx=210
mptbase: ioc0: Got non-TURBO reply=E000070182A02260 req_idx=d2 cb_idx=e Function=0
mptscsih: ioc0: ScsiDone (mf=E000070182A076C0,mr=E000070182A02260,sc=E00007018297C180,idx=210)
mptscsih: ioc0:   sc->underflow={report ERR if < 00h bytes xfer'd}
mptscsih: ioc0:   ActBytesXferd=10h
mptspi: ioc0: id=5 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07720
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07722 req_idx=211 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A022B0 req_idx=d3 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07720,mr=E000070182A022B0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07780
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07782 req_idx=212 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07780 idx=212
mptbase: ioc0: Got TURBO reply req_idx=000e00d4
mptscsih: ioc0: ScsiDone (mf=E000070182A07780,mr=0000000000000000,sc=E00007018297C180,idx=212)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A077E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a077e2 req_idx=213 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A077E0 idx=213
mptbase: ioc0: Got TURBO reply req_idx=000e00d5
mptscsih: ioc0: ScsiDone (mf=E000070182A077E0,mr=0000000000000000,sc=E00007018297C180,idx=213)
scsi 8:0:5:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
mptspi: ioc0: Enabling QAS due to byte56=02 on id=5!
mptscsih: ioc0: device @ E000070182970800, channel=0, id=5, lun=0
mptscsih: ioc0: sdtr 1 wdtr 1 ppr 1 inq length=96
mptscsih: ioc0: Queue depth=64, tflags=9
mptscsih: ioc0: negoFlags=0, maxOffset=7f, SyncFactor=8
mptscsih: ioc0: tagged 1, simple 1, ordered 0
mptspi: ioc0: id=5 min_period=0x08 max_offset=0x7f max_width=1
 target8:0:5: Beginning Domain Validation
mptspi: ioc0: id=5 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07840
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07842 req_idx=214 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02300 req_idx=d6 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07840,mr=E000070182A02300)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A078A0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a078a2 req_idx=215 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02350 req_idx=d7 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A078A0,mr=E000070182A02350)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07900
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07902 req_idx=216 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07900 idx=216
mptbase: ioc0: Got TURBO reply req_idx=000e00d8
mptscsih: ioc0: ScsiDone (mf=E000070182A07900,mr=0000000000000000,sc=E00007018297C180,idx=216)
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07960
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07962 req_idx=217 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07960 idx=217
mptbase: ioc0: Got TURBO reply req_idx=000e00d9
mptscsih: ioc0: ScsiDone (mf=E000070182A07960,mr=0000000000000000,sc=E00007018297C180,idx=217)
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A079C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a079c2 req_idx=218 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A079C0 idx=218
mptbase: ioc0: Got TURBO reply req_idx=000e00da
mptscsih: ioc0: ScsiDone (mf=E000070182A079C0,mr=0000000000000000,sc=E00007018297C180,idx=218)
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07A20
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07a22 req_idx=219 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07A20 idx=219
mptbase: ioc0: Got TURBO reply req_idx=000e00db
mptscsih: ioc0: ScsiDone (mf=E000070182A07A20,mr=0000000000000000,sc=E00007018297C180,idx=219)
mptspi: ioc0: id=5 Requested = 0x20000a00 ( Wide  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07A80
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07a82 req_idx=220 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A023A0 req_idx=dc cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07A80,mr=E000070182A023A0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07AE0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07ae2 req_idx=221 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07AE0 idx=221
mptbase: ioc0: Got TURBO reply req_idx=000e00dd
mptscsih: ioc0: ScsiDone (mf=E000070182A07AE0,mr=0000000000000000,sc=E00007018297C180,idx=221)
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07B40
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07b42 req_idx=222 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07B40 idx=222
mptbase: ioc0: Got TURBO reply req_idx=000e00de
mptscsih: ioc0: ScsiDone (mf=E000070182A07B40,mr=0000000000000000,sc=E00007018297C180,idx=222)
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07BA0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07ba2 req_idx=223 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07BA0 idx=223
mptbase: ioc0: Got TURBO reply req_idx=000e00df
mptscsih: ioc0: ScsiDone (mf=E000070182A07BA0,mr=0000000000000000,sc=E00007018297C180,idx=223)
mptspi: ioc0: id=5 Requested = 0x207f0a00 ( Wide  factor = 0x0a @ offset = 0x7f )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07C00
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07c02 req_idx=224 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A023F0 req_idx=e0 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07C00,mr=E000070182A023F0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x207f0803 ( Wide  factor = 0x08 @ offset = 0x7f IU DT )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07C60
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07c62 req_idx=225 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02440 req_idx=e1 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07C60,mr=E000070182A02440)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x207f0807 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07CC0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07cc2 req_idx=226 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02490 req_idx=e2 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07CC0,mr=E000070182A02490)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x207f0807 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07D20
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07d22 req_idx=227 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A024E0 req_idx=e3 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07D20,mr=E000070182A024E0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x207f0827 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RDSTRM )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07D80
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07d82 req_idx=228 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02530 req_idx=e4 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07D80,mr=E000070182A02530)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x207f0837 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07DE0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07de2 req_idx=229 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02580 req_idx=e5 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07DE0,mr=E000070182A02580)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x207f0877 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07E40
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07e42 req_idx=230 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A025D0 req_idx=e6 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07E40,mr=E000070182A025D0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x207f08f7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI PCOMP )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07EA0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07ea2 req_idx=231 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02620 req_idx=e7 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07EA0,mr=E000070182A02620)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x207f08f7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI PCOMP )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07F00
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07f02 req_idx=232 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02670 req_idx=e8 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07F00,mr=E000070182A02670)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Requested = 0x207f08f7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI PCOMP )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A07F60
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a07f62 req_idx=233 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A026C0 req_idx=e9 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A07F60,mr=E000070182A026C0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07FC0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07fc2 req_idx=234 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07FC0 idx=234
mptbase: ioc0: Got TURBO reply req_idx=000e00ea
mptscsih: ioc0: ScsiDone (mf=E000070182A07FC0,mr=0000000000000000,sc=E00007018297C180,idx=234)
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08020
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08022 req_idx=235 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08020 idx=235
mptbase: ioc0: Got TURBO reply req_idx=000e00eb
mptscsih: ioc0: ScsiDone (mf=E000070182A08020,mr=0000000000000000,sc=E00007018297C180,idx=235)
scsi 8:0:5:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08080
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08082 req_idx=236 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08080 idx=236
mptbase: ioc0: Got TURBO reply req_idx=000e00ec
mptscsih: ioc0: ScsiDone (mf=E000070182A08080,mr=0000000000000000,sc=E00007018297C180,idx=236)
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A080E0
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: mf_dma_addr=82a080e2 req_idx=237 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A02710 req_idx=ed cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A080E0,mr=E000070182A02710)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Read = 0x207f08c7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RTI PCOMP )
scsi 8:0:5:0: CDB: cdb[0]=0x0: 00 00 00 00 00 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08140
mptbase: ioc0: mf_dma_addr=82a08142 req_idx=238 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08140 idx=238
mptbase: ioc0: Got non-TURBO reply=E000070182A02760 req_idx=ee cb_idx=e Function=0
mptscsih: ioc0: ScsiDone (mf=E000070182A08140,mr=E000070182A02760,sc=E00007018297C180,idx=238)
scsi 8:0:5:0: CDB: cdb[0]=0x0: 00 00 00 00 00 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A081A0
mptbase: ioc0: mf_dma_addr=82a081a2 req_idx=239 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A081A0 idx=239
mptbase: ioc0: Got TURBO reply req_idx=000e00ef
mptscsih: ioc0: ScsiDone (mf=E000070182A081A0,mr=0000000000000000,sc=E00007018297C180,idx=239)
scsi 8:0:5:0: CDB: cdb[0]=0x3c: 3c 0b 00 00 00 00 00 00 04 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08200
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08202 req_idx=240 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08200 idx=240
mptbase: ioc0: Got TURBO reply req_idx=000e00f0
mptscsih: ioc0: ScsiDone (mf=E000070182A08200,mr=0000000000000000,sc=E00007018297C180,idx=240)
scsi 8:0:5:0: CDB: cdb[0]=0x3b: 3b 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08260
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08262 req_idx=241 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08260 idx=241
mptbase: ioc0: Got TURBO reply req_idx=000e00f1
mptscsih: ioc0: ScsiDone (mf=E000070182A08260,mr=0000000000000000,sc=E00007018297C180,idx=241)
scsi 8:0:5:0: CDB: cdb[0]=0x3c: 3c 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A082C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a082c2 req_idx=242 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A082C0 idx=242
mptbase: ioc0: Got TURBO reply req_idx=000e00f2
mptscsih: ioc0: ScsiDone (mf=E000070182A082C0,mr=0000000000000000,sc=E00007018297C180,idx=242)
scsi 8:0:5:0: CDB: cdb[0]=0x3b: 3b 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08320
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08322 req_idx=243 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08320 idx=243
mptbase: ioc0: Got TURBO reply req_idx=000e00f3
mptscsih: ioc0: ScsiDone (mf=E000070182A08320,mr=0000000000000000,sc=E00007018297C180,idx=243)
scsi 8:0:5:0: CDB: cdb[0]=0x3c: 3c 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08380
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08382 req_idx=244 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08380 idx=244
mptbase: ioc0: Got TURBO reply req_idx=000e00f4
mptscsih: ioc0: ScsiDone (mf=E000070182A08380,mr=0000000000000000,sc=E00007018297C180,idx=244)
scsi 8:0:5:0: CDB: cdb[0]=0x3b: 3b 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A083E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a083e2 req_idx=245 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A083E0 idx=245
mptbase: ioc0: Got TURBO reply req_idx=000e00f5
mptscsih: ioc0: ScsiDone (mf=E000070182A083E0,mr=0000000000000000,sc=E00007018297C180,idx=245)
scsi 8:0:5:0: CDB: cdb[0]=0x3c: 3c 0a 00 00 00 00 00 00 fc 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08440
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08442 req_idx=246 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08440 idx=246
mptbase: ioc0: Got TURBO reply req_idx=000e00f6
mptscsih: ioc0: ScsiDone (mf=E000070182A08440,mr=0000000000000000,sc=E00007018297C180,idx=246)
 target8:0:5: Ending Domain Validation
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A084A0
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: mf_dma_addr=82a084a2 req_idx=247 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A027B0 req_idx=f7 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A084A0,mr=E000070182A027B0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Read = 0x207f08c7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RTI PCOMP )
 target8:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A08500
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: mf_dma_addr=82a08502 req_idx=248 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00000 req_idx=f8 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A08500,mr=E000070182A00000)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=5 Read = 0x207f08c7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RTI PCOMP )
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08560
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08562 req_idx=249 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08560 idx=249
mptbase: ioc0: Got non-TURBO reply=E000070182A00050 req_idx=f9 cb_idx=e Function=0
mptscsih: ioc0: ScsiDone (mf=E000070182A08560,mr=E000070182A00050,sc=E00007018297C180,idx=249)
mptscsih: ioc0:   sc->underflow={report ERR if < 00h bytes xfer'd}
mptscsih: ioc0:   ActBytesXferd=10h
mptspi: ioc0: id=6 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A085C0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a085c2 req_idx=250 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A000A0 req_idx=fa cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A085C0,mr=E000070182A000A0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08620
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08622 req_idx=251 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08620 idx=251
mptbase: ioc0: Got non-TURBO reply=E000070182A000F0 req_idx=fb cb_idx=e Function=0
mptscsih: ioc0: ScsiDone (mf=E000070182A08620,mr=E000070182A000F0,sc=E00007018297C180,idx=251)
mptspi: ioc0: id=8 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A08680
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a08682 req_idx=252 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00140 req_idx=fc cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A08680,mr=E000070182A00140)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A086E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a086e2 req_idx=253 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A086E0 idx=253
mptbase: ioc0: Got TURBO reply req_idx=000e00fd
mptscsih: ioc0: ScsiDone (mf=E000070182A086E0,mr=0000000000000000,sc=E00007018297C180,idx=253)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08740
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08742 req_idx=254 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A08740 idx=254
mptbase: ioc0: Got TURBO reply req_idx=000e00fe
mptscsih: ioc0: ScsiDone (mf=E000070182A08740,mr=0000000000000000,sc=E00007018297C180,idx=254)
scsi 8:0:8:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
mptspi: ioc0: Enabling QAS due to byte56=02 on id=8!
mptscsih: ioc0: device @ E000070182971000, channel=0, id=8, lun=0
mptscsih: ioc0: sdtr 1 wdtr 1 ppr 1 inq length=96
mptscsih: ioc0: Queue depth=64, tflags=9
mptscsih: ioc0: negoFlags=0, maxOffset=7f, SyncFactor=8
mptscsih: ioc0: tagged 1, simple 1, ordered 0
mptspi: ioc0: id=8 min_period=0x08 max_offset=0x7f max_width=1
 target8:0:8: Beginning Domain Validation
mptspi: ioc0: id=8 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02860
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02862 req_idx=1 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00190 req_idx=1 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02860,mr=E000070182A00190)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A028C0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a028c2 req_idx=2 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A001E0 req_idx=2 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A028C0,mr=E000070182A001E0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
scsi 8:0:8:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02920
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02922 req_idx=3 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A02920 idx=3
mptbase: ioc0: Got TURBO reply req_idx=000e0003
mptscsih: ioc0: ScsiDone (mf=E000070182A02920,mr=0000000000000000,sc=E00007018297C180,idx=3)
scsi 8:0:8:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02980
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02982 req_idx=4 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A02980 idx=4
mptbase: ioc0: Got TURBO reply req_idx=000e0004
mptscsih: ioc0: ScsiDone (mf=E000070182A02980,mr=0000000000000000,sc=E00007018297C180,idx=4)
scsi 8:0:8:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A029E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a029e2 req_idx=5 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A029E0 idx=5
mptbase: ioc0: Got TURBO reply req_idx=000e0005
mptscsih: ioc0: ScsiDone (mf=E000070182A029E0,mr=0000000000000000,sc=E00007018297C180,idx=5)
scsi 8:0:8:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02A40
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02a42 req_idx=6 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A02A40 idx=6
mptbase: ioc0: Got TURBO reply req_idx=000e0006
mptscsih: ioc0: ScsiDone (mf=E000070182A02A40,mr=0000000000000000,sc=E00007018297C180,idx=6)
mptspi: ioc0: id=8 Requested = 0x20000a00 ( Wide  factor = 0x0a @ offset = 0x00 )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02AA0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02aa2 req_idx=7 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00230 req_idx=7 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02AA0,mr=E000070182A00230)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
scsi 8:0:8:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02B00
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02b02 req_idx=8 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A02B00 idx=8
mptbase: ioc0: Got TURBO reply req_idx=000e0008
mptscsih: ioc0: ScsiDone (mf=E000070182A02B00,mr=0000000000000000,sc=E00007018297C180,idx=8)
scsi 8:0:8:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02B60
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02b62 req_idx=9 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A02B60 idx=9
mptbase: ioc0: Got TURBO reply req_idx=000e0009
mptscsih: ioc0: ScsiDone (mf=E000070182A02B60,mr=0000000000000000,sc=E00007018297C180,idx=9)
scsi 8:0:8:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02BC0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02bc2 req_idx=10 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A02BC0 idx=10
mptbase: ioc0: Got TURBO reply req_idx=000e000a
mptscsih: ioc0: ScsiDone (mf=E000070182A02BC0,mr=0000000000000000,sc=E00007018297C180,idx=10)
mptspi: ioc0: id=8 Requested = 0x207f0a00 ( Wide  factor = 0x0a @ offset = 0x7f )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02C20
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02c22 req_idx=11 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00280 req_idx=b cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02C20,mr=E000070182A00280)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x207f0803 ( Wide  factor = 0x08 @ offset = 0x7f IU DT )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02C80
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02c82 req_idx=12 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A002D0 req_idx=c cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02C80,mr=E000070182A002D0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x207f0807 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02CE0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02ce2 req_idx=13 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00320 req_idx=d cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02CE0,mr=E000070182A00320)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x207f0807 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02D40
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02d42 req_idx=14 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00370 req_idx=e cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02D40,mr=E000070182A00370)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x207f0827 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS RDSTRM )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02DA0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02da2 req_idx=15 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A003C0 req_idx=f cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02DA0,mr=E000070182A003C0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x207f0837 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02E00
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02e02 req_idx=16 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00410 req_idx=10 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02E00,mr=E000070182A00410)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x207f0877 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02E60
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02e62 req_idx=17 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00460 req_idx=11 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02E60,mr=E000070182A00460)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x207f08f7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI PCOMP )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02EC0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02ec2 req_idx=18 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A004B0 req_idx=12 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02EC0,mr=E000070182A004B0)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x207f08f7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI PCOMP )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02F20
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02f22 req_idx=19 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00500 req_idx=13 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02F20,mr=E000070182A00500)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: id=8 Requested = 0x207f08f7 ( Wide  factor = 0x08 @ offset = 0x7f IU DT QAS WRFLOW RDSTRM RTI PCOMP )
mptbase: ioc0: mpt_get_msg_frame(15,0), got mf=E000070182A02F80
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: mf_dma_addr=82a02f82 req_idx=20 RequestNB=2
mptbase: ioc0: Got non-TURBO reply=E000070182A00550 req_idx=14 cb_idx=f Function=4
mptbase: ioc0: mpt_base_reply() called
mptbase: ioc0: mpt_base_reply, Function=04h
mptbase: ioc0: config_complete (mf=E000070182A02F80,mr=E000070182A00550)
mptbase: ioc0:   IOCStatus=0000h, IOCLogInfo=00000000h
scsi 8:0:8:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02FE0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02fe2 req_idx=21 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A02FE0 idx=21
mptbase: ioc0: Got TURBO reply req_idx=000e0015
mptscsih: ioc0: ScsiDone (mf=E000070182A02FE0,mr=0000000000000000,sc=E00007018297C180,idx=21)
scsi 8:0:8:0: CDB: cdb[0]=0x12: 12 00 00 00 60 00
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03040
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03042 req_idx=22 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A03040 idx=22
mptbase: ioc0: Got TURBO reply req_idx=000e0016
mptscsih: ioc0: ScsiDone (mf=E000070182A03040,mr=0000000

<snip -- lost console output -- more of same?>

mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07d22 req_idx=227 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07D20 idx=227
mptbase: ioc0: Got TURBO reply req_idx=000e00e3
mptscsih: ioc0: ScsiDone (mf=E000070182A07D20,mr=0000000000000000,sc=E00007018297C180,idx=227)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07D80
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07d82 req_idx=228 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07D80 idx=228
mptbase: ioc0: Got TURBO reply req_idx=000e00e4
mptscsih: ioc0: ScsiDone (mf=E000070182A07D80,mr=0000000000000000,sc=E00007018297C180,idx=228)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07DE0
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a07de3 req_idx=229 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07DE0 idx=229
mptbase: ioc0: Got TURBO reply req_idx=000e00e5
mptscsih: ioc0: ScsiDone (mf=E000070182A07DE0,mr=0000000000000000,sc=E00007018297C180,idx=229)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07E40
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07e42 req_idx=230 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07E40 idx=230
mptbase: ioc0: Got TURBO reply req_idx=000e00e6
mptscsih: ioc0: ScsiDone (mf=E000070182A07E40,mr=0000000000000000,sc=E00007018297C180,idx=230)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07EA0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07ea2 req_idx=231 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07EA0 idx=231
mptbase: ioc0: Got TURBO reply req_idx=000e00e7
mptscsih: ioc0: ScsiDone (mf=E000070182A07EA0,mr=0000000000000000,sc=E00007018297C180,idx=231)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07F00
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07f02 req_idx=232 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07F00 idx=232
mptbase: ioc0: Got TURBO reply req_idx=000e00e8
mptscsih: ioc0: ScsiDone (mf=E000070182A07F00,mr=0000000000000000,sc=E00007018297C180,idx=232)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07F60
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a07f62 req_idx=233 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07F60 idx=233
mptbase: ioc0: Got TURBO reply req_idx=000e00e9
mptscsih: ioc0: ScsiDone (mf=E000070182A07F60,mr=0000000000000000,sc=E00007018297C180,idx=233)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A07FC0
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a07fc3 req_idx=234 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C180) mf=E000070182A07FC0 idx=234
mptbase: ioc0: Got TURBO reply req_idx=000e00ea
mptscsih: ioc0: ScsiDone (mf=E000070182A07FC0,mr=0000000000000000,sc=E00007018297C180,idx=234)
mptscsih: ioc1: qcmd: SCpnt=E00007018297C180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B05EC0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b05ec2 req_idx=146 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E00007018297C180) mf=E000070182B05EC0 idx=146
mptbase: ioc1: Got TURBO reply req_idx=000e0092
mptscsih: ioc1: ScsiDone (mf=E000070182B05EC0,mr=0000000000000000,sc=E00007018297C180,idx=146)
mptscsih: ioc1: qcmd: SCpnt=E00007018297C600, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B05F20
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b05f22 req_idx=147 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E00007018297C600) mf=E000070182B05F20 idx=147
mptbase: ioc1: Got TURBO reply req_idx=000e0093
mptscsih: ioc1: ScsiDone (mf=E000070182B05F20,mr=0000000000000000,sc=E00007018297C600,idx=147)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B05F80
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b05f82 req_idx=148 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B05F80 idx=148
mptbase: ioc1: Got TURBO reply req_idx=000e0094
mptscsih: ioc1: ScsiDone (mf=E000070182B05F80,mr=0000000000000000,sc=E0000701829A0180,idx=148)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B05FE0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b05fe2 req_idx=149 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B05FE0 idx=149
mptbase: ioc1: Got TURBO reply req_idx=000e0095
mptscsih: ioc1: ScsiDone (mf=E000070182B05FE0,mr=0000000000000000,sc=E0000701829A0180,idx=149)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06040
mptscsih: ioc1: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc1: mf_dma_addr=82b06043 req_idx=150 RequestNB=3
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06040 idx=150
mptbase: ioc1: Got TURBO reply req_idx=000e0096
mptscsih: ioc1: ScsiDone (mf=E000070182B06040,mr=0000000000000000,sc=E0000701829A0180,idx=150)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B060A0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b060a2 req_idx=151 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B060A0 idx=151
mptbase: ioc1: Got TURBO reply req_idx=000e0097
mptscsih: ioc1: ScsiDone (mf=E000070182B060A0,mr=0000000000000000,sc=E0000701829A0180,idx=151)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06100
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06102 req_idx=152 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06100 idx=152
mptbase: ioc1: Got TURBO reply req_idx=000e0098
mptscsih: ioc1: ScsiDone (mf=E000070182B06100,mr=0000000000000000,sc=E0000701829A0180,idx=152)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06160
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06162 req_idx=153 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06160 idx=153
mptbase: ioc1: Got TURBO reply req_idx=000e0099
mptscsih: ioc1: ScsiDone (mf=E000070182B06160,mr=0000000000000000,sc=E0000701829A0180,idx=153)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B061C0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b061c2 req_idx=154 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B061C0 idx=154
mptbase: ioc1: Got TURBO reply req_idx=000e009a
mptscsih: ioc1: ScsiDone (mf=E000070182B061C0,mr=0000000000000000,sc=E0000701829A0180,idx=154)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06220
mptscsih: ioc1: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc1: mf_dma_addr=82b06223 req_idx=155 RequestNB=3
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06220 idx=155
mptbase: ioc1: Got TURBO reply req_idx=000e009b
mptscsih: ioc1: ScsiDone (mf=E000070182B06220,mr=0000000000000000,sc=E0000701829A0180,idx=155)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06280
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06282 req_idx=156 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06280 idx=156
mptbase: ioc1: Got TURBO reply req_idx=000e009c
mptscsih: ioc1: ScsiDone (mf=E000070182B06280,mr=0000000000000000,sc=E0000701829A0180,idx=156)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B062E0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b062e2 req_idx=157 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B062E0 idx=157
mptbase: ioc1: Got TURBO reply req_idx=000e009d
mptscsih: ioc1: ScsiDone (mf=E000070182B062E0,mr=0000000000000000,sc=E0000701829A0180,idx=157)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06340
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06342 req_idx=158 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06340 idx=158
mptbase: ioc1: Got TURBO reply req_idx=000e009e
mptscsih: ioc1: ScsiDone (mf=E000070182B06340,mr=0000000000000000,sc=E0000701829A0180,idx=158)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B063A0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b063a2 req_idx=159 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B063A0 idx=159
mptbase: ioc1: Got TURBO reply req_idx=000e009f
mptscsih: ioc1: ScsiDone (mf=E000070182B063A0,mr=0000000000000000,sc=E0000701829A0180,idx=159)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06400
mptscsih: ioc1: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc1: mf_dma_addr=82b06403 req_idx=160 RequestNB=3
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06400 idx=160
mptbase: ioc1: Got TURBO reply req_idx=000e00a0
mptscsih: ioc1: ScsiDone (mf=E000070182B06400,mr=0000000000000000,sc=E0000701829A0180,idx=160)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06460
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06462 req_idx=161 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06460 idx=161
mptbase: ioc1: Got TURBO reply req_idx=000e00a1
mptscsih: ioc1: ScsiDone (mf=E000070182B06460,mr=0000000000000000,sc=E0000701829A0180,idx=161)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B064C0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b064c2 req_idx=162 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B064C0 idx=162
mptbase: ioc1: Got TURBO reply req_idx=000e00a2
mptscsih: ioc1: ScsiDone (mf=E000070182B064C0,mr=0000000000000000,sc=E0000701829A0180,idx=162)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06520
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06522 req_idx=163 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06520 idx=163
mptbase: ioc1: Got TURBO reply req_idx=000e00a3
mptscsih: ioc1: ScsiDone (mf=E000070182B06520,mr=0000000000000000,sc=E0000701829A0180,idx=163)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06580
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06582 req_idx=164 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06580 idx=164
mptbase: ioc1: Got TURBO reply req_idx=000e00a4
mptscsih: ioc1: ScsiDone (mf=E000070182B06580,mr=0000000000000000,sc=E0000701829A0180,idx=164)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B065E0
mptscsih: ioc1: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc1: mf_dma_addr=82b065e3 req_idx=165 RequestNB=3
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B065E0 idx=165
mptbase: ioc1: Got TURBO reply req_idx=000e00a5
mptscsih: ioc1: ScsiDone (mf=E000070182B065E0,mr=0000000000000000,sc=E0000701829A0180,idx=165)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06640
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06642 req_idx=166 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06640 idx=166
mptbase: ioc1: Got TURBO reply req_idx=000e00a6
mptscsih: ioc1: ScsiDone (mf=E000070182B06640,mr=0000000000000000,sc=E0000701829A0180,idx=166)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B066A0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b066a2 req_idx=167 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B066A0 idx=167
mptbase: ioc1: Got TURBO reply req_idx=000e00a7
mptscsih: ioc1: ScsiDone (mf=E000070182B066A0,mr=0000000000000000,sc=E0000701829A0180,idx=167)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06700
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06702 req_idx=168 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06700 idx=168
mptbase: ioc1: Got TURBO reply req_idx=000e00a8
mptscsih: ioc1: ScsiDone (mf=E000070182B06700,mr=0000000000000000,sc=E0000701829A0180,idx=168)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06760
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06762 req_idx=169 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06760 idx=169
mptbase: ioc1: Got TURBO reply req_idx=000e00a9
mptscsih: ioc1: ScsiDone (mf=E000070182B06760,mr=0000000000000000,sc=E0000701829A0180,idx=169)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B067C0
mptscsih: ioc1: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc1: mf_dma_addr=82b067c3 req_idx=170 RequestNB=3
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B067C0 idx=170
mptbase: ioc1: Got TURBO reply req_idx=000e00aa
mptscsih: ioc1: ScsiDone (mf=E000070182B067C0,mr=0000000000000000,sc=E0000701829A0180,idx=170)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06820
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06822 req_idx=171 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06820 idx=171
mptbase: ioc1: Got TURBO reply req_idx=000e00ab
mptscsih: ioc1: ScsiDone (mf=E000070182B06820,mr=0000000000000000,sc=E0000701829A0180,idx=171)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06880
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06882 req_idx=172 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06880 idx=172
mptbase: ioc1: Got TURBO reply req_idx=000e00ac
mptscsih: ioc1: ScsiDone (mf=E000070182B06880,mr=0000000000000000,sc=E0000701829A0180,idx=172)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B068E0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b068e2 req_idx=173 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B068E0 idx=173
mptbase: ioc1: Got TURBO reply req_idx=000e00ad
mptscsih: ioc1: ScsiDone (mf=E000070182B068E0,mr=0000000000000000,sc=E0000701829A0180,idx=173)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06940
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06942 req_idx=174 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06940 idx=174
mptbase: ioc1: Got TURBO reply req_idx=000e00ae
mptscsih: ioc1: ScsiDone (mf=E000070182B06940,mr=0000000000000000,sc=E0000701829A0180,idx=174)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B069A0
mptscsih: ioc1: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc1: mf_dma_addr=82b069a3 req_idx=175 RequestNB=3
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B069A0 idx=175
mptbase: ioc1: Got TURBO reply req_idx=000e00af
mptscsih: ioc1: ScsiDone (mf=E000070182B069A0,mr=0000000000000000,sc=E0000701829A0180,idx=175)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06A00
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06a02 req_idx=176 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06A00 idx=176
mptbase: ioc1: Got TURBO reply req_idx=000e00b0
mptscsih: ioc1: ScsiDone (mf=E000070182B06A00,mr=0000000000000000,sc=E0000701829A0180,idx=176)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06A60
mptscsih: ioc1: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc1: mf_dma_addr=82b06a63 req_idx=177 RequestNB=3
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06A60 idx=177
mptbase: ioc1: Got TURBO reply req_idx=000e00b1
mptscsih: ioc1: ScsiDone (mf=E000070182B06A60,mr=0000000000000000,sc=E0000701829A0180,idx=177)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06AC0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06ac2 req_idx=178 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06AC0 idx=178
mptbase: ioc1: Got TURBO reply req_idx=000e00b2
mptscsih: ioc1: ScsiDone (mf=E000070182B06AC0,mr=0000000000000000,sc=E0000701829A0180,idx=178)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06B20
mptscsih: ioc1: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc1: mf_dma_addr=82b06b23 req_idx=179 RequestNB=3
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06B20 idx=179
mptbase: ioc1: Got TURBO reply req_idx=000e00b3
mptscsih: ioc1: ScsiDone (mf=E000070182B06B20,mr=0000000000000000,sc=E0000701829A0180,idx=179)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06B80
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06b82 req_idx=180 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06B80 idx=180
mptbase: ioc1: Got TURBO reply req_idx=000e00b4
mptscsih: ioc1: ScsiDone (mf=E000070182B06B80,mr=0000000000000000,sc=E0000701829A0180,idx=180)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06BE0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06be2 req_idx=181 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06BE0 idx=181
mptbase: ioc1: Got TURBO reply req_idx=000e00b5
mptscsih: ioc1: ScsiDone (mf=E000070182B06BE0,mr=0000000000000000,sc=E0000701829A0180,idx=181)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06C40
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06c42 req_idx=182 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06C40 idx=182
mptbase: ioc1: Got TURBO reply req_idx=000e00b6
mptscsih: ioc1: ScsiDone (mf=E000070182B06C40,mr=0000000000000000,sc=E0000701829A0180,idx=182)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06CA0
mptscsih: ioc1: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc1: mf_dma_addr=82b06ca2 req_idx=183 RequestNB=2
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06CA0 idx=183
mptbase: ioc1: Got TURBO reply req_idx=000e00b7
mptscsih: ioc1: ScsiDone (mf=E000070182B06CA0,mr=0000000000000000,sc=E0000701829A0180,idx=183)
mptscsih: ioc1: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc1: mpt_get_msg_frame(14,1), got mf=E000070182B06D00
mptscsih: ioc1: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc1: mf_dma_addr=82b06d03 req_idx=184 RequestNB=3
mptscsih: ioc1: Issued SCSI cmd (E0000701829A0180) mf=E000070182B06D00 idx=184
mptbase: ioc1: Got TURBO reply req_idx=000e00b8
mptscsih: ioc1: ScsiDone (mf=E000070182B06D00,mr=0000000000000000,sc=E0000701829A0180,idx=184)
mptscsih: ioc0: qcmd: SCpnt=E0000701829A0180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08020
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08022 req_idx=235 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000701829A0180) mf=E000070182A08020 idx=235
mptbase: ioc0: Got TURBO reply req_idx=000e00eb
mptscsih: ioc0: ScsiDone (mf=E000070182A08020,mr=0000000000000000,sc=E0000701829A0180,idx=235)
mptscsih: ioc0: qcmd: SCpnt=E0000701829A0300, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08080
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a08083 req_idx=236 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E0000701829A0300) mf=E000070182A08080 idx=236
mptbase: ioc0: Got TURBO reply req_idx=000e00ec
mptscsih: ioc0: ScsiDone (mf=E000070182A08080,mr=0000000000000000,sc=E0000701829A0300,idx=236)
mptscsih: ioc0: qcmd: SCpnt=E0000701829A0480, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A080E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a080e2 req_idx=237 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000701829A0480) mf=E000070182A080E0 idx=237
mptbase: ioc0: Got TURBO reply req_idx=000e00ed
mptscsih: ioc0: ScsiDone (mf=E000070182A080E0,mr=0000000000000000,sc=E0000701829A0480,idx=237)
mptscsih: ioc0: qcmd: SCpnt=E0000701829A0600, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08140
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08142 req_idx=238 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000701829A0600) mf=E000070182A08140 idx=238
mptbase: ioc0: Got TURBO reply req_idx=000e00ee
mptscsih: ioc0: ScsiDone (mf=E000070182A08140,mr=0000000000000000,sc=E0000701829A0600,idx=238)
mptscsih: ioc0: qcmd: SCpnt=E0000701829A0780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A081A0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a081a2 req_idx=239 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000701829A0780) mf=E000070182A081A0 idx=239
mptbase: ioc0: Got TURBO reply req_idx=000e00ef
mptscsih: ioc0: ScsiDone (mf=E000070182A081A0,mr=0000000000000000,sc=E0000701829A0780,idx=239)
mptscsih: ioc0: qcmd: SCpnt=E0000701829A0900, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08200
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08202 req_idx=240 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000701829A0900) mf=E000070182A08200 idx=240
mptbase: ioc0: Got TURBO reply req_idx=000e00f0
mptscsih: ioc0: ScsiDone (mf=E000070182A08200,mr=0000000000000000,sc=E0000701829A0900,idx=240)
mptscsih: ioc0: qcmd: SCpnt=E0000701829A0A80, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08260
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08262 req_idx=241 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000701829A0A80) mf=E000070182A08260 idx=241
mptbase: ioc0: Got TURBO reply req_idx=000e00f1
mptscsih: ioc0: ScsiDone (mf=E000070182A08260,mr=0000000000000000,sc=E0000701829A0A80,idx=241)
mptscsih: ioc0: qcmd: SCpnt=E0000701829A0C00, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A082C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a082c2 req_idx=242 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000701829A0C00) mf=E000070182A082C0 idx=242
mptbase: ioc0: Got TURBO reply req_idx=000e00f2
mptscsih: ioc0: ScsiDone (mf=E000070182A082C0,mr=0000000000000000,sc=E0000701829A0C00,idx=242)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08320
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08322 req_idx=243 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A08320 idx=243
mptbase: ioc0: Got TURBO reply req_idx=000e00f3
mptscsih: ioc0: ScsiDone (mf=E000070182A08320,mr=0000000000000000,sc=E00007018297C780,idx=243)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Setting up other filesystems.
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08380
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08382 req_idx=244 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A08380 idx=244
Setting up new rmptbase: ioc0: Got TURBO reply req_idx=000e00f4
mptscsih: ioc0: ScsiDone (mf=E000070182A08380,mr=0000000000000000,sc=E00007018297C780,idx=244)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A083E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a083e2 req_idx=245 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A083E0 idx=245
oot fs
mptbase: ioc0: Got TURBO reply req_idx=000e00f5
mptscsih: ioc0: ScsiDone (mf=E000070182A083E0,mr=0000000000000000,sc=E00007018297C780,idx=245)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08440
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08442 req_idx=246 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A08440 idx=246
mptbase: ioc0: Got TURBO reply req_idx=000e00f6
mptscsih: ioc0: ScsiDone (mf=E000070182A08440,mr=0000000000000000,sc=E00007018297C780,idx=246)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A084A0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a084a2 req_idx=247 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A084A0 idx=247
mptbase: ioc0: Got TURBO reply req_idx=000e00f7
mptscsih: ioc0: ScsiDone (mf=E000070182A084A0,mr=0000000000000000,sc=E00007018297C780,idx=247)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08500
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08502 req_idx=248 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A08500 idx=248
mptbase: ioc0: Got TURBO reply req_idx=000e00f8
mptscsih: ioc0: ScsiDone (mf=E000070182A08500,mr=0000000000000000,sc=E00007018297C780,idx=248)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08560
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
no fstab.sys, momptbase: ioc0: mf_dma_addr=82a08562 req_idx=249 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A08560 idx=249
mptbase: ioc0: Got TURBO reply req_idx=000e00f9
mptscsih: ioc0: ScsiDone (mf=E000070182A08560,mr=0000000000000000,sc=E00007018297C780,idx=249)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A085C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a085c2 req_idx=250 RequestNB=2
unting internal mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A085C0 idx=250
mptbase: ioc0: Got TURBO reply req_idx=000e00fa
mptscsih: ioc0: ScsiDone (mf=E000070182A085C0,mr=0000000000000000,sc=E00007018297C780,idx=250)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08620
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08622 req_idx=251 RequestNB=2
defaults
Switchmptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A08620 idx=251
mptbase: ioc0: Got TURBO reply req_idx=000e00fb
mptscsih: ioc0: ScsiDone (mf=E000070182A08620,mr=0000000000000000,sc=E00007018297C780,idx=251)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08680
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
ing to new root mptbase: ioc0: mf_dma_addr=82a08682 req_idx=252 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A08680 idx=252
mptbase: ioc0: Got TURBO reply req_idx=000e00fc
mptscsih: ioc0: ScsiDone (mf=E000070182A08680,mr=0000000000000000,sc=E00007018297C780,idx=252)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A086E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
and running initmptbase: ioc0: mf_dma_addr=82a086e2 req_idx=253 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A086E0 idx=253
mptbase: ioc0: Got TURBO reply req_idx=000e00fd
mptscsih: ioc0: ScsiDone (mf=E000070182A086E0,mr=0000000000000000,sc=E00007018297C780,idx=253)
.
unmounting olmptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A08740
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a08742 req_idx=254 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A08740 idx=254
mptbase: ioc0: Got TURBO reply req_idx=000e00fe
mptscsih: ioc0: ScsiDone (mf=E000070182A08740,mr=0000000000000000,sc=E00007018297C780,idx=254)
d /dev
unmountimptscsih: ioc0: qcmd: SCpnt=E000072181340180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02860
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02862 req_idx=1 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E000072181340180) mf=E000070182A02860 idx=1
mptbase: ioc0: Got TURBO reply req_idx=000e0001
mptscsih: ioc0: ScsiDone (mf=E000070182A02860,mr=0000000000000000,sc=E000072181340180,idx=1)
ng old /proc
unmptscsih: ioc0: qcmd: SCpnt=E000072181340300, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A028C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a028c2 req_idx=2 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E000072181340300) mf=E000070182A028C0 idx=2
mptbase: ioc0: Got TURBO reply req_idx=000e0002
mounting old /symptscsih: ioc0: ScsiDone (mf=E000070182A028C0,mr=0000000000000000,sc=E000072181340300,idx=2)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02920
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02922 req_idx=3 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02920 idx=3
mptbase: ioc0: Got TURBO reply req_idx=000e0003
s
mptscsih: ioc0: ScsiDone (mf=E000070182A02920,mr=0000000000000000,sc=E00007018297C780,idx=3)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02980
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02982 req_idx=4 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02980 idx=4
mptbase: ioc0: Got TURBO reply req_idx=000e0004
mptscsih: ioc0: ScsiDone (mf=E000070182A02980,mr=0000000000000000,sc=E00007018297C780,idx=4)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A029E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a029e2 req_idx=5 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A029E0 idx=5
mptbase: ioc0: Got TURBO reply req_idx=000e0005
mptscsih: ioc0: ScsiDone (mf=E000070182A029E0,mr=0000000000000000,sc=E00007018297C780,idx=5)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02A40
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02a42 req_idx=6 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02A40 idx=6
mptbase: ioc0: Got TURBO reply req_idx=000e0006
mptscsih: ioc0: ScsiDone (mf=E000070182A02A40,mr=0000000000000000,sc=E00007018297C780,idx=6)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02AA0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02aa2 req_idx=7 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02AA0 idx=7
mptbase: ioc0: Got TURBO reply req_idx=000e0007
mptscsih: ioc0: ScsiDone (mf=E000070182A02AA0,mr=0000000000000000,sc=E00007018297C780,idx=7)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02B00
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a02b03 req_idx=8 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02B00 idx=8
mptbase: ioc0: Got TURBO reply req_idx=000e0008
mptscsih: ioc0: ScsiDone (mf=E000070182A02B00,mr=0000000000000000,sc=E00007018297C780,idx=8)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02B60
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02b62 req_idx=9 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02B60 idx=9
mptbase: ioc0: Got TURBO reply req_idx=000e0009
mptscsih: ioc0: ScsiDone (mf=E000070182A02B60,mr=0000000000000000,sc=E00007018297C780,idx=9)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02BC0
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a02bc3 req_idx=10 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02BC0 idx=10
mptbase: ioc0: Got TURBO reply req_idx=000e000a
mptscsih: ioc0: ScsiDone (mf=E000070182A02BC0,mr=0000000000000000,sc=E00007018297C780,idx=10)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02C20
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02c22 req_idx=11 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02C20 idx=11
mptbase: ioc0: Got TURBO reply req_idx=000e000b
mptscsih: ioc0: ScsiDone (mf=E000070182A02C20,mr=0000000000000000,sc=E00007018297C780,idx=11)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02C80
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02c82 req_idx=12 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02C80 idx=12
mptbase: ioc0: Got TURBO reply req_idx=000e000c
mptscsih: ioc0: ScsiDone (mf=E000070182A02C80,mr=0000000000000000,sc=E00007018297C780,idx=12)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02CE0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02ce2 req_idx=13 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02CE0 idx=13
mptbase: ioc0: Got TURBO reply req_idx=000e000d
mptscsih: ioc0: ScsiDone (mf=E000070182A02CE0,mr=0000000000000000,sc=E00007018297C780,idx=13)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02D40
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02d42 req_idx=14 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02D40 idx=14
mptbase: ioc0: Got TURBO reply req_idx=000e000e
mptscsih: ioc0: ScsiDone (mf=E000070182A02D40,mr=0000000000000000,sc=E00007018297C780,idx=14)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02DA0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02da2 req_idx=15 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02DA0 idx=15
mptbase: ioc0: Got TURBO reply req_idx=000e000f
mptscsih: ioc0: ScsiDone (mf=E000070182A02DA0,mr=0000000000000000,sc=E00007018297C780,idx=15)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02E00
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02e02 req_idx=16 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02E00 idx=16
mptbase: ioc0: Got TURBO reply req_idx=000e0010
mptscsih: ioc0: ScsiDone (mf=E000070182A02E00,mr=0000000000000000,sc=E00007018297C780,idx=16)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02E60
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02e62 req_idx=17 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02E60 idx=17
mptbase: ioc0: Got TURBO reply req_idx=000e0011
mptscsih: ioc0: ScsiDone (mf=E000070182A02E60,mr=0000000000000000,sc=E00007018297C780,idx=17)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02EC0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02ec2 req_idx=18 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02EC0 idx=18
mptbase: ioc0: Got TURBO reply req_idx=000e0012
mptscsih: ioc0: ScsiDone (mf=E000070182A02EC0,mr=0000000000000000,sc=E00007018297C780,idx=18)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02F20
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02f22 req_idx=19 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02F20 idx=19
mptbase: ioc0: Got TURBO reply req_idx=000e0013
mptscsih: ioc0: ScsiDone (mf=E000070182A02F20,mr=0000000000000000,sc=E00007018297C780,idx=19)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02F80
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a02f83 req_idx=20 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02F80 idx=20
mptbase: ioc0: Got TURBO reply req_idx=000e0014
mptscsih: ioc0: ScsiDone (mf=E000070182A02F80,mr=0000000000000000,sc=E00007018297C780,idx=20)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A02FE0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a02fe2 req_idx=21 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A02FE0 idx=21
mptbase: ioc0: Got TURBO reply req_idx=000e0015
mptscsih: ioc0: ScsiDone (mf=E000070182A02FE0,mr=0000000000000000,sc=E00007018297C780,idx=21)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03040
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03042 req_idx=22 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03040 idx=22
mptbase: ioc0: Got TURBO reply req_idx=000e0016
mptscsih: ioc0: ScsiDone (mf=E000070182A03040,mr=0000000000000000,sc=E00007018297C780,idx=22)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A030A0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a030a2 req_idx=23 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A030A0 idx=23
mptbase: ioc0: Got TURBO reply req_idx=000e0017
mptscsih: ioc0: ScsiDone (mf=E000070182A030A0,mr=0000000000000000,sc=E00007018297C780,idx=23)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03100
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a03103 req_idx=24 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03100 idx=24
mptbase: ioc0: Got TURBO reply req_idx=000e0018
mptscsih: ioc0: ScsiDone (mf=E000070182A03100,mr=0000000000000000,sc=E00007018297C780,idx=24)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03160
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03162 req_idx=25 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03160 idx=25
mptbase: ioc0: Got TURBO reply req_idx=000e0019
mptscsih: ioc0: ScsiDone (mf=E000070182A03160,mr=0000000000000000,sc=E00007018297C780,idx=25)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A031C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a031c2 req_idx=26 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A031C0 idx=26
mptbase: ioc0: Got TURBO reply req_idx=000e001a
mptscsih: ioc0: ScsiDone (mf=E000070182A031C0,mr=0000000000000000,sc=E00007018297C780,idx=26)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03220
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a03223 req_idx=27 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03220 idx=27
mptbase: ioc0: Got TURBO reply req_idx=000e001b
mptscsih: ioc0: ScsiDone (mf=E000070182A03220,mr=0000000000000000,sc=E00007018297C780,idx=27)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03280
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03282 req_idx=28 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03280 idx=28
mptbase: ioc0: Got TURBO reply req_idx=000e001c
mptscsih: ioc0: ScsiDone (mf=E000070182A03280,mr=0000000000000000,sc=E00007018297C780,idx=28)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A032E0
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=84
mptbase: ioc0: mf_dma_addr=82a032e3 req_idx=29 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A032E0 idx=29
mptbase: ioc0: Got TURBO reply req_idx=000e001d
mptscsih: ioc0: ScsiDone (mf=E000070182A032E0,mr=0000000000000000,sc=E00007018297C780,idx=29)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03340
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03342 req_idx=30 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03340 idx=30
mptbase: ioc0: Got TURBO reply req_idx=000e001e
mptscsih: ioc0: ScsiDone (mf=E000070182A03340,mr=0000000000000000,sc=E00007018297C780,idx=30)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A033A0
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a033a3 req_idx=31 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A033A0 idx=31
mptbase: ioc0: Got TURBO reply req_idx=000e001f
mptscsih: ioc0: ScsiDone (mf=E000070182A033A0,mr=0000000000000000,sc=E00007018297C780,idx=31)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03400
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a03403 req_idx=32 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03400 idx=32
mptbase: ioc0: Got TURBO reply req_idx=000e0020
mptscsih: ioc0: ScsiDone (mf=E000070182A03400,mr=0000000000000000,sc=E00007018297C780,idx=32)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03460
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=84
mptbase: ioc0: mf_dma_addr=82a03463 req_idx=33 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03460 idx=33
mptbase: ioc0: Got TURBO reply req_idx=000e0021
mptscsih: ioc0: ScsiDone (mf=E000070182A03460,mr=0000000000000000,sc=E00007018297C780,idx=33)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A034C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a034c2 req_idx=34 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A034C0 idx=34
mptbase: ioc0: Got TURBO reply req_idx=000e0022
mptscsih: ioc0: ScsiDone (mf=E000070182A034C0,mr=0000000000000000,sc=E00007018297C780,idx=34)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03520
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=84
mptbase: ioc0: mf_dma_addr=82a03523 req_idx=35 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03520 idx=35
mptbase: ioc0: Got TURBO reply req_idx=000e0023
mptscsih: ioc0: ScsiDone (mf=E000070182A03520,mr=0000000000000000,sc=E00007018297C780,idx=35)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03580
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a03583 req_idx=36 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03580 idx=36
mptbase: ioc0: Got TURBO reply req_idx=000e0024
mptscsih: ioc0: ScsiDone (mf=E000070182A03580,mr=0000000000000000,sc=E00007018297C780,idx=36)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A035E0
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=84
mptbase: ioc0: mf_dma_addr=82a035e3 req_idx=37 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A035E0 idx=37
mptbase: ioc0: Got TURBO reply req_idx=000e0025
mptscsih: ioc0: ScsiDone (mf=E000070182A035E0,mr=0000000000000000,sc=E00007018297C780,idx=37)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03640
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=84
mptbase: ioc0: mf_dma_addr=82a03643 req_idx=38 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03640 idx=38
mptbase: ioc0: Got TURBO reply req_idx=000e0026
mptscsih: ioc0: ScsiDone (mf=E000070182A03640,mr=0000000000000000,sc=E00007018297C780,idx=38)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A036A0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a036a2 req_idx=39 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A036A0 idx=39
mptbase: ioc0: Got TURBO reply req_idx=000e0027
mptscsih: ioc0: ScsiDone (mf=E000070182A036A0,mr=0000000000000000,sc=E00007018297C780,idx=39)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03700
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03702 req_idx=40 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03700 idx=40
mptbase: ioc0: Got TURBO reply req_idx=000e0028
mptscsih: ioc0: ScsiDone (mf=E000070182A03700,mr=0000000000000000,sc=E00007018297C780,idx=40)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03760
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a03763 req_idx=41 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03760 idx=41
mptbase: ioc0: Got TURBO reply req_idx=000e0029
mptscsih: ioc0: ScsiDone (mf=E000070182A03760,mr=0000000000000000,sc=E00007018297C780,idx=41)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A037C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a037c2 req_idx=42 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A037C0 idx=42
mptbase: ioc0: Got TURBO reply req_idx=000e002a
mptscsih: ioc0: ScsiDone (mf=E000070182A037C0,mr=0000000000000000,sc=E00007018297C780,idx=42)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03820
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=84
mptbase: ioc0: mf_dma_addr=82a03823 req_idx=43 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03820 idx=43
mptbase: ioc0: Got TURBO reply req_idx=000e002b
mptscsih: ioc0: ScsiDone (mf=E000070182A03820,mr=0000000000000000,sc=E00007018297C780,idx=43)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03880
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=84
mptbase: ioc0: mf_dma_addr=82a03883 req_idx=44 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03880 idx=44
mptbase: ioc0: Got TURBO reply req_idx=000e002c
mptscsih: ioc0: ScsiDone (mf=E000070182A03880,mr=0000000000000000,sc=E00007018297C780,idx=44)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A038E0
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=84
mptbase: ioc0: mf_dma_addr=82a038e3 req_idx=45 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A038E0 idx=45
mptbase: ioc0: Got TURBO reply req_idx=000e002d
mptscsih: ioc0: ScsiDone (mf=E000070182A038E0,mr=0000000000000000,sc=E00007018297C780,idx=45)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03940
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03942 req_idx=46 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03940 idx=46
mptbase: ioc0: Got TURBO reply req_idx=000e002e
mptscsih: ioc0: ScsiDone (mf=E000070182A03940,mr=0000000000000000,sc=E00007018297C780,idx=46)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A039A0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a039a2 req_idx=47 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A039A0 idx=47
mptbase: ioc0: Got TURBO reply req_idx=000e002f
mptscsih: ioc0: ScsiDone (mf=E000070182A039A0,mr=0000000000000000,sc=E00007018297C780,idx=47)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03A00
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a03a03 req_idx=48 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03A00 idx=48
mptbase: ioc0: Got TURBO reply req_idx=000e0030
mptscsih: ioc0: ScsiDone (mf=E000070182A03A00,mr=0000000000000000,sc=E00007018297C780,idx=48)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03A60
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03a62 req_idx=49 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03A60 idx=49
mptbase: ioc0: Got TURBO reply req_idx=000e0031
mptscsih: ioc0: ScsiDone (mf=E000070182A03A60,mr=0000000000000000,sc=E00007018297C780,idx=49)
mptscsih: ioc0: qcmd: SCpnt=E0000761810D4300, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03AC0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03ac2 req_idx=50 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000761810D4300) mf=E000070182A03AC0 idx=50
mptbase: ioc0: Got TURBO reply req_idx=000e0032
mptscsih: ioc0: ScsiDone (mf=E000070182A03AC0,mr=0000000000000000,sc=E0000761810D4300,idx=50)
mptscsih: ioc0: qcmd: SCpnt=E0000701825B4000, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03B20
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03b22 req_idx=51 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000701825B4000) mf=E000070182A03B20 idx=51
mptbase: ioc0: Got TURBO reply req_idx=000e0033
mptscsih: ioc0: ScsiDone (mf=E000070182A03B20,mr=0000000000000000,sc=E0000701825B4000,idx=51)
mptscsih: ioc0: qcmd: SCpnt=E0000701825B4180, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03B80
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03b82 req_idx=52 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E0000701825B4180) mf=E000070182A03B80 idx=52
mptbase: ioc0: Got TURBO reply req_idx=000e0034
mptscsih: ioc0: ScsiDone (mf=E000070182A03B80,mr=0000000000000000,sc=E0000701825B4180,idx=52)
mptscsih: ioc0: qcmd: SCpnt=E0000701825B4300, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03BE0
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a03be3 req_idx=53 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E0000701825B4300) mf=E000070182A03BE0 idx=53
mptbase: ioc0: Got TURBO reply req_idx=000e0035
mptscsih: ioc0: ScsiDone (mf=E000070182A03BE0,mr=0000000000000000,sc=E0000701825B4300,idx=53)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03C40
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03c42 req_idx=54 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03C40 idx=54
mptbase: ioc0: Got TURBO reply req_idx=000e0036
mptscsih: ioc0: ScsiDone (mf=E000070182A03C40,mr=0000000000000000,sc=E00007018297C780,idx=54)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03CA0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03ca2 req_idx=55 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03CA0 idx=55
mptbase: ioc0: Got TURBO reply req_idx=000e0037
mptscsih: ioc0: ScsiDone (mf=E000070182A03CA0,mr=0000000000000000,sc=E00007018297C780,idx=55)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03D00
mptscsih: ioc0: Single Buffer RequestNB=3, sgeOffset=72
mptbase: ioc0: mf_dma_addr=82a03d03 req_idx=56 RequestNB=3
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03D00 idx=56
mptbase: ioc0: Got TURBO reply req_idx=000e0038
mptscsih: ioc0: ScsiDone (mf=E000070182A03D00,mr=0000000000000000,sc=E00007018297C780,idx=56)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03D60
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03d62 req_idx=57 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03D60 idx=57
mptbase: ioc0: Got TURBO reply req_idx=000e0039
mptscsih: ioc0: ScsiDone (mf=E000070182A03D60,mr=0000000000000000,sc=E00007018297C780,idx=57)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03DC0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03dc2 req_idx=58 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03DC0 idx=58
mptbase: ioc0: Got TURBO reply req_idx=000e003a
mptscsih: ioc0: ScsiDone (mf=E000070182A03DC0,mr=0000000000000000,sc=E00007018297C780,idx=58)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03E20
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03e22 req_idx=59 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03E20 idx=59
mptbase: ioc0: Got TURBO reply req_idx=000e003b
mptscsih: ioc0: ScsiDone (mf=E000070182A03E20,mr=0000000000000000,sc=E00007018297C780,idx=59)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03E80
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03e82 req_idx=60 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03E80 idx=60
mptbase: ioc0: Got TURBO reply req_idx=000e003c
mptscsih: ioc0: ScsiDone (mf=E000070182A03E80,mr=0000000000000000,sc=E00007018297C780,idx=60)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03EE0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03ee2 req_idx=61 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03EE0 idx=61
mptbase: ioc0: Got TURBO reply req_idx=000e003d
mptscsih: ioc0: ScsiDone (mf=E000070182A03EE0,mr=0000000000000000,sc=E00007018297C780,idx=61)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03F40
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03f42 req_idx=62 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03F40 idx=62
mptbase: ioc0: Got TURBO reply req_idx=000e003e
mptscsih: ioc0: ScsiDone (mf=E000070182A03F40,mr=0000000000000000,sc=E00007018297C780,idx=62)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A03FA0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a03fa2 req_idx=63 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A03FA0 idx=63
mptbase: ioc0: Got TURBO reply req_idx=000e003f
mptscsih: ioc0: ScsiDone (mf=E000070182A03FA0,mr=0000000000000000,sc=E00007018297C780,idx=63)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A04000
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a04002 req_idx=64 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A04000 idx=64
mptbase: ioc0: Got TURBO reply req_idx=000e0040
mptscsih: ioc0: ScsiDone (mf=E000070182A04000,mr=0000000000000000,sc=E00007018297C780,idx=64)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A04060
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a04062 req_idx=65 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A04060 idx=65
mptbase: ioc0: Got TURBO reply req_idx=000e0041
mptscsih: ioc0: ScsiDone (mf=E000070182A04060,mr=0000000000000000,sc=E00007018297C780,idx=65)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A040C0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a040c2 req_idx=66 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A040C0 idx=66
mptbase: ioc0: Got TURBO reply req_idx=000e0042
mptscsih: ioc0: ScsiDone (mf=E000070182A040C0,mr=0000000000000000,sc=E00007018297C780,idx=66)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A04120
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a04122 req_idx=67 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A04120 idx=67
mptbase: ioc0: Got TURBO reply req_idx=000e0043
mptscsih: ioc0: ScsiDone (mf=E000070182A04120,mr=0000000000000000,sc=E00007018297C780,idx=67)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A04180
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a04182 req_idx=68 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A04180 idx=68
mptbase: ioc0: Got TURBO reply req_idx=000e0044
mptscsih: ioc0: ScsiDone (mf=E000070182A04180,mr=0000000000000000,sc=E00007018297C780,idx=68)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C780, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A041E0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a041e2 req_idx=69 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C780) mf=E000070182A041E0 idx=69
mptbase: ioc0: Got TURBO reply req_idx=000e0045
mptscsih: ioc0: ScsiDone (mf=E000070182A041E0,mr=0000000000000000,sc=E00007018297C780,idx=69)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C900, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A04240
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a04242 req_idx=70 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C900) mf=E000070182A04240 idx=70
mptbase: ioc0: Got TURBO reply req_idx=000e0046
mptscsih: ioc0: ScsiDone (mf=E000070182A04240,mr=0000000000000000,sc=E00007018297C900,idx=70)
mptscsih: ioc0: qcmd: SCpnt=E00007018297C900, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A042A0
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a042a2 req_idx=71 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C900) mf=E000070182A042A0 idx=71
mptbase: ioc0: Got TURBO reply req_idx=000e0047
mptscsih: ioc0: ScsiDone (mf=E000070182A042A0,mr=0000000000000000,sc=E00007018297C900,idx=71)
csih: ioc0: qcmd: SCpnt=E00007018297C900, done()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A04300
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a04302 req_idx=72 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C900) mf=E000070182A04300 idx=72
mptbase: ioc0: Got TURBO reply req_idx=000e0048
mptscsih: ioc0: ScsiDone (mf=E000070182A04300,mr=0000000000000000,sc=E00007018297C900,idx=72)
mptscsih: ioc0: qcmd: SCpnt=E00007018297one()=A00000010082F040
mptbase: ioc0: mpt_get_msg_frame(14,0), got mf=E000070182A04360
mptscsih: ioc0: Single Buffer RequestNB=2, sgeOffset=60
mptbase: ioc0: mf_dma_addr=82a04362 req_idx=73 RequestNB=2
mptscsih: ioc0: Issued SCSI cmd (E00007018297C900) mf=E000070182A04360 idx=73

<etc.  until I reset platform.  Maybe too soon?>



