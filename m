From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Wed, 6 Jul 2011 14:49:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107061432340.1995-100000@iolanthe.rowland.org>
References: <CAL1RGDXXQc3VOq7UB0z7P=xwpmV3m8vNnFk078p_G8aMGJ5XDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44791 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751996Ab1GFStj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2011 14:49:39 -0400
In-Reply-To: <CAL1RGDXXQc3VOq7UB0z7P=xwpmV3m8vNnFk078p_G8aMGJ5XDQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Wed, 6 Jul 2011, Roland Dreier wrote:

> On Wed, Jul 6, 2011 at 9:53 AM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> > He probably meant blk_execute_rq_nowait(). =A0The test has to be do=
ne
> > before the elevator is accessed.
>=20
> Hmm, seems we would need the test in multiple places, since my second=
 call
> trace is io_schedule -> blk_flush_plug_list -> queue_unplugged ->
> __blk_run_queue
>=20
> So I don't think I hit blk_execute_rq_nowait in my crash.
>=20
> But maybe the problem is that dm-multipath is trying to requeue the I=
O to an
> underlying sdX device that is already dead?

I'm not at all familiar with the block layer.  It seems that the check
for a dead queue would have to be made on every path that ends up
calling the elevator, which would be a difficult sort of thing to
enforce.

I'm not too sure about James's comment:

> Moving the
> queue free is wrong ... it recently moved to fix another oops.

Apparently this refers to commit
e73e079bf128d68284efedeba1fbbc18d78610f9 ([SCSI] Fix oops caused by
queue refcounting failure).  In fact that commit does _not_ move the
call to scsi_free_queue().  Instead it merely takes another reference
to the queue, so that scsi_free_queue() doesn't actually deallocate the
queue.  But it does still deallocate the elevator.

Perhaps this means the elevator shouldn't be freed until the queue is. =
=20
I just don't know.  Jens and James are the experts, but Jens hasn't
said anything and James is currently busy.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
