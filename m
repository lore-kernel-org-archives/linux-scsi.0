From: "Ujval Lodha" <ujval@gdc-tech.com>
Subject: Re: Writing to tape from C system calls
Date: Sat, 13 Dec 2003 00:18:04 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <002d01c3c0cb$85c266f0$7b00a8c0@pluto>
References: <03Dec12.101354est.332511@cyborg.cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n219076065135.netvigator.com ([219.76.65.135]:49166 "HELO
	imsmq10.netvigator.com") by vger.kernel.org with SMTP
	id S265285AbTLLQSN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2003 11:18:13 -0500
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com, linux-scsi@vger.kernel.org


Thanks for your reply. That clears up my understanding.

I've already read the man page. That is how I got so far, in fact. It seems
to require some understanding of the functionality of tape drives. The
description of some of the options seems very cryptic to me - as I dont know
much of the jargon associated with tape drives. Any material that would help
understand tape devices and tape as a medium - filemarks, setmarks, and the
order of operations one is expected to perform.

Also, I wonder if it absolutely not possible to use the tape in the manner I
intended. I am using the tape without compression - and I dont mind making
'sub-optimal' use of the capacity of the tape.

Thanks again.

Regards,
Ujval


----- Original Message ----- 
From: "Tony Battersby" <tonyb@cybernetics.com>
To: "'Ujval Lodha'" <ujval@gdc-tech.com>; <linux-scsi@vger.kernel.org>
Sent: Friday, December 12, 2003 11:14 PM
Subject: RE: Writing to tape from C system calls


> > When I write to it at any block that block becomes the last
> > block on the device. I am unable to seek to any block after
> > that on the tape.
>
> > Is this normal? Is it not possible to use the tape device -
> > and modify data at any block by seeking to it and writing?
>
> It is completely normal.  All modern tape drives work this way.  Unlike
> a disk drive, a block address on tape does not correspond to a
> predefined location on the medium.  The tape drive (re)formats the
> medium while it writes, which invalidates anything past the last written
> point on tape.  So, you can seek/read/write the tape from the beginning
> of the tape up to just after the last written block, but the tape medium
> after that point is not considered to be formatted and cannot be used
> (again) until it is reached while writing.
>
> As you observed, writing to tape in the middle of valid data will cause
> the contents of the tape to be truncated at the write point.  That's the
> way the technology works.  There is no way to update a block in the
> middle of the valid data without losing everything that comes after it.
> The only way around this is to use multiple partitions, but not all tape
> drives support partitions, and changing partitions takes time.
>
> > Is there some source of information where I can read about
> > programming tape devices from C? So far, I havent been able
> > to find one.
>
> man st
>
> But that's pretty low-level, of course.
>
> Anthony J. Battersby
> Cybernetics
>


