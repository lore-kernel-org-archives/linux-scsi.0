From: "Alexander Stohr" <Alexander.Stohr@gmx.de>
Subject: Re: [BUG] Sym. 53c895 fails accessing tape device - kernel
Date: Mon, 4 Oct 2004 14:02:40 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <27952.1096891360@www43.gmx.net>
References: <4939.1096877314@www43.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:56234 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268053AbUJDMCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2004 08:02:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org

Hello,

i think the problem has improved in the key area
with one of the most recent kernels.
After a reboot and tape insertion to the drive
i can operate like this:

$ uname -r
2.6.9-rc3-bk3
$ mt status
SCSI 2 tape drive:
File number=0, block number=0, partition=0.
Tape block size 512 bytes. Density code 0x25 (DDS-3).
Soft error count since last status=0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN
$ mt setblk 0
$ tar -tvf /dev/tape
[...file list...]

the "strange" thing is that the tape device
now reports a block size of 512 bytes at startup
where previousely i always expected a "0" default.
No i have to set that value once for the machine
(it is persistent trough tape changes and all users)
so that a "setblk" might have to go into init scritps.

I dont know if this is wanted or intended behaviour
for a SCSI tape device, but it is at least not
equal to what is characteristic for my (and others)
method of normal usage.

If you can comment on the idea behind it
how the normal use is intended to happen,
it would be nice.

checking back to syslog (after a bit of testing)
i still could find lots of verbosity:
  kernel: sym1:4:0:phase change 6-7 9@02189f84 resid=6.                     
     
  last message repeated 52 times                                            
     
  last message repeated 61 times                                            
     
  last message repeated 8 times                                             
     
  kernel: sym1:4:0:phase change 6-7 9@02189f84 resid=6.                     
     
  last message repeated 2 times                                             
     
  kernel: st0: Block limits 1 - 16777215 bytes.                             
     
  kernel: sym1:4:0:phase change 6-7 9@02189f84 resid=6.                     
     
  last message repeated 9 times                                             
     
  last message repeated 7 times                                             
     
  last message repeated 120 times
What about that? This is filling up the logs,
but is that really an error or what else is it?

-Alex.

-- 
GMX ProMail mit bestem Virenschutz http://www.gmx.net/de/go/mail
+++ Empfehlung der Redaktion +++ Internet Professionell 10/04 +++

