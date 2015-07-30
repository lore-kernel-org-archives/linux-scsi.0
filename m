From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCSI] hptiop: Support HighPoint RR36xx HBAs and Support
 SAS tape and SAS media changer
Date: Thu, 30 Jul 2015 13:10:10 -0700
Message-ID: <1438287010.2229.74.camel@HansenPartnership.com>
References: <004e01d0ae2f$a44e3870$eceaa950$@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35627 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbbG3UKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2015 16:10:13 -0400
In-Reply-To: <004e01d0ae2f$a44e3870$eceaa950$@highpoint-tech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux <linux@highpoint-tech.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2015-06-24 at 11:41 +0800, linux wrote:
> Support HighPoint RR36xx HBAs which are based on Marvell Frey.
> Support SAS tape and SAS media changer.
> 
> Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
> 
>  drivers/scsi/hptiop.c |  104
> +++++++++++++++++++++++++++++++++++++++------------------------
>  drivers/scsi/hptiop.h |    6 +--
>  2 files changed, 69 insertions(+), 41 deletions(-)
> 
> diff -urN linux.git/drivers/scsi/hptiop.c linux/drivers/scsi/hptiop.c
> --- linux.git/drivers/scsi/hptiop.c	2015-06-08 01:48:38.093750000 -0400
> +++ linux/drivers/scsi/hptiop.c	2015-06-08 02:45:33.234375000 -0400
> @@ -1,6 +1,6 @@
>  /*
>   * HighPoint RR3xxx/4xxx controller driver for Linux
> - * Copyright (C) 2006-2012 HighPoint Technologies, Inc. All Rights
> Reserved.

This patch won't apply.  Your email tool has broken the lines which
damage the patch.

Can you resend either preferentially from an email tool which doesn't do
linebreaks or as an attachment?

Thanks,

James

> + * Copyright (C) 2006-2015 HighPoint Technologies, Inc. All Rights
> Reserved.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -42,7 +42,7 @@
>  
>  static char driver_name[] = "hptiop";
>  static const char driver_name_long[] = "RocketRAID 3xxx/4xxx Controller
> driver";
> -static const char driver_ver[] = "v1.8";
> +static const char driver_ver[] = "v1.10.0";
>  
>  static int iop_send_sync_msg(struct hptiop_hba *hba, u32 msg, u32
> millisec);
>  static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
> @@ -764,9 +764,7 @@
>  		scsi_set_resid(scp,
>  			scsi_bufflen(scp) -
> le32_to_cpu(req->dataxfer_length));
>  		scp->result = SAM_STAT_CHECK_CONDITION;
> -		memcpy(scp->sense_buffer, &req->sg_list,
> -				min_t(size_t, SCSI_SENSE_BUFFERSIZE,
> -					le32_to_cpu(req->dataxfer_length)));
> +		memcpy(scp->sense_buffer, &req->sg_list,
> SCSI_SENSE_BUFFERSIZE);
>  		goto skip_resid;
>  		break;
>  
> @@ -1036,9 +1034,10 @@
>  			_req->index, _req->req_virt);
>  
>  	scp->result = 0;
> -
> -	if (scp->device->channel || scp->device->lun ||
> -			scp->device->id > hba->max_devices) {
> +	
> +	if (scp->device->channel ||
> +			(scp->device->id > hba->max_devices) ||
> +			((scp->device->id == (hba->max_devices-1)) &&
> scp->device->lun)) {
>  		scp->result = DID_BAD_TARGET << 16;
>  		free_req(hba, _req);
>  		goto cmd_done;
> @@ -1168,6 +1167,14 @@
>  	NULL
>  };
>  
> +static int hptiop_slave_config(struct scsi_device *sdev)
> +{
> +	if (sdev->type == TYPE_TAPE)
> +		blk_queue_max_hw_sectors(sdev->request_queue, 8192);
> +
> +	return 0;
> +}
> +
>  static struct scsi_host_template driver_template = {
>  	.module                     = THIS_MODULE,
>  	.name                       = driver_name,
> @@ -1179,6 +1186,7 @@
>  	.use_clustering             = ENABLE_CLUSTERING,
>  	.proc_name                  = driver_name,
>  	.shost_attrs                = hptiop_attrs,
> +	.slave_configure            = hptiop_slave_config,
>  	.this_id                    = -1,
>  	.change_queue_depth         = hptiop_adjust_disk_queue_depth,
>  };
> @@ -1323,7 +1331,8 @@
>  	}
>  
>  	hba = (struct hptiop_hba *)host->hostdata;
> -
> +	memset(hba, 0, sizeof(struct hptiop_hba));
> +	
>  	hba->ops = iop_ops;
>  	hba->pcidev = pcidev;
>  	hba->host = host;
> @@ -1336,7 +1345,7 @@
>  	init_waitqueue_head(&hba->reset_wq);
>  	init_waitqueue_head(&hba->ioctl_wq);
>  
> -	host->max_lun = 1;
> +	host->max_lun = 128;
>  	host->max_channel = 0;
>  	host->io_port = 0;
>  	host->n_io_port = 0;
> @@ -1428,34 +1437,33 @@
>  	dprintk("req_size=%d, max_requests=%d\n", req_size,
> hba->max_requests);
>  
>  	hba->req_size = req_size;
> -	start_virt = dma_alloc_coherent(&pcidev->dev,
> -				hba->req_size*hba->max_requests + 0x20,
> -				&start_phy, GFP_KERNEL);
> -
> -	if (!start_virt) {
> -		printk(KERN_ERR "scsi%d: fail to alloc request mem\n",
> -					hba->host->host_no);
> -		goto free_request_irq;
> -	}
> -
> -	hba->dma_coherent = start_virt;
> -	hba->dma_coherent_handle = start_phy;
> -
> -	if ((start_phy & 0x1f) != 0) {
> -		offset = ((start_phy + 0x1f) & ~0x1f) - start_phy;
> -		start_phy += offset;
> -		start_virt += offset;
> -	}
> -
>  	hba->req_list = NULL;
> +	
>  	for (i = 0; i < hba->max_requests; i++) {
> +		start_virt = dma_alloc_coherent(&pcidev->dev,
> +					hba->req_size + 0x20,
> +					&start_phy, GFP_KERNEL);
> +
> +		if (!start_virt) {
> +			printk(KERN_ERR "scsi%d: fail to alloc request
> mem\n",
> +						hba->host->host_no);
> +			goto free_request_mem;
> +		}
> +
> +		hba->dma_coherent[i] = start_virt;
> +		hba->dma_coherent_handle[i] = start_phy;
> +
> +		if ((start_phy & 0x1f) != 0) {
> +			offset = ((start_phy + 0x1f) & ~0x1f) - start_phy;
> +			start_phy += offset;
> +			start_virt += offset;
> +		}
> +		
>  		hba->reqs[i].next = NULL;
>  		hba->reqs[i].req_virt = start_virt;
>  		hba->reqs[i].req_shifted_phy = start_phy >> 5;
>  		hba->reqs[i].index = i;
>  		free_req(hba, &hba->reqs[i]);
> -		start_virt = (char *)start_virt + hba->req_size;
> -		start_phy = start_phy + hba->req_size;
>  	}
>  
>  	/* Enable Interrupt and start background task */
> @@ -1474,9 +1482,15 @@
>  	return 0;
>  
>  free_request_mem:
> -	dma_free_coherent(&hba->pcidev->dev,
> -			hba->req_size * hba->max_requests + 0x20,
> -			hba->dma_coherent, hba->dma_coherent_handle);
> +	for (i = 0; i < hba->max_requests; i++) {
> +		if (hba->dma_coherent[i] && hba->dma_coherent_handle[i])
> +			dma_free_coherent(&hba->pcidev->dev,
> +					hba->req_size + 0x20,
> +					hba->dma_coherent[i], 
> +					hba->dma_coherent_handle[i]);
> +		else
> +			break;
> +	}
>  
>  free_request_irq:
>  	free_irq(hba->pcidev->irq, hba);
> @@ -1546,6 +1560,7 @@
>  {
>  	struct Scsi_Host *host = pci_get_drvdata(pcidev);
>  	struct hptiop_hba *hba = (struct hptiop_hba *)host->hostdata;
> +	u32 i;
>  
>  	dprintk("scsi%d: hptiop_remove\n", hba->host->host_no);
>  
> @@ -1555,10 +1570,15 @@
>  
>  	free_irq(hba->pcidev->irq, hba);
>  
> -	dma_free_coherent(&hba->pcidev->dev,
> -			hba->req_size * hba->max_requests + 0x20,
> -			hba->dma_coherent,
> -			hba->dma_coherent_handle);
> +	for (i = 0; i < hba->max_requests; i++) {
> +		if (hba->dma_coherent[i] && hba->dma_coherent_handle[i])
> +			dma_free_coherent(&hba->pcidev->dev,
> +					hba->req_size + 0x20,
> +					hba->dma_coherent[i], 
> +					hba->dma_coherent_handle[i]);
> +		else
> +			break;
> +	}
>  
>  	hba->ops->internal_memfree(hba);
>  
> @@ -1653,6 +1673,14 @@
>  	{ PCI_VDEVICE(TTI, 0x3020), (kernel_ulong_t)&hptiop_mv_ops },
>  	{ PCI_VDEVICE(TTI, 0x4520), (kernel_ulong_t)&hptiop_mvfrey_ops },
>  	{ PCI_VDEVICE(TTI, 0x4522), (kernel_ulong_t)&hptiop_mvfrey_ops },
> +	{ PCI_VDEVICE(TTI, 0x3610), (kernel_ulong_t)&hptiop_mvfrey_ops },
> +	{ PCI_VDEVICE(TTI, 0x3611), (kernel_ulong_t)&hptiop_mvfrey_ops },
> +	{ PCI_VDEVICE(TTI, 0x3620), (kernel_ulong_t)&hptiop_mvfrey_ops },
> +	{ PCI_VDEVICE(TTI, 0x3622), (kernel_ulong_t)&hptiop_mvfrey_ops },
> +	{ PCI_VDEVICE(TTI, 0x3640), (kernel_ulong_t)&hptiop_mvfrey_ops },
> +	{ PCI_VDEVICE(TTI, 0x3660), (kernel_ulong_t)&hptiop_mvfrey_ops },
> +	{ PCI_VDEVICE(TTI, 0x3680), (kernel_ulong_t)&hptiop_mvfrey_ops },
> +	{ PCI_VDEVICE(TTI, 0x3690), (kernel_ulong_t)&hptiop_mvfrey_ops },
>  	{},
>  };
>  
> diff -urN linux.git/drivers/scsi/hptiop.h linux/drivers/scsi/hptiop.h
> --- linux.git/drivers/scsi/hptiop.h	2015-06-08 01:49:36.734375000 -0400
> +++ linux/drivers/scsi/hptiop.h	2015-06-08 02:15:44.421875000 -0400
> @@ -1,6 +1,6 @@
>  /*
>   * HighPoint RR3xxx/4xxx controller driver for Linux
> - * Copyright (C) 2006-2012 HighPoint Technologies, Inc. All Rights
> Reserved.
> + * Copyright (C) 2006-2015 HighPoint Technologies, Inc. All Rights
> Reserved.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -327,8 +327,8 @@
>  	struct hptiop_request reqs[HPTIOP_MAX_REQUESTS];
>  
>  	/* used to free allocated dma area */
> -	void        *dma_coherent;
> -	dma_addr_t  dma_coherent_handle;
> +	void        *dma_coherent[HPTIOP_MAX_REQUESTS];
> +	dma_addr_t  dma_coherent_handle[HPTIOP_MAX_REQUESTS];
>  
>  	atomic_t    reset_count;
>  	atomic_t    resetting;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



