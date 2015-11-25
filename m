From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Tue, 24 Nov 2015 23:21:13 -0700
Message-ID: <20151125062113.GA29187@obsidianresearch.com>
References: <20151124100839.48b52fb35c6f209c51bccbb9807b6df0.f113bf890f.wbe@email24.secureserver.net>
 <20151124175226.GA10391@obsidianresearch.com>
 <56552132.7090701@asomi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56552132.7090701-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 24, 2015 at 06:47:14PM -0800, Caitlin Bestler wrote:
>         Acknowledge packet for the last packet of the request has been
>         committed to the wire (including the appropriate fields for RDMA
>         READ response).

> The target side cannot generate a response before it receives the request.
> The target side verbs cannot generate the completion before the acknowledge
> packet has been
> committed to the wire.

Sure, but, I keep saying this, the responder behavior is largely
irrelevant to what the target is able/required to do.

> Therefore the initiating side cannot receive a response before the write
> operation has completed.

Wrong. The ladder diagram would be

Requestor          Responder           Responder Verbs

SEND1 ----------->   Process
         X---------  ACK (lost)
	                     --------> recv1 CQ
			     <-------   send2 WQE
recv2 CQE <--------  SEND2 Packet
[..]
send1 CQE <--------  ACK (resent)

The Ack may be lost, causing the send CQE to arrive after the recv
CQE, even though the responder did everything in a specific order.

The fundamental issue is that the responder cannot detect the lost
ACK. The PSN of the ACK packet is part of the Requestor's PSN space,
not part of the Responders:

 9.7.5.1.1 GENERATING PSNs FOR ACKNOWLEDGE MESSAGES

 C9-95: For responses to SEND requests or RDMA WRITE requests the
  responder shall insert in the PSN field of the response the PSN of the
  most recent request packet being acknowledged.

Or stated another way, the value of the AckReq bit in SEND1 has no
impact on the contents of the SEND2 packet - thus there is no way for
the requestor to detect the loss of the ACK and hold off delivering
recv2 CQE.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
