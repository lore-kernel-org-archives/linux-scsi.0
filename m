From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi host/scsi device ref count cleanup 3/4
Date: Wed, 9 Jul 2003 08:53:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030709085322.B21371@infradead.org>
References: <20030708222447.GA2232@beaverton.ibm.com> <20030708222541.GB2232@beaverton.ibm.com> <20030708222622.GC2232@beaverton.ibm.com> <20030708222706.GD2232@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:39695 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265764AbTGIHip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2003 03:38:45 -0400
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 19a9lS-0007BW-00
	for linux-scsi@vger.kernel.org; Wed, 09 Jul 2003 08:53:22 +0100
Content-Disposition: inline
In-Reply-To: <20030708222706.GD2232@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Jul 08, 2003 at 03:27:07PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Jul 08, 2003 at 03:27:07PM -0700, Mike Anderson wrote:
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
> DESC
> This is a cleanup patch for scsi_host removal.
> 	- Addition of a host_flags member to the scsi_host strucuture to
> 	  contain "state" of the host instance.
> 	- Added SHOST_ADD, SHOST_DEL, SHOST_CANCEL, SHOST_RECOVERY states
> 	  for a scsi host

Hmm, I'd call this shost_state.


> +	spin_lock_irqsave(shost->host_lock, flags);
> +	__set_bit(SHOST_CANCEL, &shost->host_flags);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +	device_for_each_child(&shost->host_gendev, &recovery,
> +			      scsi_device_cancel);
> +	wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
> +						&shost->host_flags)));

Using the non-atomic and the atomic bitops on one variable doesn't
get you atomicity.  Always use the atomic ones if you need them sometimes.

> +/**
> + * scsi_remove_host - remove a scsi host
> + * @shost:	a pointer to a scsi host to remove
> + **/
> +void scsi_remove_host(struct Scsi_Host *shost)

A, cool I already had a patch pending to make this a void retval.

> -void scsi_host_get(struct Scsi_Host *shost)
> +struct Scsi_Host * scsi_host_get(struct Scsi_Host *shost)

struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)

>  {
> -	get_device(&shost->host_gendev);
> -	class_device_get(&shost->class_dev);
> +	struct Scsi_Host *res_shost = shost;
> +
> +	if (res_shost) {

I don't think we should allow for a NULL argument here.  Also
can't we just return NULL in the error case?  That would
simplify the code to:

struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
{
	if (test_bit(SHOST_DEL, &shost->host_flags) ||
	    !get_device(&res_shost->host_gendev))
		return NULL;
	return shost;
}

>  void scsi_host_put(struct Scsi_Host *shost)
>  {
> -	class_device_put(&shost->class_dev);

Can you explain why we don't need that anymore?  /me wants to learn a bit
more about deep LDM magic..

> -void scsi_set_device_offline(struct scsi_device *sdev)
> +int scsi_device_cancel(struct device *dev, void *data)
>  {
>  	struct scsi_cmnd *scmd;
>  	LIST_HEAD(active_list);
>  	struct list_head *lh, *lh_sf;
>  	unsigned long flags;
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	unsigned int recovery = *(unsigned int *)data;

I think the prototype should be

int scsi_device_cancel(struct scsi_device *sdev, int recovery)

and there should be a small wrapper for the LDM iterator.

> +shost_rd_attr(host_flags, "%lx\n");

Shouldn't these better be printed in ascii instead of the binary
presentation that might aswell change form one kernelrelease to
another?

> +/*
> + * shost flags
> + */
> +#define SHOST_ADD	1
> +#define SHOST_DEL	2
> +#define SHOST_CANCEL	3
> +#define SHOST_RECOVERY	4

Make this an enum?

>  	/* Dissociate from the USB device */
>  	dissociate_dev(us);
>  
> -	/* Begin the SCSI host removal sequence */
> -	if (scsi_remove_host(us->host)) {
> -		US_DEBUGP("-- SCSI refused to remove the host\n");
> -		BUG();
> -		return;
> -	}
> +	scsi_remove_host(us->host);

Also in usb-storage the loop over my_devices to set them offline
just before scsi_remove_host should be nuked now, shouldn't it?

