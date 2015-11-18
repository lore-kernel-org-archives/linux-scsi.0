From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 4/9] srpt: chain RDMA READ/WRITE requests
Date: Wed, 18 Nov 2015 15:06:07 +0100
Message-ID: <20151118140607.GH18820@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-5-git-send-email-hch@lst.de> <564BD1AF.60200@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564BD1AF.60200-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2015 at 05:17:35PM -0800, Bart Van Assche wrote:
> Chaining RDMA requests is a great idea. But it seems to me that this patch 
> is based on the assumption that posting multiple RDMA requests either 
> succeeds as a whole or fails as a whole. Sorry but I'm not sure that the 
> verbs API guarantees this. In the ib_srpt driver a QP can be changed at any 
> time into the error state and there might be drivers that report an 
> immediate failure in that case. I think even when chaining RDMA requests 
> that we still need a mechanism to wait until ongoing RDMA transfers have 
> finished if some but not all RDMA requests have been posted.

I'd have to look at where it's guaranteed that we get flushed errors,
but if there were drivers that broke this assumption the iSER driver
would already be badly broken by this.  So if we don't have the formal
guaranteed yet we should add it and fix up the drivers.

Once all drivers use the new-style complentions we could in fact just
remove the return value from ->post_send_wr and require that all erorrs
are reported through ->done.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
