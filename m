From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61771] Support for LSI Logic / Symbios Logic M1064E MegaRAID
 SAS
Date: Fri, 16 May 2014 07:54:00 +0000
Message-ID: <bug-61771-11613-fwbal9iHNw@https.bugzilla.kernel.org/>
References: <bug-61771-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60713 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbaEPHyD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2014 03:54:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D4AFD20380
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2014 07:54:01 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 650F9202EA
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2014 07:54:00 +0000 (UTC)
In-Reply-To: <bug-61771-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=61771

Azamat H. Hackimov <azamat.hackimov@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |azamat.hackimov@gmail.com

--- Comment #3 from Azamat H. Hackimov <azamat.hackimov@gmail.com> ---
Hello.
There one trick with mptsas driver from recent kernel. Since this is
unofficial, there NO WARRANTY big warning. I not checked for already existing
RAID with data only on just created RAID. Before any actions on actual data
perform backup first!

Turns out, some LSI / Symbios Logic fakeraid cards can be recognized my mptsas
with additional pciids. All you need is find pciids for you card. My card is

lspci -nn | grep LSI
08:00.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic M1064E
MegaRAID SAS [1000:0057] (rev 04)

Where [1000:0057] is PCI ID. Next you need do follow:

echo "1000 0057" > /sys/bus/pci/drivers/mptsas/new_id

Add this row to /etc/rc.conf or somewhere else for applying to next boot.

If all goes right, you physical disks will be appear in system (check dmesg).
For RAID capabilities you need to install mdadm. It autodetects partitions as
/dev/mdX:

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
[raid10]
md126 : active raid1 sde[1] sdd[0]
      142577664 blocks super external:/md127/0 [2/2] [UU]
      [=======>.............]  resync = 39.3% (56174464/142577664)
finish=1351.1min speed=1065K/sec

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
