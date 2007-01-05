From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: unifying the command permission for block layer SG_IO and sg
Date: Sat, 06 Jan 2007 02:40:02 +0900
Message-ID: <200701051740.l05He2R9019926@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo06.iij.ad.jp ([210.130.1.94]:61168 "EHLO mfo06.iij.ad.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161156AbXAERy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jan 2007 12:54:28 -0500
Received: MFO(mfo06) for <linux-scsi@vger.kernel.org> id l05Hh4W8007833; Sat, 6 Jan 2007 02:43:04 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, jens.axboe@oracle.com, dougg@torque.net, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This is the first try to unify the command permission tables for
the block layer SG_IO and sg.

I think that we need different default permission for each device
type. This mainly focuses on SBC and MMC.

After everyone agrees on the default permission, I'll extend Jens'
command filters to set an default permission according to device
types. Another possible option is removing policy in kernel
completely. That is, everything is set to CAP_SYS_RAW_IO by default
and distributions need to set up them nicely. I'll convert sg to use
the new permission table code too.

I put all the commands in Doug's document that have the different
permission. I also added some commands that have the same permission
but I'm not sure about.

CAP_SYS_RAW_IO is chosen if the root permission seems to be necessary,
or a device type doesn't support the opcode.

Suggestions?

	     		        current	current
SCSI command		        sg      block	chosen permission
--------------------------------------------------------------------
BLANK				RDWR	RDWR	?
- same permission, but conflicts with ATA_PASS_THROUGHT_12. 

GET CONFIGURATION		RDWR	RDONLY	RAW_IO(SBC), RDONLY(MMC)

GET EVENT STATUS NOTIFICATION	RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

GET PERFORMANCE			RDWR 	RDONLY 	RDWR(SBC), RDONLY(MMC)
- safe for MMC but, conflicts with ERASE12

MAINTENANCE COMMAND IN		RDONLY	RAW_IO	RDONLY
- various "REPORT ..." commands in here (Doug)

PAUSE RESUME			RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

PLAY AUDIO (10)			RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

PLAY AUDIO MSF			RDWR	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

PLAY AUDIO TI			RDWR 	RDONLY	RAW_IO
- opcode 0x48, unassigned to any spec in SPC-4 (Doug).

PLAY CD				RDWR 	RDONLY	RDONLY
- old, new SPARE IN in SPC-4 (Doug).

READ BUFFER CAPACITY		RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

READ CAPACITY(16)		RDONLY	RAW_IO	RDONLY

READ CD				RDWR 	RDONLY 	RDONLY
- conflicts with VOLUME SET(IN).

READ DEFECT (10)		RDWR	RDONLY 	RDONLY

READ DISC INFO			RDWR 	RDONLY 	RDWR(SBC), RDONLY(MMC)
- conflicts with WPWRITE(10)

READ DVD STRUCTURE		RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

READ FORMAT CAPACITIES		RDWR	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

READ HEADER			RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

READ SUB-CHANNEL		RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

READ TOC/PMA/ATIP		RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

READ TRACK (RZONE) INFO		RDWR 	RDONLY	RDONLY
- conflicts with XDREAD(10)

RECEIVE DIAGNOSTIC		RDONLY 	RAW_IO	RDONLY
- the SES command set uses this command a lot. An SES device is only
accessible via an sg device node (Doug).

REPORT KEY			RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)
- conflicts with MAINTENANCE (OUT)

REPORT LUNS			RDONLY	RAW_IO	RDONLY

SCAN				RDWR 	RDONLY 	RDONLY
- conflicts with REDUNDNCY GROUP(IN)

SEEK				RDWR 	RDONLY 	RDONLY

SEND DVD STRUCTURE		RDWR 	RDWR	RDWR
- same permission but conflicts with VOLUME SET(OUT). RAW_IO for SBC?

SEND EVENT				RDWR	?
- cdrom.h associates opcode 0xa2 but MMC-2 uses opcode 0x5d?(Doug)

SERVICE ACTION IN		RDONLY 	RAW_IO	RAW_IO

START STOP UNIT		     	RDWR 	RDONLY	RAW_IO(SBC), RDONLY(MMC)
- hmm (Doug).

STOP PLAY/SCAN			RDWR 	RDONLY 	RAW_IO(SBC), RDONLY(MMC)

VERIFY (10)			RDWR 	RDONLY 	RDONLY

VERIFY (16)			RDWR 	RDONLY 	RDONLY(SBC), RAW_IO(MMC)
