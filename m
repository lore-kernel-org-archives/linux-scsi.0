From: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
Subject: [SCSI] can't plug Nokia 5300 anymore (bisected)
Date: Fri, 25 Jul 2008 22:41:46 +0200
Message-ID: <488A3A8A.7000603@belbone.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:7654 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbYGYUl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2008 16:41:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Kernel <linux-scsi@vger.kernel.org>

resending because wrong address of lkml and cc scsi list

Hello,

since 2 or 3 -git kernels (Linus tree)  I have a problem with my laptop 
and its connection through USB to a nokia 5300 gsm.

The logs show me a endless loop (until i unplug my USB cable) of 
following messages :

Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]

I bisected the kernel and found the following commit as result :

427e59f09fdba387547106de7bab980b7fff77be is first bad commit
commit 427e59f09fdba387547106de7bab980b7fff77be
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Mar 8 18:24:17 2008 -0600

   [SCSI] make use of the residue value

   USB sometimes doesn't return an error but instead returns a residue
   value indicating part (or all) of the command wasn't completed.  So if
   the driver _done() error processing indicates the command was fully
   processed, subtract off the residue so that this USB error gets
   propagated.

   Cc: Alan Stern <stern@rowland.harvard.edu>
   Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd 
c85f8cb8bd4910724f0101e41054555980727e16 M      drivers


When reverting it with 2.6.26-06077-gc010b2f , everything is back to normal.



The git bisect sequence is the following one :

git-bisect start 'drivers/scsi'
# bad: [c010b2f76c3032e48097a6eef291d8593d5d79a6] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect bad c010b2f76c3032e48097a6eef291d8593d5d79a6
# good: [bce7f793daec3e65ec5c5705d2457b81fe7b5725] Linux 2.6.26
git-bisect good bce7f793daec3e65ec5c5705d2457b81fe7b5725
# good: [a5db33411ae762e597bfcde6bb9d0c8c2ea9c0eb] BUG_ON on kernel 
misbehavior on A100U2W driver
git-bisect good a5db33411ae762e597bfcde6bb9d0c8c2ea9c0eb
# bad: [30e9ba9f2001f45960507f1963551311a67d0209] [SCSI] iscsi_tcp: 
Enable any size command
git-bisect bad 30e9ba9f2001f45960507f1963551311a67d0209
# bad: [b40977d95fb3a1898ace6a7d97e4ed1a33a440a4] [SCSI] iser: fix 
handling of scsi cmnds during recovery.
git-bisect bad b40977d95fb3a1898ace6a7d97e4ed1a33a440a4
# bad: [427e59f09fdba387547106de7bab980b7fff77be] [SCSI] make use of the 
residue value
git-bisect bad 427e59f09fdba387547106de7bab980b7fff77be
# good: [f6dd337ee4c440f29a873da3779eb3af44bd1623] [SCSI] scsi_dh: add 
hp sw device handler
git-bisect good f6dd337ee4c440f29a873da3779eb3af44bd1623
# good: [13a17fdeedbb156463a9a007378366ec0a0c30ef] [SCSI] aacraid: 
linit.c make aac_show_serial_number static
git-bisect good 13a17fdeedbb156463a9a007378366ec0a0c30ef
# good: [19c4158bcdf42ee3b2394342caf14f8471d2c78e] [SCSI] SCSI: remove 
dev->power.power_state from mesh driver
git-bisect good 19c4158bcdf42ee3b2394342caf14f8471d2c78e

It's my first bisect so if i have done something wrong, don't hesitate 
to shout.

Cedric



