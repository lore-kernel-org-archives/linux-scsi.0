From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 2/5] scsi_dh: add scsi_dh_attached_handler_name
Date: Thu, 17 May 2012 17:23:34 -0400
Message-ID: <20120517212333.GA5312@redhat.com>
References: <1336612366-30794-1-git-send-email-snitzer@redhat.com>
 <20120510213112.GA7374@redhat.com>
 <1337289153.2825.9.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760151Ab2EQVXp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 17:23:45 -0400
Content-Disposition: inline
In-Reply-To: <1337289153.2825.9.camel@chandra-lucid.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com, hare@suse.de, babu.moger@netapp.com, dm-devel@redhat.com

On Thu, May 17 2012 at  5:12pm -0400,
Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> > +/*
> > + * scsi_dh_attached_handler_name - Get attached device handler's name
> > + * @q - Request queue that is associated with the scsi_device
> > + *      that may have a device handler attached
> > + * @gfp - the GFP mask used in the kmalloc() call when allocating memory
> > + *
> > + * Returns name of attached handler, NULL if no handler is attached.
> > + * Caller must take care to free the returned string.
> > + */
> > +const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
> > +{
> > +	unsigned long flags;
> > +	struct scsi_device *sdev;
> > +	const char *handler_name = NULL;
> > +
> > +	spin_lock_irqsave(q->queue_lock, flags);
> > +	sdev = q->queuedata;
> > +	if (!sdev || !get_device(&sdev->sdev_gendev))
> > +		sdev = NULL;
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> > +
> > +	if (!sdev)
> 
> put_device() missing here.

Not that I can see.  If sdev is NULL then get_device never succeeded.

(same pattern is used in scsi_dh_detach)

> > +		return NULL;
> > +
> > +	if (sdev->scsi_dh_data)
> > +		handler_name = kstrdup(sdev->scsi_dh_data->scsi_dh->name, gfp);
> > +
> > +	put_device(&sdev->sdev_gendev);
> > +	return handler_name;
> > +}
> > +EXPORT_SYMBOL_GPL(scsi_dh_attached_handler_name);
> > +
> >  static struct notifier_block scsi_dh_nb = {
> >  	.notifier_call = scsi_dh_notifier
> >  };
> > Index: linux-2.6/include/scsi/scsi_dh.h
> > ===================================================================
> > --- linux-2.6.orig/include/scsi/scsi_dh.h
> > +++ linux-2.6/include/scsi/scsi_dh.h
> > @@ -60,6 +60,7 @@ extern int scsi_dh_activate(struct reque
> >  extern int scsi_dh_handler_exist(const char *);
> >  extern int scsi_dh_attach(struct request_queue *, const char *);
> >  extern void scsi_dh_detach(struct request_queue *);
> > +extern const char *scsi_dh_attached_handler_name(struct request_queue *, gfp_t);
> >  extern int scsi_dh_set_params(struct request_queue *, const char *);
> >  #else
> >  static inline int scsi_dh_activate(struct request_queue *req,
> > @@ -80,6 +81,11 @@ static inline void scsi_dh_detach(struct
> >  {
> >  	return;
> >  }
> > +static inline const char *scsi_dh_attached_handler_name(struct request_queue *q,
> > +							gfp_t gfp)
> > +{
> > +	return NULL;
> > +}
> >  static inline int scsi_dh_set_params(struct request_queue *req, const char *params)
> >  {
> >  	return -SCSI_DH_NOSYS;
> > 
> 
> 
