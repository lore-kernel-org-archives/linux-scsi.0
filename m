From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi host/scsi device ref count cleanup 3/4
Date: Thu, 10 Jul 2003 07:03:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030710140340.GA3336@beaverton.ibm.com>
References: <20030708222447.GA2232@beaverton.ibm.com> <20030708222541.GB2232@beaverton.ibm.com> <20030708222622.GC2232@beaverton.ibm.com> <20030708222706.GD2232@beaverton.ibm.com> <20030709085322.B21371@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:63192 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S269281AbTGJNqd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2003 09:46:33 -0400
Content-Disposition: inline
In-Reply-To: <20030709085322.B21371@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Tue, Jul 08, 2003 at 03:27:07PM -0700, Mike Anderson wrote:
> > -andmike
> > --
> > Michael Anderson
> > andmike@us.ibm.com
> > 
> > DESC
> > This is a cleanup patch for scsi_host removal.
> > 	- Addition of a host_flags member to the scsi_host strucuture to
> > 	  contain "state" of the host instance.
> > 	- Added SHOST_ADD, SHOST_DEL, SHOST_CANCEL, SHOST_RECOVERY states
> > 	  for a scsi host
> 
> Hmm, I'd call this shost_state.
> 

Done.

> 
> > +	spin_lock_irqsave(shost->host_lock, flags);
> > +	__set_bit(SHOST_CANCEL, &shost->host_flags);
> > +	spin_unlock_irqrestore(shost->host_lock, flags);
> > +	device_for_each_child(&shost->host_gendev, &recovery,
> > +			      scsi_device_cancel);
> > +	wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
> > +						&shost->host_flags)));
> 
> Using the non-atomic and the atomic bitops on one variable doesn't
> get you atomicity.  Always use the atomic ones if you need them sometimes.

Yes, I will clean this up. I went through many different iterations of
state implementations and got sloppy.

> > -void scsi_host_get(struct Scsi_Host *shost)
> > +struct Scsi_Host * scsi_host_get(struct Scsi_Host *shost)
> 
> struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
> 
> >  {
> > -	get_device(&shost->host_gendev);
> > -	class_device_get(&shost->class_dev);
> > +	struct Scsi_Host *res_shost = shost;
> > +
> > +	if (res_shost) {
> 
> I don't think we should allow for a NULL argument here.  Also
> can't we just return NULL in the error case?  That would
> simplify the code to:
> 
> struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
> {
> 	if (test_bit(SHOST_DEL, &shost->host_flags) ||
> 	    !get_device(&res_shost->host_gendev))
> 		return NULL;
> 	return shost;
> }
> 

Done.

> >  void scsi_host_put(struct Scsi_Host *shost)
> >  {
> > -	class_device_put(&shost->class_dev);
> 
> Can you explain why we don't need that anymore?  /me wants to learn a bit
> more about deep LDM magic..
> 

I do not know if I can reveal the magic as some of this is bread crumbs
created by previous bad paths taken :-).

I think SCSI core has unique issues stuck between the bus layer struct
device LDM registration and the block layer pure kobjects.

I removed the class get/puts to simplify the scsi_host_get code and
reduce ordering problems between the class and device release methods.
We could have chosen either the structure device or the class device to
ref count on. The struct device appears to be a better object to ref
count against as it is the child of the adapter struct device and the
parent of the scsi device struct device.

We also had an issue previously discussed by Alan of no class device
release method which could cause a problem if a user had an open on a
scsi_host class attribute..

So now our scsi host ref counting is like the following:
(Note: scsi_sysfs_remove_host has device_del as the patch I sent out was
wrong in this area and had some old code used to debug a issue with 

scsi_sysfs_init_host:
	(1) device_initialize host_gendev (ref = 1)
	(2) class_device_initialize shost_classdev (ref = 1)
	(3) get_device on host_gendev (ref+1 (2)) (This will keep the
	host_gendev in place until release of the shost_classdev)

scsi_sysfs_add_host
	(1) device_add on host_gendev (ref+1 (3)) and (ref+1) on parent
	(2) get_device on parent to hold them in place post device_del.
	(3) class_device_add on shost_classdev (ref+1 (2))

scsi_sysfs_remove_host
	(1) class_device_unregister on shost_classdev (ref-2) (del
	and put will result in release if no users have opens on host
	class attributes)
	(2) device_del on shost_gendev (ref-1) and (ref-1) on parent

scsi_host_cls_release
	put_device on host_gendev (ref-1) (This will allow the
	host_gendev release to be called)

scsi_host_dev_release
	(1) put_device on parent (ref-1)
	(2) scsi_free_shost

scsi_host_get
	get_device on host_gendev (ref+1)

scsi_host_put
	put_device on shost_gendev (ref-1)

Each scsi_device_register / scsi_device_unregister will incr / dec the
host_gendev ref.
	

> > -void scsi_set_device_offline(struct scsi_device *sdev)
> > +int scsi_device_cancel(struct device *dev, void *data)
> >  {
> >  	struct scsi_cmnd *scmd;
> >  	LIST_HEAD(active_list);
> >  	struct list_head *lh, *lh_sf;
> >  	unsigned long flags;
> > +	struct scsi_device *sdev = to_scsi_device(dev);
> > +	unsigned int recovery = *(unsigned int *)data;
> 
> I think the prototype should be
> 
> int scsi_device_cancel(struct scsi_device *sdev, int recovery)
> 
> and there should be a small wrapper for the LDM iterator.
> 

ok I created a wrapper function called scsi_device_cancel_cb (seems like
others where using callback but that seemed to long).


> > +shost_rd_attr(host_flags, "%lx\n");
> 
> Shouldn't these better be printed in ascii instead of the binary
> presentation that might aswell change form one kernelrelease to
> another?
> 

Yes, I was lazy and did this initially for debug. Do have a suggested
format (i.e., comma separated or colon separated or ??).

> > +/*
> > + * shost flags
> > + */
> > +#define SHOST_ADD	1
> > +#define SHOST_DEL	2
> > +#define SHOST_CANCEL	3
> > +#define SHOST_RECOVERY	4
> 
> Make this an enum?
> 

Done. I guess also since I am using set_bit that I should use the zero
shift (not that we will need all these states).

> >  	/* Dissociate from the USB device */
> >  	dissociate_dev(us);
> >  
> > -	/* Begin the SCSI host removal sequence */
> > -	if (scsi_remove_host(us->host)) {
> > -		US_DEBUGP("-- SCSI refused to remove the host\n");
> > -		BUG();
> > -		return;
> > -	}
> > +	scsi_remove_host(us->host);
> 
> Also in usb-storage the loop over my_devices to set them offline
> just before scsi_remove_host should be nuked now, shouldn't it?

Yes it should. I made this a separate patch in the series
in case Matthew / Alan see other changes needed with usb storage
shutdown.

-andmike
--
Michael Anderson
andmike@us.ibm.com

