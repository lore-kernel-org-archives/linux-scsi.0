From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 11/13] scsi: add reprep arg to scsi_requeue_command() and make it public
Date: Fri, 1 Apr 2005 14:35:59 +0900
Message-ID: <20050401053559.GI11318@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.ABDB1FF4@htj.dyndns.org> <20050331103203.GA14266@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.200]:64703 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262632AbVDAFgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 00:36:05 -0500
Received: by wproxy.gmail.com with SMTP id 36so425440wri
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 21:36:04 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20050331103203.GA14266@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, Christoph.

On Thu, Mar 31, 2005 at 11:32:03AM +0100, Christoph Hellwig wrote:
> > - * Arguments:	q	- queue to operate on
> > - *		cmd	- command that may need to be requeued.
> > + * Arguments:	cmd	- command that may need to be requeued.
> > + *		reprep	- needs to prep the command again?
> >   *
> >   * Returns:	Nothing
> >   *
> > @@ -478,11 +478,16 @@ void scsi_device_unbusy(struct scsi_devi
> >   *		we need to request the blocks that come after the bad
> >   *		sector.
> >   */
> > -static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
> > +void scsi_requeue_command(struct scsi_cmnd *cmd, int reprep)
> >  {
> > +	struct request_queue *q = cmd->device->request_queue;
> >  	unsigned long flags;
> >  
> > -	cmd->request->flags &= ~REQ_DONTPREP;
> > +	cmd->state = SCSI_STATE_MLQUEUE;
> > +	cmd->owner = SCSI_OWNER_MIDLEVEL;
> > +
> > +	if (reprep)
> > +		cmd->request->flags &= ~REQ_DONTPREP;
> 
> the flag is not needed, you can move the clearing of the flag to the
> caller.  And given that there's lots of callers rename the
> scsi_requeue_command without it to __scsi_requeue_command and make
> scsi_requeue_command a tiny inline wrapper around it that clears it.

 I opt for scsi_requeue_command() and scsi_requeue_command_reprep()
for clarity (the latter being static inline).

 Thanks a lot for all your inputs. :-)

-- 
tejun

