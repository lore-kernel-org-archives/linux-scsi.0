From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: An oops will occur while SCSI core is being used in 3.4-rc1
Date: Wed, 11 Apr 2012 16:40:08 +0000
Message-ID: <4F85B3E8.7040704@acm.org>
References: <CAAxnys5O7PfWYv0q+BvhK2CP7X-_pNRa4j-Z1gSWHqLm8D8XmA@mail.gmail.com> <4F83EC71.90904@acm.org> <4F8461E3.3050808@cs.wisc.edu> <4F846398.5030609@cs.wisc.edu> <4F846506.4060801@cs.wisc.edu> <yq18vi2ckrj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:53653 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760661Ab2DKQkO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Apr 2012 12:40:14 -0400
In-Reply-To: <yq18vi2ckrj.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Elric Fu <elricfu1@gmail.com>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Felipe Balbi <balbi@ti.com>, Alex He <alex.he@amd.com>, Andiry Xu <andiry.xu@amd.com>, Greg KH <gregkh@linuxfoundation.org>, Linux USB Mailing List <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On 04/11/12 16:10, Martin K. Petersen wrote:

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 2cfcbff..386f0c5 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -835,7 +835,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  
>  	scsi_eh_restore_cmnd(scmd, &ses);
>  
> -	if (sdrv->eh_action)
> +	if (sdrv && sdrv->eh_action)
>  		rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
>  
>  	return rtn;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 377df4a..1e11985 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -134,6 +134,9 @@ struct scsi_cmnd {
>  
>  static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
>  {
> +	if (!cmd->request->rq_disk)
> +		return NULL;
> +
>  	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
>  }


What if the rq_disk pointer is cleared by another kernel thread after it
has been checked but before it is used ?

Personally I would feel more comfortable if code inside sd_eh_action() /
sd_show_max_medium_access_timeouts() /
sd_store_max_medium_access_timeouts() would be moved inside the SCSI
core such that scsi_send_eh_cmnd() doesn't have to access struct
scsi_driver.

Bart.
