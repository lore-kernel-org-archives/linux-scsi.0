From: Bradley Chapman <kakadu_croc@yahoo.com>
Subject: Badness in atomic_dec_and_test with 2.6.0-test9-mm2
Date: Thu, 6 Nov 2003 08:51:45 -0800 (PST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20031106165145.64242.qmail@web40912.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@SteelEye.com>, mdharm-usb@one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

I have recently acquired a 256MB USB flash disk preformatted with the VFAT
filesystem which is recognized by the 2.6.0-test9-mm2 usb_storage driver
and the SCSI subsystem like so:

hub 1-0:1.0: new USB device on port 2, assigned address 5
SCSI subsystem initialized
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
  Vendor: STF       Model: Flash Drive       Rev: 1.89
  Type:   Direct-Access                      ANSI SCSI revision: 02
WARNING: USB Mass Storage data integrity not assured
USB Mass Storage device found at 5
drivers/usb/core/usb.c: registered new driver usb-storage
USB Mass Storage support registered.
SCSI device sda: 512000 512-byte hdwr sectors (262 MB)
sda: Write Protect is off
sda: Mode Sense: 00 06 94 00
sda: assuming drive cache: write through
 sda: sda1
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0

I have compiled the SCSI core, usb_storage and the SCSI disk core as modules.

However, when usb_storage and scsi_mod are unloaded, I get the following
badness message:

drivers/usb/core/usb.c: deregistering driver usb-storage
Badness in atomic_dec_and_test at include/asm/atomic.h:150
Call Trace:
 [<c02184f0>] kobject_put+0x7e/0x80
 [<e4cd2adb>] scsi_remove_host+0x104/0x1a0 [scsi_mod]
 [<e4cc6e5f>] dissociate_dev+0x55/0xd2 [usb_storage]
 [<e4cc7269>] storage_disconnect+0x38/0x48 [usb_storage]
 [<c02c311d>] usb_unbind_interface+0xa4/0xa6
 [<c02845ee>] device_release_driver+0x64/0x66
 [<c0284610>] driver_detach+0x20/0x2e
 [<c028489f>] bus_remove_driver+0x5b/0x97
 [<c0284cb4>] driver_unregister+0x1a/0x46
 [<c02c3277>] usb_deregister+0x31/0x3d
 [<e4cc898b>] usb_stor_exit+0xf/0x13 [usb_storage]
 [<c01460f0>] sys_delete_module+0x139/0x177
 [<c0166031>] sys_munmap+0x58/0x78
 [<c03b8cd6>] sysenter_past_esp+0x43/0x65

Interesting parts of .config (grep "=[y,m]" .config):

CONFIG_SCSI=m
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=m
CONFIG_USB=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y

TIA

Brad

=====
Brad Chapman

Permanent e-mail: kakadu_croc@yahoo.com

__________________________________
Do you Yahoo!?
Protect your identity with Yahoo! Mail AddressGuard
http://antispam.yahoo.com/whatsnewfree


-------------------------------------------------------
This SF.net email is sponsored by: SF.net Giveback Program.
Does SourceForge.net help you be more productive?  Does it
help you create better code?   SHARE THE LOVE, and help us help
YOU!  Click Here: http://sourceforge.net/donate/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
