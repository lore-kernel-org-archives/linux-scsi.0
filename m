From: Alan Stern <stern@rowland.harvard.edu>
Subject: Bug in hot-unplugging for SCSI CD-ROM
Date: Wed, 21 May 2003 11:19:28 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0305211106560.617-100000@ida.rowland.org>
References: <3EC81B67.2040807@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:772 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262150AbTEUPG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 11:06:29 -0400
In-Reply-To: <3EC81B67.2040807@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

Mike:

I just modified the usb-storage driver to simulate a failed device and
tried it with my USB CD-RW drive.  The SCSI error handler kicked in, tried
a device reset (which I had doctored to simulate a failure), tried a bus
reset (which actually did fail because of an bug somewhere else in the
USB stack), couldn't do a host reset (because usb-storage doesn't support
it), and finally decided to take the device off-line.

That much worked fine.  But afterwards, when the process trying to read 
from the drive ended and the device file was closed, usb-storage received 
an ALLOW_MEDIUM_REMOVAL command.  This should not have happened given that 
the device was off-line.

Here are the relevant parts of the kernel log:

May 21 10:09:29 localhost kernel: usb-storage: Command READ_10 (10 bytes)
May 21 10:09:29 localhost kernel: usb-storage:  28 00 00 00 00 44 00 00 40 00
(delay to simulate failure)
May 21 10:09:59 localhost kernel: usb-storage: usb_storage_command_abort called
May 21 10:09:59 localhost kernel: usb-storage: usb_stor_stop_transport called
May 21 10:09:59 localhost kernel: usb-storage: Bulk status result = 3
May 21 10:09:59 localhost kernel: usb-storage: -- command was aborted
May 21 10:09:59 localhost kernel: usb-storage: Bulk reset requested
(delay for automatically-generated device reset)
May 21 10:10:05 localhost kernel: usb-storage: Soft reset done
May 21 10:10:05 localhost kernel: usb-storage: scsi command aborted
May 21 10:10:05 localhost kernel: usb-storage: *** thread sleeping.
May 21 10:10:05 localhost kernel: usb-storage: queuecommand() called
May 21 10:10:05 localhost kernel: usb-storage: *** thread awakened.
May 21 10:10:05 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
May 21 10:10:05 localhost kernel: usb-storage:  00 00 00 00 00 00
(delay to simulate failure)
May 21 10:10:15 localhost kernel: usb-storage: usb_storage_command_abort called
May 21 10:10:15 localhost kernel: usb-storage: usb_stor_stop_transport called
May 21 10:10:15 localhost kernel: usb-storage: Bulk status result = 3
May 21 10:10:15 localhost kernel: usb-storage: -- command was aborted
May 21 10:10:15 localhost kernel: usb-storage: Bulk reset requested
(delay for automatically-generated device reset)
May 21 10:10:21 localhost kernel: usb-storage: Soft reset done
May 21 10:10:21 localhost kernel: usb-storage: scsi command aborted
May 21 10:10:21 localhost kernel: usb-storage: *** thread sleeping.
May 21 10:10:21 localhost kernel: usb-storage: usb_storage_device_reset called
(simulate failure of device reset)
May 21 10:10:21 localhost kernel: usb-storage: usb_storage_bus_reset called
(next line is due to an error in the USB stack, causing failure)
May 21 10:10:21 localhost kernel: drivers/usb/core/hub.c: USB device not accepting new address (error=-22)
May 21 10:10:21 localhost kernel: usb-storage: usb_reset_device returns -22
May 21 10:10:21 localhost kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
May 21 10:10:21 localhost kernel: SCSI cdrom error : <0 0 0 0> return code = 0x6050000
May 21 10:10:21 localhost kernel: end_request: I/O error, dev sr0, sector 272
May 21 10:10:21 localhost kernel: Buffer I/O error on device scsi/host0/bus0/target0/lun0/cd, logical block 68
May 21 10:10:21 localhost kernel: Buffer I/O error on device scsi/host0/bus0/target0/lun0/cd, logical block 69
(more I/O error messages, not shown)
May 21 10:10:21 localhost kernel: usb-storage: queuecommand() called
May 21 10:10:21 localhost kernel: usb-storage: *** thread awakened.
May 21 10:10:21 localhost kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
May 21 10:10:21 localhost kernel: usb-storage:  1e 00 00 00 00 00

I trust this won't be hard to fix.

Alan Stern

