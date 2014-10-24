From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Fri, 24 Oct 2014 04:43:15 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959324A17@G4W3296.americas.hpqcorp.net>
References: <5433E43D.3010107@acm.org> <5433E557.3010505@acm.org>
 <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net>
 <20141023084744.GA24965@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:16888 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJXEq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2014 00:46:29 -0400
In-Reply-To: <20141023084744.GA24965@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, "Scales, Webb" <webb.scales@hp.com>, "Don Brace (PMC)" <Don.Brace@pmcs.com>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, October 23, 2014 3:48 AM
> To: Elliott, Robert (Server Storage)
> Cc: Bart Van Assche; Jens Axboe; Sagi Grimberg; Sebastian Parschauer;
> Ming Lei; linux-scsi@vger.kernel.org; linux-rdma; Scales, Webb; Don
> Brace (PMC)
> Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
> 
> On Wed, Oct 22, 2014 at 10:03:24PM +0000, Elliott, Robert (Server
> Storage) wrote:
> > Have you tested this with scsi_mod.use_blk_mq=n?
> >
> > Trying similar changes in hpsa, we still receive some INQUIRY commands
> > submitted through queuecommand with tag -1.  They are for devices for
> > which slave_alloc has not yet been run, implying this work needs to
> > be done even earlier.  Maybe the midlayer is missing a slave_alloc
> > call somewhere?
> 
> Did that version of hpsa really enable tagging in slave_alloc
> or just in slave_configure?  The latter would cause INQUIRY to be
> sent untagged.

Yes, it is slave_alloc, not slave_configure.  

However, it was looking at scmd->tag, which is always 0xff (at 
least in those early discovery commands).  scmd->request->tag 
looks like it is the field that has the correct values.

Also, I noticed that scmd->tag is just an 8 bit field, so
it could never represent a large number of tags.

Just to confirm: After calling scsi_init_shared_tag_map()
in non-mq mode, will scmd->request->tag be based on 
controller-wide tag allocation (never using the same
value at the same time for the request queues of multiple
devices in that controller)?


