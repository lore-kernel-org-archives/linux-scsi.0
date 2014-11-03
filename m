From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Mon, 3 Nov 2014 00:25:21 -0800
Message-ID: <20141103082521.GA22628@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E557.3010505@acm.org>
 <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net>
 <20141023084744.GA24965@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402959324A17@G4W3296.americas.hpqcorp.net>
 <20141024064514.GA15654@infradead.org>
 <0b1b37c7fe497160a80a1f5515d01534@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaKCIZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2014 03:25:29 -0500
Content-Disposition: inline
In-Reply-To: <0b1b37c7fe497160a80a1f5515d01534@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Ming Lei <ming.lei@canonical.com>, linux-scsi@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, "Scales, Webb" <webb.scales@hp.com>, "Don Brace (PMC)" <Don.Brace@pmcs.com>

On Mon, Nov 03, 2014 at 01:22:18PM +0530, Kashyap Desai wrote:
> I also used below setting in slave_alloc(), so that first Inquiry command
> received by driver also has valid Tag in (Non-MQ mode).
> 	sdev->tagged_supported = 1
> Without above setting Inquiry command comes with 0xFF. If I see below code
> in scsi_scan.c, it looks like tagged_supported value should be popped by
> after actual value reported from Inquiry command.
> 
>         if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
>             !(*bflags & BLIST_NOTQ))
>                 sdev->tagged_supported = 1;
> 
> Does it means what driver set in slave_alloc is OK to get Inquiry commands
> with valid Tag  ?
> What will happen if Target really does not support Tagged command queue
> and driver overwrite it in slave_alloc ?

I think the right thing here is to better differenciate between
assigning a software tag, and a SCSI tagged command.  That is, we should
assign a request->tag value for every command if we enable host wide
tags, independent of issuing an actual tagged command.

I'll send a series of patches for this ASAP.
