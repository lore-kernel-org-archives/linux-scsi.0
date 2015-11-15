From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Sun, 15 Nov 2015 13:55:01 +0100
Message-ID: <20151115125501.GB2218@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-3-git-send-email-hch@lst.de> <564852F2.5080602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564852F2.5080602-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 15, 2015 at 11:40:02AM +0200, Sagi Grimberg wrote:
> I doubt INT_MAX is useful as a budget in any use-case. it can easily
> hog the CPU. If the consumer is given access to poll a CQ, it must be
> able to provide some way to budget it. Why not expose a budget argument
> to the consumer?

Because in theory we could have a lot of sends completing before
we finally need to reap them.  I think that's more of a theoretical
than real issue.

My preference would be to simply kill this mode though.  Allocate a IU
to each block request in SRP and only use the free_tx list for task
management and AEN/req_limit calls.  Then we can use a single CQ
and mark the regular I/O requests as unsignalled.

AFAICS no other driver wants a similar polling mode as the SRP initiator
does for it's send queue.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
