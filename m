From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 16 Mar 2005 09:13:36 -0600
Message-ID: <1110986016.5771.3.camel@mulgrave>
References: <200503160209.j2G29cAf010870@hera.kernel.org>
	 <20050316075839.GC7842@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:9432 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262624AbVCPPNw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 10:13:52 -0500
In-Reply-To: <20050316075839.GC7842@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, g.liakhovetski@gmx.de

On Wed, 2005-03-16 at 08:58 +0100, Jens Axboe wrote:
> Guys, who reviewed this? It looks completely bogus, using kmap() for tha
> entire sg list is just wrong and can deadlock easily. The proper way is
> of course to skip the virtual address requirement and dma map the sg
> array properly.

I suppose ultimately, the responsibility is mine.

The problem with this particular card (at least as I read the comments
in the driver) is that most of the time, it can actually do DMA on its
own.  However, when something unexpected occurs (Like a SCSI device
disconnections), the DMA engine halts and the last pieces of data have
to be read in manually using PIO.

I agree the kmap is inefficient.  The efficient alternative is to do
dma_map_sg() and use kmap_atomic() in the interrupt routine where we do
the PIO cleanup---I'm afraid I just passed on explaining how to do
this ... unless you care to do the honours ?

James


