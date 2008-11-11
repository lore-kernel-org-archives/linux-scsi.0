From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue, 11 Nov 2008 12:22:38 -0600
Message-ID: <4919CD6E.7010901@cs.wisc.edu>
References: <20081105040154.9690A108048@picon.linux-foundation.org>	 <1225898691.4703.32.camel@localhost.localdomain>	 <4911D6F2.2080309@cs.wisc.edu> <1226245637.19841.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56493 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYKKSX0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 13:23:26 -0500
In-Reply-To: <1226245637.19841.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f5d3b96..979e07a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -567,15 +567,18 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
>   */
>  static void scsi_run_queue(struct request_queue *q)
>  {
> -	struct scsi_device *starved_head = NULL, *sdev = q->queuedata;
> +	struct scsi_device *tmp, *sdev = q->queuedata;
>  	struct Scsi_Host *shost = sdev->host;
> +	LIST_HEAD(starved_list);
>  	unsigned long flags;
>  
>  	if (scsi_target(sdev)->single_lun)
>  		scsi_single_lun_run(sdev);
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	while (!list_empty(&shost->starved_list) && !scsi_host_is_busy(shost)) {
> +	list_splice_init(&shost->starved_list, &starved_list);
> +
> +	list_for_each_entry_safe(sdev, tmp, &starved_list, starved_entry) {
>  		int flagset;
>  

I do not think we can use list_for_each_entry_safe. It might be he cause 
of the oops in the other mail. If we use list_for_each_entry_safe here, 
but then some other process like the kernel block workueue calls the 
request_fn of a device on the starved list then we can go from 
scsi_request_fn -> scsi_host_queue_ready which can do:

         /* We're OK to process the command, so we can't be starved */
         if (!list_empty(&sdev->starved_entry))
                 list_del_init(&sdev->starved_entry);

and that can end up removing the sdev from scsi_run_queue's spliced 
starved list. And so if the kblock workqueue did this to multiple 
devices while scsi_run_queue has dropped the host lock then I do not 
think list_for_each_entry_safe can handle that.

I can sort of replicate this now. Let me do some testing on the changes 
and I will submit something in a minute.
