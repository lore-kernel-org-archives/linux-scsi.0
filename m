From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] cciss: kernel thread to detect changes on MSA2012
Date: Thu, 5 Mar 2009 15:43:17 -0800
Message-ID: <20090305154317.1efd66d0.akpm@linux-foundation.org>
References: <20090305232647.GA24830@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbZCEXn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 18:43:59 -0500
In-Reply-To: <20090305232647.GA24830@roadking.ldev.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: jens.axboe@oracle.com, coldwell@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009 17:26:47 -0600
Mike Miller <mike.miller@hp.com> wrote:

> PATCH 1 of 2
> 
> The MSA2000 the firmware cannot tell the driver to rescan when logical
> drives are added or deleted. This patch adds a check for unit attentions and
> if a change in the topology is detected a kernel thread will fire off and
> call rebuild_lun_table to update the drivers view of the world.
> 
> The MSA2012 uses out of band management for configuration unlike any other
> storage box we support. This is the reason for this patch.
> 
> Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index d2cb67b..d745d8c 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -186,6 +186,7 @@ static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
>  			   __u8 page_code, int cmd_type);
>  
>  static void fail_all_cmds(unsigned long ctlr);
> +static int scan_thread(ctlr_info_t *h);
>  
>  #ifdef CONFIG_PROC_FS
>  static void cciss_procinit(int i);
> @@ -3008,6 +3009,69 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +static int scan_thread(ctlr_info_t *h)
> +{
> +	int rc;
> +
> +	DECLARE_COMPLETION(wait);
> +	INIT_COMPLETION(wait);
> +	h->rescan_wait = &wait;

The blank line is in the wrong place.

This should use DECLARE_COMPLETION_ONSTACK() to keep lockdep happy.

Please test patches with lockdep enabled.

INIT_COMPLATION() isn't needed - DECLARE_COMPLETION[_ONSTACK]() already
did that.

> +	for (;;) {
> +		rc = wait_for_completion_timeout(&wait);

that won't compile.

> +		if (!rc)
> +			continue;
> +		else
> +			rebuild_lun_table(h, 0);
> +
> +		INIT_COMPLETION(wait);

No need to reinitialise it here.

> +	}
> +
> +	return 0;
> +}
> +
> +static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
> +{
> +	if (CMD_TARGET_STATUS && (c->err_info->ScsiStatus ==
> +			SAM_STAT_CHECK_CONDITION) &&
> +			c->err_info->SenseInfo[2] == UNIT_ATTENTION) {

You could do

	if (!<that expression>)
		return 0;

> +		switch (c->err_info->SenseInfo[12]) {
> +		case STATE_CHANGED:
> +			printk(KERN_WARNING "cciss%d: a state change "
> +				"detected, command retried\n", h->ctlr);
> +			return 1;
> +		break;
> +		case LUN_FAILED:
> +			printk(KERN_WARNING "cciss%d: LUN failure "
> +				"detected, action required\n", h->ctlr);
> +			return 1;
> +		break;
> +		case REPORT_LUNS_CHANGED:
> +			printk(KERN_WARNING "cciss%d: report LUN data "
> +				"changed\n", h->ctlr);
> +			if (h->rescan_wait)
> +				complete(h->rescan_wait);
> +			return 1;
> +		break;
> +		case POWER_OR_RESET:
> +			printk(KERN_WARNING "cciss%d: a power on "
> +				"or device reset detected\n", h->ctlr);
> +			return 1;
> +		break;
> +		case UNIT_ATTENTION_CLEARED:
> +			printk(KERN_WARNING "cciss%d: unit attention "
> +			    "cleared by another initiator\n", h->ctlr);
> +			return 1;
> +		break;
> +		default:
> +			printk(KERN_WARNING "cciss%d: unknown "
> +				"unit attention detected\n", h->ctlr);
> +				return 1;
> +		}
> +	}

and then save a tabstop for all the above.

> +	return 0;
> +}
> +
>  /*
>   *  We cannot read the structure directly, for portability we must use
>   *   the io functions.
> @@ -3600,6 +3664,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  	int rc;
>  	int dac, return_code;
>  	InquiryData_struct *inq_buff = NULL;
> +	struct task_struct *cciss_scan_thread;
>  
>  	if (reset_devices) {
>  		/* Reset the controller with a PCI power-cycle */
> @@ -3751,6 +3816,11 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  	hba[i]->busy_initializing = 0;
>  
>  	rebuild_lun_table(hba[i], 1);
> +	cciss_scan_thread = kthread((void *)scan_thread, hba[i],
> +				"scan_thread");

This will appears in `ps' output as "scan_thread".  Nobody will know
where it came from.  I suggest that it have "cciss" in its name.

Do we really need one of these per controller?  Can't arrange for a
single thread kernel-wide?

Do we really need the thread to be running all the time?  Can't create
it on demand?  Perhaps use the kernel/async.c infrastructure?  Or
perhaps schedule_work() or schedule_delayed_work()?


> +	if (IS_ERR(cciss_scan_thread))
> +		return PTR_ERR(cciss_scan_thread);
> +
>  	return 1;
>  
>  clean4:
> diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
> index 15e2b84..c85783f 100644
> --- a/drivers/block/cciss.h
> +++ b/drivers/block/cciss.h
> @@ -121,6 +121,7 @@ struct ctlr_info
>  	struct sendcmd_reject_list scsi_rejects;
>  #endif
>  	unsigned char alive;
> +	struct completion *rescan_wait;
>  };

