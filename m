From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] bnx2fc: bnx2fc_eh_abort(): fix wrong return code.
Date: Mon, 1 Feb 2016 11:02:31 -0500
Message-ID: <alpine.OSX.2.00.1602011101510.795@administrators-macbook-pro.local>
References: <1454339325-12579-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:41842 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbcBAQCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 11:02:47 -0500
In-Reply-To: <1454339325-12579-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: QLogic-Storage-Upstream@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org


On Mon, 1 Feb 2016, Maurizio Lombardi wrote:

> If the link is not ready, the bnx2fc_eh_abort() function
> should return FAILED.
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
> drivers/scsi/bnx2fc/bnx2fc_io.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 0002caf..2230dab 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1104,8 +1104,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
> 	struct bnx2fc_cmd *io_req;
> 	struct fc_lport *lport;
> 	struct bnx2fc_rport *tgt;
> -	int rc = FAILED;
> -
> +	int rc;
>
> 	rc = fc_block_scsi_eh(sc_cmd);
> 	if (rc)
> @@ -1114,7 +1113,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
> 	lport = shost_priv(sc_cmd->device->host);
> 	if ((lport->state != LPORT_ST_READY) || !(lport->link_up)) {
> 		printk(KERN_ERR PFX "eh_abort: link not ready\n");
> -		return rc;
> +		return FAILED;
> 	}
>
> 	tgt = (struct bnx2fc_rport *)&rp[1];
>

Yes, nice catch.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
