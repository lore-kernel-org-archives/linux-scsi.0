From: Brian King <brking@us.ibm.com>
Subject: Re: command queueing cmd_per_lun, queue_depth and tags
Date: Fri, 07 Apr 2006 17:29:28 -0500
Message-ID: <4436E7C8.5030204@us.ibm.com>
References: <20060407214954.GA4990@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35723 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964993AbWDGW3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2006 18:29:31 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k37MTUrQ026256
	for <linux-scsi@vger.kernel.org>; Fri, 7 Apr 2006 18:29:30 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k37MTUuE256154
	for <linux-scsi@vger.kernel.org>; Fri, 7 Apr 2006 18:29:30 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k37MTUIS019439
	for <linux-scsi@vger.kernel.org>; Fri, 7 Apr 2006 18:29:30 -0400
In-Reply-To: <20060407214954.GA4990@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Currently cmd_per_lun is the default queue depth for both tagged and
> untagged queueing. That is, if the LLDD does not modify queue_depth in its
> slave_configure, queue_depth will be set to cmd_per_lun, no matter what
> the command queueing/tag support. 
> 
> If we don't allow queueing in the LLDD, and cmd_per_lun is supposed to be
> the default depth for untagged support, shouldn't it always be 1, and
> hence go away? 

This seems to assume there are no SCSI devices which do command queuing, but do
not support queue tags. This is not the case.

> Similarily, why do some LLDD's use a cmd_per_lun of 3, or (like
> ncr53c8xx_slave_configure) set queue_depth for !tagged_supported to
> anything other than 1?

In the case of ipr, there are two scenarios. The first is for JBOD disks.
I use a default queue depth of 6 in ipr. When running untagged, with a queue depth
of > 1, the ipr adapter firmware then maintains a queue, guaranteeing only
one command will be outstanding to the device at once. This lower level
queue allows for a faster turnaround of commands and improved performance.
The second case is that of RAID arrays. These show up as logical scsi disks.
They support command queueing, but not tagged command queueing.

> I know (at least) FCP can always do simple queueing, but I don't think
> scsi core should allow multiple commands to be sent if the device does not
> have CMDQUE (or BQUE).

This will break both of the working scenarios I described above for ipr
and performance will suffer significantly. The inquiry data for ipr RAID
arrays does not set either CMDQUE or BQUE.


> Also we don't even check the BQUE in the INQUIRY result (byte 6, bit 7).
> Should this be changed? That is set tagged_supported if BQUE is set, like
> we do for CMDQUE (byte 7 bit 1). And also set simple_tags if
> tagged_supported is set.

I don't like the idea of always enabling TCQ in scsi core simply if
the device supports it. What if the HBA does not support it? To make
matters more interesting, what if the HBA does not support TCQ, but does
support untagged command queueing, similar to ipr as described above?
Additionally, ipr is currently relying on the fact that TCQ does not
get enabled by default. It lets userspace code enable it after verifying
the mode page settings of the drive for things like qerr, which the adapter
firmware has dependencies on.

Brian

> That is something like this patch to always set queue_depth to 1 by
> default, then later if BQUE or CMDQUE are set, set queue_depth to
> cmd_per_lun. Of course slave_configure can still override this, but this
> change means queue_depth is 1 if you call scsi_deactivate_tcq().
> 
> Using this patch might also require changes in some LLDD's, like ipr.
> 
> diff -uprN -X /home/patman/dontdiff /home/linux/views/linux-2.6.17-rc1/drivers/scsi/scsi.c linux-2.6.17-rc1/drivers/scsi/scsi.c
> --- /home/linux/views/linux-2.6.17-rc1/drivers/scsi/scsi.c	2006-04-03 11:35:58.000000000 -0700
> +++ linux-2.6.17-rc1/drivers/scsi/scsi.c	2006-04-07 10:00:15.000000000 -0700
> @@ -866,9 +866,7 @@ EXPORT_SYMBOL(scsi_finish_command);
>   * Arguments:	sdev	- SCSI Device in question
>   * 		tagged	- Do we use tagged queueing (non-0) or do we treat
>   * 			  this device as an untagged device (0)
> - * 		tags	- Number of tags allowed if tagged queueing enabled,
> - * 			  or number of commands the low level driver can
> - * 			  queue up in non-tagged mode (as per cmd_per_lun).
> + * 		tags	- Number of tags allowed if tagged queueing enabled
>   *
>   * Returns:	Nothing
>   *
> @@ -883,6 +881,8 @@ void scsi_adjust_queue_depth(struct scsi
>  {
>  	unsigned long flags;
>  
> +	if (!tagged)
> +		tags = 1;
>  	/*
>  	 * refuse to set tagged depth to an unworkable size
>  	 */
> @@ -913,7 +913,6 @@ void scsi_adjust_queue_depth(struct scsi
>  				    "disabled\n");
>  		case 0:
>  			sdev->ordered_tags = sdev->simple_tags = 0;
> -			sdev->queue_depth = tags;
>  			break;
>  	}
>   out:
> @@ -935,8 +934,7 @@ EXPORT_SYMBOL(scsi_adjust_queue_depth);
>   *
>   * Returns:	0 - No change needed
>   * 		>0 - Adjust queue depth to this new depth
> - * 		-1 - Drop back to untagged operation using host->cmd_per_lun
> - * 			as the untagged command depth
> + * 		-1 - Drop back to untagged operation
>   *
>   * Lock Status:	None held on entry
>   *
> @@ -960,7 +958,7 @@ int scsi_track_queue_full(struct scsi_de
>  		return 0;
>  	if (sdev->last_queue_full_depth < 8) {
>  		/* Drop back to untagged */
> -		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
> +		scsi_adjust_queue_depth(sdev, 0, 1);
>  		return -1;
>  	}
>  	
> diff -uprN -X /home/patman/dontdiff /home/linux/views/linux-2.6.17-rc1/drivers/scsi/scsi_scan.c linux-2.6.17-rc1/drivers/scsi/scsi_scan.c
> --- /home/linux/views/linux-2.6.17-rc1/drivers/scsi/scsi_scan.c	2006-04-03 11:35:58.000000000 -0700
> +++ linux-2.6.17-rc1/drivers/scsi/scsi_scan.c	2006-04-07 09:47:47.000000000 -0700
> @@ -256,7 +256,7 @@ static struct scsi_device *scsi_alloc_sd
>  	}
>  
>  	sdev->request_queue->queuedata = sdev;
> -	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
> +	scsi_adjust_queue_depth(sdev, 0, 1);
>  
>  	scsi_sysfs_device_initialize(sdev);
>  
> @@ -719,9 +719,12 @@ static int scsi_add_lun(struct scsi_devi
>  	 * End sysfs code.
>  	 */
>  
> -	if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
> -	    !(*bflags & BLIST_NOTQ))
> +	if ((sdev->scsi_level >= SCSI_2) && ((inq_result[6] & 0x10) ||
> +	     (inq_result[7] & 2)) && !(*bflags & BLIST_NOTQ)) {
>  		sdev->tagged_supported = 1;
> +		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG,
> +					sdev->host->cmd_per_lun);
> +	}
>  	/*
>  	 * Some devices (Texel CD ROM drives) have handshaking problems
>  	 * when used with the Seagate controllers. borken is initialized
> 
> -- Patrick Mansfield
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
