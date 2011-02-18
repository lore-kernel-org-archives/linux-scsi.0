From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.37: USB Thermaltake Dock: Only see's 1 HDD? [SOLVED, but which
 option fixed it?]
Date: Fri, 18 Feb 2011 16:33:12 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1102181621190.4561@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

[177281.689265] usb 1-1.2: new high speed USB device using ehci_hcd and address 6
[177281.775112] usb 1-1.2: New USB device found, idVendor=152d, idProduct=2352
[177281.775118] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[177281.775122] usb 1-1.2: Product: USB to ATA/ATAPI Bridge
[177281.775125] usb 1-1.2: Manufacturer: JMicron
[177281.775127] usb 1-1.2: SerialNumber: 30220FFFFFFF
[177281.775688] scsi12 : usb-storage 1-1.2:1.0
[177282.776414] scsi 12:0:0:0: Direct-Access     ST310003 40AS                  PQ: 0 ANSI: 2 CCS
[177282.777140] sd 12:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[177282.778210] sd 12:0:0:0: [sdc] Write Protect is off
[177282.778212] sd 12:0:0:0: [sdc] Mode Sense: 34 00 00 00
[177282.778214] sd 12:0:0:0: [sdc] Assuming drive cache: write through
[177282.779634] sd 12:0:0:0: [sdc] Assuming drive cache: write through
[177282.806516]  sdc: unknown partition table
[177282.807881] sd 12:0:0:0: [sdc] Assuming drive cache: write through
[177282.807884] sd 12:0:0:0: [sdc] Attached SCSI disk

When I attach a dock with two HDD's on it in Linux, it only picks up one HDD,
this is with a Thermaltake BlackX Duet, is there a special module/etc
I need to load so it sees both drives on USB?

So I added some additional kernel options and now it seems fixed, but 
this is more of a shotgun approach, instead of rebuilding/rebooting 
several times does anyone know which module enabled support of > 1 HDD on 
the USB dock as shown below?

--- .config-2.6.37-2    2011-01-06 06:35:52.353863142 -0500
+++ .config-2.6.37-3    2011-02-18 16:26:02.194145805 -0500
@@ -1,7 +1,7 @@
  #
  # Automatically generated make config: don't edit
  # Linux/x86_64 2.6.37 Kernel Configuration
-# Thu Jan  6 06:34:12 2011
+# Fri Feb 18 16:25:45 2011
  #
  CONFIG_64BIT=y
  # CONFIG_X86_32 is not set
@@ -701,7 +701,7 @@
  # CONFIG_RAID_ATTRS is not set
  CONFIG_SCSI=y
  CONFIG_SCSI_DMA=y
-# CONFIG_SCSI_TGT is not set
+CONFIG_SCSI_TGT=y
  # CONFIG_SCSI_NETLINK is not set
  CONFIG_SCSI_PROC_FS=y

@@ -713,9 +713,9 @@
  # CONFIG_CHR_DEV_OSST is not set
  CONFIG_BLK_DEV_SR=y
  # CONFIG_BLK_DEV_SR_VENDOR is not set
-# CONFIG_CHR_DEV_SG is not set
-# CONFIG_CHR_DEV_SCH is not set
-# CONFIG_SCSI_MULTI_LUN is not set
+CONFIG_CHR_DEV_SG=y
+CONFIG_CHR_DEV_SCH=y
+CONFIG_SCSI_MULTI_LUN=y
  CONFIG_SCSI_CONSTANTS=y
  # CONFIG_SCSI_LOGGING is not set
  # CONFIG_SCSI_SCAN_ASYNC is not set
@@ -789,7 +789,7 @@
  # CONFIG_ATA_NONSTANDARD is not set
  CONFIG_ATA_VERBOSE_ERROR=y
  # CONFIG_ATA_ACPI is not set
-# CONFIG_SATA_PMP is not set
+CONFIG_SATA_PMP=y

  #
  # Controllers with non-SFF native interface
@@ -842,7 +842,7 @@
  # CONFIG_PATA_HPT3X3 is not set
  # CONFIG_PATA_IT8213 is not set
  # CONFIG_PATA_IT821X is not set
-# CONFIG_PATA_JMICRON is not set
+CONFIG_PATA_JMICRON=y
  # CONFIG_PATA_MARVELL is not set
  # CONFIG_PATA_NETCELL is not set
  # CONFIG_PATA_NINJA32 is not set
@@ -1618,8 +1618,8 @@
  # CONFIG_USB_STORAGE_ALAUDA is not set
  # CONFIG_USB_STORAGE_ONETOUCH is not set
  # CONFIG_USB_STORAGE_KARMA is not set
-# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
-# CONFIG_USB_UAS is not set
+CONFIG_USB_STORAGE_CYPRESS_ATACB=y
+CONFIG_USB_UAS=y
  # CONFIG_USB_LIBUSUAL is not set

--

Now:

[    4.176148] scsi 12:0:0:0: Direct-Access     ST310003 40AS                  PQ: 0 ANSI: 2 CCS
[    4.176370] sd 12:0:0:0: Attached scsi generic sg2 type 0
[    4.176893] scsi 12:0:0:1: Direct-Access     ST310003 40AS                  PQ: 0 ANSI: 2 CCS
[    4.177063] sd 12:0:0:1: Attached scsi generic sg3 type 0
[    4.177264] sd 12:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.178261] sd 12:0:0:0: [sdc] Write Protect is off
[    4.178351] sd 12:0:0:0: [sdc] Mode Sense: 34 00 00 00
[    4.178353] sd 12:0:0:0: [sdc] Assuming drive cache: write through
[    4.178652] sd 12:0:0:1: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.179640] sd 12:0:0:1: [sdd] Write Protect is off
[    4.179762] sd 12:0:0:1: [sdd] Mode Sense: 34 00 00 00
[    4.179763] sd 12:0:0:1: [sdd] Assuming drive cache: write through
[    4.181012] sd 12:0:0:0: [sdc] Assuming drive cache: write through
[    4.182142] sd 12:0:0:1: [sdd] Assuming drive cache: write through
[    4.182643]  sdc: unknown partition table
[    4.183263]  sdd: unknown partition table
[    4.185261] sd 12:0:0:0: [sdc] Assuming drive cache: write through
[    4.185377] sd 12:0:0:0: [sdc] Attached SCSI disk
[    4.186012] sd 12:0:0:1: [sdd] Assuming drive cache: write through
[    4.186135] sd 12:0:0:1: [sdd] Attached SCSI disk

Even smart works when using usbmicron!

Justin.
