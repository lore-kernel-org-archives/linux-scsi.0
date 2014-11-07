From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Fri, 7 Nov 2014 12:48:31 -0600
Message-ID: <545D13FF.6090306@windriver.com>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>	<yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <545C5A1B.9020206@windriver.com> <yq1bnoj9dvu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1bnoj9dvu.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2014 10:25 AM, Martin K. Petersen wrote:
>>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:
> 
> Chris,
> 
> Chris> Also, I think it's wrong for filesystems and userspace to use it
> Chris> for alignment.  In E.4 and E.5 in the "sbc3r25.pdf" doc, it looks
> Chris> like they use the optimal granularity field for alignment, not
> Chris> the optimal transfer length.
> 
> The original rationale behind the OTLG and OTL values was to be able to
> express stripe chunk size and stripe width. And to encourage aligned,
> full stripe writes but nothing bigger than that. Obviously the wording
> went through the usual standards body process to be vague/generic enough
> to be used for anything. It has changed several times since sbc3r25,
> btw.

You've obviously been involved in this area a lot more closely than me,
so I'll defer to your experience. :)

I think that if that's the intended use case, then the spec wording could
be improved.  Looking at "sbc3r36.pdf", it still only explicitly mentions
performance penalties for transfers that are larger than the "optimal
transfer length", not for transfers that are smaller.



On 11/07/2014 12:03 PM, Martin K. Petersen wrote:
>>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:
> 
> Chris> Apparently there's a new firmware available, dated Oct 13 but
> Chris> with no release notes.  We just tried updating the firmware on
> Chris> one of the drives in question and it failed from two different
> Chris> versions of linux,
> 
> Did you use sg_write_buffer or some special firmware update tool?

Both.  I didn't do it myself, but the guy who did sent me the following:


localhost:~$ ./dl_sea_fw-0.2.3_64 -m ST900MM0026 -d /dev/sda -f Lightningbug10K6-SED-0003.LOD 
================================================================================
 Seagate Firmware Download Utility v0.2.3 Build Date: Jan  9 2013
 Copyright (c) 2012 Seagate Technology LLC, All Rights Reserved
 Fri Nov  7 14:51:21 2014
================================================================================
Downloading file Lightningbug10K6-SED-0003.LOD to /dev/sda
send_io: Input/output error
send_io: Input/output error
 !
FW Download FAILED


This log is from a different system running Debian:

 root@bricklane-2:/home/cgcs# sg_write_buffer -vvv --in=Lightningbug10K6-SED-0003.LOD --length=1752576 --mode=5 /dev/sdb

open /dev/sdb with flags=0x802

sending single write buffer, mode=0x5, mpsec=0, id=0, offset=0, len=1752576

    Write buffer cmd: 3b 05 00 00 00 00 1a be 00 00 

    Write buffer parameter list (first 256 bytes):

e7 1a 0e 59 01 00 02 00  00 00 00 00 00 00 19 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

00 00 00 00 00 be 1a 00  00 00 00 00 00 00 00 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 d5 cd

00 00 00 00 00 00 00 00  00 00 00 00 00 00 07 00

80 01 00 00 00 00 00 00  00 00 00 00 00 00 00 00

00 00 00 00 00 bc 1a 00  00 00 00 00 00 00 00 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 5f 42

00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

ioctl(SG_IO v3) failed: Invalid argument (errno=22)

write buffer: pass through os error: Invalid argument

Write buffer failed: Sense category: -1, try '-v' option for more information


Apparently the "hdparm -I" command is giving bogus data as well.
I've seen that happen if the drive is on a RAID controller--I assume
that could cause problems with firmware updates too?

Chris
