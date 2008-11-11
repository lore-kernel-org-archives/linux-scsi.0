From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue, 11 Nov 2008 10:23:25 -0800 (PST)
Message-ID: <20081111182325.9F805108058@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYKKSY0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 13:24:26 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mABINtSR001155
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2008 10:23:56 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #35 from anonymous@kernel-bugs.osdl.org  2008-11-11 10:23 -------
Reply-To: michaelc@cs.wisc.edu

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


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
