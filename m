From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 15:04:51 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605171455050.10823@g5.osdl.org>
References: <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
 <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
 <4469F9FB.7020807@garzik.org> <1147797507.3505.52.camel@mulgrave.il.steeleye.com>
 <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de>
 <446B3BE0.8040806@garzik.org> <1147881002.3463.23.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0605171036140.10823@g5.osdl.org> <20060517175541.GT4197@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:31167 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751190AbWEQWFR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:05:17 -0400
In-Reply-To: <20060517175541.GT4197@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>



On Wed, 17 May 2006, Jens Axboe wrote:
>
> That gets you the "parent" structure (or "host") for the queues, but it
> doesn't help you with managing them. One issue could be a shared tag
> queue - we already solved that by sharing the tag map between the
> queues, but that still allows on queue to deplete more entries that it
> should be allowed to. And so on.

Right. But all of this is very much dependent on the actual hardware. It 
makes no sense to have a "generic host" kind of structure like SCSI has, 
except for historical reasons.

It makes sense to make _individual_ design issues be able to share some 
resource(s) between queues, and that's exactly what we do. We have the 
notion of having a shared lock (which makes sense because while the queues 
might be otherwise independent, they may go through a shared hw 
interface), and as you point out, we can also share the tags for exactly 
the same reason.

But in _no_ case is is valid to think that a shared resource would somehow 
mean anything more being shared. There simply is no "host" level sharing. 
It's very much -not- an all-or-nothing thing. It's a "some hardware may 
share some stuff, and it very much depends on the hw which parts it might 
end up sharing between the queues.

So what I was objecting to was introducing the overlying "host" notion 
that SCSI has. I don't think it makes any sense from any generic 
standpoint, and I wanted to point out that _if_ you have a "all or 
nothing" shared model like SCSI has, you can use any of the fields that we 
_can_ share (eg the lock field) as a way to tie that one field together 
with all the other fields.

But it would be wrong to see that as anything but a special case.

> Some devices need serialization between them, and the only way to
> achieve that currently is by sharing a queue.

Hmm? No. We share the queue for some things, but the most _common_ example 
of a device that needs serialization between queues is IDE, and we don't 
share queues there. We have independent queues, they just end up sharing 
certain infrastructure (tags and locking).

But they _are_ independent, and you can have different elevators, 
different merging rules, and even different request functions for the 
different queues - even if they also have some things they share.

And yes, you can see an ATA host as a host in the SCSI sense, but I wanted 
to point out that you don't _need_ to see it that way, and indeed, the 
requests queues don't. The fact that a driver can then _use_ the request 
queues as if there was a "host" is fine. But we should not _enforce_ such 
a totally broken and limited model on the queues.

		Linus
