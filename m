From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/7]MVSAS:Optimization for DMA buffer
Date: Sat, 14 Nov 2009 11:41:01 -0600
Message-ID: <1258220461.4070.7.camel@mulgrave.site>
References: <20091109121952.GD32336@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZKNRlF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Nov 2009 12:41:05 -0500
In-Reply-To: <20091109121952.GD32336@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, qswang@marvell.com, jfeng@marvell.com

On Mon, 2009-11-09 at 20:19 +0800, Andy Yan wrote:
> -       if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
> -               rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> +       if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
> +               rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);

So I might not agree with the people who pointlessly churn our
interfaces while adding no value but the old form now warns, so you
can't just revert this change any more:

drivers/scsi/mvsas/mv_init.c: In function 'pci_go_64':
drivers/scsi/mvsas/mv_init.c:460: warning: 'DMA_nnBIT_MASK' is deprecated
drivers/scsi/mvsas/mv_init.c:461: warning: 'DMA_nnBIT_MASK' is deprecated
drivers/scsi/mvsas/mv_init.c:463: warning: 'DMA_nnBIT_MASK' is deprecated
drivers/scsi/mvsas/mv_init.c:471: warning: 'DMA_nnBIT_MASK' is deprecated
drivers/scsi/mvsas/mv_init.c:477: warning: 'DMA_nnBIT_MASK' is deprecated

Please remove this reversion from the diff.

Thanks,

James


