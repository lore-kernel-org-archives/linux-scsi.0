From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] SCSI core: better initialization for sdev->scsi_level
Date: Mon, 08 Jan 2007 19:13:06 -0500
Message-ID: <45A2DE12.4050603@torque.net>
References: <Pine.LNX.4.44L0.0701081107440.4249-100000@iolanthe.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58711 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXAIANZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2007 19:13:25 -0500
In-Reply-To: <Pine.LNX.4.44L0.0701081107440.4249-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> Both scsi_device and scsi_target include a scsi_level field, and the
> SCSI core makes a half-hearted effort to keep the values equal.
> Ultimately this effort may be doomed, since as far as I know there is
> no reason why all LUNs in a target must report the same "ANSI-approved
> version" number.  But for the most part it should work okay.
> 
> This patch (as834) changes the SCSI core so that after the first LUN
> has been probed and the target's scsi_level is known, further LUNs
> default to the target's scsi_level and not to SCSI_2.

Alan,
Umm, scsi_level is a mangled value derived from the
"version" field in an INQUIRY standard response. As
such it is per logical unit ***. There is nothing to stop
a single target (especially if it is a bridge that
maps targets at the remote end to luns) having a wide
variety of lus with different "version" values (and
different peripheral device types).

IMO scsi_level should only be per lu which means it
should only exist in the scsi_device structure.
If the scsi mid level was really advanced it could
track the "version" value in the INQUIRY response to
"well known" logical units (see spc4r08.pdf section 8)
because these really are per target. I don't expect
that to happen any time soon (and there wouldn't be
much benefit).

So the existing code seems broken but I'm not sure
your patch advances things.


*** this statement assumes the "peripheral qualifier"
    field is 0, otherwise there is no real lu at the
    given lun

Doug Gilbert


> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> This patch will affect the CDB in INQUIRY commands sent to LUNs above 0 
> when LUN-0 reports a scsi_level of 0; the LUN bits will no longer be set 
> in the second byte of the CDB.  This is as it should be.  Nevertheless, 
> it's possible that some wacky device might be adversely affected.  I doubt 
> anyone will complain...
> 
> Alan Stern
> 
> 
> Index: usb-2.6/drivers/scsi/scsi_scan.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> +++ usb-2.6/drivers/scsi/scsi_scan.c
> @@ -382,6 +382,7 @@ static struct scsi_target *scsi_alloc_ta
>  	INIT_LIST_HEAD(&starget->siblings);
>  	INIT_LIST_HEAD(&starget->devices);
>  	starget->state = STARGET_RUNNING;
> +	starget->scsi_level = SCSI_2;
>   retry:
>  	spin_lock_irqsave(shost->host_lock, flags);
>  
> Index: usb-2.6/drivers/scsi/scsi_sysfs.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
> +++ usb-2.6/drivers/scsi/scsi_sysfs.c
> @@ -922,7 +922,7 @@ void scsi_sysfs_device_initialize(struct
>  	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
>  		 "%d:%d:%d:%d", sdev->host->host_no,
>  		 sdev->channel, sdev->id, sdev->lun);
> -	sdev->scsi_level = SCSI_2;
> +	sdev->scsi_level = starget->scsi_level;
>  	transport_setup_device(&sdev->sdev_gendev);
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_add_tail(&sdev->same_target_siblings, &starget->devices);
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

