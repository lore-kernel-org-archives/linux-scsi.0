From: Christian Iversen <chrivers@iversen-net.dk>
Subject: Problem with tape drive: illegal seek
Date: Sat, 26 Feb 2005 00:16:11 +0100
Message-ID: <200502260016.11954.chrivers@iversen-net.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from port741.ds1-noe.adsl.cybercity.dk ([212.242.204.118]:24651 "EHLO
	boreas.iversen-net.dk") by vger.kernel.org with ESMTP
	id S262102AbVBYXQc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 18:16:32 -0500
Received: from localhost (localhost [127.0.0.1])
	by boreas.iversen-net.dk (Postfix) with ESMTP id E2357744D8
	for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2005 00:16:16 +0100 (CET)
Received: from boreas.iversen-net.dk ([127.0.0.1])
	by localhost (boreas.iversen-net.dk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 26027-04 for <linux-scsi@vger.kernel.org>;
	Sat, 26 Feb 2005 00:16:06 +0100 (CET)
Received: from zephyr.iversen-net.dk (zephyr.iversen-net.dk [10.0.0.2])
	by boreas.iversen-net.dk (Postfix) with ESMTP
	for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2005 00:16:06 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Whenever I use --verify for tar, I get problems. Specifically, I get 
"Illegal seek" when tar gets to the verify phase. 

I'm trying this on a Compaq SDT-10000 on an Adaptec AHA-3940U2x/395U2x, 
according to lspci.


The following simulates my backup script.. to some extend :)

[root@boreas]/tmp #dd if=/dev/urandom of=random-data bs=1024 count=1024                        
1024+0 records in
1024+0 records out
1048576 bytes transferred in 0,324788 seconds (3228493 bytes/sec)
[root@boreas]/tmp #mt rewind
[root@boreas]/tmp #tar --create --verify --file /dev/tape random-data
tar: /dev/tape: Warning: Cannot seek: Illegal seek
[root@boreas]/tmp #dmesg | tail
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
ReiserFS: md0: warning: vs-8115: get_num_ver: not directory item
[root@boreas]/tmp #

Should I look into the buggy'dness of this, or am I doing something wrong?

Please note that I can restore the data just fine, if I use tar. If I try to 
use dd, I get strange errors as well:

[root@boreas]/tmp #dd if=/dev/tape of=dump
dd: reading `/dev/tape': Cannot allocate memory
0+0 records in
0+0 records out
0 bytes transferred in 3,699040 seconds (0 bytes/sec)

I hope you can help me.

-- 
Regards,
Christian Iversen
