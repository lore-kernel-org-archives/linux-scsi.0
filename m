From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Mon, 17 Nov 2003 01:03:17 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311170054040.2228-100000@poirot.grange>
References: <Pine.LNX.4.44.0311152233110.2142-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:65415 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263215AbTKQAFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2003 19:05:18 -0500
In-Reply-To: <Pine.LNX.4.44.0311152233110.2142-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, garloff@suse.de, gl@dsa-ac.de

On Sat, 15 Nov 2003, Guennadi Liakhovetski wrote:

> several first commands seem to complete fine, but then I get an Oops,
> because dma_map_page is called with direction == DMA_NONE. Below is

Ok, I found where the data_direction is set to DMA_NONE, but I still don't
understand why, and how this is supposed to work. So, in
sd_revalidate_disk() sr_data_direction is initialised by
scsi_allocate_request() to DMA_BIDIRECTIONAL:
                sreq->sr_data_direction = DMA_BIDIRECTIONAL;
, but already in sd_spinup_disk() it is reset to DMA_NONE:
                        SRpnt->sr_data_direction = DMA_NONE;
I haven't found yet how sr_data_direction gets copied to sc_data_direction
(so far it only looks like struct scsi_cmnd is just overlayd on struct
scsi_request, but I may be wrong there... Or is it really so?

Thanks
Guennadi
---
Guennadi Liakhovetski


