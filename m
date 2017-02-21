From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 10/10] mpt3sas: lockless command submission for
        scsi-mq
Date: Tue, 21 Feb 2017 16:03:49 +0100
Message-ID: <20170221150349.GA28150@lst.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de> <1487680029-3701-11-git-send-email-hare@suse.de> <20170221143437.GC27251@lst.de> <77d6469d-1e96-3136-2753-2dcf1aed989c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37850 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752838AbdBUPDv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 10:03:51 -0500
Content-Disposition: inline
In-Reply-To: <77d6469d-1e96-3136-2753-2dcf1aed989c@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Tue, Feb 21, 2017 at 03:58:08PM +0100, Hannes Reinecke wrote:
> >> +	if (ioc->shost->use_blk_mq) {
> >> +		u32 unique_tag = blk_mq_unique_tag(scmd->request);
> >> +
> >> +		tag = blk_mq_unique_tag_to_tag(unique_tag);
> >> +	} else
> >> +		tag = scmd->request->tag;
> > 
> > All that unique_tag stuff is only required for SCSI LLDDs that
> > set nr_hw_queues > 1, which isn't the ase with this patch.
> > 
> Abstraction.
> I would not presume anything about SCSI-MQ/block-mq here; calling
> blk_mq_unique_tag() insulates me against any changes blk-mq might be
> doing for the tag allocation or management.

cmd->request->tag has the same meaning with blk-mq or not, so this
check is obviously wrong.

> >> +	ioc->shost->reserved_cmds = INTERNAL_SCSIIO_CMDS_COUNT;
> > 
> > Why?  You're never calling the block layer to allocate a reserved
> > request.
> > 
> The idea was to have a stub command for any ioctl passthrough commands,
> so they'll show up when traversing the list of active commands (hence it
> always uses 'scsiio_depth' and not 'can_queue').

Sure.  But setting reserved_cmds has nothing to do with that - it only
sets requests aside so they can be allocated using BLK_MQ_REQ_RESERVED.

If you reserve tags for purely driver internal usage without a struct
request just don't advertise them to the block layer at all.  This
is what we do in hpsa, and that's what mpt3sas should do as well.

> >> +		if (ioc->shost->use_blk_mq)
> >> +			smid = 1;
> >> +		else
> >> +			smid = ioc->scsiio_depth - ioc->shost->reserved_cmds;
> > 
> > Huh?  Explanation, please.
> > 
> When enabling reserved tags with blk-mq the reserved tag range is at the
> start of the tagspace; for legacy sq there is no reserved range, but
> 'can_queue' is reduced by the number of reserved commands, effectively
> locating the reserved tag range at the end of the tag space.

internal tag number are a blk-mq implementation detail, and drivers
should not second guess it.  As said above - just don't use the
reserved_cmds field and set the smids aside inside mpt3sas.

> Figuring out if there are still pending commands on the given target.

starget->target_busy

> Figuring out if there are pending commands on that LUN.

sdev->device_busy
