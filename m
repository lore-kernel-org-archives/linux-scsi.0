From: Tape Help <tape.help@gmail.com>
Subject: Re: Fwd: Multi tape problems with cpio
Date: Tue, 18 Jan 2005 19:16:43 -0500
Message-ID: <12c7da3e05011816162f1a9e09@mail.gmail.com>
References: <12c7da3e0501132353150d51f2@mail.gmail.com>
	 <12c7da3e050114233249899ca1@mail.gmail.com>
	 <Pine.LNX.4.61.0501162041120.18018@kai.makisara.local>
	 <12c7da3e050116112875ff287d@mail.gmail.com>
Reply-To: Tape Help <tape.help@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.202]:13658 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261502AbVASAQo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 19:16:44 -0500
Received: by wproxy.gmail.com with SMTP id 36so1001279wri
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2005 16:16:43 -0800 (PST)
In-Reply-To: <12c7da3e050116112875ff287d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Ok, I have the debug info, with comments where needed.
Thanks alot!

#Unload then loaded st, without a reboot
10:37:10 kernel: st: Unloaded.
10:37:37 kernel: st: Version 20040102, bufsize 32768, max init. bufs
4, s/g segs 16
10:37:37 kernel: Attached scsi tape st0 at scsi1, channel 0, id 2, lun 0
10:37:37 kernel: st: Allocated tape buffer 0 (32768 bytes, 1 segments,
dma: 1, a: c0
310000).
10:37:37 kernel: st: segment sizes: first 32768, last 32768 bytes.
10:37:37 kernel: Attached scsi tape st1 at scsi4, channel 0, id 5, lun 0
10:37:37 kernel: st: Allocated tape buffer 1 (32768 bytes, 1 segments,
dma: 1, a: c0
848000).
10:37:37 kernel: st: segment sizes: first 32768, last 32768 bytes.

# mt -f /dev/st1 eject
10:40:31 kernel: st1: Block limits 1 - 16777215 bytes.
10:40:31 kernel: st1: Mode sense. Length 11, medium 85, WBS 10, BLL 8
10:40:31 kernel: st1: Density 1a, tape length: 0, drv buffer: 1
10:40:31 kernel: st1: Block size: 0, buffer size: 32768 (1 blocks).
10:40:31 kernel: st1: Unloading tape.

# dd if=/dev/st1 of=/dev/null bs=64k 
10:42:43 kernel: st1: Block limits 1 - 16777215 bytes.
10:42:43 kernel: st1: Mode sense. Length 11, medium 85, WBS 10, BLL 8
10:42:43 kernel: st1: Density 1a, tape length: 0, drv buffer: 1
10:42:43 kernel: st1: Block size: 0, buffer size: 32768 (1 blocks).
10:42:43 kernel: st: Succeeded to enlarge buffer to 65536 bytes (segs
1->9, 4096).
13:44:33 kernel: st1: Error: 8000002, cmd: 8 0 1 0 0 0 Len: 65536
13:44:33 kernel: Info fld=0x10000, FMK Current st09:01: sense key None
13:44:33 kernel: Additional sense indicates Filemark detected
13:44:33 kernel: st1: Sense: f0  0 80  0  1  0  0 15
13:44:33 kernel: st1: EOF detected (0 bytes read).
13:44:33 kernel: st1: Rewinding tape.
13:46:47 kernel: st: Buffer at c0310000 normalized to 32768 bytes (segs 9).
# dd if=/dev/st1 of=/dev/null bs=64k

# find home -depth|cpio -o --format=newc --block-size=128 -F /dev/st0
14:24:48 kernel: st0: Block limits 1 - 16777215 bytes.
14:24:48 kernel: st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
14:24:48 kernel: st0: Density 40, tape length: 0, drv buffer: 1
14:24:48 kernel: st0: Block size: 0, buffer size: 32768 (1 blocks).
14:24:48 kernel: st: Succeeded to enlarge buffer to 65536 bytes (segs
1->9, 4096).
16:32:28 kernel: st0: Error: 8000002, cmd: a 0 1 0 0 0 Len: 65536
16:32:28 kernel: Info fld=0x0, EOM Current st09:00: sense key None
16:32:28 kernel: Additional sense indicates End-of-partition/medium detected
16:32:28 kernel: st0: Async write error (write) 7fffffff.
16:32:28 kernel: st0: Unloading tape.
16:32:58 kernel: st: Buffer at c0310000 normalized to 32768 bytes (segs 9).
# cpio ejected the tape and was waiting for another.
# I hit <cntrl>c
# I put the tape back in
# cpio -i --only-verify-crc --list --block-size=128< /dev/st0
16:40:52 kernel: st0: Error: 8000002, cmd: 0 0 0 0 0 0 Len: 0
16:40:52 kernel: Current st09:00: sense key Unit Attention
16:40:52 kernel: Additional sense indicates Not ready to ready
change,medium may have changed
16:40:52 kernel: st0: Block limits 1 - 16777215 bytes.
16:40:52 kernel: st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
16:40:52 kernel: st0: Density 40, tape length: 0, drv buffer: 1
16:40:52 kernel: st0: Block size: 0, buffer size: 32768 (1 blocks).
16:40:52 kernel: st: Succeeded to enlarge buffer to 65536 bytes (segs
1->9, 4096).
18:45:58 kernel: st0: Error: 8000002, cmd: 8 0 1 0 0 0 Len: 65536
18:45:58 kernel: Info fld=0x10000, Current st09:00: sense key Blank Check
18:45:58 kernel: Additional sense indicates End-of-data detected
18:45:58 kernel: st0: Sense: f0  0  8  0  1  0  0  e
18:45:58 kernel: st0: Tape error while reading.
18:45:58 kernel: st0: Rewinding tape.
18:46:07 kernel: st: Buffer at c0310000 normalized to 32768 bytes (segs 9).
# cpio give this error: cpio: read error: Input/output error



On Sun, 16 Jan 2005 14:28:33 -0500, Tape Help <tape.help@gmail.com> wrote:
> On Sun, 16 Jan 2005 20:47:55 +0200 (EET), Kai Makisara
> <Kai.Makisara@kolumbus.fi> wrote:
> > On Sat, 15 Jan 2005, Tape Help wrote:
> >
> > > No one on linux-tape has responded.  I think that list is dead.
> > > Can anyone help?
> > >
> > linux-tape may not be dead but you have to give us some time ;-)
> >
> > > Thanks.
> > >
> > > ---------- Forwarded message ----------
> > > From: Tape Help <tape.help@gmail.com>
> > > Date: Fri, 14 Jan 2005 02:53:16 -0500
> > > Subject: Multi tape problems with cpio
> > > To: linux-tape@vger.kernel.org
> > >
> > >
> > > I am using cpio to backup a system.  The backup does not fit on 1
> > > tape, so cpio prompts for another tape.  I change the tape and hit
> > > enter.  cpio continues and completes.  cpio does eject the first tape,
> > > which is handy.
> > >
> > > When I try to list the tape, cpio gets an I/O error at the end of the
> > > first tape and does not prompt for a second tape.  Same problem if I
> > > try to restore data.
> > >
> > > cpio: read error: Input/output error
> > >
> > > I have tried 2 different tape drives.
> > > Both give the same results.
> > > I have done this test about 5 or so times.
> > >
> > > The backup command:
> > > find MyFS -depth|cpio -o --format=newc --block-size=128 -F /dev/st0
> > >
> > > The command to list the tape(s):
> > > cpio -i --only-verify-crc --list --block-size=128< /dev/st0
> > >
> > > If I use dd to read the tape, it also gets a read error at the end.  I
> > > think it should get an end of file and exit cleanly.
> > >
> > > I am using kernel 2.4.28.  It also fails with 2.4.20-8.
> > >
> > I tested cpio and dd in my system with 2.4.28 without finding any problems
> > (both variable block mode and fixed block mode with 1024 byte blocks).
> > Some additional information may help to solve your problem:
> > - Fixed or variable block mode? What blocksize if fixed block mode?
> >  (Output of 'mt status' tells these.)
> > - Tape drive and SCSI adapter make and model
> > - Any tape messages in system log?
> > - Debugging output from st. (You can enable debugging in st by editing the
> >  driver source (change '#define DEBUG 0' to '#define DEBUG 1') and
> >  recompiling the kernel/module.
> > --
> > Kai
> >
> 
> Sorry if I insulted the linux tape list!
> I monitored it for almost 1 week, no posts.
> The archive has been down for 4+ days.
> http://www.geocrawler.com/lists/3/Linux/
> The IP pings, but port 80 is closed.
> My post also had no response.
> 
> Glad it is still there!
> 
> Fixed or varible?  I used "--block-size=128"  which gives 64K blocks.
> I assume these would be fixed, but not sure.  I think fixed would be a
> hardware option.  I have not used any fixed hardware options.  I can't
> see that mt satus gives this info.  But output is below.
> 
> st0 is an HP LTO-1.
> st1 is a DLT-4000 in a 5 slot mini changer (Quantum DLT 4500).
> 
> st0 is connected to a SCSI port on the motherboard.  AIC-7860
> This is an ultra wide card.  The tape drive is in 20MB/sec mode.
> 
> st1 is an Adaptec card, 50 pin, ultra turnned off.  AIC-7880U
> 
> From /var/log/messages (in not order)
> kernel: Attached scsi tape st0 at scsi1, channel 0, id 2, lun 0
> kernel: Attached scsi tape st1 at scsi4, channel 0, id 5, lun 0
> kernel: st0: Block limits 1 - 16777215 bytes.
> kernel: st1: Block limits 1 - 16777215 bytes.
> 
> From /var/log/dmesg:
> st0:
> (scsi1:A:2): 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
> st1:
> (scsi4:A:5): 10.000MB/s transfers (10.000MHz, offset 15)
> 
> # mt -f /dev/st0 status
> SCSI 2 tape drive:
> File number=0, block number=0, partition=0.
> Tape block size 0 bytes. Density code 0x40 (DLT1 40 GB, or Ultrium).
> Soft error count since last status=0
> General status bits on (41010000):
> BOT ONLINE IM_REP_EN
> 
> # mt -f /dev/st1 status
> SCSI 2 tape drive:
> File number=0, block number=286270, partition=0.
> Tape block size 0 bytes. Density code 0x1a (DLT 20GB).
> Soft error count since last status=0
> General status bits on (21010000):
> EOT ONLINE IM_REP_EN
> 
> I will attempt '#define DEBUG 1'.  I have never done any custom Kernel
> stuff.  Or generated debug output before.  My current Kernel was built
> by me, so I do stand a chance! :)
> 
> Thanks.
>
