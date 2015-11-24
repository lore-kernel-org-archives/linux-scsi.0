From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 19:34:53 -0500
Message-ID: <5653B0AD.7090402@talpey.com>
References: <20151113220636.GA32133@obsidianresearch.com>
 <20151114071344.GE27738@lst.de> <20151123203712.GB5640@obsidianresearch.com>
 <56537F59.4080708@sandisk.com> <20151123212822.GE6062@obsidianresearch.com>
 <56538AFD.9080103@sandisk.com> <20151123221806.GA7152@obsidianresearch.com>
 <56539421.9050705@sandisk.com> <20151123230659.GA8287@obsidianresearch.com>
 <B24F4DDE-709A-4D2D-8B26-4E83325DBB1A@asomi.com>
 <20151124000011.GA9301@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124000011.GA9301-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/23/2015 7:00 PM, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2015 at 03:30:42PM -0800, Caitlin Bestler wrote:
>>     The receive completion can be safely assumed to indicate transmit
>>     completion over a reliable connection unless your peer has gone
>>     completely bonkers and is replying to a command that it did not
>>     receive.
>
> Perhaps iWarp is different and does specify this ordering but IB does
> not.

iWARP is not different. The situation you (Jason) describe has
nothing to do with the transport. It has everything to do with
as you point out the lack of causality between send and receive
completions.

It is entirely possible for the reply to be received before the
send is fully processed. For example, the send might be issued
on one core, and that core scheduled away before the completion
for the send is ready. In the meantime, the request goes on
the wire, the target processes it and replies, and the reply
is processed. Boom, the send queue completion is still pending.

Been there, seen that. Bluescreened on it, mysteriously.

A really good way to see this is with software providers, btw.
Try it with soft{roce,iwarp}, under heavy load.

Tom.

>
> The issue with IB is how the ACK protocol is designed. There is not
> strong ordering between ACKs and data transfers. A HCA can send
> ACK,DATA and the network could drop the ACK. The recevier side does
> not know the ACK was lost and goes ahead to process DATA.
>
> Since only ACK advances the sendq and DATA advances the recvq it is
> trivial to get a case where the recvq is advanced with a reply while
> the sendq continues to wait for the ACK to be resent.
>
> Further IB allows ACK coalescing and has no rules for how an ACK is
> placed. It is entirely valid for a HCA to RECV,REPLY,ACK - for
> instance.
>
>>     I actually had a bug in an early iWARP emulation where the simulated
>>     peer, because it was simulated, responded
>>     instantly. The result was a TCP segment that both acked the
>>     transmission *and* contained the reply. The bug was
>>     that the code processed the reception before the transmission ack,
>>     causing the receive completion to be placed
>>     on the completion queue before transmit completion.
>
> I don't know if iWARP has the same lax ordering as IB, but certainly,
> what you describe is legal for IB verbs to do, and our kernel ULPs
> have to cope with it.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
