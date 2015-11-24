From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Tue, 24 Nov 2015 00:03:01 -0700
Message-ID: <20151124070301.GA23597@obsidianresearch.com>
References: <20151123203712.GB5640@obsidianresearch.com>
 <56537F59.4080708@sandisk.com>
 <20151123212822.GE6062@obsidianresearch.com>
 <56538AFD.9080103@sandisk.com>
 <20151123221806.GA7152@obsidianresearch.com>
 <56539421.9050705@sandisk.com>
 <20151123230659.GA8287@obsidianresearch.com>
 <B24F4DDE-709A-4D2D-8B26-4E83325DBB1A@asomi.com>
 <20151124000011.GA9301@obsidianresearch.com>
 <5653CCF0.7050501@asomi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5653CCF0.7050501-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2015 at 06:35:28PM -0800, Caitlin Bestler wrote:

> Is it possible for an IB HCA to transmit a response on a QP and not
> in that packet or a previous packet acknowledge something that it
> has delivered to the user?

AFAIK, the rules of ack coalescing do not interact with the send
side. Even if they did, that is the wrong place to look at.

We must look at the receiver. Ordered ack,data on the wire may suffer
a packet loss and the ack may not reach the reciever. In this case can
the reciever detect the lost ack and not progress the data? For IB, it
cannot. The ack sequencing is part of the transmitters recv FSM, and
does not interact with the send FSM.

I feel this a deliberate IB design choice to be simple and efficient
in hardware.

> My recollection of the IB verbs is that they were unlikely to have
> overlooked something like that. If it did slip through then there
> should be an errata.

verbs reflects the wire protocol and the wire protocol has no way to
create a linkage between the send and recv sides of a RC QP. It is not
a spec bug, there is no errata.

> But regardless of specification lawyering, is this an implementation
> issue.

All IB implementations have no choice but to act this way - the wire
protocol provides no way to guarentee ack vs data sequencing at the
receiver, so there is simply no way to guarentee the sendq advances
strictly causally with the recvq.

> Are there actual HCAs that make this mistake?

All IB HCAs have this behavior and require apps to see a send CQ
completion before making any statements about the state of the send Q
or buffers handed over to the HCA. Tom and I have seen this in real
systems under proper stress conditions. [Which is why I am so certain
about this, because when I first hit it years ago I dug into the spec
and figured out it was not a HW bug I was looking at]

This is a direct consequence of how IB runs the ACK protocol.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
