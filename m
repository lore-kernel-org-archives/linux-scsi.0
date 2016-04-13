From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/iser: set max_segment_size
Date: Wed, 13 Apr 2016 11:01:57 +0300
Message-ID: <570DFCF5.1090501@grimberg.me>
References: <1460414846-29540-1-git-send-email-hch@lst.de>
 <1460414846-29540-3-git-send-email-hch@lst.de> <570CD26E.70502@grimberg.me>
 <1460471256.2338.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460471256.2338.5.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


>> In iser we sorta rely on 4k pages so we avoid
>> PAGE_SIZE but rather set SIZE_4K for these sort
>> of things (like we did in the virt_boundary).
>
> So you still want only 4k segments even on PPC where the PAGE_SIZE is
> 16k?

Yes, iSER has the "no-gaps" constraint (like nvme) and some
applications in the past were known to issue vectored IO that doesn't
necessarily align with the system PAGE_SIZE. These sort of workloads
resulted in suboptimal performance on ppc, ia64 etc (almost every I/O
had gaps).

Before the block layer was able to enforce scatterlists without gaps,
iSER used bounce buffering in order to service "gappy" I/O which was
probably a lot worse than bio splitting like the block layer is doing
today, but still we felt that having 4k segments even on larger
PAGE_SIZE systems was a decent compromise.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
