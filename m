From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [BUG] Sym. 53c895 fails accessing tape device - kernel
Date: Mon, 4 Oct 2004 23:52:10 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.61.0410042333350.5689@kai.makisara.local>
References: <4939.1096877314@www43.gmx.net> <27952.1096891360@www43.gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:43668 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S268524AbUJDUwN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Oct 2004 16:52:13 -0400
In-Reply-To: <27952.1096891360@www43.gmx.net>
List-Id: linux-scsi@vger.kernel.org
To: Alexander Stohr <Alexander.Stohr@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Mon, 4 Oct 2004, Alexander Stohr wrote:

> Hello,
> 
> i think the problem has improved in the key area
> with one of the most recent kernels.
> After a reboot and tape insertion to the drive
> i can operate like this:
> 
> $ uname -r
> 2.6.9-rc3-bk3
> $ mt status
> SCSI 2 tape drive:
> File number=0, block number=0, partition=0.
> Tape block size 512 bytes. Density code 0x25 (DDS-3).
> Soft error count since last status=0
> General status bits on (41010000):
>  BOT ONLINE IM_REP_EN
> $ mt setblk 0
> $ tar -tvf /dev/tape
> [...file list...]
> 
> the "strange" thing is that the tape device
> now reports a block size of 512 bytes at startup
> where previousely i always expected a "0" default.

This is really strange. The drive firmware should set either fixed block 
mode or variable block mode after power-up/reset but it should not change 
depending on the kernel version. The st driver does not change this 
setting (or any other drive parameter) unless the user tells it to do so.

One possibility is that your drive autodetects the tape block size when a 
tape is inserted. However, this is a somewhat bad theory because it did 
not do that in your previous message.

BTW, if you look carefully at your previous message, you can see that 
setting the block size fails because you don't have tape in the drive. tar 
with variable block size is quite permissive and this is why your test 
succeeds.

> No i have to set that value once for the machine
> (it is persistent trough tape changes and all users)
> so that a "setblk" might have to go into init scritps.
> 
It persists if your drive does not autodetect the block size when you 
insert a tape.

> I dont know if this is wanted or intended behaviour
> for a SCSI tape device, but it is at least not
> equal to what is characteristic for my (and others)
> method of normal usage.
> 
> If you can comment on the idea behind it
> how the normal use is intended to happen,
> it would be nice.
> 
If you want to use a mode and/or block size that is not the default for 
the firmware, use should set the default block size. You can use
'mt defblksize xxx' or stinit in your initscripts. This may give you the 
behaviour you expect. The st driver gives you mechanisms you can use to 
set the tape parameters for each drive. Since the choice of parameters is 
a policy issue, choosing the parameters is left to the user 
(distribution).

> checking back to syslog (after a bit of testing)
> i still could find lots of verbosity:
>   kernel: sym1:4:0:phase change 6-7 9@02189f84 resid=6.                     
>      
...
> What about that? This is filling up the logs,
> but is that really an error or what else is it?
> 
It looks like there is a problem in the communications between your drive 
and the SCSI HBA. The reason may be the drive firmware, HBA driver, 
cables, termination, etc. Anyway, from the st point of view, everything 
seems to work correctly. The low-level driver shows errors but it can work 
around the errors.

-- 
Kai
