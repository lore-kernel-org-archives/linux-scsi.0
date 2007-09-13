From: Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-rc4-mm1
Date: Thu, 13 Sep 2007 18:34:27 +0100
Message-ID: <20070913173427.GB455@shadowen.org>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070910174926.GC30335@shadowen.org> <20070910111926.9c942358.akpm@linux-foundation.org> <20070910042256Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hellhawk.shadowen.org ([80.68.90.175]:2925 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbXIMRfE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2007 13:35:04 -0400
Content-Disposition: inline
In-Reply-To: <20070910042256Z.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, Sep 11, 2007 at 04:10:47AM +0900, FUJITA Tomonori wrote:

> > The only patch which touches qla1280 is git-block.patch.  From a quick
> > squizz the change looks OK, although it's tricky and something might have
> > broken.
> 
> Can you try this patch (against 2.6.23-rc4-mm1)?

Yep this patch seems to sort out booting on these boxes.  The other one
is also testing.  Results later.

> >From 592bd2049cb3e6e1f1dde7cf631879f26ddffeaa Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Mon, 10 Sep 2007 04:17:13 +0100
> Subject: [PATCH] qla1280: sg chaining fixes
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/qla1280.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index bd805ec..7c1eaec 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -2977,8 +2977,8 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
>  						cpu_to_le32(pci_dma_hi32(dma_handle)),
>  						cpu_to_le32(pci_dma_lo32(dma_handle)),
>  						cpu_to_le32(sg_dma_len(s)));
> -					remseg--;
>  				}
> +				remseg -= cnt;
>  				dprintk(5, "qla1280_64bit_start_scsi: "
>  					"continuation packet data - b %i, t "
>  					"%i, l %i \n", SCSI_BUS_32(cmd),
> @@ -3250,6 +3250,8 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
>  
>  				/* Load continuation entry data segments. */
>  				for_each_sg(sg, s, remseg, cnt) {
> +					if (cnt == 7)
> +						break;
>  					*dword_ptr++ =
>  						cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
>  					*dword_ptr++ =
> @@ -3260,6 +3262,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
>  						cpu_to_le32(pci_dma_lo32(sg_dma_address(s))),
>  						cpu_to_le32(sg_dma_len(s)));
>  				}
> +				remseg -= cnt;
>  				dprintk(5, "qla1280_32bit_start_scsi: "
>  					"continuation packet data - "
>  					"scsi(%i:%i:%i)\n", SCSI_BUS_32(cmd),
> -- 
> 1.5.2.4
> 
> 

-apw
