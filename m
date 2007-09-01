From: Andreas Koenecke <akoenecke@akoenecke.de>
Subject: Re: usb-storage and Motorola Z6
Date: Sat, 1 Sep 2007 13:56:26 +0200
Message-ID: <20070901115626.GA21586@kocom.akoenecke.de>
References: <20070831190405.GA7506@kocom.akoenecke.de>
	<Pine.LNX.4.44L0.0708311636090.24258-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708311636090.24258-100000@netrider.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: USB users list <linux-usb-users@lists.sourceforge.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

* Freitag, 31. August 2007 um 16:56 (-0400) schrieb Alan Stern:
> 
> All those reset messages are caused by a bug in the device.  Every 
> command sent to the device is labelled with a "Tag" value; it shows up 
> in the debugging log on each "Bulk Command" line as the number 
> following the T.  For example:
> 
> 	Bulk Command S 0x43425355 T 0x4 L 18 F 128 Trg 0 LUN 0 CL 6
> 
> Here the Tag is 0x4.  In its status response, the device must include a
> matching Tag value to indicate which command the status is for.  If you
> look at the debugging log, you'll see the status line for this
> particular command was:
> 
> 	Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
> 
> The Tag is 0x3, which doesn't match!  The device made this mistake 15
> times in 410 commands, apparently at random, and each time the computer
> issued a reset to try and fix the problem.  That's a pretty serious 
> bug in the Z6.
> 
> If you want to work around this bug, you can edit the file 
> drivers/usb/storage/transport.c.  In the usb_stor_Bulk_transport() 
> routine, edit this line:
> 
>         if (bcs->Tag != us->tag || bcs->Status > US_BULK_STAT_PHASE) {
> 
> and change it to:
> 
>         if (bcs->Status > US_BULK_STAT_PHASE) {

I' done this, too.
The non-debug-messages are now:
----------------------------------------------------------------------------
Sep  1 13:09:17 kocom kernel: usb 3-1: new high speed USB device using ehci_hcd and address 12
Sep  1 13:09:17 kocom kernel: usb 3-1: configuration #1 chosen from 1 choice
Sep  1 13:09:17 kocom kernel: Initializing USB Mass Storage driver...
Sep  1 13:09:17 kocom kernel: scsi7 : SCSI emulation for USB Mass Storage devices
Sep  1 13:09:17 kocom kernel: usb-storage: device found at 12
Sep  1 13:09:17 kocom kernel: usb-storage: waiting for device to settle before scanning
Sep  1 13:09:17 kocom kernel: usbcore: registered new interface driver usb-storage
Sep  1 13:09:17 kocom kernel: USB Mass Storage support registered.
Sep  1 13:09:22 kocom kernel: usb-storage: device scan complete
Sep  1 13:09:22 kocom kernel: scsi 7:0:0:0: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
Sep  1 13:09:22 kocom kernel: scsi 7:0:0:1: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
Sep  1 13:09:22 kocom kernel: sd 7:0:0:0: [sdb] Attached SCSI removable disk
Sep  1 13:09:22 kocom kernel: sd 7:0:0:0: Attached scsi generic sg2 type 0
Sep  1 13:09:22 kocom kernel: sd 7:0:0:1: [sdc] Attached SCSI removable disk
Sep  1 13:09:22 kocom kernel: sd 7:0:0:1: Attached scsi generic sg3 type 0
Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] 1983495 512-byte hardware sectors (1016 MB)
Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Write Protect is off
Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Assuming drive cache: write through
Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] 1983495 512-byte hardware sectors (1016 MB)
Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Write Protect is off
Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Assuming drive cache: write through
Sep  1 13:09:28 kocom kernel:  sdb:
Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] 128673 512-byte hardware sectors (66 MB)
Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Write Protect is off
Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Mode Sense: 03 00 00 00
Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Assuming drive cache: write through
Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] 128673 512-byte hardware sectors (66 MB)
Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Write Protect is off
Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Mode Sense: 03 00 00 00
Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Assuming drive cache: write through
Sep  1 13:09:28 kocom kernel:  sdc:
Sep  1 13:09:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 12
Sep  1 13:10:14 kocom kernel: usb 3-1: device descriptor read/64, error -110
Sep  1 13:10:29 kocom kernel: usb 3-1: device descriptor read/64, error -110
Sep  1 13:10:29 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 12
Sep  1 13:10:44 kocom kernel: usb 3-1: device descriptor read/64, error -110
Sep  1 13:11:00 kocom kernel: usb 3-1: device descriptor read/64, error -110
Sep  1 13:11:00 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 12
Sep  1 13:11:05 kocom kernel: usb 3-1: device descriptor read/8, error -110
------------------------------------------------------------------------------------------------

sdb and sdc appear in /proc/partitions, but trying to access with 'fdisk -l` or
'mount' freezes the phone.

I uploaded the debug-log to:
<http://www.akoenecke.de/moto/usb_debug2.txt>

The debug-log included 2 spontaneous reboots and 1 freeze (in this order) of
the phone without unplugging.

Andreas

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
