From: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>
Subject: Re: [PATCH] scsi_eh_flush_done_q return status
Date: Mon, 02 Feb 2004 19:29:34 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <034d01c3e977$7bf68780$2987110a@lsd.css.fujitsu.com>
References: <20040116201117.GD1053@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:2531 "EHLO
	fgwmail7.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S265326AbUBBK3y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2004 05:29:54 -0500
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72]) by fgwmail7.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i12ATq1q019843 for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2004 19:29:52 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from s4.gw.fujitsu.co.jp by m2.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i12ATqej018383 for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2004 19:29:52 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from fjmail504.fjmail.jp.fujitsu.com (fjmail504-0.fjmail.jp.fujitsu.com [10.59.80.102]) by s4.gw.fujitsu.co.jp (8.12.10)
	id i12ATpd6031062 for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2004 19:29:51 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from CARREN (fjscan501-0.fjmail.jp.fujitsu.com [10.59.80.120])
 by fjmail504.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HSG008VED5QHQ@fjmail504.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Mon,  2 Feb 2004 19:29:51 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

Hi Mike,

Sorry for my too late response.
I verified your patch on the original faling system.
It was OK.

Thank you.
Hironobu Ishii
----- Original Message ----- 
From: "Mike Anderson" <andmike@us.ibm.com>
To: <linux-scsi@vger.kernel.org>
Cc: <ishii.hironobu@jp.fujitsu.com>
Sent: Saturday, January 17, 2004 5:11 AM
Subject: [PATCH] scsi_eh_flush_done_q return status


> This is a refresh of a patch for a previously reported problem with the
> scsi_eh_flush_done_q. The original thread is located here:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107043398314649&w=2
> 
> This patch has a one line difference than the one previously posted in
> response to the thread. In the previous patch I was unconditionally
> setting result in the finish case.
> 
> I verified the patch using scsi_debug + gov, but could only cover the
> retry path of the patch. I ran out of time to tweak scsi_debug to give
> me the right failure signature. If Hironobu has some free time may be
> the patch could be verified on the original failing system.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
> DESC
> This patch fixes a bug in scsi_eh_flush_done_q when the allowed count has
> been exceeded and the command errored for a timeout. The bug is that the
> result will be left at zero and the command finished.
> 
> author: Mike Anderson <andmike@us.ibm.com>
> patch_version: Thu Jan 15 20:27:10 UTC 2004
> EDESC
> 
> 
>  patched-scsi-misc-2.7-andmike/drivers/scsi/scsi_error.c |   28 +++++++---------
>  1 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff -puN drivers/scsi/scsi_error.c~scsi_error_retry drivers/scsi/scsi_error.c
> --- patched-scsi-misc-2.7/drivers/scsi/scsi_error.c~scsi_error_retry Thu Jan 15 22:14:40 2004
> +++ patched-scsi-misc-2.7-andmike/drivers/scsi/scsi_error.c Thu Jan 15 22:14:40 2004
> @@ -1420,23 +1420,21 @@ static void scsi_eh_flush_done_q(struct 
>   list_for_each_safe(lh, lh_sf, done_q) {
>   scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
>   list_del_init(lh);
> - if (!scmd->device->online) {
> - scmd->result |= (DRIVER_TIMEOUT << 24);
> - } else {
> - if (++scmd->retries < scmd->allowed) {
> - SCSI_LOG_ERROR_RECOVERY(3,
> - printk("%s: flush retry"
> -        " cmd: %p\n",
> -   current->comm,
> -   scmd));
> + if (scmd->device->online &&
> +     (++scmd->retries < scmd->allowed)) {
> + SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
> +   " retry cmd: %p\n",
> +   current->comm,
> +   scmd));
>   scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> - continue;
> - }
> + } else {
> + if (!scmd->result)
> + scmd->result |= (DRIVER_TIMEOUT << 24);
> + SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
> + " cmd: %p\n",
> + current->comm, scmd));
> + scsi_finish_command(scmd);
>   }
> - SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
> -        " cmd: %p\n",
> -   current->comm, scmd));
> - scsi_finish_command(scmd);
>   }
>  }
>  
> 
> _
> 
