From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] sg: add SG_FLAG_Q_AT_TAIL flag
Date: Thu, 05 Jun 2014 18:09:48 -0400
Message-ID: <5390EAAC.10400@interlog.com>
References: <538F3416.5090306@interlog.com> <53908C46.8080308@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48254 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbaFEWJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2014 18:09:56 -0400
In-Reply-To: <53908C46.8080308@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>

On 14-06-05 11:27 AM, Boaz Harrosh wrote:
> On 06/04/2014 05:58 PM, Douglas Gilbert wrote:
>> When the SG_IO ioctl was copied into the block layer and
>> later into the bsg driver, subtle differences emerged.
>>
>> One difference is the way injected commands are queued through
>> the block layer (i.e. this is not SCSI device queueing nor SATA
>> NCQ). Summarizing:
>>     - SG_IO in the block layer: blk_exec*(at_head=false)
>>     - sg SG_IO: at_head=true
>>     - bsg SG_IO: at_head=true
>>
>> Some time ago Boaz Harrosh introduced a sg v4 flag called
>> BSG_FLAG_Q_AT_TAIL to override the bsg driver default.
>> This patch does the equivalent for the sg driver.
>>
>
> Yep
>
>>
>> ChangeLog:
>>       Introduce SG_FLAG_Q_AT_TAIL flag to cause commands
>>       to be injected into the block layer with
>>       at_head=false.
>>
>> Changes since v1:
>>       Make guard condition (only take sg v3 interface or later
>>       invocations) clearer.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>
>
> Douglas Hi
>
> Please I'm just curious? up until now all application users
> used "SG_FLAG_Q_AT_HEAD". Therefor I deduce that you guys
> came across a new application that can make use of the new
> SG_FLAG_Q_AT_TAIL facility.

sg_dd and more recently ddpt request the equivalent of
SG_FLAG_Q_AT_TAIL on SCSI READs and WRITEs. So that is
the default with a Linux block device, implemented with
a bsg device, and ignored with a sg device. When you
think of dd with POSIX threading (e.g. sgp_dd) then
SG_FLAG_Q_AT_HEAD seems rather counter-productive.

Also WRITE_ATOMIC with SG_FLAG_Q_AT_HEAD seems to be asking
for trouble (unless power failure was imminent). OTOH
an INQUIRY with SG_FLAG_Q_AT_TAIL is a bit strange as
well (as it is implicit "head of queue" through SCSI device
queues).

> What was the application's writer considerations for using
> the old sg interface and not use the newer bsg interface
> that already has this support. For me I can see 2 main areas
> that I find bsg missing.
>
> 1. aio "scatter_gather" type io.
>     (ie multiple pointers multiple length buffers that are
>      written / read from same linear range on device)
>    [The async aspect of aio can be implemented via bsg
>     with the write+read system calls]
> 2. mmap of direct device range to user vm memory
>
> Which of these, or other, considerations where cardinal
> in using of the old interface in new code?
>
> (For me personally both above shortcomings are very
>   much missed]

Not a subject that I wanted to bring up by since you ask ...


The bsg driver first appeared in the kernel in lk 2.6.23 which
was released in October 2007. It probably took a few releases to
be usable, lets say it has been in place for 6 years. In that
time there have been no new features added to the sg driver while
several new features have been added to bsg (e.g. async support)
but in the last year or so, it has lost its active maintainer:
Fujita Tomonori (aka Tomo). Various bugs have been reported
against the bsg driver (actually some against the sg driver and
tests showed the bsg driver had the same problem of worse). No
fixes have been presented for any of bsg's recently reported
problems as far as I am aware.

Consider me a part-time kernel driver maintainer so the sg and
scsi_debug drivers are more than enough for me. I have no desire
to pick up the bsg driver. Volunteers can contact Jens.


As a tool maker I get another view of various SCSI (and related)
pass-throughs across several OSes. sg3_utils has been ambivalent
about which Linux SCSI pass-through it uses since version 1.27
[20090411], about 5 years. Judging from my email, Linux users
demonstrate problems and suggestions using the these devices,
ordered by frequency:
   - block devices (e.g. /dev/sdc)
   - sg devices
   - bsg devices

I could be wrong about the order of the first two, but bsg devices
are a long way last (e.g. a handful in the last two years). At a
low level, bsg is not helped by only supporting the v4 interface
while block devices and the sg devices only support the v3
interface. To most sg3_utils users this is almost invisible since
its library chooses between the two interfaces dynamically. Only
issuing something like VERIFY(32) via sg_verify to a Linux sg
device would demonstrate a difference (i.e. it would work with
a bsg device, fail with a sg device).

I also maintain the SCSI side of smartmontools and adding bsg
support is on my ToDo list. The most active maintainer has
responded: why bother? And that seems to be a common response
from those familiar with these issues.

So the bsg driver, IMO, has become a niche player, with some
important niches. OSD users need bi-directional, variable
length commands. Several transports use the bsg driver as a
transport layer pass-through. For example my smp_utils package
uses the bsg driver in that fashion, thus avoiding several
proprietary interfaces.


The O_EXCL issue is instructive. Vaughan Cao brought this up
last year (or earlier ?). Basically the sg driver's handling
of the O_EXCL flag was flaky, not obviously, but if you
threw enough threads at it, bad things happened. So I wrote
some test programs (in sg3_utils: examples/sg_tst_excl.cpp and
friends). The Linux block device interface doesn't survive
these tests either. And the bsg driver: it just accepts and
ignores the O_EXCL flag! [You might argue that POSIX doesn't
define O_EXCL semantics on a device node.] Obviously some
folks out there care and have taken my patches (based on
Vaughan's work) into their kernels. Those patches are not
in the mainline yet; they may be re-presented soon.


So here is a list:
   Pro bsg:
     - better interface (v4), should be able to handle most
       request/response, data_in/data_out type protocols
     - has several mature transport layer pass-throughs: can
       do more than issue SCSI commands
     - faster (about the same speed as the block layer)
     - handles bi-directional SCSI commands
     - handles cdb length > 16 bytes (sg patch pending)

   Pro sg:
     - slower! (checking more things takes time, locking needs
       cleanup, no blk_execute_rq() fastpath)
     - its interface has been stable for more than 10 years
       with backward compatibility to earlier interfaces that
       are over 20 years old
     - async interface that works
     - supports things like O_EXCL (imperfectly)
     - has better debugging ('cat /proc/scsi/sg/debug') and
       error reporting (very few instances of EIO)
     - mmap and related options for moving data
     - aio "scatter_gather" type io
     - more familiar device nodes (e.g. /dev/sg3)
     - supports a few specials like those to reset SCSI devices,
       targets and hosts


I'm not proposing any major changes. Microsoft has two variants
of its SCSI pass-through, so if the Linux pass-through users
are relatively happy with the current situation, then it ain't
broke so doesn't need fixing.


All that said, I sometimes toy with the idea of adding the v4
interface to the sg driver. After all it must be about 10 years
since Jens said that wasn't going to happen ...

Doug Gilbert






