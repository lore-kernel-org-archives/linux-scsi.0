From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 15:18:06 -0700
Message-ID: <20151123221806.GA7152@obsidianresearch.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
 <20151113182513.GB21808@obsidianresearch.com>
 <564640C4.3000603@sandisk.com>
 <20151113220636.GA32133@obsidianresearch.com>
 <20151114071344.GE27738@lst.de>
 <20151123203712.GB5640@obsidianresearch.com>
 <56537F59.4080708@sandisk.com>
 <20151123212822.GE6062@obsidianresearch.com>
 <56538AFD.9080103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56538AFD.9080103@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sagig@dev.mellanox.co.il" <sagig@dev.mellanox.co.il>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2015 at 01:54:05PM -0800, Bart Van Assche wrote:

> Not really ... Please have a look at the SRP initiator source code. What the
> SRP initiator does is to poll the send queue before sending a new
> SCSI

I see that. What I don't see is how SRP handles things when the
sendq fills up, ie the case where __srp_get_tx_iu() == NULL. It looks
like the driver starts to panic and generates printks. I can't tell if
it can survive that, but it doesn't look very good..

It would be a lot better if this wasn't allowed to happen, the polling
loop can run until a sendq becomes available, and never return null
from __srp_get_tx_iu().

Ie, __srp_get_tx_iu should look more like

   ib_poll_cq_until(..., !list_empty(&ch->free_tx));

Which would be a fairly sane core API for this direct usage.. Ideally
the core code would sleep if possible and not just spin. Maybe also
protect it with a timer.

> command to the target system starts. I think this approach could also be
> used in other ULP drivers if the send queue poll frequency is such that no
> send queue overflow occurs.

Yes, I agree, but it has to be done properly :)

Jason
