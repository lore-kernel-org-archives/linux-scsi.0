From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 10:12:09 -0700
Message-ID: <20050621171209.GB29396@us.ibm.com>
References: <1118930260.4998.6.camel@mulgrave> <Pine.LNX.4.44L0.0506181554270.3347-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:15751 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262238AbVFURLv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 13:11:51 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5LHBnQ9028735
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 13:11:49 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5LHBnKK259148
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 13:11:49 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5LHBmCE004104
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 13:11:48 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0506181554270.3347-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> James and Mike:
> 
> Here's my patch (as529), very lightly tested.  Among the changes:
> 

I ran the updated version of your patch on a scsi-misc-2.6 kernel with an
Emulex and Qlogic adapter. It does not find any devices of these adapters
during scan. I need to look into this.

> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> --- a/include/scsi/scsi_host.h	Mon Jun 13 14:57:26 2005
> +++ b/include/scsi/scsi_host.h	Fri Jun 17 22:19:09 2005
> @@ -411,6 +411,7 @@
>  	SHOST_DEL,
>  	SHOST_CANCEL,
>  	SHOST_RECOVERY,
> +	SHOST_REMOVE,
>  };

Well it is a larger change we should consider migrating the shost state
model to one like the scsi device uses and also align on similar states
if possible.

>  
>  struct Scsi_Host {
> --- a/drivers/scsi/hosts.c	Mon Jun 13 14:57:14 2005
> +++ b/drivers/scsi/hosts.c	Fri Jun 17 22:20:19 2005
> @@ -74,8 +74,13 @@
>   **/
>  void scsi_remove_host(struct Scsi_Host *shost)
>  {
> -	scsi_forget_host(shost);
> +	set_bit(SHOST_REMOVE, &shost->shost_state);
>  	scsi_host_cancel(shost, 0);
> +
> +	down(&shost->scan_mutex);	/* Wait for scanning to stop */
> +	up(&shost->scan_mutex);
> +
> +	scsi_forget_host(shost);
>  	scsi_proc_host_rm(shost);
>  
>  	set_bit(SHOST_DEL, &shost->shost_state);

Moving scsi_forget_host to after scsi_host_cancel will cause the sd cache
flush routines to fail. Also as previously mentioned I would like to
understand if we still need the cancel functionality. I believe there are
end case races with cancel and LLDD really should be able to return all
commands prior to calling scsi_remove_host or post (prior to the last
shost put).

The bit is set to SHOST_REMOVE then scsi_host_cancel is called which will
set the bit SHOST_CANCEL. Later on scan is stopped only if state is
SHOST_REMOVE. Is that what you wanted?

>  int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
> @@ -1347,11 +1363,14 @@
>  		return -EINVAL;
>  
>  	down(&shost->scan_mutex);
> +	if (test_bit(SHOST_REMOVE, &shost->shost_state))
> +		goto out;
>  	if (channel == SCAN_WILD_CARD) 
>  		for (channel = 0; channel <= shost->max_channel; channel++)
>  			scsi_scan_channel(shost, channel, id, lun, rescan);
>  	else
>  		scsi_scan_channel(shost, channel, id, lun, rescan);
> +out:
>  	up(&shost->scan_mutex);
>  
>  	return 0;

It might be better to have a wrapper function so if we change the cases
where we would allow scanning we can change just one place. Also we might
cover more states if we reverse the logic on the check and look for the
case we allow scanning (see previous comment about cancel). This is what I
did in my previous patch.

> @@ -1383,23 +1402,17 @@
>  
>  void scsi_forget_host(struct Scsi_Host *shost)
>  {
> -	struct scsi_target *starget, *tmp;
> +	struct scsi_device *sdev;
>  	unsigned long flags;
>  
> -	/*
> -	 * Ok, this look a bit strange.  We always look for the first device
> -	 * on the list as scsi_remove_device removes them from it - thus we
> -	 * also have to release the lock.
> -	 * We don't need to get another reference to the device before
> -	 * releasing the lock as we already own the reference from
> -	 * scsi_register_device that's release in scsi_remove_device.  And
> -	 * after that we don't look at sdev anymore.
> -	 */
> +restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
> +	list_for_each_entry(sdev, &shost->__devices, siblings) {
> +		if (sdev->sdev_state == SDEV_DEL)
> +			continue;
>  		spin_unlock_irqrestore(shost->host_lock, flags);
> -		scsi_remove_target(&starget->dev);
> -		spin_lock_irqsave(shost->host_lock, flags);
> +		scsi_remove_device(sdev);
> +		goto restart;
>  	}
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  }

Well it saves some some overhead we really should delete the parent
and let it handle cleanup of children. If we switch to using the driver
model lists the code would be easier to migrate.

-andmike
--
Michael Anderson
andmike@us.ibm.com

