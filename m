From: wenxiong <wenxiong@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6] ipr: Fix missed EH wakeup
Date: Thu, 23 Mar 2017 10:54:40 -0500
Message-ID: <f027450da9b3ba5214b1c60420a26384@linux.vnet.ibm.com>
References: <20170315215837.5146A13603C@b03ledav002.gho.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32939 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934419AbdCWPvN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Mar 2017 11:51:13 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2NFmfHo127138
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2017 11:51:12 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29cgnr2gsm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2017 11:51:12 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
        Thu, 23 Mar 2017 11:51:11 -0400
In-Reply-To: <20170315215837.5146A13603C@b03ledav002.gho.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On 2017-03-15 16:58, Brian King wrote:

I have reviewed this serial of patches and tested them on IBM systems 
successfully

Thanks for your help!
Wendy
> Following a command abort or device reset, ipr's EH handlers wait
> for the commands getting aborted to get sent back from the adapter
> prior to returning from the EH handler. This fixes up some cases
> where the completion handler was not getting called, which would
> have resulted in the EH thread waiting until it timed out, greatly
> extending EH time.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff -puN drivers/scsi/ipr.c~ipr_fix_missed_eh_wakeup 
> drivers/scsi/ipr.c
> ---
> linux-2.6.git/drivers/scsi/ipr.c~ipr_fix_missed_eh_wakeup	2017-03-13
> 14:52:17.974545318 -0500
> +++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2017-03-13 
> 17:03:13.635568644 -0500
> @@ -836,8 +836,10 @@ static void ipr_sata_eh_done(struct ipr_
> 
>  	qc->err_mask |= AC_ERR_OTHER;
>  	sata_port->ioasa.status |= ATA_BUSY;
> -	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  	ata_qc_complete(qc);
> +	if (ipr_cmd->eh_comp)
> +		complete(ipr_cmd->eh_comp);
> +	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  }
> 
>  /**
> @@ -5947,8 +5949,10 @@ static void ipr_erp_done(struct ipr_cmnd
>  		res->in_erp = 0;
>  	}
>  	scsi_dma_unmap(ipr_cmd->scsi_cmd);
> -	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  	scsi_cmd->scsi_done(scsi_cmd);
> +	if (ipr_cmd->eh_comp)
> +		complete(ipr_cmd->eh_comp);
> +	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  }
> 
>  /**
> @@ -6338,8 +6342,10 @@ static void ipr_erp_start(struct ipr_ioa
>  	}
> 
>  	scsi_dma_unmap(ipr_cmd->scsi_cmd);
> -	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  	scsi_cmd->scsi_done(scsi_cmd);
> +	if (ipr_cmd->eh_comp)
> +		complete(ipr_cmd->eh_comp);
> +	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  }
> 
>  /**
> @@ -6365,8 +6371,10 @@ static void ipr_scsi_done(struct ipr_cmn
>  		scsi_dma_unmap(scsi_cmd);
> 
>  		spin_lock_irqsave(ipr_cmd->hrrq->lock, lock_flags);
> -		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  		scsi_cmd->scsi_done(scsi_cmd);
> +		if (ipr_cmd->eh_comp)
> +			complete(ipr_cmd->eh_comp);
> +		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, lock_flags);
>  	} else {
>  		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> _
