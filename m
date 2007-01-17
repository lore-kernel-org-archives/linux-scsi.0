From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libata: initialize qc->dma_dir to DMA_NONE
Date: Wed, 17 Jan 2007 09:19:13 -0600
Message-ID: <1169047153.3416.5.camel@mulgrave.il.steeleye.com>
References: <45AD50AD.2040700@linux.vnet.ibm.com>
	 <20070116224115.50d29cf7@localhost.localdomain> <45AD55A4.50208@pobox.com>
	 <1168989094.2789.20.camel@mulgrave.il.steeleye.com>
	 <45AD5D27.8020004@linux.vnet.ibm.com> <45AD60B9.3030501@linux.vnet.ibm.com>
	 <20070117023402.GP10987@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070117023402.GP10987@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, Alan <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-01-17 at 11:34 +0900, Tejun Heo wrote:
> libata didn't used to init qc->dma_dir to any specific value on qc
> initialization and command translation path didn't set qc->dma_dir if
> the command doesn't need data transfer.  This made non-data commands
> to have random qc->dma_dir.
> 
> This usually doesn't cause problem because LLDs usually check
> qc->protocol first and look at qc->dma_dir iff the command needs data
> transfer but this doesn't hold for all LLDs.
> 
> It might be worthwhile to rename qc->dma_dir to qc->data_dir as we use
> the field to tag data direction for both PIO and DMA protocols.
> 
> This problem has been spotted by James Bottomley.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: James Bottomley <James.Bottomley@SteelEye.com>

This looks perfectly fine as a possible solution.  Is there any reason
not to initialise qc->dma_dir unconditionally from the SCSI command?
The only potential problem is DMA_BIDIRECTIONAL, which we don't use
(yet) ... but if it ever did come down libata will do the wrong thing
anyway.

James


