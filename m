From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ibmvfc: Fix I/O hang when port is not mapped
Date: Mon, 19 Sep 2016 14:21:15 -0700
Message-ID: <d79ea6ba-c15c-e463-3b06-2f1dd378bef0@linux.vnet.ibm.com>
References: <20160919135919.689C528041@b01ledav001.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60535 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932094AbcISVVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Sep 2016 17:21:21 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8JLIXwm008336
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2016 17:21:21 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25jama7y26-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2016 17:21:21 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Mon, 19 Sep 2016 15:21:20 -0600
In-Reply-To: <20160919135919.689C528041@b01ledav001.gho.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, tyreld@linux.vnet.ibm.com

On 09/19/2016 06:59 AM, Brian King wrote:
> If a VFC port gets unmapped in the VIOS, it may not respond with a CRQ init
> complete following H_REG_CRQ. If this occurs, we can end up having called
> scsi_block_requests and not a resulting unblock until the init complete
> happens, which may never occur, and we end up hanging I/O requests.
> This patch ensures the host action stay set to IBMVFC_HOST_ACTION_TGT_DEL so
> we move all rports into devloss state and unblock unless we receive an
> init complete. 
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

In retrospect this probably should have been queued up for stable as well.

-Tyrel

> ---
> 
>  drivers/scsi/ibmvscsi/ibmvfc.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_unmap_hang_fix drivers/scsi/ibmvscsi/ibmvfc.c
> --- linux-2.6.git/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_unmap_hang_fix	2016-09-09 15:46:36.452011778 -0500
> +++ linux-2.6.git-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2016-09-09 15:47:07.026632886 -0500
> @@ -717,7 +717,6 @@ static int ibmvfc_reset_crq(struct ibmvf
>  	spin_lock_irqsave(vhost->host->host_lock, flags);
>  	vhost->state = IBMVFC_NO_CRQ;
>  	vhost->logged_in = 0;
> -	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
>  
>  	/* Clean out the queue */
>  	memset(crq->msgs, 0, PAGE_SIZE);
> _
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

