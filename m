From: James.Smart@Emulex.Com
Subject: RE: [PATCH] Another fix for suspend i/o - validate dev state before transition
Date: Tue, 30 Nov 2004 16:17:30 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12E7D5@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:12789 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262311AbUK3VRe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 16:17:34 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id iAULHUni015879
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 13:17:31 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

James,

I have yet to see this hit scsi-misc-2.6...  hope it didn't get dropped.

-- james

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Smart, James
> Sent: Wednesday, November 17, 2004 1:40 PM
> To: linux-scsi@vger.kernel.org
> Subject: [PATCH] Another fix for suspend i/o - validate dev 
> state before
> transition
> 
> 
> The block/unblock patch reports stack dumps and illegal 
> transitions when the driver continues to call block or 
> unblock after the device has failed (moved into offline state 
> due to i/o error, etc). The LLDD/transport is unaware of the 
> sdev transition, so it doesn't know better.
> 
> This patch has the internal device block/unblock routines 
> validate the state transition before invoking it.
> 
> Hopefully this is it for this darn feature...
> 
> -- James S
> 
> 
> 
> 
> --- scsi_lib.c.2.6.10-rc2	2004-11-16 09:03:58.000000000 -0500
> +++ scsi_lib.c.NEW	2004-11-17 13:23:22.340667480 -0500
> @@ -1813,6 +1813,12 @@
>   *	state, all commands are deferred until the scsi lld reenables
>   *	the device with scsi_device_unblock or device_block_tmo fires.
>   *	This routine assumes the host_lock is held on entry.
> + *
> + *      As the LLDD/Transport that is calling this function doesn't
> + *	actually know what the device state is, the function may be
> + *	called at an inappropriate time. Therefore, before requesting
> + *	the state change, the function validates that the transition is
> + *	valid.
>   **/
>  int
>  scsi_internal_device_block(struct scsi_device *sdev)
> @@ -1821,6 +1827,10 @@
>  	unsigned long flags;
>  	int err = 0;
>  
> +	if ((sdev->sdev_state != SDEV_CREATED) &&
> +	    (sdev->sdev_state != SDEV_RUNNING))
> +		return 0;
> +
>  	err = scsi_device_set_state(sdev, SDEV_BLOCK);
>  	if (err)
>  		return err;
> @@ -1853,6 +1863,12 @@
>   *	(which must be a legal transition) allowing the midlayer to
>   *	goose the queue for this device.  This routine assumes the 
>   *	host_lock is held upon entry.
> + *
> + *      As the LLDD/Transport that is calling this function doesn't
> + *	actually know what the device state is, the function may be
> + *	called at an inappropriate time. Therefore, before requesting
> + *	the state change, the function validates that the transition is
> + *	valid.
>   **/
>  int
>  scsi_internal_device_unblock(struct scsi_device *sdev)
> @@ -1861,6 +1877,9 @@
>  	int err;
>  	unsigned long flags;
>  	
> +	if (sdev->sdev_state != SDEV_BLOCK)
> +		return 0;
> +	
>  	/* 
>  	 * Try to transition the scsi device to SDEV_RUNNING
>  	 * and goose the device queue if successful.  
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
