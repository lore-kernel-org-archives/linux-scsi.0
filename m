From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libata: initialize qc->dma_dir to DMA_NONE
Date: Wed, 17 Jan 2007 10:07:20 -0600
Message-ID: <1169050040.3416.14.camel@mulgrave.il.steeleye.com>
References: <45AD50AD.2040700@linux.vnet.ibm.com>
	 <20070116224115.50d29cf7@localhost.localdomain> <45AD55A4.50208@pobox.com>
	 <1168989094.2789.20.camel@mulgrave.il.steeleye.com>
	 <45AD5D27.8020004@linux.vnet.ibm.com> <45AD60B9.3030501@linux.vnet.ibm.com>
	 <20070117023402.GP10987@htj.dyndns.org>
	 <1169047153.3416.5.camel@mulgrave.il.steeleye.com>
	 <45AE4589.4070309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60430 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932545AbXAQQNt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2007 11:13:49 -0500
In-Reply-To: <45AE4589.4070309@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, Alan <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

On Thu, 2007-01-18 at 00:49 +0900, Tejun Heo wrote:
> James Bottomley wrote:
> > This looks perfectly fine as a possible solution.  Is there any reason
> > not to initialise qc->dma_dir unconditionally from the SCSI command?
> 
> That should work too.  I did what I did because it was more in line with
> what the current code assumed and initializing the field on qc alloc
> seemed like a good idea with or without unconditional qc->dma_dir =
> scmd->sc_data_direction because not all commands are translated from
> scsi command.

Sure, I agree with the initialisation (although it should perhaps be
initialised to an error value we can detect just in case there are other
paths where it would leak through uninitialised ... we'll still get
cockups if a command with data ever goes through as DMA_NONE.

> > The only potential problem is DMA_BIDIRECTIONAL, which we don't use
> > (yet) ... but if it ever did come down libata will do the wrong thing
> > anyway.
> 
> If that ever happens, libata probably should emulate it using multiple
> commands, I guess.

This really depends on where SATA is going.  Current SCSI bidirectional
commands are the preserve of the complex command sets I don't believe
even a SATA device would ever emulate.  On the other hand, we're
planning to use bidirectional in SGv4 for frame in/frame out type
packets that are used to control expanders.

So the interesting question is whether SATA would ever want to drive
expanders?  For the low end, given the lack of success of the port
multipliers which are effectively a poor man's expander, I guess not ...
but, since most SAS/SATA cages seem to be coming with built in
expanders, I can see that changing.

James


