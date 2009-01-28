From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi: Correct DMA mapping leak
Date: Wed, 28 Jan 2009 08:45:30 -0600
Message-ID: <49806F8A.2000907@linux.vnet.ibm.com>
References: <20090122194009.GB14767@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47197 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZA1Oqw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2009 09:46:52 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n0SEjDeF027948
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2009 09:45:13 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0SEkoco195162
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2009 09:46:50 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0SEkowl004217
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2009 09:46:50 -0500
In-Reply-To: <20090122194009.GB14767@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Acked by: Brian King <brking@linux.vnet.ibm.com>

Robert Jennings wrote:
> The ibmvscsi client driver is not unmapping the SCSI command after
> encountering a DMA mapping error while trying to map an indirect
> scattergather list for the event pool.  This leads to a leak of DMA
> entitlement that could result in the device failing future DMA operations
> in a CMO environment.
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: b/drivers/scsi/ibmvscsi/ibmvscsi.c
> ===================================================================
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -432,6 +432,7 @@ static int map_sg_data(struct scsi_cmnd 
>  				sdev_printk(KERN_ERR, cmd->device,
>  				            "Can't allocate memory "
>  				            "for indirect table\n");
> +			scsi_dma_unmap(cmd);
>  			return 0;
>  		}
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


