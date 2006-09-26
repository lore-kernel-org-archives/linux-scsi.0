From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [patch 15/28] megaraid: Use the proper type to hold the irq number.
Date: Tue, 26 Sep 2006 06:29:33 -0600
Message-ID: <890BF3111FB9484E9526987D912B261932E39B@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43949 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751206AbWIZM3v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 08:29:51 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, ebiederm@xmission.com, "Kolli, Neela" <Neela.Kolli@engenio.com>

ACK - Thank you for fix. 

> -----Original Message-----
> From: akpm@osdl.org [mailto:akpm@osdl.org] 
> Sent: Monday, September 25, 2006 7:59 PM
> To: James.Bottomley@steeleye.com
> Cc: linux-scsi@vger.kernel.org; akpm@osdl.org; 
> ebiederm@xmission.com; Kolli, Neela; Ju, Seokmann
> Subject: [patch 15/28] megaraid: Use the proper type to hold 
> the irq number.
> 
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> When testing on a Unisys machine it was discovered that the 
> megaraid driver
> would not initialize as it was requesting irq 162 instead of 
> irq 1442 it
> was assigned.  The problem was the irq number had been 
> truncated by being
> stored in an unsigned char.
> 
> This patches fixes that problem and the driver now appears to work.
> 
> The ioctl interface appears fundamentally broken as it exports the irq
> number to user space in an unsigned char.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Neela Syam Kolli<Neela.Kolli@engenio.com>
> Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/megaraid/mega_common.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN 
> drivers/scsi/megaraid/mega_common.h~megaraid-use-the-proper-ty
> pe-to-hold-the-irq-number drivers/scsi/megaraid/mega_common.h
> --- 
> a/drivers/scsi/megaraid/mega_common.h~megaraid-use-the-proper-
> type-to-hold-the-irq-number
> +++ a/drivers/scsi/megaraid/mega_common.h
> @@ -175,7 +175,7 @@ typedef struct {
>  	uint8_t			max_lun;
>  
>  	uint32_t		unique_id;
> -	uint8_t			irq;
> +	int			irq;
>  	uint8_t			ito;
>  	caddr_t			ibuf;
>  	dma_addr_t		ibuf_dma_h;
> _
> 
