From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Tue, 08 May 2007 15:01:37 -0500
Message-ID: <1178654497.3737.81.camel@mulgrave.il.steeleye.com>
References: <20070508112553C.fujita.tomonori@lab.ntt.co.jp>
	 <4640C724.8030409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55670 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031834AbXEHUBz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 16:01:55 -0400
In-Reply-To: <4640C724.8030409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, bhalevy@panasas.com, jens.axboe@oracle.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

On Tue, 2007-05-08 at 21:53 +0300, Boaz Harrosh wrote:
> Before I get to my main concern here I have one comment. in scsi_get_cmd_from_req()
> there is a code path in which a scsi_cmnd is taken from special and is not newly
> allocated. It is best to move bidi allocation to scsi_get_cmd_from_req() and allocate
> new sdb only if we get a new Command. (See my attached patch for an example)
> 
> OK! My main concern is with kzalloc(sizeof(*sdb), GFP_ATOMIC);
> All IO allocations should come from slabs in case of a memory starved system.

I think you'll find that kzalloc comes directly out of a slab for this
size of allocation anyway ... you mean you want to see a dedicated pool
for this specific allocation?

> There are 3 possible solutions I see:
> 1. Use struct scsi_cmnd for bidi_read and not a special scsi_data_buffer.
>    Attached is above solution. It is by far the simplest of the three.
>    So simple that even Jens's BigIO patch can almost apply at scsi_lib.c. (and vise versa)
>    What's hanged on the request->next_rq->special is a second scsi_cmnd.
>    The command is taken from regular command pool. This solution, though
>    wasteful of some memory is very stable.

There's another problem in that it destroys our forward progress
guarantee.  There's always a single reserve command for every HBA so
that forward progress for freeing memory can always be made in the
system even if the command slab is out and we have to reclaim memory
through a HBA with no outstanding commands.  Allocating two commands per
bidirectional request hoses that guarantee ... it could be fixed up by
increasing the reserve pool to 2, but that's adding further unwanted
complexity ...

> 2. Force the users of BIDI to allocate scsi_data_buffer(s)
>    Users will allocate a slab for scsi_data_buffers and hang them on nex_rq->special before
>    hand. Than free them together with second request. This approach can be very stable, But
>    it is bad because it is a layering violation. When block and SCSI layers decide to change
>    the wiring of bidi. Users will have to change with them.

I Agree.

> 3. Let SCSI-ml manage a slab for scsi_data_buff's
>    Have a flag to  scsi_setup_command_freelist() or a new API. When a device is flagged
>    bidi-able we could 1-Allocate bigger slots to have extra memory for SDBs together
>    with the command itself. or 2-allocate yet another slab for SDBs.

if you're worried about allocations, doing a single allocate is better

> The 3rd approach is clean, and I can submit a patch for it. But I think it is not currently
> necessary. The first solution (See attached patch) we can all live with, I hope. Since for
> me it gives me the stability I need. And for the rest of the kernel it is the minimum
> change, layered on existing building blocks.


There's actually a fourth option you haven't considered:

Roll all the required sglist definitions (request_bufflen,
request_buffer, use_sg and sglist_len) into the sgtable pools.

We're getting very close to the point where someone gets to sweep
through the drivers eliminating the now superfluous non-sg path in the
queuecommand.  When that happens the only cases become no transfer or SG
backed commands.  At this point we can do a consolidation of the struct
scsi_cmnd fields.  This does represent the ideal time to sweep the sg
list handling fields into the sgtable and simply have a single pointer
to struct sgtable in the scsi_cmnd (== NULL is the signal for a no
transfer command).

James


