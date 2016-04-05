From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] bnx2fc: Fix locking requirements in bnx2fc_init_tgt
Date: Tue, 5 Apr 2016 13:43:20 -0400
Message-ID: <alpine.OSX.2.00.1604051341370.1272@administrators-macbook-pro.local>
References: <1459867006-19605-1-git-send-email-bastienphilbert@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:24636 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759230AbcDERnf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2016 13:43:35 -0400
In-Reply-To: <1459867006-19605-1-git-send-email-bastienphilbert@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bastien Philbert <bastienphilbert@gmail.com>
Cc: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



On Tue, 5 Apr 2016, Bastien Philbert wrote:

> This fixes the locking around the call to bnx2fc_alloc_id to comply
> with the comments about this particular function's definition about
> requiring the need to hold the hba mutex before and after calling
> it.
> Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
> ---
> drivers/scsi/bnx2fc/bnx2fc_tgt.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> index 08ec318..f2988cd 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> @@ -368,9 +368,13 @@ static int bnx2fc_init_tgt(struct bnx2fc_rport *tgt,
> 		return -1;
> 	}
>
> +	mutex_lock(&hba->hba_mutex);
> 	tgt->fcoe_conn_id = bnx2fc_alloc_conn_id(hba, tgt);
> -	if (tgt->fcoe_conn_id == -1)
> +	if (tgt->fcoe_conn_id == -1) {
> +		mutex_unlock(&hba->hba_mutex);
> 		return -1;
> +	}
> +	mutex_unlock(&hba->hba_mutex);
>
> 	BNX2FC_TGT_DBG(tgt, "init_tgt - conn_id = 0x%x\n", tgt->fcoe_conn_id);
>
>

Taking the mutex here is not needed as it is already taken in 
bnx2fc_rport_event_handler() in the call chain 
bnx2fc_rport_event_handler->bnx2fc_offload_session->bnx2fc_init_tgt->bnx2fc_alloc_conn_id
