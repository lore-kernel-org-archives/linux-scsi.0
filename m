From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ibmvfc: Fix for offlining devices during error
 recovery
Date: Tue, 3 Sep 2013 10:55:22 -0500
Message-ID: <20130903155522.GA3180@linux.vnet.ibm.com>
References: <201308201608.r7KG8hCR015363@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56251 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3ICPzc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 11:55:32 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <rcj@linux.vnet.ibm.com>;
	Wed, 4 Sep 2013 01:41:35 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id BC43F357804E
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2013 01:55:24 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r83Fd27H52363412
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2013 01:39:02 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r83FtOnn024314
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2013 01:55:24 +1000
Content-Disposition: inline
In-Reply-To: <201308201608.r7KG8hCR015363@d01av05.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

* Brian King (brking@linux.vnet.ibm.com) wrote:
> 
> This fixes an issue seen with devices getting marked offline
> in a scenario where a VIOS was getting rebooted while a
> client VFC adapter is in SCSI EH and prevents unnecessary
> EH escalation in some scenarios.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ibmvscsi/ibmvfc.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_during_reset drivers/scsi/ibmvscsi/ibmvfc.c
> --- linux/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_during_reset	2013-08-06 15:10:04.000000000 -0500
> +++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2013-08-06 15:10:04.000000000 -0500
> @@ -2208,7 +2208,10 @@ static int ibmvfc_cancel_all(struct scsi
> 
>  	if (rsp_rc != 0) {
>  		sdev_printk(KERN_ERR, sdev, "Failed to send cancel event. rc=%d\n", rsp_rc);
> -		return -EIO;
> +		/* If failure is received, the host adapter is most likely going
> +		 through reset, return success so the caller will wait for the command
> +		 being cancelled to get returned */
> +		return 0;
>  	}
> 
>  	sdev_printk(KERN_INFO, sdev, "Cancelling outstanding commands.\n");
> @@ -2221,7 +2224,15 @@ static int ibmvfc_cancel_all(struct scsi
> 
>  	if (status != IBMVFC_MAD_SUCCESS) {
>  		sdev_printk(KERN_WARNING, sdev, "Cancel failed with rc=%x\n", status);
> -		return -EIO;
> +		switch (status) {
> +		case IBMVFC_MAD_DRIVER_FAILED:
> +		case IBMVFC_MAD_CRQ_ERROR:
> +			/* Host adapter most likely going through reset, return success to
> +			 the caller will wait for the command being cancelled to get returned */
> +			return 0;
> +		default:
> +			return -EIO;
> +		};
>  	}
> 
>  	sdev_printk(KERN_INFO, sdev, "Successfully cancelled outstanding commands\n");
> _

