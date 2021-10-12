Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5379FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD9560FDA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbhJLXkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:40:07 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:46697 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236054AbhJLXkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 19:40:06 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 32C203200DA8;
        Tue, 12 Oct 2021 19:38:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 12 Oct 2021 19:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=q117RS
        Lv3RobY8UuO/vQ7wnIEv8TSbDfx48RDKhsmIM=; b=Epu0peO6s1ANPAo9FDqcT1
        XCxAVvX8Xa1kCCaQ1JLq7xhEXCUv0YIGpgBo/pQE3oxY0Cw5pvoVbrcrdU6qxPWr
        pFhaxHhwkH+PmpfUQIli/lGkMQBCBEzKdioeR5RYtPvjXfubkb22fliufL3VyU+X
        +0gnHLDFlLUkUSdVlAIMcbIKoJOfRnEAoL5pvywPwyluIFNSwXODC0yfgd7quFgP
        Yc5hFMCWlKCyXPdj+9Bc6v8SgSUJRQnnXDVoHqZvrGQLN84Rabgn1tZYW1EUj/+h
        SYvfQx07gUcCwN+N/7idvCgwbSBfcB4flXvhbZua1/ik6osyEGlzwivuY3yJKzeA
        ==
X-ME-Sender: <xms:WRxmYbURIpDxhXcdfadfdXn2vpQ2hwy2Zn-aLol2DH8DIs4Ny_KeVw>
    <xme:WRxmYTlEPItbUSljhmdp4qqroV-tw6DWpdQQwgyDdC5AXmW3jWqhq3v62PPDOy4pF
    0ns1-zNVdB40kIrcXw>
X-ME-Received: <xmr:WRxmYXaa4LdeKwFezLsByepnCpOPJ8RcH4wWRwdnJrl9BbS6ItlSR8etwMfLS79EPRbmxePhgYkvcXDtGwjYFLT266U2bM4NcXk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtledgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepffduhfegfedvieetudfgleeugeehkeekfeevfffhieevteelvdfhtdevffet
    uedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfh
    hthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:WhxmYWU0ExNNWI_v69HfUfiC0kLKxvbPh_hWlFlQNre5Blo25P7G0w>
    <xmx:WhxmYVnRn38COkdQPK7YY4A71Fa8EREf0eOuPUssQ1IGwqPvHYE3gg>
    <xmx:WhxmYTe1FJrjpWO_M99hX67wHDkDD0-UK7k8R01RGLHbhILZlbWjDQ>
    <xmx:WhxmYYuI7siuz1LmNXRyrW4aeiv57gLplZtvadOSbYnIefzoYut_Wg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 19:38:00 -0400 (EDT)
Date:   Wed, 13 Oct 2021 10:37:56 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Cai Huoqing <caihuoqing@baidu.com>
cc:     hch@infradead.org, Michael Cyr <mikecyr@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ibmvscsi_tgt: Use dma_alloc_noncoherent()
 instead of get_zeroed_page/dma_map_single()
In-Reply-To: <20211012032110.2224-1-caihuoqing@baidu.com>
Message-ID: <f8c34711-18a5-6c9d-8066-99cf19c2b2@linux-m68k.org>
References: <20211012032110.2224-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Oct 2021, Cai Huoqing wrote:

> Replacing get_zeroed_page/free_page/dma_map_single/dma_unmap_single()
> with dma_alloc_noncoherent/dma_free_noncoherent() helps to reduce
> code size, and simplify the code, and the hardware keep DMA coherent
> itself.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
> v1->v2:
> 	*Change to dma_alloc/free_noncoherent from dma_alloc/free_coherent.
> 	*Update changelog.
> 
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 46 ++++++++----------------
>  1 file changed, 15 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index 61f06f6885a5..91199b969718 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3007,20 +3007,13 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
>  
>  	vscsi->cmd_q.size = pages;
>  
> -	vscsi->cmd_q.base_addr =
> -		(struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
> -	if (!vscsi->cmd_q.base_addr)
> -		return -ENOMEM;
> -
>  	vscsi->cmd_q.mask = ((uint)pages * CRQ_PER_PAGE) - 1;
>  
> -	vscsi->cmd_q.crq_token = dma_map_single(&vdev->dev,
> -						vscsi->cmd_q.base_addr,
> -						PAGE_SIZE, DMA_BIDIRECTIONAL);
> -	if (dma_mapping_error(&vdev->dev, vscsi->cmd_q.crq_token)) {
> -		free_page((unsigned long)vscsi->cmd_q.base_addr);
> +	vscsi->cmd_q.base_addr = dma_alloc_noncoherent(&vdev->dev, PAGE_SIZE,
> +						       &vscsi->cmd_q.crq_token,
> +						       DMA_BIDIRECTIONAL, GFP_KERNEL);
> +	if (!vscsi->cmd_q.base_addr)
>  		return -ENOMEM;
> -	}
>  
>  	return 0;
>  }
> @@ -3036,9 +3029,9 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
>   */
>  static void ibmvscsis_destroy_command_q(struct scsi_info *vscsi)
>  {
> -	dma_unmap_single(&vscsi->dma_dev->dev, vscsi->cmd_q.crq_token,
> -			 PAGE_SIZE, DMA_BIDIRECTIONAL);
> -	free_page((unsigned long)vscsi->cmd_q.base_addr);
> +	dma_free_noncoherent(&vscsi->dma_dev->dev,
> +			     PAGE_SIZE, vscsi->cmd_q.base_addr,
> +			     vscsi->cmd_q.crq_token, DMA_BIDIRECTIONAL);
>  	vscsi->cmd_q.base_addr = NULL;
>  	vscsi->state = NO_QUEUE;
>  }
> @@ -3504,18 +3497,12 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
>  		goto free_timer;
>  	}
>  
> -	vscsi->map_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	vscsi->map_buf = dma_alloc_noncoherent(&vdev->dev,
> +					       PAGE_SIZE, &vscsi->map_ioba,
> +					       DMA_BIDIRECTIONAL, GFP_KERNEL);
>  	if (!vscsi->map_buf) {
>  		rc = -ENOMEM;
>  		dev_err(&vscsi->dev, "probe: allocating cmd buffer failed\n");
> -		goto destroy_queue;
> -	}
> -
> -	vscsi->map_ioba = dma_map_single(&vdev->dev, vscsi->map_buf, PAGE_SIZE,
> -					 DMA_BIDIRECTIONAL);
> -	if (dma_mapping_error(&vdev->dev, vscsi->map_ioba)) {
> -		rc = -ENOMEM;
> -		dev_err(&vscsi->dev, "probe: error mapping command buffer\n");
>  		goto free_buf;

Shouldn't that be goto destroy_queue?

>  	}
>  
> @@ -3544,7 +3531,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
>  	if (!vscsi->work_q) {
>  		rc = -ENOMEM;
>  		dev_err(&vscsi->dev, "create_workqueue failed\n");
> -		goto unmap_buf;
> +		goto destroy_queue;

And goto free_buf?

>  	}
>  
>  	rc = request_irq(vdev->irq, ibmvscsis_interrupt, 0, "ibmvscsis", vscsi);
> @@ -3562,11 +3549,9 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
>  
>  destroy_WQ:
>  	destroy_workqueue(vscsi->work_q);
> -unmap_buf:
> -	dma_unmap_single(&vdev->dev, vscsi->map_ioba, PAGE_SIZE,
> -			 DMA_BIDIRECTIONAL);
>  free_buf:
> -	kfree(vscsi->map_buf);
> +	dma_free_noncoherent(&vdev->dev, PAGE_SIZE, vscsi->map_buf,
> +			     vscsi->map_ioba, DMA_BIDIRECTIONAL);
>  destroy_queue:
>  	tasklet_kill(&vscsi->work_task);
>  	ibmvscsis_unregister_command_q(vscsi);
> @@ -3602,9 +3587,8 @@ static void ibmvscsis_remove(struct vio_dev *vdev)
>  	vio_disable_interrupts(vdev);
>  	free_irq(vdev->irq, vscsi);
>  	destroy_workqueue(vscsi->work_q);
> -	dma_unmap_single(&vdev->dev, vscsi->map_ioba, PAGE_SIZE,
> -			 DMA_BIDIRECTIONAL);
> -	kfree(vscsi->map_buf);
> +	dma_free_noncoherent(&vdev->dev, PAGE_SIZE, vscsi->map_buf,
> +			     vscsi->map_ioba, DMA_BIDIRECTIONAL);
>  	tasklet_kill(&vscsi->work_task);
>  	ibmvscsis_destroy_command_q(vscsi);
>  	ibmvscsis_freetimer(vscsi);
> 
