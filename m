From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: do not set DID_PASSTHROUGH on CHECK CONDITION
Date: Tue, 11 Apr 2017 09:34:06 -0500
Message-ID: <195c1f0d-2ff5-a54f-a51d-f595b8673be6@linux.vnet.ibm.com>
References: <1491877731-19287-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60082 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753321AbdDKOeL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Apr 2017 10:34:11 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3BEQNwZ029424
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 10:34:10 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29rrne6y2y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 10:34:10 -0400
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Tue, 11 Apr 2017 08:34:09 -0600
In-Reply-To: <1491877731-19287-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com

Mauricio,

Looks good to me. Thanks for the detailed analysis. One minor nit below
and you can add:

Acked-by: Brian King <brking@linux.vnet.ibm.com>

On 04/10/2017 09:28 PM, Mauricio Faria de Oliveira wrote:
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index b29afafc2885..1012674d9dc5 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -6293,7 +6293,12 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
>  		break;
>  	case IPR_IOASC_MED_DO_NOT_REALLOC: /* prevent retries */
>  	case IPR_IOASA_IR_DUAL_IOA_DISABLED:
> -		scsi_cmd->result |= (DID_PASSTHROUGH << 16);
> +		/*
> +		 * exception: do not set DID_PASSTHROUGH on CHECK CONDITION
> +		 * so SCSI mid-layer and upper layers handle it accordingly.
> +		 */
> +		if (ipr_cmd->scsi_cmd->result != SAM_STAT_CHECK_CONDITION)

Since we already have a scsi_cmd local, you don't need to go back to the ipr_cmd
to get the pointer, so could be:

if (scsi_cmd->result != SAM_STAT_CHECK_CONDITION)


> +			scsi_cmd->result |= (DID_PASSTHROUGH << 16);
>  		break;
>  	case IPR_IOASC_BUS_WAS_RESET:
>  	case IPR_IOASC_BUS_WAS_RESET_BY_OTHER:
> 

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
