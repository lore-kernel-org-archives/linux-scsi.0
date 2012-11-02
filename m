From: =?ISO-8859-1?Q?J=E9r=E9mie_GUILLAUME?=
	<jeremie.guillaume-prestataire@credit-agricole.net>
Subject: [Linux Megaraid SAS driver] bug report
Date: Fri, 02 Nov 2012 12:06:30 +0100
Message-ID: <5093A936.5020709@credit-agricole.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phil2.credit-agricole.fr ([192.44.63.130]:5913 "EHLO
	phil2.credit-agricole.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762691Ab2KBLQT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Nov 2012 07:16:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I'm a linux sysadmin working with Linux in a large company, and we are=20
encountering what seems to be a regression bug with the Megaraid SAS=20
RAID driver.

The issue is performance related , when we compile the linux kernel in=20
the i386 (32 bits) architecture and activate the 64Gb High Memory=20
support. The hardware we are using is the Dell M610 Poweredge blade ser=
ver.

Here is the exact description of the problem :

- we compile the kernels by typing 'make defconfig' , and then 'make=20
nconfig' and changing only two things :
   - the two drivers we need for the kernel to work on the server (NIC=20
and 'SCSI low-level drivers' -> 'LSI Logic MegaRAID SAS RAID Module').
   - the architecture and the support for high memory .

- when we run the kernel, here are the performances we obtain :


With 3.3.x and 3.4.x kernels (including the latest 3.4.16 kernel)
-----------------------------------------------------------------
   - when compiled for the x86_64 architecture, or for the i386 32 bits=
=20
architecture with 4Gb high memory support , we obtain some good=20
performance for disk data transfer ( more or less 250 Mb/s ).
   - but with i386 architecture and 64 Gb High Memory support ,=20
performances decrease in a +200 factor : we obtain only 1 Mb/s data=20
transfer rate ).


with 3.6.x kernels (including the latest 3.6.4 kernel)
------------------------------------------------------
   - a similar problem occurs, but performance falls less drastically :=
=20
we obtain a 25 Mb/s transfer rate.


with 3.2.x kernels
------------------
   - no problem occurs ; we have good data transfers , even in 64 Gb=20
High Memory mode.


We measure data transfers by typing the following command:
dd if=3D/dev/zero of=3D./foobar bs=3D1000 count=3D10000

The distribution we are using for the tests is a just-installed i386=20
Debian 6.0 "squeeze".

When using some other drivers (such as the 'MPT fusion' driver) on some=
=20
other models
  of servers, we have no problems .


Could you help us determining what goes wrong ... ?
Of course, we can send you any information (such as debug logs, kernel=20
=2Econfig files ...) you may need to do so ...

Have a nice day,

best regards

J=E9r=E9mie GUILLAUME


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
