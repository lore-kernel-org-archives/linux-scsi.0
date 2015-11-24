From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Tue, 24 Nov 2015 10:52:26 -0700
Message-ID: <20151124175226.GA10391@obsidianresearch.com>
References: <20151124100839.48b52fb35c6f209c51bccbb9807b6df0.f113bf890f.wbe@email24.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151124100839.48b52fb35c6f209c51bccbb9807b6df0.f113bf890f.wbe-wCzC33v8tqnShzhksYgB+AejPw4fNl8p@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 24, 2015 at 10:08:39AM -0700, cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org wrote:
>    >> My recollection of the IB verbs is that they were unlikely to have
>    >> overlooked something like that. If it did slip through then there
>    >> should be an errata.
>    >verbs reflects the wire protocol and the wire protocol has no way to
>    >create a linkage between the send and recv sides of a RC QP. It is not
>    >a spec bug, there is no errata.
> 
>    No, verbs do not reflect the link layer. Verbs fulfill the contract
>    with the end user - especially when the hardware cannot.

Are you serious? You think verbs should specify things that cannot
actually be implemented? IB verbs doesn't do that.

>    Reporting a completion of a receive without having guaranteed
>    that the acknowledgement will be sent before anything
>    subsequently submitted is failing to implement a reliable
>    connection.

As I've said repeatedly, the side receiving the request has no impact
on this issue. Requiring it to generate an ack before delivering the
recv completion *does nothing* to guarantee ordering on the other
side in IB. The network can always drop the ack, and the receiver
cannot tell.

I disagree that RC has anything to do with this causal ordering issue,
this is not a property described in the IB spec for RC.

>    One of the hardware designs I worked with over a decade ago
>    actually had *two* completion queues, one from the left brain (receive)
>    and the other from the right brain (transmit). Nevertheless we
>    presented

All verbs hardware has to have these two flows.

>    a unified completion queue that followed ordering rules. We were not
>    "reflecting" the hardware, we were implementing an interface in a
>    combination of hardware and software.

And how did you detect lost acks at the reciever to make this an
actual guarentee? Maybe TCP can do this but IB cannot.

I honestly don't know why you think verbs has this requirement. It is
not in the IB spec, and can't be implemented by IB hardware. If
one of the other flavours of verbs has this, then fine, but it is not
part of the *Linux* verbs flavour.

> I cannot think of a reason why that would not work here. Simply do
> not report a completion to the user before guaranteeing that the
> acks will be transmitted.

I've already explained three times why this is not enough for IB.

>    What would you do if the next user action had been to close the
>    connection?  Would the acks have been lost?

No acks will be lost. The IB termination process requires the closing
side to drain it's sendq and stop injecting new traffic before sending
the CM close message. The other must also drain the sendq before
replying. This handshake ensures the QP is quiescent and all in flight
traffic completed before the QP is destroyed.

IB basically shifts the lingering close into the CM arena, where it
costs less, and allows the QP and associated HW resources to be
destroyed quickly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
