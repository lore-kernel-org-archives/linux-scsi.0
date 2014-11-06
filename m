From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/10] scsi: Move remaining printk() statement to
 scmd_printk()
Date: Wed, 5 Nov 2014 23:20:23 -0800
Message-ID: <20141106072023.GF19721@infradead.org>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
 <1415088409-46590-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39157 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaKFHU0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 02:20:26 -0500
Content-Disposition: inline
In-Reply-To: <1415088409-46590-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On Tue, Nov 04, 2014 at 09:06:49AM +0100, Hannes Reinecke wrote:
> One statement was missing from the conversion to dev_printk().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 92d5912..9880b59 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -541,10 +541,12 @@ void scsi_log_send(struct scsi_cmnd *cmd)
>  				    "Send: scmd 0x%p\n", cmd);
>  			scsi_print_command(cmd);
>  			if (level > 3) {
> -				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
> -				       " queuecommand 0x%p\n",
> -					scsi_sglist(cmd), scsi_bufflen(cmd),
> -					cmd->device->host->hostt->queuecommand);
> +				struct Scsi_Host *shost = cmd->device->host;
> +				scmd_printk(KERN_INFO, cmd,
> +					    "buffer = 0x%p, bufflen = %d,"
> +					    " queuecommand 0x%p\n",
> +					    scsi_sglist(cmd), scsi_bufflen(cmd),
> +					    shost->hostt->queuecommand);

This printk doesn't look very useful, I'd rather kill it.
