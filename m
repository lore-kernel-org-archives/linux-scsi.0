From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Mon, 5 May 2003 09:57:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505095715.6d96e703.rddunlap@osdl.org>
References: <3EB11AD3.2070503@torque.net>
	<3EB22F09.7060906@torque.net>
	<20030502095536.76dba4dd.rddunlap@osdl.org>
	<3EB385F3.6010708@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:24769 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263755AbTEEQrg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2003 12:47:36 -0400
In-Reply-To: <3EB385F3.6010708@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

On Sat, 03 May 2003 19:03:47 +1000 Douglas Gilbert <dougg@torque.net> wrote:

| > | As Randy has found the setting of kernel boot time parameters
| > | doesn't work. The problem seems to be that the ide subsystem
| > | asserts ownership over all parameters that start with "ide".
| > | I was unable to bend moduleparam.h to accept a leading underscore
| > | so I went back to the old "__setup" method: the kernel boot time
| > | parameters are now:
| > |    - _ide_scsi_debug + _ide_scsi_suppress_reset
| > 
| > I'll confirm that those work.  I.e., I saw values 3 and 1 in
| > /sys/bus/ide/drivers/ide-scsi/*.
| > 
| > | Module load time and sysfs parameters remain the same.
| > | 
| > | A new patch against lk 2.5.68 is attached.
| > 
| > Used that patch instead of v1 of it.  Got an oops in ide-scsi.
| 
| Randy,
| Thanks for testing this. At this stage I have no
| solution but can offer some analysis.
| 
| Firstly, it seems like Mandrake 9.0 has some
| program like RedHat's "magicdev" that polls
| cd/dvds every second or so. Nuke it please!
| It won't fix the problem but will make it easier
| to see the wood for the trees.

I'll happily do that if I can find it, since I don't use it anyway.
However, I don't see it.  I also don't see any periodic activity
after enabling scsi logging as Mike A. mentioned.

I did 'cdrecord -scanbus' and then
cdrecord -v speed=4 dev=2,0,0 -data lca2003.iso
and got the same oops as before (invalid ptr = 6b6b6bxx, into
bad memory area).


New kernel log file is now at
  http://www.xenotime.net/linux/capture2.txt

Are there any docs on SCSI logging?

--
~Randy
