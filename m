From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/22] scsi: remove obsolete __scsi_print_command() usages
Date: Sun, 31 Aug 2014 15:18:09 -0700
Message-ID: <20140831221809.GH16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-13-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHaWSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:18:12 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-13-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

Can you change the subject a bit?  There's nothing obsolete in
__scsi_print_command, you're just moving it to a higher level helper.

>  #if defined(AHA152X_DEBUG)
>  	if (HOSTDATA(shpnt)->debug & debug_queue) {
> -		printk(INFO_LEAD "queue: %p; cmd_len=%d pieces=%d size=%u cmnd=",
> -		       CMDINFO(SCpnt), SCpnt, SCpnt->cmd_len,
> -		       scsi_sg_count(SCpnt), scsi_bufflen(SCpnt));
> -		__scsi_print_command(SCpnt->cmnd);
> +		scmd_printk(KERN_INFO, SCpnt,
> +			    "queue: %p; cmd_len=%d pieces=%d size=%u\n",
> +			    SCpnt, SCpnt->cmd_len,
> +			    scsi_sg_count(SCpnt), scsi_bufflen(SCpnt));
> +		scsi_print_command(SCpnt);

This also has a printk -> scmd_printk change that's unrelated to the
patch.

Honestly I think we should just kill much of the AHA152X_DEBUG code at
the start of this series to avoid all the churn in it.

