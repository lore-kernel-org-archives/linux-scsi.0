From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH 1/1] cciss: resubmit kernel scan thread for MSA2012
Date: Wed, 11 Mar 2009 09:31:22 -0500
Message-ID: <20090311143122.GA28208@beardog.cca.cpqcorp.net>
References: <20090310151738.GA18243@beardog.cca.cpqcorp.net> <1236700241.14822.4.camel@localhost.localdomain> <20090310163426.GC18243@beardog.cca.cpqcorp.net> <20090310153933.7a7fc224.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:33405 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZCKObX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2009 10:31:23 -0400
Content-Disposition: inline
In-Reply-To: <20090310153933.7a7fc224.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com

On Tue, Mar 10, 2009 at 03:39:33PM -0700, Andrew Morton wrote:
> 
> Confused.

I was too. I copied myself and that's what I saw. Sorry to bother everyone.

-- mikem

> 
> > +static int scan_thread(ctlr_info_t *h)
> > +{
> > +	int rc;
> > +	DECLARE_COMPLETION_ONSTACK(wait);
> > +	h->rescan_wait = &wait;
> > +
> > +	while (!kthread_should_stop()) {
> > +		rc = wait_for_completion_interruptible(&wait);
> > +		if (!rc)
> > +			continue;
> > +		else
> > +			rebuild_lun_table(h, 0);
> > +	}
> > +	return 0;
> > +}
> 
> afacit this thread won't ever do anything,
> 
> > +static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
> > +{
> > +	if (c->err_info->SenseInfo[2] != UNIT_ATTENTION)
> > +		return 0;
> > +
> > +	switch (c->err_info->SenseInfo[12]) {
> > +	case STATE_CHANGED:
> > +		printk(KERN_WARNING "cciss%d: a state change "
> > +			"detected, command retried\n", h->ctlr);
> > +		return 1;
> > +	break;
> > +	case LUN_FAILED:
> > +		printk(KERN_WARNING "cciss%d: LUN failure "
> > +			"detected, action required\n", h->ctlr);
> > +		return 1;
> > +	break;
> > +	case REPORT_LUNS_CHANGED:
> > +		printk(KERN_WARNING "cciss%d: report LUN data "
> > +			"changed\n", h->ctlr);
> > +		if (h->rescan_wait)
> > +			complete(h->rescan_wait);
> 
> because this will cause the wait_for_completion_interruptible() to return 0.
> 
> > +		return 1;
> > +	break;
> > +	case POWER_OR_RESET:
> > +		printk(KERN_WARNING "cciss%d: a power on "
> > +			"or device reset detected\n", h->ctlr);
> > +		return 1;
> > +	break;
> > +	case UNIT_ATTENTION_CLEARED:
> > +		printk(KERN_WARNING "cciss%d: unit attention "
> > +		    "cleared by another initiator\n", h->ctlr);
> > +		return 1;
> > +	break;
> > +	default:
> > +		printk(KERN_WARNING "cciss%d: unknown "
> > +			"unit attention detected\n", h->ctlr);
> > +				return 1;
> > +	}
> > +}
> 
