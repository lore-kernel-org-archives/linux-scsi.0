From: Tape Help <tape.help@gmail.com>
Subject: Re: Fwd: Multi tape problems with cpio
Date: Wed, 19 Jan 2005 18:03:49 -0500
Message-ID: <12c7da3e05011915036f54cb1c@mail.gmail.com>
References: <12c7da3e0501132353150d51f2@mail.gmail.com>
	 <12c7da3e050114233249899ca1@mail.gmail.com>
	 <Pine.LNX.4.61.0501162041120.18018@kai.makisara.local>
	 <12c7da3e050116112875ff287d@mail.gmail.com>
	 <12c7da3e05011816162f1a9e09@mail.gmail.com>
	 <Pine.LNX.4.61.0501192023550.6929@kai.makisara.local>
Reply-To: Tape Help <tape.help@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-tape-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0501192023550.6929@kai.makisara.local>
Sender: linux-tape-owner@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, linux-tape@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 19 Jan 2005 20:50:32 +0200 (EET), Kai Makisara
<Kai.Makisara@kolumbus.fi> wrote:
> On Tue, 18 Jan 2005, Tape Help wrote:
> 
> > Ok, I have the debug info, with comments where needed.
> > Thanks alot!
> > 
> ...
> > # find home -depth|cpio -o --format=newc --block-size=128 -F /dev/st0
> > 14:24:48 kernel: st0: Block limits 1 - 16777215 bytes.
> > 14:24:48 kernel: st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
> > 14:24:48 kernel: st0: Density 40, tape length: 0, drv buffer: 1
> > 14:24:48 kernel: st0: Block size: 0, buffer size: 32768 (1 blocks).
>                                    ^
> This shows that your drive is in variable block mode.
> 
> > 14:24:48 kernel: st: Succeeded to enlarge buffer to 65536 bytes (segs
> > 1->9, 4096).
> > 16:32:28 kernel: st0: Error: 8000002, cmd: a 0 1 0 0 0 Len: 65536
> > 16:32:28 kernel: Info fld=0x0, EOM Current st09:00: sense key None
> > 16:32:28 kernel: Additional sense indicates End-of-partition/medium detected
> > 16:32:28 kernel: st0: Async write error (write) 7fffffff.
> 
> This is actually a 'magic error code' within st: the previous write did
> see the EOM early warning but all data was written. The code 7fffffff is
> later interpreted as succesful write and reported as such but the next
> write then returns the EOM error.
> 
> Next I would expect to see a message telling that one filemark is written.
> It can be done by the application but it is also automatically done when
> the device file is closed at this point (i.e., after write). But ...
> 
> > 16:32:28 kernel: st0: Unloading tape.
> 
> at this point cpio ejects the tape and no filemark is written.
> 
> > 16:32:58 kernel: st: Buffer at c0310000 normalized to 32768 bytes (segs 9).
> > # cpio ejected the tape and was waiting for another.
> > # I hit <cntrl>c
> > # I put the tape back in
> > # cpio -i --only-verify-crc --list --block-size=128< /dev/st0
> > 16:40:52 kernel: st0: Error: 8000002, cmd: 0 0 0 0 0 0 Len: 0
> > 16:40:52 kernel: Current st09:00: sense key Unit Attention
> > 16:40:52 kernel: Additional sense indicates Not ready to ready
> > change,medium may have changed
> > 16:40:52 kernel: st0: Block limits 1 - 16777215 bytes.
> > 16:40:52 kernel: st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
> > 16:40:52 kernel: st0: Density 40, tape length: 0, drv buffer: 1
> > 16:40:52 kernel: st0: Block size: 0, buffer size: 32768 (1 blocks).
> > 16:40:52 kernel: st: Succeeded to enlarge buffer to 65536 bytes (segs
> > 1->9, 4096).
> > 18:45:58 kernel: st0: Error: 8000002, cmd: 8 0 1 0 0 0 Len: 65536
> > 18:45:58 kernel: Info fld=0x10000, Current st09:00: sense key Blank Check
> > 18:45:58 kernel: Additional sense indicates End-of-data detected
> > 18:45:58 kernel: st0: Sense: f0  0  8  0  1  0  0  e
> 
> Now st encounters end of data and this is reported as read error.
> 
> My drive behaves in a slightly different way: it returns the same data but
> it also sets the EOM bit. In this case the st driver interprets the
> situation as normal end of data assuming that this is where the writing
> application stopped writing.
> 
> > 18:45:58 kernel: st0: Tape error while reading.
> > 18:45:58 kernel: st0: Rewinding tape.
> > 18:46:07 kernel: st: Buffer at c0310000 normalized to 32768 bytes (segs 9).
> > # cpio give this error: cpio: read error: Input/output error
> >
> 
> So, your debugging data and my debugging data revealed what was happening
> and why we had different results. It is debatable what is the basic
> problem. The st driver is working as it has been designed to work but this does
> not match the expectations of cpio. My opinion is that any application
> should at least try to write a filemark at the end of each tape file and
> not rely on certain behaviour of drives and drivers at the end of an
> incomplete file. This is especially important because there is no common
> standard for tape semantics.
> 
> The problem can be solved by either changing st semantics or cpio
> behavior. Before changing st semantics I would like to be convinced that
> the changed semantics is what all (most) other unix tape drivers use. Any
> change of semantics can break other applications.
> 
> I will forward this analysis (with a preface) to the cpio maintainers.
> 
> --
> Kai
> 

Are the cpio maintainers on a list?
I would like to monitor the status of this issue.

Thanks for spending your time and effort on this.
