From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 100921] New: Kernel cannot read partition table
 automatically.But use partprobe command can.
Date: Sun, 05 Jul 2015 03:59:30 +0000
Message-ID: <bug-100921-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34699 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbbGEIrz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Jul 2015 04:47:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 16A7820954
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jul 2015 03:59:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 55E4520958
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jul 2015 03:59:31 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=100921

            Bug ID: 100921
           Summary: Kernel cannot read partition table automatically.But
                    use partprobe command can.
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.1.0
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: halyx@126.com
        Regression: No

I use linux kernel 4.1.0 in my Gentoo Linux.
Whenever I insert my USB-HDD into USB-port, kernel cannot read the partition
table automatically.
But when I use the partprobe command, it can read my partition table.
I want to know whether it is a bug.

As the following, the output of the "dmesg|tail":
dmesg | tail 
[ 5384.806237] usb-storage 1-4:1.0: USB Mass Storage device detected 
[ 5384.807159] scsi host8: usb-storage 1-4:1.0 
[ 5386.440476] scsi 8:0:0:0: Direct-Access     hp       v250w            1100
PQ: 0 ANSI: 4 
[ 5386.440660] sd 8:0:0:0: Attached scsi generic sg2 type 0 
[5386.440899] sd 8:0:0:0: [sdb] 31506432 512-byte logical blocks: (16.1 GB/15.0
GiB) 
[ 5386.441314] sd 8:0:0:0: [sdb] Write Protect is off 
[ 5386.441319] sd 8:0:0:0: [sdb] Mode Sense: 43 00 00 00 
[ 5386.441758] sd 8:0:0:0: [sdb] No Caching mode page found 
[ 5386.441762] sd 8:0:0:0: [sdb] Assuming drive cache: write through 
[ 5386.445789] sd 8:0:0:0: [sdb] Attached SCSI removable disk

ls /dev/sd*
/dev/sda  /dev/sda1  /dev/sda2  /dev/sda3  /dev/sda4  /dev/sda5  /dev/sda6 
/dev/sda7  /dev/sda8  /dev/sdb
As above, there is not /dev/sdbX(X=1,2,3...)
Then, I use "sudo partprobe" 
ls /dev/sd*
/dev/sda  /dev/sda1  /dev/sda2  /dev/sda3  /dev/sda4  /dev/sda5  /dev/sda6 
/dev/sda7  /dev/sda8  /dev/sdb  /dev/sdb1
As above, the /dev/sdb1 occurred.

I want to know whether it is a bug.I didn't want to insert "partprobe" command
whenever I use my USB devices.

Yours sincerely
Thanks.

-- 
You are receiving this mail because:
You are the assignee for the bug.
