From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 4/9] srpt: chain RDMA READ/WRITE requests
Date: Fri, 20 Nov 2015 11:20:52 +0100
Message-ID: <20151120102052.GD24298@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-5-git-send-email-hch@lst.de> <564BD1AF.60200@sandisk.com> <564C41B8.2080904@dev.mellanox.co.il> <564CA83B.4060403@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564CA83B.4060403-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 18, 2015 at 08:32:59AM -0800, Bart Van Assche wrote:
> As you know events like a cable pull can cause some of the RDMA work 
> requests to succeed and others to fail. It is essential that all RDMA work 
> requests related to the same SCSI command have finished before the buffers 
> these requests operate upon are reused. The purpose of the SRPT_RDMA_ABORT 
> request is to wait for the RDMA requests that were posted without 
> IB_SEND_SIGNALED and for which no error completion will be received. BTW, I 
> think this consideration applies to all SCSI target drivers and not only to 
> SRP target drivers.

I think everyone understand the theroetical issue, but we'd like to
see a practical case that the implementation in isert and my proposed
srpt one don't handle.

Given that chained WRs must not be reordered the HCA must also give
us the completions in the order we submitted them.  Because of that
the previous WRs must have been completed by the time we get the
notification for the last one which usually does the cleanup.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
