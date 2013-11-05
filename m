From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Tue, 05 Nov 2013 11:19:27 -0800
Message-ID: <527944BF.9000507@cs.wisc.edu>
References: <1383635145-112651-1-git-send-email-hare@suse.de> <1383635145-112651-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56694 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab3KETVA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Nov 2013 14:21:00 -0500
In-Reply-To: <1383635145-112651-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 11/04/2013 11:05 PM, Hannes Reinecke wrote:
> +
> +	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
> +	SCSI_LOG_ERROR_RECOVERY(3,
> +		scmd_printk(KERN_INFO, scmd,
> +			    "scmd %p abort scheduled\n", scmd));
> +	schedule_delayed_work(&scmd->abort_work, HZ / 100);
> +	return SUCCESS;
> +}

Do we want to use our own workqueue_struct with WQ_MEM_RECLAIM set?
