From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Tue, 8 May 2007 18:53:59 +0100
Message-ID: <20070508185359.01a1a18d@the-village.bc.nu>
References: <20070508171710.1ac730cd@the-village.bc.nu>
	<20070508161444.GA4163@kernel.dk>
	<1178642376.3737.36.camel@mulgrave.il.steeleye.com>
	<20070508184256.029cf8a4@the-village.bc.nu>
	<1178646426.3737.59.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [81.2.110.250] ([81.2.110.250]:43167 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S966405AbXEHRuY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 May 2007 13:50:24 -0400
In-Reply-To: <1178646426.3737.59.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

> > Long answer - it doesn't take this path.
> > 
> > Different bug, both want fixing I suspect.
> 
> Actually, it does take this path ... one of the things we've been doing
> in SCSI is slowly eliminating the old direct submission paths in favour
> of sending everything through the correct block layer paths.
> scsi_execute(), which the sr ioctl uses is just such a fixed path ...
> the bug is that it should be bouncing the request but because of an
> oversight (which Mike's patch corrects) it doesn't.

Well if Mike's patch is going in and it fixes this then I'll be more than
happy to withdraw the pending one.

> 
> The ultimate goal is to be able to eliminate the unchecked_isa_dma flag
> entirely and have the block layer (or device mask allocations) fix all
> of this in every ULD.

About time ;)


Alan
