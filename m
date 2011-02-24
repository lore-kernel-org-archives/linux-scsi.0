From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 7/15] megaraid_sas: Sanity check user supplied length
 in megasas_mgmt_fw_ioctl
Date: Thu, 24 Feb 2011 15:01:33 +0100
Message-ID: <4D6664BD.4080205@redhat.com>
References: <AANLkTimgTBkOXV3gdvrQH0Vj7UnY6fXNECsFGc=7j2fO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab1BXOBi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2011 09:01:38 -0500
In-Reply-To: <AANLkTimgTBkOXV3gdvrQH0Vj7UnY6fXNECsFGc=7j2fO@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On 02/20/2011 03:22 AM, adam radford wrote:
> James/Linux-scsi,
>
> The following patch from Bjorn Mork for megaraid_sas sanity checks the
> user supplied length in
> megasas_mgmt_fw_ioctl() to prevent a null pointer dereference in
> dma_alloc_coherent() while running
> smartmontools.
>   
Hi Adam,

there was proposed another patch for this issue -
http://marc.info/?l=linux-scsi&m=129542474703680&w=2
I think it's a little bit more precise.

 	for (i = 0; i < ioc->sge_count; i++) {
+		if (!ioc->sgl[i].iov_len)
+			continue;
+

Tomas


> Signed-off-by: Adam Radford <aradford@gmail.com>
>
> diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
> linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
> --- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
> 14:07:13.455395141 -0800
> +++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
> 14:08:31.914332199 -0800
> @@ -4630,6 +4630,11 @@
>  	 * For each user buffer, create a mirror buffer and copy in
>  	 */
>  	for (i = 0; i < ioc->sge_count; i++) {
> +		if (ioc->sgl[i].iov_len == 0) {
> +			kbuff_arr[i] = NULL;
> +			continue;
> +		}
> +
>  		kbuff_arr[i] = dma_alloc_coherent(&instance->pdev->dev,
>  						    ioc->sgl[i].iov_len,
>  						    &buf_handle, GFP_KERNEL);
>   

