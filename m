From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi: Do not complete timed-out command
Date: Fri, 13 Jun 2014 09:29:18 -0700
Message-ID: <20140613162918.GB19895@infradead.org>
References: <1402660906-74661-1-git-send-email-hare@suse.de>
 <1402660906-74661-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaFMQ3V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2014 12:29:21 -0400
Content-Disposition: inline
In-Reply-To: <1402660906-74661-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Bart vn Assche <bvanassche@acm.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ff176a6..cde9c11 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -125,11 +125,13 @@ scmd_eh_abort_handler(struct work_struct *work)
>  			scmd_printk(KERN_INFO, scmd,
>  				    "scmd %p eh timeout, not aborting\n",
>  				    scmd));
> +		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;

What lock is supposed to prevent concurrent modifications to eh_eflags
here?

