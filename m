From: Jean Tourrilhes <jt@hpl.hp.com>
Subject: Problem with MPT in 2.4.X
Date: Tue, 15 Mar 2005 16:29:17 -0800
Message-ID: <20050316002917.GA2331@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from palrel12.hp.com ([156.153.255.237]:65159 "EHLO palrel12.hp.com")
	by vger.kernel.org with ESMTP id S262186AbVCPA3S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2005 19:29:18 -0500
Received: from tomil.hpl.hp.com (tomil.hpl.hp.com [15.0.152.100])
	by palrel12.hp.com (Postfix) with ESMTP id 994D7400365
	for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2005 16:29:17 -0800 (PST)
Received: from bougret.hpl.hp.com (Debian-exim@bougret.hpl.hp.com [15.9.72.130])
	by tomil.hpl.hp.com (8.9.3 (PHNE_29774)/8.9.3 HPLabs Timeshare Server) with ESMTP id QAA05077
	for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2005 16:29:28 -0800 (PST)
Received: from jt by bougret.hpl.hp.com with local (Exim 4.44)
	id 1DBMPV-0000dk-Db
	for linux-scsi@vger.kernel.org; Tue, 15 Mar 2005 16:29:17 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

	Hi,

	I have a problem with a system which use a MPT SCSI host and a
Maxtor drive. After a few days the scsi subsystem throw zillions of
errors and can't access the disk anymore. The only way out is the
reset button.
	The system came with SCSI preinstalled, the MPT is on the
motherboard, both the cable and the drive were factory installed, and
I checked that it looks ok. I've installed a second drive after the
last reset, just in case, but the crashes were without it.
	I've found in the log some SCSI errors, a few samples are
listed below. I think there were more than those, but without a disk
to save them on...
	What I'm wondering is which part is bad, the drive, the cable
or the driver (I'm using 2.4.29). Thanks in advance for clues...

	Regards,

	Jean

-------------------------------------------------------------

SCSI subsystem driver Revision: 1.00
kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno = 2
Fusion MPT base driver 2.05.16
Copyright (c) 1999-2004 LSI Logic Corporation
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities={Initiator}
mptbase: 2 MPT adapters found, 2 installed.
Fusion MPT SCSI Host driver 2.05.16
scsi0 : ioc0: LSI53C1030, FwRev=01030800h, Ports=1, MaxQ=222, IRQ=30
scsi1 : ioc1: LSI53C1030, FwRev=01030800h, Ports=1, MaxQ=222, IRQ=31
blk: queue f7bf2c18, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
  Vendor: MAXTOR    Model: ATLAS15K2_146WLS  Rev: HPM0
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7bf2a18, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
  Vendor: SEAGATE   Model: ST34501W          Rev: 8301
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue f7bf2618, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 3, lun 0
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
Partition check:
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
SCSI device sdb: 8887200 512-byte hdwr sectors (4550 MB)
 sdb:
--------------
SCSI Error: (0:0:0) Status=02h (CHECK CONDITION)
 Key=Bh (ABORTED COMMAND); FRU=00h
 ASC/ASCQ=47h/03h ""
 CDB: 2A 00 00 18 00 5F 00 00 28 00
---------------
scsi0 channel 0 : resetting for second half of retries.
SCSI bus is being reset for host 0 channel 0.
mptscsih: OldReset scheduling BUS_RESET (sc=f7b22a00)
---------------
SCSI disk error : host 0 channel 0 id 0 lun 0 return code = 18000002
Info fld=0x7c0077, Current sd08:01: sense key Aborted Command
Additional sense indicates Information unit CRC error detected
 I/O error: dev 08:01, sector 8126520
---------------
scsi0 channel 0 : resetting for second half of retries.
SCSI bus is being reset for host 0 channel 0.
mptscsih: OldReset scheduling BUS_RESET (sc=f7b22a00)
scsi : aborting command due to timeout : pid 722035, scsi0, channel 0, id 0, lun 0 Write (10) 00 00 00 2e 07 00 00 88 00 
---------------

