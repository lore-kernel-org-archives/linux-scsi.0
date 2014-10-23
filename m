From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Thu, 23 Oct 2014 01:47:44 -0700
Message-ID: <20141023084744.GA24965@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E557.3010505@acm.org>
 <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51524 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaJWIrt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 04:47:49 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, "Scales, Webb" <webb.scales@hp.com>, "Don Brace (PMC)" <Don.Brace@pmcs.com>

On Wed, Oct 22, 2014 at 10:03:24PM +0000, Elliott, Robert (Server Storage) wrote:
> Have you tested this with scsi_mod.use_blk_mq=n?
> 
> Trying similar changes in hpsa, we still receive some INQUIRY commands 
> submitted through queuecommand with tag -1.  They are for devices for
> which slave_alloc has not yet been run, implying this work needs to 
> be done even earlier.  Maybe the midlayer is missing a slave_alloc
> call somewhere?

Did that version of hpsa really enable tagging in slave_alloc
or just in slave_configure?  The latter would cause INQUIRY to be
sent untagged.
