From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Initio 9100u -- Mike Christie's 2.6.0-test11 Patch -- Kernel
	Errors
Date: 21 Dec 2003 09:46:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072021603.1952.10.camel@mulgrave>
References: <Pine.LNX.4.44.0312190311160.27880-200000@dyn319634.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:49329 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263639AbTLUPrF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Dec 2003 10:47:05 -0500
In-Reply-To: <Pine.LNX.4.44.0312190311160.27880-200000@dyn319634.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: James Daniel <jdaniel@dakotacom.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-12-19 at 05:15, Mike Christie wrote:
> Here is another try. It should compile against 2.6.0-test11/2.6.0.

That's great thanks.  I've put it in the scsi tree.

I did notice in the diffs between this one and the previous patch things
like:


-			pSG->SG_Ptr = cpu_to_le32((u32)sg_dma_address(pSrbSG));
-			TotalLen += pSG->SG_Len = cpu_to_le32((u32)sg_dma_len(pSrbSG));
+			pSG->SG_Ptr = (u32)sg_dma_address(pSrbSG);
+			TotalLen += pSG->SG_Len = (u32)sg_dma_len(pSrbSG);

Which is obviously incorrect, since sg_dma_address() does return the
address in CPU endianness (and the device SG list needs to be in PCI
endiannes), but I think, since it was hard enough to find anyone with
one of these things, that the chances of finding one on a non-x86 box
are zero.

James



