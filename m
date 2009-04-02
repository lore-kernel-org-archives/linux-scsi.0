From: "Ross S. W. Walker" <RWalker@medallion.com>
Subject: RE: [Scst-devel] [Iscsitarget-devel] ISCSI-SCST	performance (with also IET and STGT data)
Date: Thu, 2 Apr 2009 13:19:49 -0400
Message-ID: <E2BB8074E5500C42984D980D4BD78EF9029E3D17@MFG-NYC-EXCH2.mfg.prv>
References: <49D10256.8030307@vlnb.net>	<e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>	<49D11096.3070804@vlnb.net>	<e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>	<49D254E4.8050806@vlnb.net>	<E2BB8074E5500C42984D980D4BD78EF9029E3D0B@MFG-NYC-EXCH2.mfg.prv>	<e2e108260903312329u118a54bfn3107fdca4b3e2b1d@mail.gmail.com>	<FA7F6940-CD5C-4460-9777-2F7AE3657B8E@gmail.com>	<1238617423.3318.82.camel@mulgrave.int.hansenpartnership.com>	<49D46B8B.5000708@vlnb.net> <49D47F28.3060409@vlnb.net> <E2BB8074E5500C42984D980D4BD78EF9029E3D14@MFG-NYC-EXCH2.mfg.prv> <49D4DB7A.2030004@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933620AbZDBRUR@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <49D4DB7A.2030004@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, iSCSI Enterprise Target Developer List <iscsitarget-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Ross Walker <rswwalker@gmail.com>, stgt@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

Vladislav Bolkhovitin wrote:
> 
> Think what you want and do what you want. You can even filter out all 
> e-mails from me, that's your right. But:
> 
> 1. As I wrote grouping threads into a single IO context doesn't explain 
> all the performance difference and finding out reasons for other's 
> performance problems isn't something I can afford at the moment.

No, not all the performance, but a substantial part of it, enough
so to say IET has a real performance issue when using CFQ scheduler.

> 2. CFQ doesn't have any processing latency and has never had. Learn to 
> understand what are your writing about and how to correctly express 
> yourself at first. You asked about that latency and I replied that there 
> is nothing to defeat.

CFQ pauses briefly before switching I/O contexts in order to make sure
it is giving as much bandwidth to a context before moving on. This is
documented. With a single I/O stream, or random I/O it won't be
noticeable, but for interleaved sequential I/O across multiple threads
with different I/O contexts it can be significant.

Not that Wikipedia is authorative: http://en.wikipedia.org/wiki/CFQ

It's right in the first paragraph:

"... While CFQ does not do explicit anticipatory IO scheduling, it
achieves the same effect of having good aggregate throughput for the
system as a whole, by allowing a process queue to idle at the end of
synchronous IO thereby "anticipating" further close IO from that
process. ..."

You can also check out the LXR:

This one in 2.6.18 kernels (RHEL) show a pause of HZ/10

http://lxr.linux.no/linux+v2.6.18/block/cfq-iosched.c#L30

So given a 10ms time slice, that would equate to ~1ms, in later
kernels it's defined as HZ/5 which can equate to ~2ms. These ms
delays can be an eternity for sequential I/O patterns.

> 3. SCST doesn't have any hooks into CFQ and not going to have in the 
> considerable future.

True, SCST doesn't have any hooks into CFQ, but your code modifies
block/blk-ioc.c to export the alloc_io_context(), which by default
is a private function, to allow your kernel based threads to set
their I/O contexts to the same group, therefore avoiding the delay
CFQ imposes on the switching of the I/O contexts between these
threads.

-Ross

______________________________________________________________________
This e-mail, and any attachments thereto, is intended only for use by
the addressee(s) named herein and may contain legally privileged
and/or confidential information. If you are not the intended recipient
of this e-mail, you are hereby notified that any dissemination,
distribution or copying of this e-mail, and any attachments thereto,
is strictly prohibited. If you have received this e-mail in error,
please immediately notify the sender and permanently delete the
original and any copy or printout thereof.
