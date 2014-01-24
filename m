From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 3/6] megaraid_sas_fusion: correctly pass queue info
 pointer
Date: Fri, 24 Jan 2014 08:41:11 +0000
Message-ID: <4da5cb533f8e4b759f8b41c96d882b5d@BN1PR07MB247.namprd07.prod.outlook.com>
References: <1389867936-118685-1-git-send-email-hare@suse.de>
 <1389867936-118685-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1lp0153.outbound.protection.outlook.com ([207.46.163.153]:6813
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaAXIlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 03:41:14 -0500
In-Reply-To: <1389867936-118685-4-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adam Radford <aradford@gmail.com>

ACK  this patch.

` Kashyap

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, January 16, 2014 3:56 PM
> To: James Bottomley
> Cc: linux-scsi@vger.kernel.org; Hannes Reinecke; Desai, Kashyap; Adam
> Radford
> Subject: [PATCH 3/6] megaraid_sas_fusion: correctly pass queue info pointer
> 
> The pointer to the queue info structure is potentially a 64-bit value, so we
> should be using the correct macros to set the values in the init frame.
> 
> Cc: Kashyap Desai <kashyap.desai@lsi.com>
> Cc: Adam Radford <aradford@gmail.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 0a588a6..5c30f9d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -644,7 +644,10 @@ megasas_ioc_init_fusion(struct megasas_instance
> *instance)
>  	/* Convert capability to LE32 */
>  	cpu_to_le32s((u32 *)&init_frame-
> >driver_operations.mfi_capabilities);
> 
> -	init_frame->queue_info_new_phys_addr_lo =
> cpu_to_le32((u32)ioc_init_handle);
> +	init_frame->queue_info_new_phys_addr_hi =
> +		cpu_to_le32(upper_32_bits(ioc_init_handle));
> +	init_frame->queue_info_new_phys_addr_lo =
> +		cpu_to_le32(lower_32_bits(ioc_init_handle));
>  	init_frame->data_xfer_len = cpu_to_le32(sizeof(struct
> MPI2_IOC_INIT_REQUEST));
> 
>  	req_desc =
> --
> 1.7.12.4
> 

