From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] BNX2I: Added reconnect fix connecting against Lefthand
 targets
Date: Sat, 08 Jan 2011 23:44:35 -0600
Message-ID: <4D294B43.1020803@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1294538424-4168-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35006 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1AIFry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jan 2011 00:47:54 -0500
In-Reply-To: <1294538424-4168-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 01/08/2011 08:00 PM, Eddie Wai wrote:
> The nopout's reserved field was not being initialized to zero
> before being reused.  Stale CDB values from previous SCSI cmds
> of the same BHS offset was the cause of the disconnection
> initiated by the Lefthand target.
>
> Signed-off-by: Eddie Wai<eddie.wai@broadcom.com>
> ---
>   drivers/scsi/bnx2i/bnx2i_hwi.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index 9375369..5442f1a 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -490,6 +490,9 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
>   	bnx2i_cmd = (struct bnx2i_cmd *)task->dd_data;
>   	nopout_hdr = (struct iscsi_nopout *)task->hdr;
>   	nopout_wqe = (struct bnx2i_nop_out_request *)ep->qp.sq_prod_qe;
> +
> +	memset(nopout_wqe, 0x00, sizeof(struct bnx2i_nop_out_request));
> +
>   	nopout_wqe->op_code = nopout_hdr->opcode;
>   	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
>   	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
