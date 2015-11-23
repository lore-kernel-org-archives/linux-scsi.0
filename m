From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 16:06:59 -0700
Message-ID: <20151123230659.GA8287@obsidianresearch.com>
References: <20151113182513.GB21808@obsidianresearch.com>
 <564640C4.3000603@sandisk.com>
 <20151113220636.GA32133@obsidianresearch.com>
 <20151114071344.GE27738@lst.de>
 <20151123203712.GB5640@obsidianresearch.com>
 <56537F59.4080708@sandisk.com>
 <20151123212822.GE6062@obsidianresearch.com>
 <56538AFD.9080103@sandisk.com>
 <20151123221806.GA7152@obsidianresearch.com>
 <56539421.9050705@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56539421.9050705@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sagig@dev.mellanox.co.il" <sagig@dev.mellanox.co.il>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2015 at 02:33:05PM -0800, Bart Van Assche wrote:
> On 11/23/2015 02:18 PM, Jason Gunthorpe wrote:
> >On Mon, Nov 23, 2015 at 01:54:05PM -0800, Bart Van Assche wrote:
> >What I don't see is how SRP handles things when the
> >sendq fills up, ie the case where __srp_get_tx_iu() == NULL. It looks
> >like the driver starts to panic and generates printks. I can't tell if
> >it can survive that, but it doesn't look very good..
> 
> Hello Jason,
> 
> From srp_cm_rep_handler():
> 
> 		target->scsi_host->can_queue
> 			= min(ch->req_lim - SRP_TSK_MGMT_SQ_SIZE,
> 			      target->scsi_host->can_queue);
> 
> In other words, the SCSI core is told to ensure that the number of
> outstanding SCSI commands is one less than the number of elements in the
> ch->free_tx list. And since the SRP initiator serializes task management
> requests it is guaranteed that __srp_get_tx_iu() won't fail due to
> ch->free_tx being empty.

I realize that, and as I already explained, SRP cannot drive the sendq
flow control from the recv side.

The SCSI core considers the command complete and will issue a new
command as soon as the recv completion associated with the command is
returned. (ie when the remote responds)

This *DOES NOT* say anything about the state of the sendq, it does not
guarantee there is send CQ entry available for the associated send, it
does not guarantee there is available space in the sendq. Verbs DOES
NOT make ordering guarentees between queues, even if the queues are
causally related.

This is an important point in verbs and it is commonly done wrong.

So, yes, __srp_get_tx_iu absolutely can fail due to ch->free_tx being
empty, even though by observing the recv side SRP has inferred that
the sendq should have space.

Every ULP has to cope with this, and a direct poll API that doesn't
account for the need to block on a predicate is broken by design.
This is why I object.

'ib_poll_cq_until' would correct all of this.

Jason
