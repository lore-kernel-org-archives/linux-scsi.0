From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Problem with tape drive: illegal seek
Date: Fri, 25 Feb 2005 22:23:30 -0500
Message-ID: <200502260323.j1Q3NZ904511@www.watkins-home.com>
References: <200502260016.11954.chrivers@iversen-net.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from rwcrmhc14.comcast.net ([216.148.227.89]:21128 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S261394AbVBZDXj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 22:23:39 -0500
In-Reply-To: <200502260016.11954.chrivers@iversen-net.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christian Iversen' <chrivers@iversen-net.dk>, 'linux-scsi' <linux-scsi@vger.kernel.org>

Your dd issue may be related to block size.
Tar defaults to 10k blocks, dd defaults to 512 bytes blocks.

Try this dd command:
dd if=/dev/tape of=dump bs=10k

No idea about the verify.

Guy

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christian Iversen
Sent: Friday, February 25, 2005 6:16 PM
To: linux-scsi
Subject: Problem with tape drive: illegal seek


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
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

