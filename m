From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: 14 Mar 2004 10:31:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079278279.2022.34.camel@mulgrave>
References: <20040314082444.GA3416@linux.local.home>
	<1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de>
	<1079276396.2022.8.camel@mulgrave>  <20040314151809.GG19737@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:9874 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263376AbUCNPbb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 10:31:31 -0500
In-Reply-To: <20040314151809.GG19737@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-03-14 at 10:18, Anton Blanchard wrote:
> With 2.6.3 on a ppc64 box connected to a shark with 8 LUNs I could
> easily consume all the request slots on the card. At this point we spent
> > 50% of the cpu bouncing into qla2x00_start_scsi, doing a pci_map_sg
> realising it wont fit and doing a pci_unmap_sg.

Well, since the pool is fixed size, can't the driver do some rule of
thumb check before it actually gets to the map_sg (perhaps even
pre-reserve the slots before mapping)?

> As Andrew points out, the driver shouldnt be doing this constant
> map/unmap stuff, but is there some way for a scsi device driver to tell
> the layers above it to temporarily leave it alone?

Mappings can be very limited in certain machines.  I really don't think
we want precious mapping resources sitting in an issue queue in the
mid-layer just because the qla driver couldn't manage them efficiently.

The layering rules say that the driver is responsible for getting the
IOMMU resources with dma_map_sg before it places the I/O in-flight and
should free them ASAP after the I/O returns.

All drivers have to manage their issue slots efficiently.  It really
sounds like the root cause of this problem is mapping too early.

If you think you don't know how many resource slots you'll need, that's
in scsi_cmnd->request->nr_hw_segments (give or take, this is always
guaranteed to be at or over the actual number dma_map_sg eventually
returns).  So: fix the qlogic mapping routines.

James


