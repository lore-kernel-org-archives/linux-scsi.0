From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] ibmvscsi: Speed up kexec boot
Date: Fri, 28 Mar 2014 16:49:08 +1100
Message-ID: <20140328164908.41441dc9@kryten>
References: <20131223182816.0e8985af@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:49567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaC1FtD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 01:49:03 -0400
In-Reply-To: <20131223182816.0e8985af@kryten>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Hi,

> During kexec boot we call ibmvscsi_release_crq_queue() to tear down
> the old CRQ from the previous kernel. ibmvscsi_release_crq_queue()
> does this by calling H_FREE_CRQ. The hypervisor breaks this work
> down so as limit the time spent in any one hcall, so we have to loop
> until complete.
> 
> At the moment we delay 0.1 seconds between every H_FREE_CRQ call.
> I see us calling H_FREE_CRQ 60 times on my box which means we
> delayed a total of 6 seconds.
> 
> This delay is overkill, we are free to handle all busy return codes
> from the hypervisor as we see fit. Cut the delay down to something
> more reasonable - 1 ms. This improves my boot time by 6 seconds.
> 
> Fix the other places we have arbitrary 100 ms delays.

Checking in on this patch, 6 seconds is a decent chunk of our boot time
on KVM.

Anton

> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c
> b/drivers/scsi/ibmvscsi/ibmvscsi.c index fa76440..ed7b52e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -159,7 +159,7 @@ static void ibmvscsi_release_crq_queue(struct
> crq_queue *queue, tasklet_kill(&hostdata->srp_task);
>  	do {
>  		if (rc)
> -			msleep(100);
> +			msleep(1);
>  		rc = plpar_hcall_norets(H_FREE_CRQ,
> vdev->unit_address); } while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
>  	dma_unmap_single(hostdata->dev,
> @@ -292,7 +292,7 @@ static int ibmvscsi_reset_crq_queue(struct
> crq_queue *queue, /* Close the CRQ */
>  	do {
>  		if (rc)
> -			msleep(100);
> +			msleep(1);
>  		rc = plpar_hcall_norets(H_FREE_CRQ,
> vdev->unit_address); } while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
>  
> @@ -392,7 +392,7 @@ static int ibmvscsi_init_crq_queue(struct
> crq_queue *queue, rc = 0;
>  	do {
>  		if (rc)
> -			msleep(100);
> +			msleep(1);
>  		rc = plpar_hcall_norets(H_FREE_CRQ,
> vdev->unit_address); } while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
>        reg_crq_failed:
> @@ -420,7 +420,7 @@ static int ibmvscsi_reenable_crq_queue(struct
> crq_queue *queue, /* Re-enable the CRQ */
>  	do {
>  		if (rc)
> -			msleep(100);
> +			msleep(1);
>  		rc = plpar_hcall_norets(H_ENABLE_CRQ,
> vdev->unit_address); } while ((rc == H_IN_PROGRESS) || (rc == H_BUSY)
> || (H_IS_LONG_BUSY(rc))); 

