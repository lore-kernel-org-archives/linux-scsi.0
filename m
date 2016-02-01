From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] bnx2fc: bnx2fc_eh_abort(): fix wrong return code.
Date: Mon, 01 Feb 2016 10:32:04 -0500
Message-ID: <1454340724.22112.219.camel@localhost.localdomain>
References: <1454339325-12579-1-git-send-email-mlombard@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbcBAPcG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 10:32:06 -0500
In-Reply-To: <1454339325-12579-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: QLogic-Storage-Upstream@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, chad.dupuis@qlogic.com

On Mon, 2016-02-01 at 16:08 +0100, Maurizio Lombardi wrote:
> If the link is not ready, the bnx2fc_eh_abort() function
> should return FAILED.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 0002caf..2230dab 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1104,8 +1104,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  	struct bnx2fc_cmd *io_req;
>  	struct fc_lport *lport;
>  	struct bnx2fc_rport *tgt;
> -	int rc = FAILED;
> -
> +	int rc;
>  
>  	rc = fc_block_scsi_eh(sc_cmd);
>  	if (rc)
> @@ -1114,7 +1113,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  	lport = shost_priv(sc_cmd->device->host);
>  	if ((lport->state != LPORT_ST_READY) || !(lport->link_up)) {
>  		printk(KERN_ERR PFX "eh_abort: link not ready\n");
> -		return rc;
> +		return FAILED;
>  	}
>  
>  	tgt = (struct bnx2fc_rport *)&rp[1];

Yes, because setting the initial setting of rc = FAILED is overwritten
by the result of fc_block_scsi_eh().

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


