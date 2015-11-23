From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 14:28:22 -0700
Message-ID: <20151123212822.GE6062@obsidianresearch.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
 <20151113182513.GB21808@obsidianresearch.com>
 <564640C4.3000603@sandisk.com>
 <20151113220636.GA32133@obsidianresearch.com>
 <20151114071344.GE27738@lst.de>
 <20151123203712.GB5640@obsidianresearch.com>
 <56537F59.4080708@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56537F59.4080708@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2015 at 01:04:25PM -0800, Bart Van Assche wrote:

> Considerable time ago the send queue in the SRP initiator driver was
> modified from signaled to non-signaled to reduce the number of interrupts
> triggered by the SRP initiator driver. The SRP initiator driver polls the
> send queue every time before a SCSI command is sent to the target. I think
> this is a pattern that is also useful for other ULP's so I'm not convinced
> that ib_process_cq_direct() should be deprecated :-)

As I explained, that is a fine idea, but I can't see how SRP is able
to correctly do sendq flow control without spinning on the poll, which
it does not do.

I'm guessing SRP is trying to drive sendq flow control from the recv
side, like NFS was. This is wrong and should not be part of the common
API.

Does that make sense?

Jason
