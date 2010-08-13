From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/5 v2] BNX2I: Added support for other TMFs besides ABORT_TASK
Date: Thu, 12 Aug 2010 20:38:39 -0500
Message-ID: <4C64A21F.8010802@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1281656671-5369-3-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35283 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab0HMBeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2010 21:34:23 -0400
In-Reply-To: <1281656671-5369-3-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 08/12/2010 06:44 PM, Eddie Wai wrote:
> -	tmfabort_wqe->ref_itt = (dword | (tmfabort_hdr->rtt&  ISCSI_ITT_MASK));
> +	switch (tmfabort_hdr->flags&  ISCSI_FLAG_TM_FUNC_MASK) {
> +	case ISCSI_TM_FUNC_ABORT_TASK:
> +	case ISCSI_TM_FUNC_TASK_REASSIGN:
> +		memcpy(tmfabort_wqe->lun, tmfabort_hdr->lun, 8);

....

> +	default:
> +		memcpy(tmfabort_wqe->lun, tmfabort_hdr->lun, 8);
> +		tmfabort_wqe->ref_itt = RESERVED_ITT;
> +	}
>   	tmfabort_wqe->ref_cmd_sn = be32_to_cpu(tmfabort_hdr->refcmdsn);

The 2 memcpys are exactly the same so just do it once right here:

	memcpy(tmfabort_wqe->lun, tmfabort_hdr->lun, 8);

>
>   	tmfabort_wqe->bd_list_addr_lo = (u32) bnx2i_conn->hba->mp_bd_dma;

