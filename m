From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/7] scsi_dh: add skeleton for SCSI Device Handlers
Date: Tue, 04 Mar 2008 14:25:56 -0800
Message-ID: <1204669556.4963.138.camel@linuxchandra>
References: <20080228010828.5535.74088.sendpatchset@localhost.localdomain>
	 <20080228010834.5535.41038.sendpatchset@localhost.localdomain>
	 <1204666622.3091.86.camel@localhost.localdomain>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:48861 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbYCDW0E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 17:26:04 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m24MPFxP003950
	for <linux-scsi@vger.kernel.org>; Tue, 4 Mar 2008 17:25:15 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m24MPwv3220178
	for <linux-scsi@vger.kernel.org>; Tue, 4 Mar 2008 15:25:58 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m24MPvTl015958
	for <linux-scsi@vger.kernel.org>; Tue, 4 Mar 2008 15:25:58 -0700
In-Reply-To: <1204666622.3091.86.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, michaelc@cs.wisc.edu, jens.axboe@oracle.com, agk@redhat.com

Thanks for your comments, James.

On Tue, 2008-03-04 at 15:37 -0600, James Bottomley wrote:
> On Wed, 2008-02-27 at 17:08 -0800, Chandra Seetharaman wrote:
> > Subject: scsi_dh: add skeleton for SCSI Device Handlers
> > 
> > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > 
> > Add base support to the SCSI subsystem for SCSI device handlers.
> 
> Generally, this is much cleaner and an easier implementation to follow,
> thanks.

Cool, thanks.
> 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

<snip>

>   	if (! scsi_command_normalize_sense(scmd, &sshdr))
> > @@ -306,6 +307,15 @@ static int scsi_check_sense(struct scsi_
> >  	if (scsi_sense_is_deferred(&sshdr))
> >  		return NEEDS_RETRY;
> >  
> > +	if (sdev->sdev_dh && sdev->sdev_dh->check_sense) {
> > +		int rc;
> > +
> > +		rc = sdev->sdev_dh->check_sense(sdev, &sshdr);
> > +		if (rc != SUCCESS)
> 
> I can see reasons for a sense handler to return SUCCESS to trigger a
> fast failure (say not ready needs initialising command or something, so
> this should be a specific sense handler doesn't care return code.

understand. I can return a NOT_HANDLED. Is it ok to add it as 0x2008 to
scsi.h ? or any suggestions.

> 
> > +			return rc;
> > +		/* handler does not care. Drop down to default handling */
> > +	}
> > +
> >  	/*
> >  	 * Previous logic looked for FILEMARK, EOM or ILI which are
> >  	 * mainly associated with tapes and returned SUCCESS.
> > Index: linux-2.6.25-rc2-mm1/include/scsi/scsi_device.h
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/include/scsi/scsi_device.h
> > +++ linux-2.6.25-rc2-mm1/include/scsi/scsi_device.h
> > @@ -161,9 +161,25 @@ struct scsi_device {
> >  
> >  	struct execute_work	ew; /* used to get process context on put */
> >  
> > +	struct scsi_device_handler *sdev_dh;
> > +	void			*sdev_dh_data;
> 
> This is a bit wasteful of 8 bytes ... why not simply move the
> sdev_dh_data inside the sdev_dh structure, then if there's no handler
> it's not occupying space?

There is one sdev_dh per handler, and one sdev_dh_data per device.

But, structures can be redefined to save space when there is no hardware
handler present. But, there will be a additional pointer dereference
while invoking the functions, is it ok ?
Here is what I am thinking:
--------
struct scsi_device_handler { }; /* same as now */
struct scsi_dh_data {
	struct scsi_device_handler *sdev_dh;
	char buf[0];
};
and the handlers will allocate appropriate size for this data structure.

struct scsi_device {
	:
	:
	struct scsi_dh_data *scsi_dh_data;
};

all the function invocations will be like
	sdev->scsi_dh_data->sdev_dh->activate,prep_fn,check_sense
------------

> 
> >  	enum scsi_device_state sdev_state;
> >  	unsigned long		sdev_data[0];
> >  } __attribute__((aligned(sizeof(unsigned long))));
> > 
<snip>

> +int scsi_dh_activate(struct request_queue *q)
> > +{
> > +	int err = SCSI_DH_NOSYS;
> > +	struct scsi_device *sdev;
> > +	struct scsi_device_handler *sdev_dh;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(q->queue_lock, flags);
> > +	sdev = q->queuedata;
> > +	sdev_dh = sdev->sdev_dh;
> > +	if (!sdev || !sdev_dh || !get_device(&sdev->sdev_gendev)) {
> > +		spin_unlock_irqrestore(q->queue_lock, flags);
> > +		goto done;
> > +	}
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> 
> just on programming style, this is marginally better expressed as
> 
> err = (!sdev || !sdev_dh || !get_device(&sdev->sdev_gendev)) ? SCSI_DH_NOSYS : 0;
> spin_unlock_irqrestore(q->queue_lock, flags);
> 
> if (err)
> 	goto done; (or even return err)
> 
> Just to eliminate the duplicate unlocks.

will do.

> 
> > +
> > +	if (sdev_dh->activate)
> > +		err = sdev_dh->activate(sdev);
> > +	put_device(&sdev->sdev_gendev);
> > +done:
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(scsi_dh_activate);
> >
<snip>

>  +
> > +extern int scsi_dh_activate(struct request_queue *);
> > Index: linux-2.6.25-rc2-mm1/drivers/scsi/scsi_lib.c
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/drivers/scsi/scsi_lib.c
> > +++ linux-2.6.25-rc2-mm1/drivers/scsi/scsi_lib.c
> > @@ -1156,6 +1156,11 @@ int scsi_setup_fs_cmnd(struct scsi_devic
> >  	struct scsi_cmnd *cmd;
> >  	int ret = scsi_prep_state_check(sdev, req);
> >  
> > +	if ((ret == BLKPREP_OK) && (req->cmd_type == REQ_TYPE_FS)) {
> > +		if (sdev->sdev_dh && sdev->sdev_dh->prep_fn)
> > +			ret = sdev->sdev_dh->prep_fn(sdev);
> > +	}
> > +
> >  	if (ret != BLKPREP_OK)
> >  		return ret;
> 
> This is the fastpath and we need to be careful.  We already checked
> cmd_type == REQ_TYPE before calling scsi_setup_fs_cmnd(), so there's no
> need to check it again, surely.

Yeah, this was a cut-n-paste problem. I had this block at the higher
level, moved it here to get rid of that check, but forgot to remove
that :)

> 
> Plus, since we're doing if (ret != BLKPREP_OK) just below this, if you
> move the if down below that, it can simply become
> 
> if (unlikely(sdev->sdev_dh && sdev->sdev_dh->prep_fn)) {
> 	ret = sdev->sdev_dh->prep_fn(sdev);
> 	if (ret != BLKPREP_OK)
> 		return ret;
> }
> 
> Because the two outer gates have already been checked.  The unlikely
> expresses the fact that having device handlers isn't currently the very
> common case.

will do.
> 
> Presumably the gcc optimiser would see all of this, but it never hurts
> to make sure.
> 
> James
> 
> 
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


