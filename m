From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Sun, 15 Nov 2015 15:21:00 +0200
Message-ID: <564886BC.5020105@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
 <564852F2.5080602@dev.mellanox.co.il> <20151115125501.GB2218@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151115125501.GB2218-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org



On 15/11/2015 14:55, Christoph Hellwig wrote:
> On Sun, Nov 15, 2015 at 11:40:02AM +0200, Sagi Grimberg wrote:
>> I doubt INT_MAX is useful as a budget in any use-case. it can easily
>> hog the CPU. If the consumer is given access to poll a CQ, it must be
>> able to provide some way to budget it. Why not expose a budget argument
>> to the consumer?
>
> Because in theory we could have a lot of sends completing before
> we finally need to reap them.  I think that's more of a theoretical
> than real issue.

Still, processing a CQ possibly forever is not something we'd want to
enable in an API, if a caller wants to do that anyway, it should loop
this call...

>
> My preference would be to simply kill this mode though.  Allocate a IU
> to each block request in SRP and only use the free_tx list for task
> management and AEN/req_limit calls.  Then we can use a single CQ
> and mark the regular I/O requests as unsignalled.

It might be better. I'd say that we keep this API and let Bart decide
if he wants to do that in srp. If he wants to convert srp, we can
always drop it.

> AFAICS no other driver wants a similar polling mode as the SRP initiator
> does for it's send queue.

iser worked in this mode in the past. But we changed that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
