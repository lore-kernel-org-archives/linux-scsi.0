From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Mon, 29 Jul 2013 12:19:31 -0700
Message-ID: <1375125571.5171.16.camel@haakon3.risingtidesystems.com>
References: <1374248000.2266.20.camel@dabdike>
	 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
	 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
	 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
	 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
	 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
	 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
	 <20130726020928.GL29296@kernel.dk>
	 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
	 <1374885793.7397.1537.camel@haakon3.risingtidesystems.com>
	 <20130729111827.GA14283@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130729111827.GA14283@dhcp-26-207.brq.redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-07-29 at 13:18 +0200, Alexander Gordeev wrote:
> On Fri, Jul 26, 2013 at 05:43:13PM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2013-07-26 at 14:14 -0700, Nicholas A. Bellinger wrote:

<SNIP>

> I also tried to make a "quick" conversion and hit the same issue(s) as you.
> Generally, I am concerned with these assumptions in such approach:
> 
> 1. While libata concept of tags matches nicely with blk-mq (blk_mq_hw_ctx::
> rqs[] vs ata_port::qcmd[]) right now, it is too exposed to changes in blk-mq
> in the long run. I.e. ata_link::sactive limits tags to indices, while tags
> might become hashes. Easily fixable, but still.
> 
> 2. Unallocated requests in blk-mq are accessed/analized from libata-eh.c as
> result of such iterations:
> 
>         for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
>                 qc = __ata_qc_from_tag(ap, tag);
> 
>                 if (!(qc->flags & ATA_QCFLAG_FAILED))
>                         continue;
> 
> 		...
> 	}
> 
> While it is probably okay right now, it is still based on a premise that
> blk-mq will not change the contents/concept of "payload", i.e. from embedded
> to (re-)allocated memory.
> 
> > The thing that I'm hung up on now for existing __ata_qc_from_tag() usage
> > outside of the main blk_mq_ops->queue_rq -> SHT->queuecommand_mq()
> > dispatch path, is how to actually locate the underlying scsi_device ->
> > request_queue -> blk_mq_ctx -> blk_mq_hw_hctx from the passed
> > ata_port..?
> 
> I am actually in favor of getting rid of ata_queued_cmd::tag. Converting
> ata_link::sactive to a list, making ata_link::active_tag as struct
> ata_queued_cmd *ata_link::active_qc and converting ata_port::qc_allocated to a
> list seems solves it all, including [2]. Have not checked it though.
> 
> Anyway, if we need a blk-mq tag (why?), we have qc->scsicmd->request->tag.
> 

Hi Alexander,

So given the feedback from Tejun, I'm going to setup back for the moment
from a larger conversion, and keep the SHT->cmd_size=0 setting for
libata in the scsi-mq WIP branch.

I'm happy to accept patches to drop the bitmap piece that Tejun
mentioned if your interested, but at least on my end right now there are
bigger fish to fry for scsi-mq.  ;)

Thanks,

--nab

