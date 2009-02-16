From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: BUG - MODE SENSE residue miscount in g_file_storage bulk-only transport ?
Date: Mon, 16 Feb 2009 12:33:26 +0100
Message-ID: <200902161233.27173.stf_xl@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.wp.pl ([212.77.101.5]:41336 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZBPLdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2009 06:33:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hello.

I'm trying to use g_file_storage gadget on my embedded Atmel board and have
some troubles. It take _very_ long time to discovery device due to USB interface
resets which happen because of residue miscouting for MODE_SENSE command.
Below are debugging mesages in configuration where USB host is connected to USB
device on the same machine (USB cable loop).

Whats happen? 
- SCSI host driver set MODE SENSE command length to 192
- device return 16 bytes of mode pages and set internal residue to 176, 
- host does not check residue and try to get command status
- device halt bulk in endpoint
- host reset device 
This sequence is repeated few times (SD_MAX_RETRIES times probably).

I'm trying to fix the issue and currently wrote a workaround which looks
works quite well, but I did not test it for other transports than BBB:

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index b10fa31..0a77ba8 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -2269,6 +2269,7 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 		buf0[0] = len - 1;
 	else
 		put_be16(buf0, len - 2);
+	fsg->residue = fsg->usb_amount_left = len;
 	return len;
 }
 
Maybe this is not only problem with MODE SENSE command but with all commands
that have allocation length field and file_storage gadget driver BBB transport
return less data.

Problem also happens in older kernels, I tried 2.6.27 and 2.6.24 - they have this issue. 
Please let me know if have more info or any other help to fix.

Cheers
Stanislaw Gruszka

[  111.320000] usb-storage: Command TEST_UNIT_READY (6 bytes)
[  111.320000] usb-storage:  00 00 00 00 00 00
[  111.320000] usb-storage: Bulk Command S 0x43425355 T 0x33 L 0 F 0 Trg 0 LUN 0 CL 6
[  111.320000] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  111.330000] SCSI CDB: 00 00 00 00 00 00
[  111.330000] g_file_storage gadget: SCSI command: TEST UNIT READY;  Dc=6, Dn=0;  Hc=6, Hn=0
[  111.330000] usb-storage: Status code 0; transferred 31/31
[  111.330000] usb-storage: -- transfer complete
[  111.330000] usb-storage: Bulk command transfer result=0
[  111.330000] usb-storage: Attempting to get CSW...
[  111.330000] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  111.330000] usb-storage: Status code 0; transferred 13/13
[  111.330000] usb-storage: -- transfer complete
[  111.330000] usb-storage: Bulk status result = 0
[  111.330000] usb-storage: Bulk Status S 0x53425355 T 0x33 R 0 Stat 0x0
[  111.330000] usb-storage: scsi cmd done, result=0x0
[  111.330000] usb-storage: *** thread sleeping.
[  111.330000] usb-storage: queuecommand called
[  111.330000] usb-storage: *** thread awakened.
[  111.330000] usb-storage: Command MODE_SENSE (6 bytes)
[  111.330000] usb-storage:  1a 00 3f 00 c0 00
[  111.330000] usb-storage: Bulk Command S 0x43425355 T 0x34 L 192 F 128 Trg 0 LUN 0 CL 6
[  111.330000] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  111.330000] SCSI CDB: 1a 00 3f 00 c0 00
[  111.330000] g_file_storage gadget: SCSI command: MODE SENSE(6);  Dc=6, Di=192;  Hc=6, Hi=192
[  111.330000] g_file_storage gadget: bulk-in set halt
[  111.330000] g_file_storage gadget: delayed bulk-in endpoint halt
[  111.330000] usb-storage: Status code 0; transferred 31/31
[  111.330000] usb-storage: -- transfer complete
[  111.330000] usb-storage: Bulk command transfer result=0
[  111.330000] usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
[  111.330000] at91_ohci at91_ohci: urb c3bfaec0 path 1 ep1in 93120000 cc 9 --> status -121
[  111.330000] usb-storage: Status code -121; transferred 16/192
[  111.330000] usb-storage: -- short read transfer
[  111.330000] usb-storage: Bulk data transfer result 0x1
[  111.330000] usb-storage: Attempting to get CSW...
[  111.330000] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  111.440000] at91_ohci at91_ohci: urb c3aef2a0 path 1 ep1in 40160000 cc 4 --> status -32
[  111.440000] usb-storage: Status code -32; transferred 0/13
[  111.440000] usb-storage: clearing endpoint halt for pipe 0xc0008280
[  111.440000] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
[  111.440000] usb-storage: usb_stor_clear_halt: result = 0
[  111.440000] usb-storage: Attempting to get CSW (2nd try)...
[  111.440000] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  142.000000] usb-storage: command_abort called
[  142.000000] usb-storage: usb_stor_stop_transport called
[  142.000000] usb-storage: -- cancelling URB
[  142.000000] usb-storage: Status code -104; transferred 0/13
[  142.000000] usb-storage: -- transfer cancelled
[  142.000000] usb-storage: Bulk status result = 4
[  142.000000] usb-storage: -- command was aborted
[  142.000000] usb-storage: storage_pre_reset
[  142.010000] g_file_storage gadget: bulk_out_complete --> -108, 0/31
[  142.010000] g_file_storage gadget: disconnect or port reset
[  142.010000] g_file_storage gadget: reset config
[  142.010000] g_file_storage gadget: reset interface
[  142.010000] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[  142.080000] at91_ohci at91_ohci: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[  142.140000] usb 1-1: reset full speed USB device using at91_ohci and address 2
[  142.140000] g_file_storage gadget: get device descriptor
[  142.150000] g_file_storage gadget: disconnect or port reset
[  142.220000] at91_ohci at91_ohci: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[  142.250000] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[  142.310000] g_file_storage gadget: get device descriptor
[  142.310000] g_file_storage gadget: get configuration descriptor
[  142.310000] g_file_storage gadget: get string descriptor
[  142.310000] g_file_storage gadget: set configuration
[  142.310000] g_file_storage gadget: set interface 0
[  142.310000] g_file_storage gadget: full speed config #1
[  142.310000] g_file_storage gadget: bulk_out_complete --> -104, 0/31
[  142.310000] g_file_storage gadget: reset interface
[  142.310000] g_file_storage gadget: set interface 0
[  142.310000] usb-storage: storage_post_reset
[  142.310000] usb-storage: usb_reset_device returns 0
[  142.310000] usb-storage: scsi command aborted
[  142.310000] usb-storage: *** thread sleeping.
[  142.310000] usb-storage: queuecommand called
[  142.310000] usb-storage: *** thread awakened.
[  142.310000] usb-storage: Command TEST_UNIT_READY (6 bytes)
...  repeat few times
