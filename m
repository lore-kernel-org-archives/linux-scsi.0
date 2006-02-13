From: Mirko Benz <mirko.benz@web.de>
Subject: SATA on mptsas performance
Date: Mon, 13 Feb 2006 15:01:53 +0100
Message-ID: <43F09151.3010000@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 162.237.ddkom.net ([212.80.237.162]:5524 "EHLO
	cheetah.dd.xiranet.com") by vger.kernel.org with ESMTP
	id S1750938AbWBMOCQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2006 09:02:16 -0500
Received: from [192.168.0.242] (dhcp242.dd.xiranet.com [192.168.0.242])
	(authenticated bits=0)
	by cheetah.dd.xiranet.com (8.13.4/8.13.4/Debian-1) with ESMTP id k1DE1wgQ030906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2006 15:02:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

We are testing the following setup:
- LSI SAS3442X controller
- Promise J300S SAS JBOD connected via the external port of the SAS 
controller
- 10 SATA disks (Seagate) in the JBOD
- Linux kernel 2.6.16RC2 on a INTEL Dual Xeon Server, 2.8 Ghz, 64 bit mode

LSI SAS driver provided by the kernel finds the JBOD and the disks.
Single disk performance is like attaching via a SATA controller from the 
chipset.
Testing with multiple parallel drive accesses gives very poor results 
and high system utilisation.
Tests performed with parallel invocations of dd with bs=32k. Values in MB/s.

# of disks    READ    AVG    WRITE        AVG
1    60    60,0    58    58,0
5    310    62,0    288    57,6
6    344    57,3    336    56,0
7    259    37,0    375    53,6
8    226    28,3    391    48,9
9    245    27,2    402    44,7
10    265    26,5    405    40,5

Up to 5 drives it looks as it should. Then the performance goes 
significantly down for READ operations.
The card is plugged in a 100 MHz PCI-X slot. No other activity on the 
system.

Any hint?

Thanks,
Mirko
