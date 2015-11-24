From: Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 18:35:28 -0800
Message-ID: <5653CCF0.7050501@asomi.com>
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
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



On 11/23/2015 4:00 PM, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2015 at 03:30:42PM -0800, Caitlin Bestler wrote:
>>     The receive completion can be safely assumed to indicate transmit
>>     completion over a reliable connection unless your peer has gone
>>     completely bonkers and is replying to a command that it did not
>>     receive.
> Perhaps iWarp is different and does specify this ordering but IB does
> not.
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
>
Is it possible for an IB HCA to transmit a response on a QP and not in 
that packet
or a previous packet acknowledge something that it has delivered to the 
user?

My recollection of the IB verbs is that they were unlikely to have 
overlooked something
like that. If it did slip through then there should be an errata.

But regardless of specification lawyering, is this an implementation 
issue. Are there
actual HCAs that make this mistake?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
