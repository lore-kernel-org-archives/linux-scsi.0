From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] cciss: resubmit kernel scan thread for MSA2012
Date: Tue, 10 Mar 2009 15:39:33 -0700
Message-ID: <20090310153933.7a7fc224.akpm@linux-foundation.org>
References: <20090310151738.GA18243@beardog.cca.cpqcorp.net>
	<1236700241.14822.4.camel@localhost.localdomain>
	<20090310163426.GC18243@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbZCJWmY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2009 18:42:24 -0400
In-Reply-To: <20090310163426.GC18243@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com


Confused.

> +static int scan_thread(ctlr_info_t *h)
> +{
> +	int rc;
> +	DECLARE_COMPLETION_ONSTACK(wait);
> +	h->rescan_wait = &wait;
> +
> +	while (!kthread_should_stop()) {
> +		rc = wait_for_completion_interruptible(&wait);
> +		if (!rc)
> +			continue;
> +		else
> +			rebuild_lun_table(h, 0);
> +	}
> +	return 0;
> +}

afacit this thread won't ever do anything,

> +static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
> +{
> +	if (c->err_info->SenseInfo[2] != UNIT_ATTENTION)
> +		return 0;
> +
> +	switch (c->err_info->SenseInfo[12]) {
> +	case STATE_CHANGED:
> +		printk(KERN_WARNING "cciss%d: a state change "
> +			"detected, command retried\n", h->ctlr);
> +		return 1;
> +	break;
> +	case LUN_FAILED:
> +		printk(KERN_WARNING "cciss%d: LUN failure "
> +			"detected, action required\n", h->ctlr);
> +		return 1;
> +	break;
> +	case REPORT_LUNS_CHANGED:
> +		printk(KERN_WARNING "cciss%d: report LUN data "
> +			"changed\n", h->ctlr);
> +		if (h->rescan_wait)
> +			complete(h->rescan_wait);

because this will cause the wait_for_completion_interruptible() to return 0.

> +		return 1;
> +	break;
> +	case POWER_OR_RESET:
> +		printk(KERN_WARNING "cciss%d: a power on "
> +			"or device reset detected\n", h->ctlr);
> +		return 1;
> +	break;
> +	case UNIT_ATTENTION_CLEARED:
> +		printk(KERN_WARNING "cciss%d: unit attention "
> +		    "cleared by another initiator\n", h->ctlr);
> +		return 1;
> +	break;
> +	default:
> +		printk(KERN_WARNING "cciss%d: unknown "
> +			"unit attention detected\n", h->ctlr);
> +				return 1;
> +	}
> +}

