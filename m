From: "Dirk Schneider" <dirk-04617@online.de>
Subject: problems with SCSI_SYM53C8XX_MMIO on alpha
Date: Thu, 16 Mar 2006 18:35:03 -0000
Message-ID: <op.s6iq8pxvzgs1m0@isabell>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:10461 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S1751272AbWCPRiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Mar 2006 12:38:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

Hi,

I am using an Symbios Logic LSI8952U PCI SCSI controller with
two Fujitsu MAH3091MP harddisks in my alpha PC164 box.
On all kernels of the 2.6 series I have tried (some of the earlier
versions did not work), the use of MMIO did not work properly.
I saw a lot of messages like "sym0: unexpected disconnect ..."
and copying data from the harddisk often results in I/O-Errors
and sometimes I have got corrupt data.
Using the swap space from these disk results in kernel crashs.
Switching to PORTIO eleminates all problems and also the 2.4 kernel
series never had these problems.
The last tested kernel is 2.6.16-rc5-mm3 but with the same
behavior. The Kconfig of the mm-tree says:
..., but some machines may have problems ... report the problem to
the maintainer.

The kernel log after modprobe -v sym53c8xx is:
[4223803.729012] sym0: <895> rev 0x2 at pci 0000:00:06.0 irq 16
[4223803.748544] sym0: Symbios NVRAM, ID 7, Fast-40, LVD, parity checking
[4223803.748544] sym0: SCSI BUS has been reset.
[4223803.755380] scsi3 : sym-2.2.2
[4223806.767097]   Vendor: FUJITSU   Model: MAH3091MP         Rev: 5207
[4223806.767097]   Type:   Direct-Access                      ANSI SCSI  
revision: 03
[4223806.767097]  target3:0:0: tagged command queuing enabled, command  
queue depth 16.
[4223806.767097]  target3:0:0: Beginning Domain Validation
[4223806.767097]  target3:0:0: asynchronous
[4223806.774909]  target3:0:0: wide asynchronous
[4223806.775886]  target3:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns,  
offset 31)
[4223806.777839]  target3:0:0: Domain Validation skipping write tests
[4223806.777839]  target3:0:0: Ending Domain Validation
[4223806.967292] SCSI device sda: 17850264 512-byte hdwr sectors (9139 MB)
[4223806.970222] sda: Write Protect is off
[4223806.970222] sda: Mode Sense: ab 00 10 08
[4223806.972175] SCSI device sda: drive cache: write back w/ FUA
[4223806.974128] SCSI device sda: 17850264 512-byte hdwr sectors (9139 MB)
[4223806.977058] sda: Write Protect is off
[4223806.977058] sda: Mode Sense: ab 00 10 08
[4223806.979011] SCSI device sda: drive cache: write back w/ FUA
[4223806.979011]  sda: sda1 sda2 sda3 sda4
[4223806.990730] sd 3:0:0:0: Attached scsi disk sda
[4223806.998542] sym0: unexpected disconnect
[4223807.000495]   Vendor: FUJITSU   Model: MAH3091MP         Rev: 5207
[4223807.000495]   Type:   Direct-Access                      ANSI SCSI  
revision: 03
[4223807.000495]  target3:0:1: tagged command queuing enabled, command  
queue depth 16.
[4223807.000495]  target3:0:1: Beginning Domain Validation
[4223807.001472]  target3:0:1: asynchronous
[4223807.004401]  target3:0:1: wide asynchronous
[4223807.006355]  target3:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns,  
offset 31)
[4223807.008308]  target3:0:1: Domain Validation skipping write tests
[4223807.008308]  target3:0:1: Ending Domain Validation
[4223807.105964] sym0: unexpected disconnect
[4223807.125495] sym0: unexpected disconnect
[4223807.202643] SCSI device sdb: 17850264 512-byte hdwr sectors (9139 MB)
[4223807.205573] sdb: Write Protect is off
[4223807.205573] sdb: Mode Sense: ab 00 10 08
[4223807.207526] SCSI device sdb: drive cache: write back w/ FUA
[4223807.209479] SCSI device sdb: 17850264 512-byte hdwr sectors (9139 MB)
[4223807.212409] sdb: Write Protect is off
[4223807.212409] sdb: Mode Sense: ab 00 10 08
[4223807.214362] SCSI device sdb: drive cache: write back w/ FUA
[4223807.214362]  sdb: sdb1 sdb2 sdb3 sdb4
[4223807.226081] sd 3:0:1:0: Attached scsi disk sdb
[4223807.549323] sym0: unexpected disconnect
[4223807.845221] sym0: unexpected disconnect
[4223811.118657] sym0: unexpected disconnect
[4223811.165532] sym0: unexpected disconnect
[4223811.183110] sym0: unexpected disconnect
[4223811.217290] sym0: unexpected disconnect
[4223811.300298] sym0: unexpected disconnect
[4223811.342290] sym0: unexpected disconnect


The cards lspci -v is:

00:06.0 SCSI storage controller: LSI Logic / Symbios Logic 53c895 (rev 02)
         Subsystem: LSI Logic / Symbios Logic LSI8952U PCI to Ultra2 SCSI  
host adapter
         Flags: bus master, medium devsel, latency 32, IRQ 16
         I/O ports at 8400 [size=256]
         Memory at 02253000 (32-bit, non-prefetchable) [size=256]
         Memory at 02250000 (32-bit, non-prefetchable) [size=4K]
         [virtual] Expansion ROM at 02220000 [disabled] [size=128K]

The System is:
cpu                     : Alpha
cpu model               : EV56
cpu variation           : 0
cpu revision            : 0
cpu serial number       : Linux_is_Great!
system type             : EB164
system variation        : PC164
system revision         : 0
system serial number    : MILO-/aux/KERNE
cycle frequency [Hz]    : 499999200
timer frequency [Hz]    : 1024.00
page size [bytes]       : 8192
phys. address bits      : 40
max. addr. space #      : 127
BogoMIPS                : 990.32
kernel unaligned acc    : 0 (pc=0,va=0)
user unaligned acc      : 0 (pc=0,va=0)
platform string         : N/A
cpus detected           : 0
L1 Icache               : 8K, 1-way, 32b line
L1 Dcache               : 8K, 1-way, 32b line
L2 cache                : 96K, 3-way, 64b line
L3 cache                : 1024K, 1-way, 64b line
linux/.config is:
...

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SAS_CLASS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_SATA is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_NCR53C406A is not set
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=0
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_FC is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_DEBUG is not set
...

If you need further informations please email me.

Thanks
Dirk


-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/m2/
