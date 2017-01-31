From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/10] mpt3sas: lockless command submission for scsi-mq
Date: Tue, 31 Jan 2017 15:24:11 +0100
Message-ID: <20170131142411.GA7307@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-9-git-send-email-hare@suse.de> <20170131132206.GA5686@lst.de> <8b403430-3fe8-2008-2748-4a3095648746@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56711 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752386AbdAaOYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 09:24:13 -0500
Content-Disposition: inline
In-Reply-To: <8b403430-3fe8-2008-2748-4a3095648746@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.com>

On Tue, Jan 31, 2017 at 02:46:19PM +0100, Hannes Reinecke wrote:
> Yes, they are with your latest patchset.

No, this has been the case since blk-mq support wa added to scsi.

> Yes, but scsi_host_find_tag() still relies on req->special, which it
> really shouldn't after your patches; scsi_cmd_priv() should be used there.

Both are perfectly fine for now.

> > I think this function just needs to go away instantly.
> > Trying to send task management requests from userspace for any
> > active smid is plain dangerous.
> > 
> Hey, I didn't to it. I just did the conversion.
> 
> But indeed, it's of questionable value.
> 
> I can remove it with the next iteration.

I think we need to sort out the mpt-specific passthrough ioctls
one way or another.  A lot of the mess in this patch comes from
the fact that no all I/O goes through the block/scsi layer.

Once that is sorted out things become a lot simpler.

> So, I'm happy to rebase it on top of your BLOCK_PC changes. Just tell me
> which tree to use.

You don't need them.  cmd_size has been there for a long time for SCSI.
The only thing my patches do is to add support to legacy block code
and use that new simpler and more efficient implementation in SCSI instead
of the old hown-grown implementation in SCSI.
