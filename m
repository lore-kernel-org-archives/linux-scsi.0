From: Ankit Jain <jankit@suse.de>
Subject: Re: [PATCH] iscsi: Use struct scsi_lun in iscsi structs instead of
 u8[8]
Date: Fri, 17 Jun 2011 11:27:06 +0530
Message-ID: <4DFAECB2.2010107@suse.de>
References: <1308265029-32337-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50392 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1FQFz3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2011 01:55:29 -0400
In-Reply-To: <1308265029-32337-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 06/17/2011 04:27 AM, Andy Grover wrote:
> struct scsi_lun is also just a struct with an array of 8 octets (64 bits)
> but using it instead in iscsi structs lets us call scsilun_to_int
> without a cast, and also lets us copy it using assignment, instead of
> memcpy().
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c |    5 ++---
>  drivers/scsi/bnx2i/bnx2i_hwi.c  |    8 ++++----
>  drivers/scsi/libiscsi.c         |   14 +++++++-------
>  include/scsi/iscsi_proto.h      |   18 +++++++++---------
>  include/scsi/libiscsi.h         |    2 +-
>  5 files changed, 23 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 94b9a07..96d7d07 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3963,11 +3963,10 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
>  	}
>  	memcpy(&io_task->cmd_bhs->iscsi_data_pdu.
>  	       dw[offsetof(struct amap_pdu_data_out, lun) / 32],
> -	       io_task->cmd_bhs->iscsi_hdr.lun, sizeof(struct scsi_lun));
> +	       &io_task->cmd_bhs->iscsi_hdr.lun, sizeof(struct scsi_lun));
>  
>  	AMAP_SET_BITS(struct amap_iscsi_wrb, lun, pwrb,
> -		      cpu_to_be16((unsigned short)io_task->cmd_bhs->iscsi_hdr.
> -				  lun[0]));
> +		      cpu_to_be16(*(unsigned short*)&io_task->cmd_bhs->iscsi_hdr.lun));
>  	AMAP_SET_BITS(struct amap_iscsi_wrb, r2t_exp_dtl, pwrb, xferlen);
>  	AMAP_SET_BITS(struct amap_iscsi_wrb, wrb_idx, pwrb,
>  		      io_task->pwrb_handle->wrb_index);
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index 5c54a2d..550e6c4 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -430,7 +430,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
>  	default:
>  		tmfabort_wqe->ref_itt = RESERVED_ITT;
>  	}
> -	memcpy(scsi_lun, tmfabort_hdr->lun, sizeof(struct scsi_lun));
> +	memcpy(scsi_lun, &tmfabort_hdr->lun, sizeof(struct scsi_lun));
>  	tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
>  	tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
>  
> @@ -547,7 +547,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
>  
>  	nopout_wqe->op_code = nopout_hdr->opcode;
>  	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
> -	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
> +	memcpy(nopout_wqe->lun, &nopout_hdr->lun, 8);

Should you be using "sizeof (..)" here (and similar instances), rather
than 8? It is being done that way in other instances and it would be
better practice, IMHO.

-- 
Ankit Jain
SUSE Labs
