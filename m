From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [dm-devel] multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Wed, 16 May 2012 13:03:33 -0400
Message-ID: <1337187813.21009.14.camel@frustration.ornl.gov>
References: <4FB39D78.9020300@itwm.fraunhofer.de>
	 <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com>
	 <4FB3B9DE.1050903@itwm.fraunhofer.de> <4FB3C75F.3070903@cs.wisc.edu>
	 <4FB3CDC5.9040608@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB3CDC5.9040608-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-05-16 at 11:54 -0400, Bernd Schubert wrote:
> 2) Low SRP command queues. Is there a reason why 
> SRP_RQ_SHIFT/SRP_RQ_SIZE and their depend values such as SRP_RQ_SIZE are 
> so small?

That's a decision that has been around since the beginning of the driver
as far as I can tell. It looks to be a balance between device needs and
memory usage, and it can certainly be raised -- I've run locally with
SRP_RQ_SHIFT set to 7 (shost.can_queue 126) and I'm sure 8 would be no
problem, either. I didn't see a performance improvement on my workload,
but may you will.

Because we take the minimum of our initiator queue depth and the initial
credits from the target (each req consumes a credit), going higher than
8 doesn't buy us much, as I don't know off-hand of any target that gives
out more than 256 credits.

The memory used for the command ring will vary depending on the value of
SRP_RQ_SHIFT and the number of s/g entries allows to be put in the
command. 255 s/g entries requires an 8 KB allocation for each request
(~4200 bytes), so we currently require 512 KB of buffers for the send
queue for each target. Going to 8 will require 2 MB max per target,
which probably isn't a real issue.

There's also a response ring with an allocation size that depends on the
target, but those should be pretty small buffers, say 1 KB * (1 <<
SRP_RQ_SHIFT).

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
