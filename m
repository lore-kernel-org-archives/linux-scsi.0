From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Fwd: Multi tape problems with cpio
Date: Sun, 16 Jan 2005 20:47:55 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0501162041120.18018@kai.makisara.local>
References: <12c7da3e0501132353150d51f2@mail.gmail.com>
 <12c7da3e050114233249899ca1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep31-0.kolumbus.fi ([193.229.0.35]:31438 "EHLO
	fep31-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262566AbVAPSrp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Jan 2005 13:47:45 -0500
In-Reply-To: <12c7da3e050114233249899ca1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tape Help <tape.help@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 15 Jan 2005, Tape Help wrote:

> No one on linux-tape has responded.  I think that list is dead.
> Can anyone help?
> 
linux-tape may not be dead but you have to give us some time ;-)

> Thanks.
> 
> ---------- Forwarded message ----------
> From: Tape Help <tape.help@gmail.com>
> Date: Fri, 14 Jan 2005 02:53:16 -0500
> Subject: Multi tape problems with cpio
> To: linux-tape@vger.kernel.org
> 
> 
> I am using cpio to backup a system.  The backup does not fit on 1
> tape, so cpio prompts for another tape.  I change the tape and hit
> enter.  cpio continues and completes.  cpio does eject the first tape,
> which is handy.
> 
> When I try to list the tape, cpio gets an I/O error at the end of the
> first tape and does not prompt for a second tape.  Same problem if I
> try to restore data.
> 
> cpio: read error: Input/output error
> 
> I have tried 2 different tape drives.
> Both give the same results.
> I have done this test about 5 or so times.
> 
> The backup command:
> find MyFS -depth|cpio -o --format=newc --block-size=128 -F /dev/st0
> 
> The command to list the tape(s):
> cpio -i --only-verify-crc --list --block-size=128< /dev/st0
> 
> If I use dd to read the tape, it also gets a read error at the end.  I
> think it should get an end of file and exit cleanly.
> 
> I am using kernel 2.4.28.  It also fails with 2.4.20-8.
> 
I tested cpio and dd in my system with 2.4.28 without finding any problems 
(both variable block mode and fixed block mode with 1024 byte blocks). 
Some additional information may help to solve your problem:
- Fixed or variable block mode? What blocksize if fixed block mode? 
  (Output of 'mt status' tells these.)
- Tape drive and SCSI adapter make and model
- Any tape messages in system log?
- Debugging output from st. (You can enable debugging in st by editing the 
  driver source (change '#define DEBUG 0' to '#define DEBUG 1') and 
  recompiling the kernel/module.
-- 
Kai
