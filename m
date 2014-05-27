From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 2/2] ibmvscsi: Add memory barriers for send / receive
Date: Tue, 27 May 2014 08:56:04 -0500
Message-ID: <53849974.2060402@linux.vnet.ibm.com>
References: <201405231552.s4NFqB4h028030@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:55089 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaE0N4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 09:56:09 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <nfont@linux.vnet.ibm.com>;
	Tue, 27 May 2014 07:56:08 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 03FD81FF003D
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2014 07:56:06 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.ahe.boulder.ibm.com [9.17.195.167])
	by b03cxnp08025.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s4RDu6cG66715866
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2014 15:56:06 +0200
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s4RDu5Uf024373
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2014 07:56:06 -0600
In-Reply-To: <201405231552.s4NFqB4h028030@d01av01.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

On 05/23/2014 10:52 AM, Brian King wrote:
> Add a memory barrier prior to sending a new command to the VIOS
> to ensure the VIOS does not receive stale data in the command buffer.
> Also add a memory barrier when processing the CRQ for completed commands.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

> ---
> 
>  drivers/scsi/ibmvscsi/ibmvscsi.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_barrier drivers/scsi/ibmvscsi/ibmvscsi.c
> --- linux/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_barrier	2014-05-23 10:41:35.000000000 -0500
> +++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2014-05-23 10:42:53.000000000 -0500
> @@ -185,6 +185,11 @@ static struct viosrp_crq *crq_queue_next
>  	if (crq->valid & 0x80) {
>  		if (++queue->cur == queue->size)
>  			queue->cur = 0;
> +
> +		/* Ensure the read of the valid bit occurs before reading any
> +		 * other bits of the CRQ entry
> +		 */
> +		rmb();
>  	} else
>  		crq = NULL;
>  	spin_unlock_irqrestore(&queue->lock, flags);
> @@ -203,6 +208,11 @@ static int ibmvscsi_send_crq(struct ibmv
>  {
>  	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
> 
> +	/*
> +	 * Ensure the command buffer is flushed to memory before handing it
> +	 * over to the VIOS to prevent it from fetching any stale data.
> +	 */
> +	mb();
>  	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
>  }
> 
> _
> 

