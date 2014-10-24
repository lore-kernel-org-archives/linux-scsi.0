From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Thu, 23 Oct 2014 23:45:14 -0700
Message-ID: <20141024064514.GA15654@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E557.3010505@acm.org>
 <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net>
 <20141023084744.GA24965@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402959324A17@G4W3296.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJXGpc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2014 02:45:32 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402959324A17@G4W3296.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, "Scales, Webb" <webb.scales@hp.com>, "Don Brace (PMC)" <Don.Brace@pmcs.com>

On Fri, Oct 24, 2014 at 04:43:15AM +0000, Elliott, Robert (Server Storage) wrote:
> However, it was looking at scmd->tag, which is always 0xff (at 
> least in those early discovery commands).  scmd->request->tag 
> looks like it is the field that has the correct values.
> 
> Also, I noticed that scmd->tag is just an 8 bit field, so
> it could never represent a large number of tags.

Yes, we need to get rid of scmd->tag.  Hannes had a patchset to get
started on it, and I hope either he or someone else will have time to
get back to it ASAP.

> Just to confirm: After calling scsi_init_shared_tag_map()
> in non-mq mode, will scmd->request->tag be based on 
> controller-wide tag allocation (never using the same
> value at the same time for the request queues of multiple
> devices in that controller)?

Yes.
