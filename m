From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Mon, 20 Jun 2005 10:31:06 -0700
Message-ID: <20050620173106.GA22086@us.ibm.com>
References: <42B6E642.3000703@us.ibm.com> <Pine.LNX.4.44L0.0506201227090.4825-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:16538 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261407AbVFTSAI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 14:00:08 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5KHxx3o623724
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2005 14:00:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5KHxxSc085218
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2005 11:59:59 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5KHxa1R014875
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2005 11:59:37 -0600
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0506201227090.4825-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Brian King <brking@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hi Alan -

On Mon, Jun 20, 2005 at 12:35:02PM -0400, Alan Stern wrote:

> -/**
> - * scsi_scan_target - scan a target id, possibly including all LUNs on the
> - *     target.
> - * @sdevsca:	Scsi_Device handle for scanning
> - * @shost:	host to scan
> - * @channel:	channel to scan
> - * @id:		target id to scan
> - *
> - * Description:
> - *     Scan the target id on @shost, @channel, and @id. Scan at least LUN
> - *     0, and possibly all LUNs on the target id.
> - *
> - *     Use the pre-allocated @sdevscan as a handle for the scanning. This
> - *     function sets sdevscan->host, sdevscan->id and sdevscan->lun; the
> - *     scanning functions modify sdevscan->lun.
> - *
> - *     First try a REPORT LUN scan, if that does not scan the target, do a
> - *     sequential scan of LUNs on the target id.
> - **/
> -void scsi_scan_target(struct device *parent, unsigned int channel,
> -		      unsigned int id, unsigned int lun, int rescan)
> +static void __scsi_scan_target(struct Scsi_Host *shost, unsigned int channel,
> +		unsigned int id, unsigned int lun, int rescan)
>  {
> -	struct Scsi_Host *shost = dev_to_shost(parent);
>  	int bflags = 0;
>  	int res;
>  	struct scsi_device *sdev = NULL;
> @@ -1257,7 +1247,7 @@ void scsi_scan_target(struct device *par
>  		return;
>  
>  
> -	starget = scsi_alloc_target(parent, channel, id);
> +	starget = scsi_alloc_target(&shost->shost_gendev, channel, id);

For FC (and iSCSI), parent != &shost->shost_gendev. See user scanning
on FC thread / patches. 

[kernel scsi]$ grep scsi_scan_target scsi_transport_fc.c
	scsi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,

And &rport->dev is not &shost->shost_gendev :-(

> +
> +/**
> + * scsi_scan_target - scan a target id, possibly including all LUNs on the
> + *     target.
> + * @parent:	host to scan
> + * @channel:	channel to scan
> + * @id:		target id to scan
> + * @rescan:	passed to LUN scanning routines
> + *
> + * Description:
> + *     Scan the target id on @shost, @channel, and @id. Scan at least LUN
> + *     0, and possibly all LUNs on the target id.
> + *
> + *     First try a REPORT LUN scan, if that does not scan the target, do a
> + *     sequential scan of LUNs on the target id.
> + **/
> +void scsi_scan_target(struct device *parent, unsigned int channel,
> +		      unsigned int id, unsigned int lun, int rescan)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(parent);
> +
> +	down(&shost->scan_mutex);
> +	if (!test_bit(SHOST_REMOVE, &shost->shost_state))
> +		__scsi_scan_target(shost, channel, id, lun, rescan);

And so parent still has to be passed down to __scsi_scan_target.

-- Patrick Mansfield
