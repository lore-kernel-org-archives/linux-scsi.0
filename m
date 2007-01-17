From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: initialize qc->dma_dir to DMA_NONE
Date: Thu, 18 Jan 2007 00:49:29 +0900
Message-ID: <45AE4589.4070309@gmail.com>
References: <45AD50AD.2040700@linux.vnet.ibm.com>	 <20070116224115.50d29cf7@localhost.localdomain> <45AD55A4.50208@pobox.com>	 <1168989094.2789.20.camel@mulgrave.il.steeleye.com>	 <45AD5D27.8020004@linux.vnet.ibm.com> <45AD60B9.3030501@linux.vnet.ibm.com>	 <20070117023402.GP10987@htj.dyndns.org> <1169047153.3416.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1169047153.3416.5.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, Alan <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> This looks perfectly fine as a possible solution.  Is there any reason
> not to initialise qc->dma_dir unconditionally from the SCSI command?

That should work too.  I did what I did because it was more in line with
what the current code assumed and initializing the field on qc alloc
seemed like a good idea with or without unconditional qc->dma_dir =
scmd->sc_data_direction because not all commands are translated from
scsi command.

> The only potential problem is DMA_BIDIRECTIONAL, which we don't use
> (yet) ... but if it ever did come down libata will do the wrong thing
> anyway.

If that ever happens, libata probably should emulate it using multiple
commands, I guess.

Thanks.

-- 
tejun
