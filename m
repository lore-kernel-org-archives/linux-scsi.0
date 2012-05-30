From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH] srp: convert SRP_RQ_SHIFT into a module parameter
Date: Wed, 30 May 2012 01:22:32 -0400
Message-ID: <1338355352.2361.24.camel@obelisk.thedillows.org>
References: <4FB39D78.9020300@itwm.fraunhofer.de>
	  <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com>
	  <4FB3B9DE.1050903@itwm.fraunhofer.de> <4FB3C75F.3070903@cs.wisc.edu>
	  <4FB3CDC5.9040608@itwm.fraunhofer.de>
	 <1337187813.21009.14.camel@frustration.ornl.gov>
	 <4FBA6412.7040505@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FBA6412.7040505-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-05-21 at 17:49 +0200, Bernd Schubert wrote:
> David, below is a first version to convert SRP_RQ_SHIFT into a new 
> module option "srp_rq_size". I already tested it, but I also need to 
> re-read it myself.
> 
> Author: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
> Date:   Mon May 21 10:25:01 2012 +0200
> 
>     infiniband/srp: convert SRP_RQ_SHIFT into a module parameter
>     
>     When SRP_RQ_SHIFT is a fix parameter the optimal value is unclear.
>     The current value of 6 might be too small for several storage systems
>     and larger values might take too much memory for other systems.
>     So make it a parameter and let the admin decide.

This shouldn't be a module parameter; if at all possible, all new
parameters should be specified on a per-target basis, with reasonable
defaults. srp_rq_size isn't the right

Also, I think we can get rid of the {tx,rx}_ring arrays and just
individually allocate the IUs and hook them on the appropriate lists.
This may make cleanup a bit more tricky, as we'd have to walk the
outstanding requests to find all of the IUs....

It may easier to just add a singly linked list to struct srp_iu to keep
the {tx,rx} IU's on, since we always use them from a direct pointer or
from a free list. We could do a code audit and remove that field later
if needed, but the simplicity is probably worth the memory cost.

We have to keep the req_ring array; we need to look those entries up by
index as we don't want to trust a pointer over the wire.

Eventually, I could see us delaying this initialization until we get the
login response back and know the maximum we'd use on this connection.
That should wait, as Bart's persistent connection changes could add some
complications there.

Thanks,

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
