From: Douglas Gilbert <dgilbert@interlog.com>
Subject: sd: protection difficulties
Date: Thu, 17 Nov 2011 11:31:13 -0500
Message-ID: <4EC536D1.6080501@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41812 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1KQQbV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2011 11:31:21 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 629B92041B9
	for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2011 17:31:17 +0100 (CET)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xDyESTdiG-M5 for <linux-scsi@vger.kernel.org>;
	Thu, 17 Nov 2011 17:31:16 +0100 (CET)
Received: from [192.168.48.66] (ip-17.55.99.216.dsl-cust.ca.inter.net [216.99.55.17])
	by smtp.infotech.no (Postfix) with ESMTPA id 9E434204181
	for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2011 17:31:15 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

When a disk is freshly formatted with protection
type 1 (ST33000650SS 3 TB taking 14 hours!) then
its 8 bytes of protection information on all LBs
are set to 0xFF.

Now with zeros filling the user data part of each
logical block and a LB guard field of 0xffffffff that
means any attempt to read a LB before it is written
will result in an error like this [lk 3.1.0]:
  sd 6:0:0:0: [sdb]
    Target Data Integrity Failure
     Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
     Sense Key : Aborted Command [current]
     Add. Sense: Logical block guard check failed
     CDB: Read(10): 28 20 00 00 00 00 00 00 08 00
     end_request: I/O error, dev sdb, sector 0

That is gparted reading LBA 0 to find out what partition
table the disk has. Answer: no partition table because
that LB has not been written to (since the FORMAT UNIT).

Since the block layer insists on reading a disk before
writing, and that the sd driver is setting the RDPROTECT
field to 1 *** (i.e. the 0x20 is the second byte of the CDB
above), then no tool that uses the block layer interface
(i.e. /dev/sdb) can work with that disk. That includes dd.

The only way I can see to make that disk useable
currently is with a generic pass-through (e.g. the bsg
or sg drivers) and write to the disk. My sg_dd and ddpt
utilities can do that. Just writing zeros (with correct
protection information) to the beginning and end of the
disk to keep GPT stuff happy is not sufficient. That
implies mkfs-type programs are also doing
read-before-write. So lets waste another 14 hours writing
zeros (with correct protection information) to the
whole disk.

Seems to be getting a bit silly. Am I missing something
obvious or does the sd driver and the block layer above
it need some serious work?


How about starting with the idea of a "tentative read".
That is a read operation to a LBA that it is not reasonable
to assume has always been written to. The first read to a
disk should always be tentative because the disk could have
just been formatted (BTW the WRITE SAME command can also
place 0xFF bytes in the protection fields).

Doug Gilbert

*** Recent work at t10.org states that if RDPROTECT=0 on
     a READ command and the DPICZ bit is 1 in the Control
     mode page then the protection information shall _not_
     be checked. The ST33000650SS disk does not support the
     DPICZ bit and when RDPROTECT=0 it does not check
     protection information. Reports about other disks on
     the market that support protection information welcome.
