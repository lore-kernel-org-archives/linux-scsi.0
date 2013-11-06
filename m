From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Wed, 6 Nov 2013 06:47:13 -0800
Message-ID: <20131106144713.GA26551@infradead.org>
References: <1383635145-112651-1-git-send-email-hare@suse.de>
 <1383635145-112651-3-git-send-email-hare@suse.de>
 <527944BF.9000507@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3KFOtP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2013 09:49:15 -0500
Content-Disposition: inline
In-Reply-To: <527944BF.9000507@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On Tue, Nov 05, 2013 at 11:19:27AM -0800, Mike Christie wrote:
> > +	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
> > +	SCSI_LOG_ERROR_RECOVERY(3,
> > +		scmd_printk(KERN_INFO, scmd,
> > +			    "scmd %p abort scheduled\n", scmd));
> > +	schedule_delayed_work(&scmd->abort_work, HZ / 100);
> > +	return SUCCESS;
> > +}
> 
> Do we want to use our own workqueue_struct with WQ_MEM_RECLAIM set?

That's probably required, I can think of all kinds of issues otherwise.

Not in this patch series, but in the near future it might make sense 
to convert the whole EH thread to that workqueue.
