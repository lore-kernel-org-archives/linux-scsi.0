From: Pat LaVarre <p.lavarre@ieee.org>
Subject: unsolicited sense in 2.6.0-test5 usb-storage.ko
Date: 10 Sep 2003 14:51:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063227068.3669.129.camel@patehci2>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
	 <1063217791.3669.43.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:13968 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265690AbTIJUuG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 16:50:06 -0400
In-Reply-To: <1063217791.3669.43.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: usb-storage@one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org


In linux-2.6.0-test5, I see sg3_utils-1.05/sg_dd plugs 'n play more than
does sgp_dd.

A contributing factor seems to be usb/storage injecting an unsolicited
request sense injected as if it were an auto sense, despite bCSWStatus =
x00 Passed.

Specifically I tried the following, except where you see ^D in my
terminal log I actually pressed Ctrl+D:

$
$ sudo ./sg_dd of=/dev/sg1 bs=2k bpt=512
^D
0+0 records in
0+0 records out
$
$ sudo ./sgp_dd of=/dev/sg1 bs=2k bpt=512
read capacity: Driver_status=0x08 (DRIVER_SENSE,SUGGEST_OK)
Current, Sense key: No Sense
[valid=0] Info fld=0x0, Raw sense data (in hex):
  70 00 00 00 00 00 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00
Unable to read capacity on /dev/sg1
Couldn't calculate count, please give one
$

CONFIG_USB_STORAGE_DEBUG=y gives contrasting dmesg traces.

For the unhappy sgp_dd we have 8 = Di < Hi = x40 = 64:

> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command READ_CAPACITY (10 bytes)
> usb-storage:  25 00 00 00 00 00 00 00 00 00
> usb-storage: Bulk Command S 0x43425355 T 0x2539c L 64 F 128 Trg 0 LUN 0 CL 10
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_buf: xfer 64 bytes
> usb-storage: Status code 0; transferred 8/64
> usb-storage: -- short transfer
> usb-storage: Bulk data transfer result 0x1
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code -32; transferred 0/13
> usb-storage: clearing endpoint halt for pipe 0xc0010280
> usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
> usb-storage: usb_stor_clear_halt: result = 0
> usb-storage: Attempting to get CSW (2nd try)...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result = 0
> usb-storage: Bulk Status S 0x53425355 T 0x2539c R 56 Stat 0x0
> usb-storage: -- unexpectedly short transfer
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: Bulk Command S 0x43425355 T 0x8002539c L 18 F 128 Trg 0 LUN 0 CL 6
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
> usb-storage: Status code 0; transferred 18/18
> usb-storage: -- transfer complete
> usb-storage: Bulk data transfer result 0x0
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result = 0
> usb-storage: Bulk Status S 0x53425355 T 0x8002539c R 0 Stat 0x0
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
> usb-storage: (Unknown Key): (unknown ASC/ASCQ)
> usb-storage: scsi cmd done, result=0x0
> usb-storage: *** thread sleeping.

For the happy sg_dd we have Di = Hi = 8:

> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command READ_CAPACITY (10 bytes)
> usb-storage:  25 00 00 00 00 00 00 00 00 00
> usb-storage: Bulk Command S 0x43425355 T 0x2539a L 8 F 128 Trg 0 LUN 0 CL 10
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
> usb-storage: Status code 0; transferred 8/8
> usb-storage: -- transfer complete
> usb-storage: Bulk data transfer result 0x0
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result = 0
> usb-storage: Bulk Status S 0x53425355 T 0x2539a R 0 Stat 0x0
> usb-storage: scsi cmd done, result=0x0
> usb-storage: *** thread sleeping.
> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command WRITE_10 (10 bytes)
> usb-storage:  2a 00 00 00 00 00 00 00 00 00
> usb-storage: Bulk Command S 0x43425355 T 0x2539b L 0 F 0 Trg 0 LUN 0 CL 10
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result = 0
> usb-storage: Bulk Status S 0x53425355 T 0x2539b R 0 Stat 0x0
> usb-storage: scsi cmd done, result=0x0
> usb-storage: *** thread sleeping.

Pat LaVarre



