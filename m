From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Tue, 24 Nov 2015 07:52:40 -0500
Message-ID: <56545D98.1020904@talpey.com>
References: <20151123203712.GB5640@obsidianresearch.com>
 <56537F59.4080708@sandisk.com> <20151123212822.GE6062@obsidianresearch.com>
 <56538AFD.9080103@sandisk.com> <20151123221806.GA7152@obsidianresearch.com>
 <56539421.9050705@sandisk.com> <20151123230659.GA8287@obsidianresearch.com>
 <B24F4DDE-709A-4D2D-8B26-4E83325DBB1A@asomi.com>
 <20151124000011.GA9301@obsidianresearch.com> <5653CCF0.7050501@asomi.com>
 <20151124070301.GA23597@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124070301.GA23597-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/24/2015 2:03 AM, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2015 at 06:35:28PM -0800, Caitlin Bestler wrote:
>> Are there actual HCAs that make this mistake?
>
> All IB HCAs have this behavior and require apps to see a send CQ
> completion before making any statements about the state of the send Q
> or buffers handed over to the HCA. Tom and I have seen this in real
> systems under proper stress conditions. [Which is why I am so certain
> about this, because when I first hit it years ago I dug into the spec
> and figured out it was not a HW bug I was looking at]

To be clear, I saw the reply-completion-before-request-completion on
Windows, not Linux, but the principle is identical. It's simply a
fact of life on a multiprocessor, unless you want to throw in locks
and synchronization rules that drivers have to follow to enforce
ordered completions across queues. Which trust me, you don't.

In Windows SMB Direct, we added reference counts around pretty much
every verb interaction associated with each upper layer operation,
and did not retire them until all refcounts went to zero. It is
excruciatingly correct yet performs incredibly well.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
