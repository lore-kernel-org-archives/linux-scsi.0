From: Terrence Martin <tmartin@physics.ucsd.edu>
Subject: Write Performance double Read Performance
Date: Mon, 22 Mar 2004 11:32:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <405F3F36.6020109@physics.ucsd.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from newport.ucsd.edu ([132.239.73.89]:37855 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S262316AbUCVTcG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2004 14:32:06 -0500
Received: from physics.ucsd.edu (newport [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id i2MJW6LH030827
	for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2004 11:32:06 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have the following system(s)

Dual 2.8 Ghz Xeon 2U Supermicro Server with 2GB RAM
Qlogic QLA2310f Controller

attached to an...

Infortrend A16F with 16 300GB WD IDE PATA Drives
The array as a RAID 5 Array with 3 partitions of 1.4TB each. I have 
mounted one of the partitions to test.

The OS is....

Fedora Core 1 with the latest Fedora 2.4 Kernel (2.4.22-1.2174.nptlsmp)
I have compiled the QLA drivers from the Qlogic site and am using v6.06.10.

The problem I am noticing is that while doing an IOZone performance test 
I get nice write performance when the test gets to large files. However 
my read performance seems to be a little over half my write.   I thought 
the read should always be faster than the write?

Command line used: /opt/iozone/bin/iozone -Ra -g 4G -i 0 -i 1

Eg. Copy paste from IOZone run

KB         reclen write      rewrite     read       reread
2097152      64  154313  171266    91012    92388
2097152     128  154125  170701    89532    82991
2097152     256  151473  169734    86227    85231
2097152     512  150925  168767    84953    86313
2097152    1024  154947  175371    84576    85733
2097152    2048  154581  175161    84865    85233
2097152    4096  155754  175689    85229    86450
2097152    8192  155847  175645    85320    86052
2097152   16384  155500  175313    84817    86864

I only notice this performance drop once I get into large reads. Here 
when the file is half RAM performance is very good.

KB         reclen write      rewrite     read       reread
1048576      64  174326  236646  1571371  1722042
1048576     128  171660  236849  1552772  1699937
1048576     256  173722  239855   893958   938153
1048576     512  171075  238875   660975   683853
1048576    1024  169105  239178   651627   675901
1048576    2048  167846  240387   649875   673732
1048576    4096  168663  238126   653533   675654
1048576    8192  171406  239028   646698   669387
1048576   16384  171545  237270   647777   669695

Before I went down the road of compiling various kernels etc I thought I 
would post this to linux-scsi to see if it is just some configuration 
setting to a driver or kernel parameter that needs to be tweaked.  Of 
course I could be completely reading this wrong but bonnie++ also 
appears to give similar results and vmstat is similarly low on the read 
side.

Thanks,

Terrence



