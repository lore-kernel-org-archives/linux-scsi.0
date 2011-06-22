From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 3/4] BNX2I: Changed the nopout_wqe->lun memcpy to use
 sizeof instead
Date: Wed, 22 Jun 2011 10:00:25 +0200
Message-ID: <fd5f3b85d2c9ef5d221cd1f3cdc56f05.squirrel@webmail.sf-mail.de>
References: <Eddie Wai <eddie.wai@broadcom.com>
    <1308674994-4694-4-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:44349 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab1FVIA3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2011 04:00:29 -0400
In-Reply-To: <1308674994-4694-4-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@novell.com>, Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

> Modified the memcpy of nopout_wqe->lun to use sizeof(struct scsi_lun)
> instead of the hardcoded value 8 as noted by review comments.
>
> Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_hwi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c
> b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index 64089e2..d5f3bf6 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -551,7 +551,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn
> *bnx2i_conn,
>
>  	nopout_wqe->op_code = nopout_hdr->opcode;
>  	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
> -	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
> +	memcpy(nopout_wqe->lun, nopout_hdr->lun, sizeof(struct scsi_lun));
>
>  	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type)) {
>  		u32 tmp = nopout_wqe->lun[0];

Why not just use sizeof(*nopout_wqe->lun)?

Eike
