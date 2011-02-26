From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi LLD implementation question
Date: Sat, 26 Feb 2011 10:16:28 +0100
Message-ID: <AANLkTi=VDvR8FoGXNfNcvNKL=gJ_S3uVA1aRsu3yLEoP@mail.gmail.com>
References: <AANLkTi=+6z4qRS7MGSNTyomtyQTu5A20iBF-T92xAPMA@mail.gmail.com>
 <1298641025.8617.63.camel@mulgrave.site> <AANLkTinzhNr7FtKW5LR6QJ3O3b_Xy50wN0tS+NRg4KL2@mail.gmail.com>
 <1298654406.2459.50.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34077 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1BZJQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2011 04:16:50 -0500
Received: by vws12 with SMTP id 12so2017425vws.19
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2011 01:16:49 -0800 (PST)
In-Reply-To: <1298654406.2459.50.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 25, 2011 at 6:20 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Fri, 2011-02-25 at 18:12 +0100, Bart Van Assche wrote:
>> On Fri, Feb 25, 2011 at 2:37 PM, James Bottomley
>> <James.Bottomley@suse.de> wrote:
>> > Having a kthread process responses is generally not a good idea be=
cause
>> > completions will come in at interrupt level ... you need a context
>> > switch to get to a thread and this costs latency. =A0The idea of d=
one
>> > processing in SCSI is to identify the scsi_cmnd as quickly as poss=
ible
>> > and post it. =A0All back end SCSI processing is done in the block =
softirq
>> > (a level between hard interrupt and user context), again to keep l=
atency
>> > low. =A0That also means that the kthread architecture is wrong bec=
ause
>> > it's difficult for the kernel to go hardirq->user->softirq without
>> > adding an extra interrupt latency (usually a clock tick).
>> >
>> > If you want a "threaded" response in a multiqueue card using MSIs,=
 then
>> > you bind the MSIs to CPU groups and use the hardware interrupt con=
text
>> > as the threading (I think drivers like lpfc already do this). =A0T=
he best
>> > performance is actually observed when the MSI comes back in on the=
 same
>> > CPU that issued the I/O because the cache is still hot. =A0The blo=
ck keeps
>> > an rq->cpu to tag this which internal HBA setup can use for progra=
mming
>> > MSI completions.
>>
>> The above sounds like great advice if the processing time is
>> reasonably short. But what if the processing time can be anything
>> between e.g. a microsecond and twenty minutes ?
>
> Well, what processing? =A0SCSI LLDs are data shifting engines; there'=
s not
> a lot of extra stuff to do. =A0If you mean things like integrity
> verification, they tend to be done inline adding directly to latency =
as
> a cost of turning on integrity. =A0If you mean something like
> excrutiatingly slow PIO just to capture the data, then that's up to t=
he
> LLD ... but most do it in-line (bogging down the whole system) primar=
ily
> because timing tends to be critical to avoid FIFO overruns (the lesso=
n
> being to avoid those cards).
>
> Can you give an example? =A0I can't really think of any processing th=
at's
> so huge it would require threaded offloading. =A0The main point I was
> making is that offloading to a thread between HW irq and SCSI done ad=
ds
> enormously to latency because of the way done completions are process=
ed
> in softirq context. =A0If that latency is just a drop in the ocean
> compared to the processing, then sure, offload it.

I don't doubt the above is correct for SCSI initiator LLDs. I had
another context in mind - target drivers. While initiator workloads
are self-balancing because the application generating the workload and
the LLD run on the same system, that does not hold for target drivers.
How much work has to be processed by a target driver depends on the
number of initiator systems it is communicating with it and how much
I/O these are generating. With a sufficient number of initiator
systems and high-bandwidth HCA hardware it is possible that work
arrives faster on a target system than it can be processed. As an
example, it has already been observed with ib_srpt driver if it is
configured to process incoming work in softirq context that it can run
continuously for ten minutes. That means that during that time no
other tasklets nor any user space threads are run, resulting in user
feedback like "console locks up". Defining budgets for I/O processing
is not a solution in this context. Or, in other words, processing
target driver I/O in softirq context kills an important property of
the Linux kernel we all appreciate, namely that all processes on a
system are responsive at any time even on a heavily loaded system.

That experience made me wonder whether target drivers for
high-bandwidth HCAs should ever process I/O in IRQ or softirq context.

Regarding LLD drivers and offloading processing to thread context: if
this really adds enormously to latency that's a bug that should be
fixed. Please keep in mind that one of the basic design choices behind
real-time Linux kernels is to offload all interrupt processing to
thread context [1]. On systems running a real-time Linux kernel in its
default configuration all completions will be processed in thread
context.

[1] Jake Edge, Moving interrupts to threads, LWN.net, October 8, 2008
(http://lwn.net/Articles/302043/).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
