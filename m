From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Sat, 14 Nov 2015 08:05:31 +0100
Message-ID: <20151114070531.GC27738@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-4-git-send-email-hch@lst.de> <56460CC4.3030001@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56460CC4.3030001-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 13, 2015 at 10:16:04AM -0600, Steve Wise wrote:
> So how can we do this for iwarp?  It seems like all that might be needed is 
> to modify the QP state to idle, retrying until it succeeds:
>
>    If the QP is transitioning to the Error state, or has not yet
>    finished flushing the Work Queues, a Modify QP request to transition
>    to the IDLE state MUST fail with an Immediate Error. If none of the
>    prior conditions are true, a Modify QP to the Idle state MUST take
>    the QP to the Idle state. No other state transitions out of Error
>    are supported. Any attempt to transition the QP to a state other
>    than Idle MUST result in an Immediate Error.

Can you try to write up some code for this?  We could then wire it up
in the common helper.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
