From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Tue, 08 May 2007 12:47:06 -0500
Message-ID: <1178646426.3737.59.camel@mulgrave.il.steeleye.com>
References: <20070508171710.1ac730cd@the-village.bc.nu>
	 <20070508161444.GA4163@kernel.dk>
	 <1178642376.3737.36.camel@mulgrave.il.steeleye.com>
	 <20070508184256.029cf8a4@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54546 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966878AbXEHRrK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 13:47:10 -0400
In-Reply-To: <20070508184256.029cf8a4@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 18:42 +0100, Alan Cox wrote:
> > Mike Christie tells me we're missing bouncing by accident in the
> > scsi_execute path (but not the scsi_execute_async path).  He says this
> > is the fix he proposed:
> > 
> > http://marc.info/?l=linux-scsi&m=115981479822790&w=2
> > 
> > Can we just merge this instead?
> 
> Short answer: No
> 
> Long answer - it doesn't take this path.
> 
> Different bug, both want fixing I suspect.

Actually, it does take this path ... one of the things we've been doing
in SCSI is slowly eliminating the old direct submission paths in favour
of sending everything through the correct block layer paths.
scsi_execute(), which the sr ioctl uses is just such a fixed path ...
the bug is that it should be bouncing the request but because of an
oversight (which Mike's patch corrects) it doesn't.

The ultimate goal is to be able to eliminate the unchecked_isa_dma flag
entirely and have the block layer (or device mask allocations) fix all
of this in every ULD.

James


