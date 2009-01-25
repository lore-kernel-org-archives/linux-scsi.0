From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bsg: Add support for submitting requests at tail of	queue
Date: Sun, 25 Jan 2009 11:17:30 +0200
Message-ID: <497C2E2A.1070809@panasas.com>
References: <20090122124640.GQ30821@kernel.dk>	<20090123070237B.fujita.tomonori@lab.ntt.co.jp>	<1232663279.27348.6.camel@localhost.localdomain> <20090123151408G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:21511 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbZAYJRi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jan 2009 04:17:38 -0500
In-Reply-To: <20090123151408G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

FUJITA Tomonori wrote:
> On Thu, 22 Jan 2009 16:27:59 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
>> On Fri, 2009-01-23 at 07:03 +0900, FUJITA Tomonori wrote: 
>>> So, Boaz, what do you want to do exactly? It should have in the patch
>>> description. I don't want to add something that nobody uses.
>> OK, can we step back a bit from this?  Everyone seems to be talking past
>> each other.  The original complaint was that multiple commands against
>> the same device issued by SG_IO could be executed "out of order".  This
>> is really irrelevant because we never guarantee execution order in the
>> first place.

out-of-order execution happens very rarely and I can live with that,
as long as statistically, over an iscsi connection, they are submitted
in order, then there are optimizations that can take advantage of this.
(Actually I have never observed an out of order submission to a target)

>>
>> However, if you consider our current at head insertion policy coupled
>> with a multi-threaded application issuing hundreds of SG_IO requests at
>> once, you can see we have a potential starvation issue:  Commands at the
>> tail of the queue end up pushed further and further back as more
>> commands are added to the head.  This starvation issue is worth
>> addressing, I think, and it can only be addressed by allowing tail
>> insertion.
> 
> Ah, I see. Thanks. We could see this with something busy.

That was my point. Submitting when queues are full.

> 
> BTW, bsg write interface enables you to send a command asynchronously
> so a single-thread-ed application could cause this.

However ...

The patch I submitted is not good enough. I have only added control for
the write/read path, Not the SG_IO path. The last one was left at_tail,
as before. But this is very bad, we should absolutely keep both interfaces
the same, as much as we can.

Now here we have a problem. write/read was default "at_head" SG_IO was default
"at_tail". If we want to absolutely keep backward compatibility with old
applications we need two bits. One - BSG_FLAG_Q_AT_TAIL but another one
BSG_FLAG_Q_FLAG_VALID.

In the light that I found a bad bug with SG_IO just recently, and for a fact
I know that Pete and all his osd guys only used the write/read method. I would
say that SG_IO applications are very rare, and could be disregarded.

TOMO, Jens, Please decide what you want to do. I'll post as reply to first patch
the one-bit-clean version. If you decide I will be happy to send a two-bit-compatible
version ASAP.

Thanks
Boaz
 
