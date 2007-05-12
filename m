From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Sat, 12 May 2007 11:12:44 +0200
Message-ID: <20070512091244.GA7981@osiris.boeblingen.de.ibm.com>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:58724 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbXELJNX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 05:13:23 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate1.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l4C9DMWt166454
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2007 09:13:22 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4C9DMNp2773034
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2007 10:13:22 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4C8Bx1U000368
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2007 09:11:59 +0100
Content-Disposition: inline
In-Reply-To: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, May 11, 2007 at 01:33:41PM -0500, James Bottomley wrote:
> It strikes me that in all of this, we could also consider doing the DMA
> mapping inside the mid layer (instead of in every driver).  This is
> essentially what libata is already doing ... leading to confusion in
> SCSI drivers that use libata for SATA.
> 
> So what do people think about this?

I hope that doesn't mean that each architecture is required to
implement all the DMA mapping stuff? s390 doesn't have any support
for DMA at all. The current workaround seems to be to sprinkle
a lot of BUG() statements in code that simply won't work on such
architectures but still compile it in.
Lately I introduced CONFIG_HAS_DMA and made building
drivers/base/dma-mapping.o and dmapool.o depend on that,
so we don't compile all the non working stuff on s390. Hope
all that can be sorted out if you go that direction.
