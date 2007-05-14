From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/19] ipr: convert to use the data buffer accessors
Date: Tue, 15 May 2007 07:37:38 +0900
Message-ID: <20070515073738I.fujita.tomonori@lab.ntt.co.jp>
References: <20070512182921I.fujita.tomonori@lab.ntt.co.jp>
	<46487FF0.7030502@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:58157 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbXENWho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 18:37:44 -0400
In-Reply-To: <46487FF0.7030502@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/19] ipr: convert to use the data buffer accessors
Date: Mon, 14 May 2007 10:27:44 -0500

> FUJITA Tomonori wrote:
> > @@ -550,12 +550,7 @@ struct ipr_cmnd *ipr_get_free_ipr_cmnd(s
> >  static void ipr_unmap_sglist(struct ipr_ioa_cfg *ioa_cfg,
> >  			     struct ipr_cmnd *ipr_cmd)
> >  {
> > -	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
> > -
> > -	if (ipr_cmd->dma_use_sg)
> > -		pci_unmap_sg(ioa_cfg->pdev, scsi_cmd->request_buffer,
> > -			     scsi_cmd->use_sg,
> > -			     scsi_cmd->sc_data_direction);
> > +	scsi_dma_unmap(&ioa_cfg->pdev->dev, ipr_cmd->scsi_cmd);
> >  }
> 
> You can completely do away with ipr_unmap_sglist and just call
> scsi_dma_unmap directly instead.

I see. I'll update the patch.

Thanks.
