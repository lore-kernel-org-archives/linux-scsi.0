From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] fix our current target reap infrastructure.
Date: Fri, 13 Dec 2013 22:32:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312132220260.7586-100000@netrider.rowland.org>
References: <1386990213.2055.97.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:56948 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754076Ab3LNDc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2013 22:32:29 -0500
In-Reply-To: <1386990213.2055.97.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 13 Dec 2013, James Bottomley wrote:

> This patch eliminates the reap_ref and replaces it with a proper kref.
> On last put of this kref, the target is removed from visibility in
> sysfs.  The final call to scsi_target_reap() for the device is done from
> __scsi_remove_device() and only if the device was made visible.  This
> ensures that the target disappears as soon as the last device is gone
> rather than waiting until final release of the device (which is often
> too long).


> @@ -474,28 +496,11 @@ static void scsi_target_reap_usercontext(struct work_struct *work)
>   */
>  void scsi_target_reap(struct scsi_target *starget)
>  {
> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> -	unsigned long flags;
> -	enum scsi_target_state state;
> -	int empty = 0;
> -
> -	spin_lock_irqsave(shost->host_lock, flags);
> -	state = starget->state;
> -	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
> -		empty = 1;
> -		starget->state = STARGET_DEL;
> -	}
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> -
> -	if (!empty)
> -		return;
> -
> -	BUG_ON(state == STARGET_DEL);
> -	if (state == STARGET_CREATED)
> +	BUG_ON(starget->state == STARGET_DEL);
> +	if (starget->state == STARGET_CREATED)
>  		scsi_target_destroy(starget);
>  	else
> -		execute_in_process_context(scsi_target_reap_usercontext,
> -					   &starget->ew);
> +		scsi_target_reap_ref_put(starget);

The refcount test and state change race with scsi_alloc_target().  
Maybe the race won't occur in practice, but to be safe you should hold
shost->host_lock throughout that time interval, as the original code
here does.

This means the kref approach won't work so easily.  You might as well
leave reap_ref as an ordinary int.

> @@ -393,7 +393,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	starget = to_scsi_target(parent);
>  
>  	spin_lock_irqsave(sdev->host->host_lock, flags);
> -	starget->reap_ref++;
>  	list_del(&sdev->siblings);
>  	list_del(&sdev->same_target_siblings);
>  	list_del(&sdev->starved_entry);

starget is now an unused local variable.  It can be eliminated.

Alan Stern

