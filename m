From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [RFC]: performance improvement by coalescing requests?
Date: Tue, 21 Jun 2005 08:05:12 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01520FCF@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:34498 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261298AbVFUMGA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 08:06:00 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Jens and Jeff, thanks for your feedback. It does indicate that I will
need to go further in my investigation and make sure I am not dealing
with a corner case.

Jens Axboe [mailto:axboe@suse.de] 
> On Mon, Jun 20 2005, Salyzyn, Mark wrote:
>> Jens Axboe [mailto:axboe@suse.de] writes:
>> > You say io, but I guess you mean writes in particular?
>> 
>> Read or writes. One of the test cases was:
>> 
>> dd if=/dev/sda of=/dev/null bs=512b
>> 
>> would break apart into 64 4K reads with no completion dependencies
>> between them.
> That's a silly test case though, because you are intentionally
> issuing io in a really small size.

The io size is 256KB (the 'b' in dd size operands is 'blocks'). This is
the worst case scenario (single thread, large enough i/o to stuff the
controller full with 4K requests, then stops waiting for them to
complete before issuing more).

> real world cases?

It is not 'real world'. iozone was hard pressed to find much of a
difference, real world is a mix of threaded, small, large, sequential
and random; Focused on single thread large sequential and a surgical
solution with zero affect on all other i/o styles.

> and see lots of small requests, then that would be more strange.
> Can you definitely verify this is what happens?

I can verify that OOB RHEL3 (2.4.21-4.EL) and SL9.1 (2.6.4-52) exhibited
this issue. I will regroup, re-instrument and report back if this is
still the case for a late model (distribution?) kernels.

> The plugging is a block layer property, it's been in use for ages
> (since at least 2.0, I forget when it was originall introduced).

Ok, so no recent changes that would affect my results. Regardless, I
will assume there are differences between RHEL3/SL9.1 and 2.6.12 that
may have an affect. Also, as Jeff pointed out, I should scrutinize the
i/o schedulers, the 'fix' may be in tuning the selection.

>> The adapter can suck in 256 requests within a single ms.
> I'm sure it can, I'm also sure that you can queue io orders of
> magnitude faster than you can send them to hardware!

With the recent 'interrupt mitigation' patch to the aacraid driver, we
don't even need to go to the hardware to queue the request after the
first two are added and triggered. We can put 512 requests queued the
controller in the time it takes to move each pointer, size and increment
a produced index on the main memory. Regardless, before the patch it was
one PCI write overhead between each, which 'only' adds 10us to that
process for each request.

Not sure if this is a flaw, or a feature ;-> But the fast disposition of
queuing may be the root cause and not the Linux I/O system.

Random i/o performance benefits, sequential i/o induced by the split up
of large i/o requests suffers (per-se, the controller will coalesce the
request, the difference is an unscientific 10% with the worst case
scenario)

Sincerely - Mark Salyzyn
