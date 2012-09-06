From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [Ping^3] Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without
 CAP_SYS_RAWIO
Date: Thu, 6 Sep 2012 10:20:27 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.1209060959500.509@new-host-2>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <50195108.1090105@redhat.com> <503CA5BA.2040003@redhat.com> <50476480.9010302@redhat.com> <5047B38D.9000607@gmail.com> <50484345.8040508@redhat.com> <504889A1.2090507@gmail.com>
 <50488DAD.3030208@redhat.com> <5048922C.20901@gmail.com> <504898E5.1070507@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab2IFOUp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2012 10:20:45 -0400
In-Reply-To: <504898E5.1070507@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, axboe@kernel.dk, Mike Snitzer <snitzer@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 6 Sep 2012, Paolo Bonzini wrote:

> Date: Thu, 06 Sep 2012 14:36:53 +0200
> From: Paolo Bonzini <pbonzini@redhat.com>
> To: Ric Wheeler <ricwheeler@gmail.com>
> Cc: axboe@kernel.dk, Mike Snitzer <snitzer@redhat.com>,
>     Alan Cox <alan@lxorguk.ukuu.org.uk>,
>     Martin K. Petersen <martin.petersen@oracle.com>,
>     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Subject: Re: [Ping^3] Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without
>     CAP_SYS_RAWIO
> 
> Il 06/09/2012 14:08, Ric Wheeler ha scritto:
> >> According to the standard, the translation layer can write a
> >> user-provided pattern to every sector in the disk.  It's an optional
> >> feature and libata doesn't do that, but it is still possible.
> > 
> > It is not possible today with our stack though, any patch that would
> > change that would also need to be vetted.
> 
> It is not possible with SATA disks, but native SCSI disks might well
> interpret FORMAT UNIT destructively.
> 
> >>> I don't see allowing anyone who can open the device to zero the data as
> >>> better though :)
> >> Note: anyone who can open it for writing!  And they can just as well
> >> issue WRITE, it just takes a little more effort than with WRITE SAME. :)
> >>   If you only have read access, you cannot issue WRITE or FORMAT UNIT,
> >> and with this patch you will not be able to issue WRITE SAME.
> > 
> > This just seems like an argument over whether or not capabilities make
> > sense. In general, anything as destructive as a single CDB that can kill
> > all of your data should be tightly controlled.
> 
> In practice, a single write to the first MB of the disk is just as
> destructive.  For that you do not even need a SCSI command.
> 
> > Pushing more code in the data path is not where we are going - we
> > routinely need to disable IO scheduling for example when driving IO to
> > high speed/low latency devices and are actively looking at how to tackle
> > other performance bottlenecks in the stack.
> 
> I am not talking about the regular data path, only of SG_IO.
> 
> > I don't see a strong reason that our existing scheme (root or
> > CAP_SYS_RAWIO access) prevents you from doing what you need to do.
> 
> Here are three:
> 
> - CAP_SYS_RAWIO partly bypasses DAC; you can issue destructive commands
> even if you only opened the disk for reading.  CAP_SYS_RAWIO also gives
> access to _really_ destructive commands (WRITE BUFFER and PERSISTENT
> RESERVE OUT for example).
> 
> - CAP_SYS_RAWIO lets you send SCSI commands to partitions, and they will
> gladly read/write the disk going outside the boundaries of the
> partition.  Changing this behavior was rejected upstream already.
> 
> - CAP_SYS_RAWIO also gives access to I/O ports, mmap at address 0, and
> too many other insecure things.
> 
> All the above mean that:
> 
> - any application using CAP_SYS_RAWIO would have to implement its own
> whitelisting, even if just to duplicate what is done in the kernel;
> 
> - exploiting a CAP_SYS_RAWIO process leads to root too easily, and it is
> not possible to give the capability to anything that will run in a
> hostile environment (in my case QEMU).

So at fist I did not think this is such a good idea however there
are several good points you've mentioned.

CAP_SYS_RAWIO is indeed too big hammer for this and it is not secure
to allow such application to possess such capability. Moreover
WRITE_SAME indeed is almost the SAME as WRITE :), only easier and
delegated to the storage itself.

UNMAP or WRITE_WAME w/ unamp bit is a little bit trickier but
thinking about it some more I do not see any real reason why the
user with write permission should not be able to use this. Yes, it
is not technically write and it has other consequences as well, but
none of it seems to be exploitable more than simple write.

Moreover looking at BLKDISCARD ioctl there is no such restrictions
(obviously) but neither is with TRIM ata command. So with sata SSD
you're allowed to use TRIM command if you have write permission to
that device. So I guess having this consistent is good idea and
considering the points above I think it is ok to allow WRITE_SAME
and UNMAP without CAP_SYS_RAWIO.

Thanks!
-Lukas

> 
> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
