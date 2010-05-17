From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: set the data list length in the request control
 block
Date: Mon, 17 May 2010 16:19:17 -0500
Message-ID: <4BF1B2D5.4020607@linux.vnet.ibm.com>
References: <20100513224944.397556901@linux.vnet.ibm.com> <4BED7261.6020108@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:38398 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0EQVTf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2010 17:19:35 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e36.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o4HLGOdr001624
	for <linux-scsi@vger.kernel.org>; Mon, 17 May 2010 15:16:24 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o4HLJLap142100
	for <linux-scsi@vger.kernel.org>; Mon, 17 May 2010 15:19:22 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o4HLJKGJ020091
	for <linux-scsi@vger.kernel.org>; Mon, 17 May 2010 15:19:20 -0600
In-Reply-To: <4BED7261.6020108@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

On 05/14/2010 10:55 AM, Wayne Boyer wrote:
> In bring up testing for the new 64 bit adapters, the first read command failed
> after loading the driver.  The cause was that the command requires more than 
> one scatter gather element and the corresponding code to set the data list
> length in the request control block was missing.  This patch adds the correct 
> assignment.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2010-05-13 12:38:47.000000000 -0700
> +++ b/drivers/scsi/ipr.c	2010-05-13 12:45:11.000000000 -0700
> @@ -5018,6 +5018,8 @@ static int ipr_build_ioadl64(struct ipr_
>  	ipr_cmd->dma_use_sg = nseg;
> 
>  	ioarcb->data_transfer_length = cpu_to_be32(length);
> +	ioarcb->ioadl_len =
> +		cpu_to_be32(sizeof(struct ipr_ioadl64_desc) * ipr_cmd->dma_use_sg);
> 
>  	if (scsi_cmd->sc_data_direction == DMA_TO_DEVICE) {
>  		ioadl_flags = IPR_IOADL_FLAGS_WRITE;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
