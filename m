From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Tue, 8 Jun 2010 00:29:58 GMT
Message-ID: <201006080029.o580TwWD005773@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52742 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0FHA37 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2010 20:29:59 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o580TwgE005774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jun 2010 00:29:58 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #28 from dujun@perabytes.com  2010-06-08 00:29:49 ---
Hi, Richard, 
Sorry I didn't follow the linux scsi mailing list. Pls note following.

There are 3 testing environments, all works under linux 2.6.32 and the LSI
official driver 4.22.00.00:

1. LSI 1068e HBA chip on mainboard connected to two LSI x12A expander chips,
then 16 1T WD SATA-II disks.
2. LSI 1068e HBA chip on mainboard connected to one LSI x36 expander chip, then
16 1T WD SATA-II disks. 
3. LSI 1068e HBA chip on mainboard and LSI 1068e HBA on pci-e slot, then both
connected to 8 1T WD SATA-II disks, totally 16 disks. 

Without the 512 byte alignment patch, only testing 1 has reset problem. 2&3
works perfectly without any problem. 

With the patch, all the testing passed stability testing. However, the dd
testing showed that the testing 1 performance degraded.
mdadm -C /dev/md10 -l 5 -n 16 /dev/sd[b-q] to setup the md raid5.
then 
dd if=/dev/zero of=/dev/md10 bs=1M count=10960 to test the write speed of the
md. 

2&3 has no performance penalty. 

After several days' investigating further, changed hardware part by part, we
found that some of the x12A expanders may caused the problem. Most of them
works ok just like in testing 2&3, only two or three caused the performance
issue. 

So we may draw a conclusion that the patch should be included in the next
release. The performance may be caused by the x12A expander. We are going to
ask our chip solution provider to investigate further why some of the chips
work just with lower performance. 

(In reply to comment #27)
> Hi Dujun,
> 
> Can you add any more information to this performance drop, here and on
> linux-scsi?
> 
> See discussion thread here: 
> 
> http://marc.info/?l=linux-scsi&m=127567915722288&w=2
> 
> Thanks,
> 
> Richard

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
