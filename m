From: Domen Puncer <domen@coderock.org>
Subject: Re: [KJ] [PATCH 11/14] scsi/lpfc_scsi: use msleep() instead of schedule_timeout()
Date: Sun, 10 Jul 2005 18:20:10 +0200
Message-ID: <20050710162009.GA2468@homer.coderock.org>
References: <20050709000324.GD2596@us.ibm.com> <20050709001458.GQ2596@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:54930 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261971AbVGJQUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 12:20:19 -0400
Content-Disposition: inline
In-Reply-To: <20050709001458.GQ2596@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: James.Bottomley@SteelEye.com, Kernel-Janitors <kernel-janitors@lists.osdl.org>, linux-scsi@vger.kernel.org

On 08/07/05 17:14 -0700, Nishanth Aravamudan wrote:
> From: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> Description: Replace schedule_timeout() with msleep() to guarantee the
> task delays as expected.
> 
> Patch is compile-tested.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> ---
> 
>  lpfc_scsi.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff -urp 2.6.13-rc2-kj/drivers/scsi/lpfc/lpfc_scsi.c 2.6.13-rc2-kj-dev/drivers/scsi/lpfc/lpfc_scsi.c
> --- 2.6.13-rc2-kj/drivers/scsi/lpfc/lpfc_scsi.c	2005-07-06 07:57:19.000000000 -0700
> +++ 2.6.13-rc2-kj-dev/drivers/scsi/lpfc/lpfc_scsi.c	2005-07-06 19:20:41.000000000 -0700
...
> @@ -1110,8 +1108,7 @@ __lpfc_reset_bus_handler(struct scsi_cmn
>  				&phba->sli.ring[phba->sli.fcp_ring],
>  				0, 0, LPFC_CTX_HOST))) {
>  		spin_unlock_irq(phba->host->host_lock);
> -		set_current_state(TASK_UNINTERRUPTIBLE);
> -		schedule_timeout(LPFC_RESET_WAIT*HZ);
> +		msleep(LPFC_RESET_WAIT * HZ);

					^^ ??
I assume you meant 1000.

>  		spin_lock_irq(phba->host->host_lock);
>  
>  		if (++loopcnt

> _______________________________________________
> Kernel-janitors mailing list
> Kernel-janitors@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/kernel-janitors

