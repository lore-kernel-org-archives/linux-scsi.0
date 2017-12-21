From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/29] scsi: aacraid: Fix hang in kdump
Date: Thu, 21 Dec 2017 17:15:42 -0200
Message-ID: <390b1d27-c72f-024b-12ec-5181d4ef0a3f@linux.vnet.ibm.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
 <20171221173420.8213-4-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752222AbdLUTPv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 14:15:51 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBLJFnXY111549
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 14:15:51 -0500
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2f0f4u3kp1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 14:15:50 -0500
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Thu, 21 Dec 2017 12:15:49 -0700
In-Reply-To: <20171221173420.8213-4-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com

On 12/21/2017 03:33 PM, Raghava Aditya Renukunta wrote:
> Driver attempts to perform a device scan and device add after coming out
> of reset. At times when the kdump kernel loads and it tries to perform
> eh recovery, the device scan hangs since its commands are blocked because
> of the eh recovery. This should have shown up in normal eh recovery path
> (Should have been obvious)
> 
> Remove the code that performs scanning.I can live without the rescanning
> support in the stable kernels but a hanging kdump/eh recovery needs to be
> fixed.
> 
> Fixes: a2d0321dd532901e (scsi: aacraid: Reload offlined drives after controller reset)
> Cc: <stable@vger.kernel.org>
> Reported-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> Tested-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> Fixes: a2d0321dd532901e (scsi: aacraid: Reload offlined drives after controller reset)
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

Thanks a lot Raghava =)

> ---
>  drivers/scsi/aacraid/commsup.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index 525a652..ffbfd04 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -1672,14 +1672,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
>  out:
>  	aac->in_reset = 0;
>  	scsi_unblock_requests(host);
> -	/*
> -	 * Issue bus rescan to catch any configuration that might have
> -	 * occurred
> -	 */
> -	if (!retval) {
> -		dev_info(&aac->pdev->dev, "Issuing bus rescan\n");
> -		scsi_scan_host(host);
> -	}
> +
>  	if (jafo) {
>  		spin_lock_irq(host->host_lock);
>  	}
> 
