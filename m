From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 1/6] fnic: add main file with module infrastructure,
 fnic structure, Makefile
Date: Thu, 12 Mar 2009 15:13:36 -0500
Message-ID: <49B96CF0.2040605@cs.wisc.edu>
References: <20090228022152.12158.11200.stgit@feynman.nuovasystems.com> <20090228023122.12158.56310.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41045 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbZCLUNt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Mar 2009 16:13:49 -0400
In-Reply-To: <20090228023122.12158.56310.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jeykholt@cisco.com

Abhijeet Joglekar wrote:
> +
> +void fnic_handle_link_event(struct fnic *fnic)
> +{
> +	int link_status = vnic_dev_link_status(fnic->vdev);
> +	struct fnic_event *event;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	if (fnic->stop_rx_link_events) {
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		return;
> +	}
> +
> +	FNIC_MAIN_DBG(KERN_DEBUG, DFX "link %s\n", fnic->fnic_no,
> +		      (link_status ? "up" : "down"));
> +
> +	event = kmem_cache_alloc(fnic_ev_cache, GFP_ATOMIC);
> +	if (!event) {
> +		FNIC_MAIN_DBG(KERN_DEBUG, DFX "Cannot allocate a event, "
> +			      "cannot indicate link event to FCS\n",
> +			      fnic->fnic_no);
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		return;
> +	}
> +
> +	/* Queue the link event in fnic workQ */
> +	memset(event, 0, sizeof(struct fnic_event));
> +	event->fnic = fnic;
> +	event->ev_type = EV_TYPE_LINK_UP;


How may events types are there going to be?

If the link is down and you need this to get the link up again then you 
do not want to rely on just a GFP_ATOMIC allocation.

If there is just a couple events then maybe allocating a work_struct for 
each one in the fnic struct would be ok. You could then just queue that 
up here and add some code to handle multiple ups/downs.


Or at least I think you want a mempool of events. That does not fully 
over you but at least you know you can handle some events and then code 
it so you can recover.


> +	if (!link_status) {
> +		event->ev_type = EV_TYPE_LINK_DOWN;
> +		fnic->lport->host_stats.link_failure_count++;
> +	}
> +	fnic->event_count++;
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +	INIT_WORK(&event->event_work, fnic_event_work);
> +	queue_work(fnic_event_queue, &event->event_work);
> +
> +}
> +
> +static int fnic_notify_set(struct fnic *fnic)
> +{
> +	int err;
> +
> +	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
> +	case VNIC_DEV_INTR_MODE_INTX:
> +		err = vnic_dev_notify_set(fnic->vdev, FNIC_INTX_NOTIFY);
> +		break;
> +	case VNIC_DEV_INTR_MODE_MSI:
> +		err = vnic_dev_notify_set(fnic->vdev, -1);
> +		break;
> +	case VNIC_DEV_INTR_MODE_MSIX:
> +		err = vnic_dev_notify_set(fnic->vdev, FNIC_MSIX_ERR_NOTIFY);
> +		break;
> +	default:
> +		printk(KERN_ERR DFX "Interrupt mode should be set up"
> +		       " before devcmd notify set %d\n", fnic->fnic_no,
> +		       vnic_dev_get_intr_mode(fnic->vdev));
> +		err = -1;
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static void fnic_notify_timer(unsigned long data)
> +{
> +	struct fnic *fnic = (struct fnic *)data;
> +
> +	fnic_handle_link_event(fnic);
> +	mod_timer(&fnic->notify_timer,
> +		  round_jiffies(jiffies + FNIC_NOTIFY_TIMER_PERIOD));
> +}
> +
> +static void fnic_notify_timer_start(struct fnic *fnic)
> +{
> +	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
> +	case VNIC_DEV_INTR_MODE_MSI:
> +		/*
> +		 * Schedule first timeout immediately. The driver is
> +		 * initiatialized and ready to look for link up notification
> +		 */
> +		mod_timer(&fnic->notify_timer, jiffies);


Do you just want to call fnic_notify_timer() here instead of going 
through the timer?




> +}
> +
> +static int __devinit fnic_probe(struct pci_dev *pdev,
> +				const struct pci_device_id *ent)
> +{
> +	struct Scsi_Host *host;
> +	struct fc_lport *lp;
> +	struct fnic *fnic;
> +	mempool_t *pool;
> +	int err;
> +	int i;
> +	unsigned long flags;
> +
> +	/*
> +	 * Allocate SCSI Host and set up association between host,
> +	 * local port, and fnic
> +	 */
> +	host = scsi_host_alloc(&fnic_host_template,
> +			       sizeof(struct fc_lport) + sizeof(struct fnic));
> +	if (!host) {
> +		printk(KERN_ERR PFX "Unable to alloc SCSI host\n");
> +		err = -ENOMEM;
> +		goto err_out;
> +	}
> +	lp = shost_priv(host);
> +	lp->host = host;
> +	fnic = lport_priv(lp);
> +	fnic->lport = lp;
> +
> +	/* fnic number starts from 0 onwards */
> +	fnic->fnic_no = atomic_add_return(1, &fnic_no);

This is basically the shost->host_no. I think it is best if you just use 
that so when you print it out users do not have look through the logs to 
match up the fnic host no with the scsi host no.

I think something built on shost_printk  or dev_printk is nice to use 
for driver logging too. I think this is optional and if needed can 
probably be fixed after this is merged though.
