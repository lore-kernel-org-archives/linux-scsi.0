From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH RESEND] bnx2fc:Fix locking requirements before calling
 the function bnx2fc_alloc_conn_id
Date: Mon, 18 Jan 2016 12:47:06 -0500
Message-ID: <alpine.OSX.2.00.1601181246140.1367@administrators-macbook-pro.local>
References: <1452828262-23117-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:40650 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755981AbcARRrP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 12:47:15 -0500
In-Reply-To: <1452828262-23117-1-git-send-email-xerofoify@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: QLogic-Storage-Upstream@qlogic.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



On Thu, 14 Jan 2016, Nicholas Krause wrote:

> This fixes the locking requirements before calling the function
> bnx2fc_alloc_conn_id by locking the mutex hba_mutex of the
> structure pointer hba in the function bnx2fc_init_tgt as this
> is commented as required to be held by the caller of the function
> bnx2fc_alloc_conn_id. In addition we must also unlock this lock if
> either a error occurs inside the function bnx2fc_alloc_conn_id or
> this function exits successfully in order to avoid deadlock with
> other users of this mutex.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
> drivers/scsi/bnx2fc/bnx2fc_tgt.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> index c66c708..41fec79 100644
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

Nack, hba->hba_mutex is already taken in the bnx2fc_alloc_conn_id() so 
there is no need to take it in the caller.
