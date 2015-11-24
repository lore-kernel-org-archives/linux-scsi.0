From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 17:00:11 -0700
Message-ID: <20151124000011.GA9301@obsidianresearch.com>
References: <20151113220636.GA32133@obsidianresearch.com>
 <20151114071344.GE27738@lst.de>
 <20151123203712.GB5640@obsidianresearch.com>
 <56537F59.4080708@sandisk.com>
 <20151123212822.GE6062@obsidianresearch.com>
 <56538AFD.9080103@sandisk.com>
 <20151123221806.GA7152@obsidianresearch.com>
 <56539421.9050705@sandisk.com>
 <20151123230659.GA8287@obsidianresearch.com>
 <B24F4DDE-709A-4D2D-8B26-4E83325DBB1A@asomi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B24F4DDE-709A-4D2D-8B26-4E83325DBB1A@asomi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Caitlin Bestler <cait@asomi.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sagig@dev.mellanox.co.il" <sagig@dev.mellanox.co.il>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2015 at 03:30:42PM -0800, Caitlin Bestler wrote:
>    The receive completion can be safely assumed to indicate transmit
>    completion over a reliable connection unless your peer has gone
>    completely bonkers and is replying to a command that it did not
>    receive.

Perhaps iWarp is different and does specify this ordering but IB does
not.

The issue with IB is how the ACK protocol is designed. There is not
strong ordering between ACKs and data transfers. A HCA can send
ACK,DATA and the network could drop the ACK. The recevier side does
not know the ACK was lost and goes ahead to process DATA.

Since only ACK advances the sendq and DATA advances the recvq it is
trivial to get a case where the recvq is advanced with a reply while
the sendq continues to wait for the ACK to be resent.

Further IB allows ACK coalescing and has no rules for how an ACK is
placed. It is entirely valid for a HCA to RECV,REPLY,ACK - for
instance.

>    I actually had a bug in an early iWARP emulation where the simulated
>    peer, because it was simulated, responded
>    instantly. The result was a TCP segment that both acked the
>    transmission *and* contained the reply. The bug was
>    that the code processed the reception before the transmission ack,
>    causing the receive completion to be placed
>    on the completion queue before transmit completion.

I don't know if iWARP has the same lax ordering as IB, but certainly,
what you describe is legal for IB verbs to do, and our kernel ULPs
have to cope with it.

Jason
