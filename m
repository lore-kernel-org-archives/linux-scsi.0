From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt2sas: fix the incorrect scsi_dma_map error checking
Date: Tue, 9 Mar 2010 17:20:03 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249020E1A7A59@inbmail02.lsi.com>
References: <20100309110916T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:38550 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784Ab0CILuc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2010 06:50:32 -0500
In-Reply-To: <20100309110916T.fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I do agree with this patch. Please consider this patch as an ACKed so that it can be merge 
In next window.

Thanks,
Kashyap

> -----Original Message-----
> From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
> Sent: Tuesday, March 09, 2010 7:40 AM
> To: Desai, Kashyap
> Cc: James.Bottomley@suse.de; linux-scsi@vger.kernel.org
> Subject: [PATCH] mpt2sas: fix the incorrect scsi_dma_map error checking
> 
> scsi_dma_map() returns -1 if an error occurred (zero means that the
> command has no data). So the following current code can't catch an
> error:
> 
> sges_left = scsi_dma_map(scmd);
> if (!sges_left) {
> 	sdev_printk(KERN_ERR, scmd->device, "pci_map_sg"
> 	" failed: request for %d bytes!\n", scsi_bufflen(scmd));
> 	return -ENOMEM;
> }
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index c7ec3f1..99d189d 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -987,7 +987,7 @@ _scsih_build_scatter_gather(struct MPT2SAS_ADAPTER
> *ioc,
>  	u32 chain_offset;
>  	u32 chain_length;
>  	u32 chain_flags;
> -	u32 sges_left;
> +	int sges_left;
>  	u32 sges_in_segment;
>  	u32 sgl_flags;
>  	u32 sgl_flags_last_element;
> @@ -1008,7 +1008,7 @@ _scsih_build_scatter_gather(struct
> MPT2SAS_ADAPTER *ioc,
> 
>  	sg_scmd = scsi_sglist(scmd);
>  	sges_left = scsi_dma_map(scmd);
> -	if (!sges_left) {
> +	if (sges_left < 0) {
>  		sdev_printk(KERN_ERR, scmd->device, "pci_map_sg"
>  		" failed: request for %d bytes!\n", scsi_bufflen(scmd));
>  		return -ENOMEM;
> --
> 1.6.5

