From: brace <brace@pmcs.com>
Subject: RE: [PATCH 37/43] hpsa: use block layer tag for command allocation
Date: Tue, 24 Feb 2015 20:51:28 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB38D5D1E8@BBYEXM01.pmc-sierra.internal>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221222049.21954.27282.stgit@brunhilda>
 <20150223202526.GE11037@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:34658 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593AbbBXUvg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2015 15:51:36 -0500
In-Reply-To: <20150223202526.GE11037@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Scott Teel <Scott.Teel@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, Justin Lindley <Justin.Lindley@pmcs.com>, brace <brace@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, February 23, 2015 2:25 PM
> To: Don Brace
> Cc: Scott Teel; Kevin Barnett; james.bottomley@parallels.com;
> hch@infradead.org; Justin Lindley; brace; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 37/43] hpsa: use block layer tag for command allocation
> 
> > @@ -4691,27 +4701,31 @@ static int hpsa_scsi_queue_command(struct
> Scsi_Host *sh, struct scsi_cmnd *cmd)
> >
> >  	/* Get the ptr to our adapter structure out of cmd->host. */
> >  	h = sdev_to_hba(cmd->device);
> > -	dev = cmd->device->hostdata;
> > -	if (!dev) {
> > +
> > +	if (cmd->request->tag < 0) {
> > +		dev_crit(&h->pdev->dev,
> > +			 "sdev %p scmd %p: bad tag %d -- rejecting\n",
> > +			 cmd->device, cmd, cmd->request->tag);
> >  		cmd->result = DID_NO_CONNECT << 16;
> >  		cmd->scsi_done(cmd);
> >  		return 0;
> 
> Shouldn't happen with a modern kernel, but if you really want to
> assert this I'd recommend a BUG_ON().
> 

Done. Left over from early block tag adoption.

> > -	if (unlikely(lockup_detected(h))) {
> > +	dev = cmd->device->hostdata;
> > +	if (!dev) {
> >  		cmd->result = DID_NO_CONNECT << 16;
> >  		cmd->scsi_done(cmd);
> >  		return 0;
> >  	}
> 
> How could this happen (see my earlier question in one of the first
> patches).

This has happened to us in the past. I'd like to leave it in for now.
> 
> > @@ -4838,6 +4852,11 @@ static int hpsa_register_scsi(struct ctlr_info *h)
> >  	sh->hostdata[0] = (unsigned long) h;
> >  	sh->irq = h->intr[h->intr_mode];
> >  	sh->unique_id = sh->irq;
> > +	if (!shost_use_blk_mq(sh)) {
> > +		error = scsi_init_shared_tag_map(sh, sh->can_queue);
> > +		if (error)
> > +			goto fail_host_put;
> > +	}
> 
> scsi_init_shared_tag_map alredy has the blk-mq check, so you can call
> it unconditionally.
> 
> > +static void hpsa_print_scsi_cmd(struct ctlr_info *h, struct scsi_cmnd *scmd,
> > +			   char *prefix)
> 
> Maybe just use scsi_print_command?

Done.

> 
> > +static void cmd_tagged_free(struct ctlr_info *h, struct CommandList *c)
> > +{
> > +	/*
> > +	 * Release our reference to the block.  We don't need to do anything
> > +	 * else to free it, because it is accessed by index.  (There's no point
> > +	 * in checking the result of the decrement, since we cannot guarantee
> > +	 * that there isn't a concurrent abort which is also accessing it.)
> > +	 */
> > +	(void)atomic_dec_and_test(&c->refcount);
> 
> Just use atomic_dec().
> 
> Any reason you're implementing your own allocator instead of setting
> ->cmd_size?

I need to do some more work on command management. Our legacy driver still has to manage its own allocation. Would like to leave this alone for now.

