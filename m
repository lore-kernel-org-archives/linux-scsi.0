From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/19] ipr: convert to use the data buffer accessors
Date: Mon, 14 May 2007 10:27:44 -0500
Message-ID: <46487FF0.7030502@linux.vnet.ibm.com>
References: <20070512182921I.fujita.tomonori@lab.ntt.co.jp>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49390 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbXENP1z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 11:27:55 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l4EFOIEd019827
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 11:24:18 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4EFRpYA067784
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 09:27:51 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4EFRo5c013846
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 09:27:50 -0600
In-Reply-To: <20070512182921I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

FUJITA Tomonori wrote:
> @@ -550,12 +550,7 @@ struct ipr_cmnd *ipr_get_free_ipr_cmnd(s
>  static void ipr_unmap_sglist(struct ipr_ioa_cfg *ioa_cfg,
>  			     struct ipr_cmnd *ipr_cmd)
>  {
> -	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
> -
> -	if (ipr_cmd->dma_use_sg)
> -		pci_unmap_sg(ioa_cfg->pdev, scsi_cmd->request_buffer,
> -			     scsi_cmd->use_sg,
> -			     scsi_cmd->sc_data_direction);
> +	scsi_dma_unmap(&ioa_cfg->pdev->dev, ipr_cmd->scsi_cmd);
>  }

You can completely do away with ipr_unmap_sglist and just call
scsi_dma_unmap directly instead.

Thanks,

Brian
