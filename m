From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 1/9] move blk_iopoll to limit and make it generally
	available
Date: Sun, 15 Nov 2015 13:51:59 +0100
Message-ID: <20151115125159.GA2218@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-2-git-send-email-hch@lst.de> <CAJ3xEMgj2ycv61K38ZOowTRbrri_UhQgBcaKT0ZnnMHiBrmL5A@mail.gmail.com> <20151114070200.GA27738@lst.de> <564846E9.9070301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564846E9.9070301-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 15, 2015 at 10:48:41AM +0200, Sagi Grimberg wrote:
> I have attempted to convert iser to use blk_iopoll in the past, however
> I've seen inconsistent performance and latency skews (comparing to
> tasklets iser is using today). This was manifested in IOPs test cases
> where I ran multiple threads with higher queue-depth and not in
> sanitized pure latency (QD=1) test cases. Unfortunately I didn't have
> the time to pick it up since.
>
> I do have every intention of testing it again with this. If it still
> exist we will need to find the root-cause of it before converting
> drivers to use it.

Thanks.  If you see issue like that with high iops and high loads
the next thing to check are:

 a) increasing the budget (both in the main poll loop and the IB
    code)
 b) try without the single jiffie time limit in the main softirq handler
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
