From: David Wuertele <dave-gnus@bfnet.com>
Subject: write protect seems wrong (was Re: Trying to troubleshoot ornery
 Phison usb-storage)
Date: Thu, 20 Mar 2003 18:01:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3wuitwk8i.fsf_-_@bfnet.com>
References: <m34r65lrmq.fsf@bfnet.com> <20030314122408.B32112@one-eyed-alien.net>
 <m3of4dk6gq.fsf@bfnet.com> <20030314144733.D32112@one-eyed-alien.net>
 <m3el59k0yd.fsf@bfnet.com> <20030314175543.E32112@one-eyed-alien.net>
 <m37kb1jreb.fsf@bfnet.com> <20030315161354.A22207@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from list by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 18wBqf-0005ZY-00
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2003 03:01:33 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb-users@lists.sourceforge.net

OK, I was able to get the phison to work properly by removing one of
its pins that had been tied down.  That pin was causing it to go into
"ISP" (in-system programming?) mode.  Anyway, I was able to get the
MemoryStick interface to work perfectly!  That one is on lun2.  The
other two sockets (SmartMedia on lun0 and MMC on lun1) get recognized
and they show up in /dev/scsi, but for some reason the phison chip
thinks their write protect is on.

Is there a way to convince my phison chip that these flash cards are
not write protected?

Here are the console messages I get when trying to fdisk each flash
card.  Note that lun0 and lun1 think they are write protected, but
lun2 does not:

# fdisk /dev/scsi/host0/bus0/target0/lun1/disc
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command START_STOP (6 bytes)
usb-storage: 1b 00 00 00 01 00 34 80 d2 01 00 00
usb-storage: Bulk command S 0x43425355 T 0x51 Trg 0 LUN 0 L 0 F 0 CL 6
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x51 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command START_STOP (6 bytes)
usb-storage: 1b 00 00 00 01 00 34 80 d2 01 00 00
usb-storage: Bulk command S 0x43425355 T 0x52 Trg 0 LUN 0 L 0 F 0 CL 6
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x52 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
You will not be usb-storage: queuecommand() called
able to write thusb-storage: *** thread awakened.
e partition tablusb-storage: Command READ_10 (10 bytes)
e.
usb-storage: 28 00 00 00 00 00 00 00 02 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x53 Trg 0 LUN 0 L 1024 F 128 CL 10
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 1024 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 1024/1024
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x53 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 02 00 00 06 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x54 Trg 0 LUN 0 L 3072 F 128 CL 10
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 3072 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 3072/3072
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x54 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 08 00 00 20 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x55 Trg 0 LUN 0 L 16384 F 128 CL 10
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x55 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.

Command (m for help): q

# fdisk /dev/scsi/host0/bus0/target0/lun1/disc
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command START_STOP (6 bytes)
usb-storage: 1b 20 00 00 01 00 34 80 d2 01 00 00
usb-storage: Bulk command S 0x43425355 T 0x56 Trg 0 LUN 1 L 0 F 0 CL 6
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x56 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command START_STOP (6 bytes)
usb-storage: 1b 20 00 00 01 00 34 80 d2 01 00 00
usb-storage: Bulk command S 0x43425355 T 0x57 Trg 0 LUN 1 L 0 F 0 CL 6
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x57 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.

Unable to open /dev/scsi/host0/bus0/target0/lun1/disc
# fdisk /dev/scsi/host0/bus0/target0/lun2/disc
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command START_STOP (6 bytes)
usb-storage: 1b 40 00 00 01 00 34 80 d2 01 00 00
usb-storage: Bulk command S 0x43425355 T 0x58 Trg 0 LUN 2 L 0 F 0 CL 6
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x58 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command START_STOP (6 bytes)
usb-storage: 1b 40 00 00 01 00 34 80 d2 01 00 00
usb-storage: Bulk command S 0x43425355 T 0x59 Trg 0 LUN 2 L 0 F 0 CL 6
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x59 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
You will not be usb-storage: queuecommand() called
able to write thusb-storage: *** thread awakened.
e partition tablusb-storage: Command READ_10 (10 bytes)
e.
usb-storage: 28 40 00 00 00 00 00 00 02 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x5a Trg 0 LUN 2 L 1024 F 128 CL 10
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 1024 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 1024/1024
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x5a R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 40 00 00 00 02 00 00 06 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x5b Trg 0 LUN 2 L 3072 F 128 CL 10
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 3072 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 3072/3072
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x5b R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 40 00 00 00 08 00 00 20 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x5c Trg 0 LUN 2 L 16384 F 128 CL 10
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x5c R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.

Command (m for help): q

# 

