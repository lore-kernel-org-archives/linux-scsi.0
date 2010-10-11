From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20072] New: tapeinfo reports MaxBlock: 16777215  but writes
 with blocksize >2M fail
Date: Mon, 11 Oct 2010 10:19:43 GMT
Message-ID: <bug-20072-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:45300 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab0JKKTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2010 06:19:43 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9BAJhAb008330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2010 10:19:43 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=20072

           Summary: tapeinfo reports MaxBlock: 16777215  but writes with
                    blocksize >2M fail
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.32.21
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: lkolbe@techfak.uni-bielefeld.de
                CC: sfrey@techfak.uni-bielefeld.de
        Regression: No


Created an attachment (id=33222)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=33222)
lsscsi of system

As subject says, tapeinfo reports the tape drives (IBM ULTRIUM-HH4) support 16M
Blocksize, but writing in blocksizes bigger than 2M fail 

root@shepherd:~# tapeinfo -f /dev/nst0
Product Type: Tape Drive
Vendor ID: 'IBM     '
Product ID: 'ULTRIUM-HH4     '
Revision: '85V3'
Attached Changer API: No
SerialNumber: '1K10014452'
MinBlock: 1
MaxBlock: 16777215
SCSI ID: 0
SCSI LUN: 0
Ready: yes
BufferedMode: yes
Medium Type: 0x48
Density Code: 0x46
BlockSize: 0
DataCompEnabled: yes
DataCompCapable: yes
DataDeCompEnabled: yes
CompType: 0x1
DeCompType: 0x1
BOP: yes
Block Position: 0
Partition 0 Remaining Kbytes: -1
Partition 0 Size in Kbytes: -1
ActivePartition: 0
EarlyWarningSize: 0

dd tests:
root@shepherd:~# dd if=/dev/zero of=/dev/nst0 bs=2M count=4
4+0 records in
4+0 records out
8388608 bytes (8.4 MB) copied, 7.52488 s, 1.1 MB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst0 bs=4M count=4
dd: writing `/dev/nst0': Device or resource busy
1+0 records in
0+0 records out
0 bytes (0 B) copied, 1.84202 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst0 bs=8M count=4
dd: writing `/dev/nst0': Device or resource busy
1+0 records in
0+0 records out
0 bytes (0 B) copied, 1.76087 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst0 bs=16M count=4
dd: writing `/dev/nst0': Invalid argument
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00986913 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst0 bs=15M count=4
dd: writing `/dev/nst0': Value too large for defined data type
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00954276 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst0 bs=16777215 count=4
dd: writing `/dev/nst0': Value too large for defined data type
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.0102587 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst0 bs=16777214 count=4
dd: writing `/dev/nst0': Value too large for defined data type
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.0100916 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst0 bs=2M count=4
4+0 records in
4+0 records out
8388608 bytes (8.4 MB) copied, 1.76435 s, 4.8 MB/s

lspci -vvvn and lsscsi -v are attached; do you need more info?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
