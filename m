From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] cciss: kernel thread to detect changes on MSA2012
Date: Thu, 05 Mar 2009 23:52:14 +0000
Message-ID: <1236297134.5626.89.camel@localhost.localdomain>
References: <20090305232647.GA24830@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40077 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbZCEXwU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 18:52:20 -0500
In-Reply-To: <20090305232647.GA24830@roadking.ldev.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, coldwell@redhat.com, LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, 2009-03-05 at 17:26 -0600, Mike Miller wrote:
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
> +
> +	for (;;) {
> +		rc = wait_for_completion_timeout(&wait);

wait_for_completion_timeout needs a timeout parameter as well, doesn't
it?

> +		if (!rc)
> +			continue;
> +		else
> +			rebuild_lun_table(h, 0);
> +
> +		INIT_COMPLETION(wait);
> +	}
> +
> +	return 0;
> +}

You can't really have and endless loop for a thread in a modular driver,
since you have to consider what happens if the module is removed.  The
code the thread is executing gets freed.  If you're using the timeout
wait then when it wakes up it immediately crashes.

If you want an example of using the kernel thread stop API for the
module removal case, see scsi_error.c:scsi_error_handler() and
hosts.c:scsi_host_dev_release()

James


