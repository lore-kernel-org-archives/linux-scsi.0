From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/4 v2] BNX2I: Changed the nopout_wqe->lun memcpy to use
 sizeof instead
Date: Fri, 24 Jun 2011 15:20:43 -0500
Message-ID: <4E04F19B.5080800@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1308869497-2709-4-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46404 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1FXUTG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 16:19:06 -0400
In-Reply-To: <1308869497-2709-4-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Andy Grover <agrover@redhat.com>

On 06/23/2011 05:51 PM, Eddie Wai wrote:
> Modified the memcpy of nopout_wqe->lun to use sizeof(struct scsi_lun)
> instead of the hardcoded value 8 as noted by review comments.
> 
> Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_hwi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index 2a1bb9f..ba2f96e 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -551,7 +551,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
>  
>  	nopout_wqe->op_code = nopout_hdr->opcode;
>  	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
> -	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
> +	memcpy(nopout_wqe->lun, nopout_hdr->lun, sizeof(struct scsi_lun));
>  
>  	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type)) {
>  		u32 tmp = nopout_wqe->lun[0];

This patch and Andy your patch "[PATCH] iscsi: Use struct scsi_lun in
iscsi structs instead of u8[8]" are going to conflict with each other.

And Eddie, I think you missed some other instances where 8 is hardcoded.

