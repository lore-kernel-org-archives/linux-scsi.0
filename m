From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/4] mvsas: Deadlocks meet when TMF tasks issue
Date: Fri, 08 May 2009 10:49:25 -0500
Message-ID: <1241797765.3327.57.camel@mulgrave.int.hansenpartnership.com>
References: <20090508061605.GA1884@jason.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56241 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705AbZEHPtZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2009 11:49:25 -0400
In-Reply-To: <20090508061605.GA1884@jason.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Chu <jasonchu@marvell.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org

On Fri, 2009-05-08 at 14:16 +0800, Ying Chu wrote:
> >From 58f754f51fced4a39adcf708319e3de946a0d61a Mon Sep 17 00:00:00 2001
> From: Andy <ayan@marvell.com>
> Date: Mon, 4 May 2009 23:31:43 +0800
> Subject: [PATCH 2/4] bug fix: deal lock 
> 
> TMF task need be issued with Interrupt Disabled, or Deadlock may take place.
> 
> Signed-off-by: Ying Chu <jasonchu@marvell.com>
> Signed-off-by: Andy Yan <ayan@marvell.com>
> Signed-off-by: Ke Wei <kewei@marvell.com>
> ---
>  drivers/scsi/mvsas/mv_sas.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 318ec01..cb002ef 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1446,7 +1446,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
>  		task->timer.expires = jiffies + MVS_TASK_TIMEOUT*HZ;
>  		add_timer(&task->timer);
>  
> -		res = mvs_task_exec(task, 1, GFP_KERNEL, NULL, 0, 1, tmf);
> +		res = mvs_task_exec(task, 1, GFP_KERNEL, NULL, 1, 1, tmf);

That eliminates the last user of the unlocked case.

Can't we just drop the conditional lock from mvs_task_exec() now
instead?  It will make the code much cleaner.

James


