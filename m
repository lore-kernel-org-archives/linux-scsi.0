From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Mon, 17 Nov 2003 13:41:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031117134140.169587af.rddunlap@osdl.org>
References: <Pine.LNX.4.44.0311152233110.2142-100000@poirot.grange>
	<Pine.LNX.4.44.0311170054040.2228-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:51916 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261850AbTKQVrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 16:47:21 -0500
In-Reply-To: <Pine.LNX.4.44.0311170054040.2228-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, garloff@suse.de, gl@dsa-ac.de

On Mon, 17 Nov 2003 01:03:17 +0100 (CET) Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

| On Sat, 15 Nov 2003, Guennadi Liakhovetski wrote:
| 
| > several first commands seem to complete fine, but then I get an Oops,
| > because dma_map_page is called with direction == DMA_NONE. Below is
| 
| Ok, I found where the data_direction is set to DMA_NONE, but I still don't
| understand why, and how this is supposed to work. So, in
| sd_revalidate_disk() sr_data_direction is initialised by
| scsi_allocate_request() to DMA_BIDIRECTIONAL:
|                 sreq->sr_data_direction = DMA_BIDIRECTIONAL;
| , but already in sd_spinup_disk() it is reset to DMA_NONE:
|                         SRpnt->sr_data_direction = DMA_NONE;

Doing a TEST_UNIT_READY doesn't require any DMA transfers, in the
sense of buffers (i.e., buffer length is 0), so DMA_NONE makes sense,
doesn't it?

| I haven't found yet how sr_data_direction gets copied to sc_data_direction
| (so far it only looks like struct scsi_cmnd is just overlayd on struct
| scsi_request, but I may be wrong there... Or is it really so?

scsi.c::scsi_init_cmd_from_req(), line 504 in 2.6.0-test9 (?),
although I haven't followed the code flow all the way from tmscsim
to that function.

--
~Randy
MOTD:  Always include version info.

PS:  I prefer this on linux-scsi instead of linux-kernel.
