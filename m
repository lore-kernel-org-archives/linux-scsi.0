From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 09:30:40 -0700
Message-ID: <20140624163040.GA11499@infradead.org>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
 <1402477799-24610-2-git-send-email-sagig@mellanox.com>
 <53A920B2.9060503@cs.wisc.edu>
 <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
 <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
 <53A9A702.8050503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53A9A702.8050503@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Michael Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 24, 2014 at 07:27:46PM +0300, Sagi Grimberg wrote:
> This condition only matters in the bidi case, which is not relevant for the
> PI case.
> I suggested to condition that in libiscsi (posted in the second thread,
> copy-paste below).
> Although I do agree that scsi_transfer_length() helper is not really just
> for PI and not more.
> I think Mike's way is cleaner.

But for bidi there are two transfers.  So either scsi_transfer_length()
needs to take the scsi_data_buffer, or we need to avoid using it.

For 3.16 I'd prefer something like you're patch below.  This patch which
has been rushed in last minute and not through the scsi tree has already
causes enough harm.  If you can come up with a clean version to
transparently handle the bidi case I'd be happy to pick that up for
3.17.

In the meantime please provide a version of the patch below with a
proper description and signoff.
