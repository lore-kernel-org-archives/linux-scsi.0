From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: A question regarding "multiple SGL"
Date: Thu, 27 Oct 2016 09:50:45 -0500
Message-ID: <017601d23061$7f8f3ba0$7eadb2e0$@opengridcomputing.com>
References: <20161027005230.9904DC00097@webmail.sinamail.sina.com.cn> <20161027064115.GA5864@lst.de> <B78D1A958924E54594997EFF975251625BD49445@szxeml592-mbx.china.huawei.com> <20161027071009.GA6434@lst.de> <178765fb-0fcf-0fdc-dc5e-0cc226375827@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <178765fb-0fcf-0fdc-dc5e-0cc226375827-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, "'Qiuxin (robert)'" <qiuxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'James Bottomley' <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "'Martin K. Petersen'" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Mike Snitzer' <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Ming Lei' <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Tiger zhao' <tiger.zhao-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Jens Axboe' <axboe-b10kYP2dOMg@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Laurence Oberman' <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Keith Busch' <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> > Hi Robert,
> 
> Hey Robert, Christoph,
> 
> > please explain your use cases that isn't handled.  The one and only
> > reason to set MSDBD to 1 is to make the code a lot simpler given that
> > there is no real use case for supporting more.
> >
> > RDMA uses memory registrations to register large and possibly
> > discontiguous data regions for a single rkey, aka single SGL descriptor
> > in NVMe terms.  There would be two reasons to support multiple SGL
> > descriptors:  a) to support a larger I/O size than supported by a single
> > MR, or b) to support a data region format not mappable by a single
> > MR.
> >
> > iSER only supports a single rkey (or stag in IETF terminology) and has
> > been doing fine on a) and mostly fine on b).   There are a few possible
> > data layouts not supported by the traditional IB/iWarp FR WRs, but the
> > limit is in fact exactly the same as imposed by the NVMe PRPs used for
> > PCIe NVMe devices, so the Linux block layer has support to not generate
> > them.  Also with modern Mellanox IB/RoCE hardware we can actually
> > register completely arbitrary SGLs.  iSER supports using this registration
> > mode already with a trivial code addition, but for NVMe we didn't have a
> > pressing need yet.
> 
> Good explanation :)
> 
> The IO transfer size is a bit more pressing on some devices (e.g.
> cxgb3/4) where the number of pages per-MR can be indeed lower than
> a reasonable transfer size (Steve can correct me if I'm wrong).
>

Currently, cxgb4 support 128KB REG_MR operations on a host with 4K page size,
via a max mr page list depth of 32.  Soon it will be bumped up from 32 to 128
and life will be better...

 
> However, if there is a real demand for this we'll happily accept
> patches :)
> 
> Just a note, having this feature in-place can bring unexpected behavior
> depending on how we implement it:
> - If we can use multiple MRs per IO (for multiple SGLs) we can either
> prepare for the worst-case and allocate enough MRs to satisfy the
> various IO patterns. This will be much heavier in terms of resource
> allocation and can limit the scalability of the host driver.
> - Or we can implement a shared MR pool with a reasonable number of MRs.
> In this case each IO can consume one or more MRs on the expense of
> other IOs. In this case we may need to requeue the IO later when we
> have enough available MRs to satisfy the IO. This can yield some
> unexpected performance gaps for some workloads.
> 

I would like to see the storage protocols deal with lack of resources for the
worst case.  This allows much smaller resource usage for both MRs, and SQ
resources, at the expense of adding flow control logic to deal with lack of
available MR and/or SQ slots to process the next IO.  I think it can be
implemented efficiently such that when in flow-control mode, the code is driving
new IO submissions off of SQ completions which will free up SQ slots and most
likely MRs from the QP's MR pool.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
