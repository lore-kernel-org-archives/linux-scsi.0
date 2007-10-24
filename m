From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
Date: Wed, 24 Oct 2007 09:34:23 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DAB4@otce2k301.adaptec.com>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024173019I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759180AbXJXNep@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20071024173019I.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, AACRAID <aacraid@adaptec.com>, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

ACK

Based on the presence of the call. 2.6.22, for instance, does not have
this capability...

I did not test this change, just accepting on the principals. How much
testing of the change did you do Fujita?

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: FUJITA Tomonori [mailto:tomof@acm.org] 
> Sent: Wednesday, October 24, 2007 6:49 AM
> To: akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; 
> James.Bottomley@SteelEye.com; AACRAID; fujita.tomonori@lab.ntt.co.jp
> Subject: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
> 
> This sets the segment size limit properly via pci_set_dma_max_seg_size
> and remove blk_queue_max_segment_size because scsi-ml calls it.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/aacraid/linit.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c 
> b/drivers/scsi/aacraid/linit.c
> index 038980b..04d6a65 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -435,9 +435,6 @@ static int aac_slave_configure(struct 
> scsi_device *sdev)
>  		else if (depth < 2)
>  			depth = 2;
>  		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
> -		if (!(((struct aac_dev 
> *)host->hostdata)->adapter_info.options &
> -				AAC_OPT_NEW_COMM))
> -			
> blk_queue_max_segment_size(sdev->request_queue, 65536);
>  	} else
>  		scsi_adjust_queue_depth(sdev, 0, 1);
>  
> @@ -1045,6 +1042,12 @@ static int __devinit 
> aac_probe_one(struct pci_dev *pdev,
>  	if (error < 0)
>  		goto out_deinit;
>  
> +	if (!(aac->adapter_info.options & AAC_OPT_NEW_COMM)) {
> +		error = pci_set_dma_max_seg_size(pdev, 65536);
> +		if (error)
> +			goto out_deinit;
> +	}
> +
>  	/*
>   	 * Lets override negotiations and drop the maximum SG 
> limit to 34
>   	 */
> -- 
> 1.5.2.4
> 
