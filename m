From: Anton Blanchard <anton@samba.org>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Tue, 16 Mar 2004 22:32:56 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040316113256.GT19737@krispykreme>
References: <B179AE41C1147041AA1121F44614F0B0598FC6@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:10155 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S261427AbUCPLiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 06:38:22 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598FC6@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

 
Hi,

> Ideally, no we don't want to do this...how about sending down larger
> individual SG entries, the ISP only limits the total transfer of a
> command to 2^32-1 bytes ;)

Many architectures with IOMMUs do virtual merging, so you will get
much larger individual SG entries on those architectures. On ppc64 its
now an option, IOMMU_VMERGE.

Virtual merging is another reason to remove the 32 SG limit. On ppc64 we
dont use the BIO_VMERGE_BOUNDARY trick (its there to allow early
estimation of how an sglist can be merged). We do this because in the
time between the estimation and the actual allocation the IOMMU space
may have become too fragmented for the allocation to succeeed.

Instead we do all the merging at pci_map_sg time which means we can fall 
back to not merging at all when the IOMMU space becomes fragmented.
Unfortunately with the 32 SG change we will be limited to requests of
PAGE_SIZE*32.

> Since the driver specifies SG_ALL for the sg_tablesize, from testing
> (x86 and ppc64), we've seen at most 128 SG entries attached to a
> command request of 512K bytes (4K page size * 128).  

Yep, we are limited by the maximum size of the scsi SG list of 128
entries. James merged a patch recently that allows us to play with
larger sizes (eg 256 entries), check out SCSI_MAX_PHYS_SEGMENTS and
MAX_PHYS_SEGMENTS.

> from queuecommand().  The 8.x series driver inherited alot of the
> queuing baggage created during driver development of [567].x to
> address some deficiecies of earlier midlayer implementations (all of
> which have been addressed in recent kernels).  I'll start to take a
> look at tearing out the pending_q.

Yeah that solution sounds promising.

Anton
