From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/iser: set max_segment_size
Date: Tue, 12 Apr 2016 07:27:36 -0700
Message-ID: <1460471256.2338.5.camel@HansenPartnership.com>
References: <1460414846-29540-1-git-send-email-hch@lst.de>
	 <1460414846-29540-3-git-send-email-hch@lst.de> <570CD26E.70502@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <570CD26E.70502-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-04-12 at 13:48 +0300, Sagi Grimberg wrote:
> > So that we don't overflow the number of MR segments allocated
> > because
> > we have to split on SGL segment into multiple MR segments.
> > 
> > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > ---
> >   drivers/infiniband/ulp/iser/iscsi_iser.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c
> > b/drivers/infiniband/ulp/iser/iscsi_iser.c
> > index 80b6bed..784504a 100644
> > --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> > +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> > @@ -623,6 +623,7 @@ iscsi_iser_session_create(struct iscsi_endpoint
> > *ep,
> >   	shost->max_id = 0;
> >   	shost->max_channel = 0;
> >   	shost->max_cmd_len = 16;
> > +	shost->max_segment_size = PAGE_SIZE;
> 
> In iser we sorta rely on 4k pages so we avoid
> PAGE_SIZE but rather set SIZE_4K for these sort
> of things (like we did in the virt_boundary).

So you still want only 4k segments even on PPC where the PAGE_SIZE is
16k?

James


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
