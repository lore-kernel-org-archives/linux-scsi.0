From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
Date: Mon, 15 Dec 2008 10:56:42 -0600
Message-ID: <49468C4A.2040508@cs.wisc.edu>
References: <Pine.LNX.4.64.0811191652570.17161@fi-hi32-dhcp068123.emea.nsn-net.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40538 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbYLOQ4v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2008 11:56:51 -0500
In-Reply-To: <Pine.LNX.4.64.0811191652570.17161@fi-hi32-dhcp068123.emea.nsn-net.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Koskinen Aaro (NSN - FI/Helsinki)" <aaro.koskinen@nsn.com>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

Koskinen Aaro (NSN - FI/Helsinki) wrote:
> Make the sym53c8xx_2 driver slave_alloc/destroy less unsafe. References
> to the destroyed LCB are cleared from the target structure (instead of
> leaving a dangling pointer), and when the last LCB for the target is
> destroyed the reference to the upper layer target data is cleared. The
> host lock is used to prevent a race with the interrupt handler. Also
> user commands are prevented for targets with all LCBs destroyed.
> 
> Signed-off-by: aaro.koskinen@nsn.com


Same signed off line issue. Should be Signed-off-by: Aaro Koskinen 
<aaro.koskinen@nsn.com>.

There were also some whitespace issues, but merging it with git-am 
--whitespace=fix fixed them up.

> 
> ---
> 
> diff -uprN -X linux-2.6.27.5-orig/Documentation/dontdiff linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_glue.c linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_glue.c
> --- linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2008-11-07 19:55:34.000000000 +0200
> +++ linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_glue.c	2008-11-19 12:19:03.000000000 +0200
> @@ -737,11 +737,14 @@ static int sym53c8xx_slave_alloc(struct 
>  
> +	if (tp->nlcb && tp->starget != sdev->sdev_target) {
> +		error = -EBUSY;
> +		goto out;
> +	}
> +


I do not think this is needed now. With your changes to slave_destroy 
below, the driver should now clear that starget pointer up, and if 
scsi-ml were screwing things in a way that resulted in us doing this 
maybe we would need some checks in scsi_scan.c because we could be 
hitting some bugs in other drivers.


>  	lp = sym_alloc_lcb(np, sdev->id, sdev->lun);
> -	if (!lp)
> -		return -ENOMEM;
> +	if (!lp) {
> +		error = -ENOMEM;
> +		goto out;
> +	}
> +	if (tp->nlcb == 1) {
> +		tp->starget = sdev->sdev_target;
> +	}
>  
>  	spi_min_period(tp->starget) = tp->usr_period;
>  	spi_max_width(tp->starget) = tp->usr_width;
>  
> -	return 0;
> +	error = 0;
> +out:
> +	spin_unlock_irqrestore(np->s.host->host_lock, flags);
> +
> +	return error;
>  }
>  
>  /*
> @@ -819,12 +839,34 @@ static int sym53c8xx_slave_configure(str
>  static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
>  {
>  	struct sym_hcb *np = sym_get_hcb(sdev->host);
> -	struct sym_lcb *lp = sym_lp(&np->target[sdev->id], sdev->lun);
> +	struct sym_tcb *tp = &np->target[sdev->id];
> +	struct sym_lcb *lp = sym_lp(tp, sdev->lun);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(np->s.host->host_lock, flags);
>  
> -	if (lp->itlq_tbl)
> -		sym_mfree_dma(lp->itlq_tbl, SYM_CONF_MAX_TASK * 4, "ITLQ_TBL");
> -	kfree(lp->cb_tags);
> -	sym_mfree_dma(lp, sizeof(*lp), "LCB");
> +	if (lp->busy_itlq || lp->busy_itl) {
> +		/*
> +		 * This really shouldn't happen, but we can't return an error
> +		 * so let's try to stop all on-going I/O.
> +		 */
> +		starget_printk(KERN_WARNING, tp->starget,
> +			       "Removing busy LCB (%d)\n", sdev->lun);
> +		sym_reset_scsi_bus(np, 1);
> +	}
> +
> + 	if (sym_free_lcb(np, sdev->id, sdev->lun) == 0) {
> +		/*
> + 		 * It was the last unit for this target.
> + 		 */
> + 		tp->head.sval        = 0;
> + 		tp->head.wval        = np->rv_scntl3;
> + 		tp->head.uval        = 0;
> + 		tp->tgoal.check_nego = 1;
> + 		tp->starget	     = NULL;
> + 	}
> + 
> +	spin_unlock_irqrestore(np->s.host->host_lock, flags);
>  }
>  
>  /*
> @@ -890,6 +932,8 @@ static void sym_exec_user_command (struc
>  			if (!((uc->target >> t) & 1))
>  				continue;
>  			tp = &np->target[t];
> +			if (!tp->nlcb)
> +				continue;
>  
>  			switch (uc->cmd) {
>  
> diff -uprN -X linux-2.6.27.5-orig/Documentation/dontdiff linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.c linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.c
> --- linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2008-11-07 19:55:34.000000000 +0200
> +++ linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.c	2008-11-19 12:19:01.000000000 +0200
> @@ -4973,6 +4973,7 @@ struct sym_lcb *sym_alloc_lcb (struct sy
>  		tp->lun0p = lp;
>  		tp->head.lun0_sa = cpu_to_scr(vtobus(lp));
>  	}
> +	tp->nlcb++;
>  
>  	/*
>  	 *  Let the itl task point to error handling.
> @@ -5050,6 +5051,43 @@ fail:
>  }
>  
>  /*
> + *  Lun control block deallocation. Returns the number of valid remaing LCBs
> + *  for the target.
> + */
> +int sym_free_lcb (struct sym_hcb *np, u_char tn, u_char ln)
> +{
> +	struct sym_tcb *tp = &np->target[tn];
> +	struct sym_lcb *lp = sym_lp(tp, ln);
> +
> +	tp->nlcb--;
> +
> +	if (ln) {
> +		if (!tp->nlcb) {
> +			kfree(tp->lunmp);
> +			sym_mfree_dma(tp->luntbl, 256, "LUNTBL");
> +			tp->lunmp = NULL;
> +			tp->luntbl = NULL;
> +			tp->head.luntbl_sa = cpu_to_scr(vtobus(np->badluntbl));
> +		} else {
> +			tp->luntbl[ln] = cpu_to_scr(vtobus(&np->badlun_sa));
> +			tp->lunmp[ln] = NULL;
> +		}
> +	} else {
> +		tp->lun0p = NULL;
> +		tp->head.lun0_sa = cpu_to_scr(vtobus(&np->badlun_sa));
> +	}
> +
> +	if (lp->itlq_tbl) {
> +		sym_mfree_dma(lp->itlq_tbl, SYM_CONF_MAX_TASK*4, "ITLQ_TBL");
> +		kfree(lp->cb_tags);
> +	}
> +
> +	sym_mfree_dma(lp, sizeof(*lp), "LCB");
> +
> +	return tp->nlcb;
> +}
> +
> +/*
>   *  Queue a SCSI IO to the controller.
>   */
>  int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *cp)
> diff -uprN -X linux-2.6.27.5-orig/Documentation/dontdiff linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.h linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.h
> --- linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.h	2008-11-07 19:55:34.000000000 +0200
> +++ linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.h	2008-11-19 12:19:00.000000000 +0200
> @@ -400,6 +400,7 @@ struct sym_tcb {
>  	 *  An array of bus addresses is used on reselection.
>  	 */
>  	u32	*luntbl;	/* LCBs bus address table	*/
> +	int	nlcb;		/* Number of valid LCBs (including LUN #0) */
>  
>  	/*
>  	 *  LUN table used by the C code.
> @@ -1061,6 +1062,7 @@ int sym_clear_tasks(struct sym_hcb *np, 
>  struct sym_ccb *sym_get_ccb(struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order);
>  void sym_free_ccb(struct sym_hcb *np, struct sym_ccb *cp);
>  struct sym_lcb *sym_alloc_lcb(struct sym_hcb *np, u_char tn, u_char ln);
> +int sym_free_lcb(struct sym_hcb *np, u_char tn, u_char ln);
>  int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
>  int sym_abort_scsiio(struct sym_hcb *np, struct scsi_cmnd *ccb, int timed_out);
>  int sym_reset_scsi_target(struct sym_hcb *np, int target);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

