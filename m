From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: usb-starge not working in the latest kernel 2.4
Date: Fri, 5 Sep 2003 20:14:05 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309051115.UAA22250@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="shift_jis"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:59101 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S262360AbTIELPc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2003 07:15:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Hi Alan,

Alan> This "not accepting new address" problem for ECHI was 
Alan> recently addressed  by a new patch.  See
Alan> http://sourceforge.net/mailarchive/message.php?msg_id=5927120
Alan> Maybe once that's fixed the error recovery will work better.
 
I tested using kernel 2.4.22-bk6. It failed by the following two patterns.
1. Bulk command transfer result=-104
2.  usb_stor_bulk_msg() returned -32

The detailed message is as follows.

1. Bulk command transfer result=-104

usb-storage: Bulk status Sig 0x53425355 T 0x93534d R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 01 ce 21 00 00 01 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x93534e Trg 0 LUN 0 L 2048 F 128 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 2048 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 2048/2048
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x93534e R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 01 ce 22 00 00 3f 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x93534f Trg 0 LUN 0 L 129024 F 128 CL 12
usb-storage: command_abort() called
usb-storage: Bulk command transfer result=-104
usb-storage: -- transport indicates command was aborted
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage: 00 00 00 00 00 00 00 00 3f 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x935350 Trg 0 LUN 0 L 0 F 0 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: command_abort() called
usb-storage: -- transport indicates command was aborted
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.
usb-storage: device_reset() called
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: bus_reset() called
hub.c: port 1, portstatus 511, change 0, 480 Mb/s
hub.c: port 1 of hub 1 not reset yet, waiting 10ms
hub.c: port 1, portstatus 511, change 0, 480 Mb/s
hub.c: port 1 of hub 1 not reset yet, waiting 10ms
ehci_hcd 00:0c.2: port 1 high speed
ehci_hcd 00:0c.2: GetStatus port 1 status 001005 POWER sig=se0  PE CONNECT
hub.c: port 1, portstatus 503, change 10, 480 Mb/s
usb.c: ignoring set_interface for dev 3, iface 0, alt 0
usb-storage: Examinging driver usb-storage...skipping ourselves.
usb-storage: bus_reset() complete
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage: 00 00 00 00 00 00 00 00 3f 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x935351 Trg 0 LUN 0 L 0 F 0 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: command_abort() called
usb-storage: -- transport indicates command was aborted
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.
scsi: device set offline - not ready or command retry failed after bus reset: host 0 channel 0 id 0 lun 0
SCSI cdrom error : host 0 channel 0 id 0 lun 0 return code = 50000
 I/O error: dev 0b:00, sector 473224
 I/O error: dev 0b:00, sector 473228
 I/O error: dev 0b:00, sector 473476
 I/O error: dev 0b:00, sector 473224

2.  usb_stor_bulk_msg() returned -32

usb-storage: usb_stor_transfer_partial(): xfer 2048 bytes
usb-storage: usb_stor_bulk_msg() returned -32 xferred 0/2048
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_clear_halt: result=0
usb-storage: usb_stor_transfer_partial(): unknown error
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x528063 R 2048 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk command S 0x43425355 T 0x528064 Trg 0 LUN 0 L 18 F 128 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 18 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 18/18
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x528064 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x4, ASCQ: 0x1
usb-storage: Not Ready: LUN in process of becoming ready
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (12 bytes)
usb-storage: 28 00 00 03 11 63 00 00 01 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x528065 Trg 0 LUN 0 L 2048 F 128 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 2048 bytes
usb-storage: usb_stor_bulk_msg() returned -32 xferred 0/2048
usb-storage: clearing endpoint halt for pipe 0xc0008280
usb-storage: usb_stor_clear_halt: result=0
usb-storage: usb_stor_transfer_partial(): unknown error
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x528065 R 2048 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk command S 0x43425355 T 0x528066 Trg 0 LUN 0 L 18 F 128 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 18 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 18/18
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x528066 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x6, ASC: 0x28, ASCQ: 0x0
usb-storage: Unit Attention: not ready to ready transition
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
 I/O error: dev 0b:00, sector 804236
 I/O error: dev 0b:00, sector 804240
 I/O error: dev 0b:00, sector 804492
 I/O error: dev 0b:00, sector 804236

Regards,
Haruo 
