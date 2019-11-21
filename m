Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD203C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 02:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A45BB20885
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 02:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJjzn0GN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKUC3b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 21:29:31 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57307 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725936AbfKUC3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 21:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574303369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=00xDEnOM/AF21OETC8ONOHPp+zFLm0s9kS6DPKrSxHY=;
        b=EJjzn0GNFS5LzbAjlbT8aJogeZoT8ETKd0Q43emeOhW+FoROvSUb5scMgxk/W3BSS4a/t2
        OMMzYW+1bky27EXuxZKgn90/eAsdh9DN+4955liEmQNHZtTF0ERCeLcioXCF6gmk5icmO9
        3JCHLNNczXRtlSyDEGha0Bp9ccLOxLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-FB6Jo5RXM2yZs72atnFaZw-1; Wed, 20 Nov 2019 21:29:26 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05C6E477;
        Thu, 21 Nov 2019 02:29:24 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9A4960BC4;
        Thu, 21 Nov 2019 02:29:13 +0000 (UTC)
Date:   Thu, 21 Nov 2019 10:29:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        chaitra.basappa@broadcom.com,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Ewan Milne <emilne@redhat.com>, hch@lst.de, hare@suse.de,
        bart.vanassche@wdc.com
Subject: Re: [PATCH 1/1] scsi core: limit overhead of device_busy counter for
 SSDs
Message-ID: <20191121022909.GI24548@ming.t460p>
References: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
 <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
 <20191120072919.GB3664@ming.t460p>
 <CADbZ7FqP1EXrUOpD1QSd9MTRz1rgN6BLyhyd0i2r30bu_4xUCA@mail.gmail.com>
 <20191121013419.GF24548@ming.t460p>
 <CADbZ7FrW+4GvS7rpcKwhaO9bs6BPFMro4b30wXMO9ufxTNFG_g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CADbZ7FrW+4GvS7rpcKwhaO9bs6BPFMro4b30wXMO9ufxTNFG_g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: FB6Jo5RXM2yZs72atnFaZw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2019 at 06:59:49PM -0700, Sumanesh Samanta wrote:
> >>IO size usually depends on workloads, instead of controller.
> >>You can't assume that big size IO is always submitted from userspace
> >>because HBA is high end.
>=20
> Absolutely, and I did not try to say otherwise.
>=20
> What I tried to say was that high end controllers normally have an IO
> size limit that they can handle, and block layer cannot merge beyond
> that anyway. And most sequential workload to HDD is large IO, because
> and application reading/writing sequentially have no reason/incentive
> to give small IO ( with the exception of DB REDO logs that go to SSD).
> So, Sequential IO is generally large anyway, and they cannot be merged
> too much by block layer, since controllers can support IO to only
> specific size.
> On top of that, many high end controllers have their own capability of
> merging IO, and does not depend on upper layer.

We shouldn't make assumptions on workloads, which is in another world,
not kernel side.

As I mentioned, if the controller exposes proper size limit, block
layer will follow it and make a proper size IO to driver/device.

>=20
> >>Frankly speaking, we should check NONROT flag instead of controller,
> >>which may connect to slow HDD too, right?
>=20
> If you can find a way of checking NONROT without the problems being
> discussed in this and the other thread, I am completely fine and happy
> with that.
> If, however, no acceptable solution is found then I would request
> giving the flag to the controller so that the ones that are not
> dependent on IO merge are not burdened with it.

Of course, this patch can do that since queue is frozen when changing
NONROT, please take a close look at the patch 4.

Thanks,
Ming

>=20
>=20
>=20
> On Wed, Nov 20, 2019 at 6:34 PM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Wed, Nov 20, 2019 at 12:59:56PM -0700, Sumanesh Samanta wrote:
> > > On Wed, Nov 20, 2019 at 12:29 AM Ming Lei <ming.lei@redhat.com> wrote=
:
> > > >
> > > > On Tue, Nov 19, 2019 at 12:07:59PM -0800, Sumanesh Samanta wrote:
> > > > > From: root <sumanesh.samanta@broadcom.com>
> > > > >
> > > > > Recently a patch was delivered to remove host_busy counter from S=
CSI mid layer. That was a major bottleneck, and helped improve SCSI stack p=
erformance.
> > > > > With that patch, bottle neck moved to the scsi_device device_busy=
 counter. The performance issue with this counter is seen more in cases whe=
re a single device can produce very high IOPs, for example h/w RAID devices=
 where OS sees one device, but there are many drives behind it, thus being =
capable of very high IOPs. The effect is also visible when cores from multi=
ple NUMA nodes send IO to the same device or same controller.
> > > > > The device_busy counter is not needed by controllers which can ma=
nage as many IO as submitted to it. Rotating media still uses it for mergin=
g IO, but for non-rotating SSD drives it becomes a major bottleneck as desc=
ribed above.
> > > > >
> > > > > A few weeks back, a patch was provided to address the device_busy=
 counter also but unfortunately that had some issues:
> > > > > 1. There was a functional issue discovered:
> > > > > https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/VFKD=
TG4XC4VHWX5KKDJJI7P36EIGK526/
> > > > > 2. There was some concern about existing drivers using the device=
_busy counter.
> > > >
> > > > There are only two drivers(mpt3sas and megaraid_sas) which uses thi=
s
> > > > counter. And there are two types of usage:
> > > >
> > > > 1) both use .device_busy to balance interrupt load among LUNs in
> > > > fast path
> > > >
> > > > 2) mpt3sas uses .device_busy in its device reset handler(slow path)=
, and
> > > > this kind of usage can be replaced by blk_mq_queue_tag_busy_iter()
> > > > easily.
> > > >
> > > > IMO, blk-mq has already considered IO load balance, see
> > > > hctx_may_queue(), meantime managed IRQ can balance IO completion lo=
ad
> > > > among each IRQ vectors, not see obvious reason for driver to do tha=
t
> > > > any more.
> > > >
> > > > However, if the two drivers still want to do that, I'd suggest to i=
mplement
> > > > it inside the driver, and no reason to re-invent generic wheels jus=
t for
> > > > two drivers.
> > > >
> > > > That is why I replace .device_busy uses in the two drivers with pri=
vate
> > > > counters in the patches posted days ago:
> > > >
> > > > https://lore.kernel.org/linux-scsi/20191118103117.978-1-ming.lei@re=
dhat.com/T/#t
> > > >
> > >
> > > Agreed, a private counter should be good enough.
> > >
> > > > And if drivers thought the private counter isn't good enough, they =
can
> > > > improve it in any way, such as this percpu approach, or even kill t=
hem.
> > > >
> > >
> > > I was more concerned about the functional issue discovered in the
> > > earlier patch and provided mine as an alternative without any side
> > > effect or functional issue, since it does not modify any core logic.
> > > Having said that, if your latest patch goes through and is accepted,
> > > then agree that my patch is not needed. If however, some issue is
> > > discovered in your latest patch, then I would request my patch to be
> > > considered as an alternative, so that the device_busy counter overhea=
d
> > > can be avoided
> > >
> > > > >
> > > > > This patch is an attempt to address both the above issues.
> > > > > For this patch to be effective, LLDs need to set a specific flag =
use_per_cpu_device_busy in the scsi_host_template. For other drivers ( who =
does not set the flag), this patch would be a no-op, and should not affect =
their performance or functionality at all.
> > > > >
> > > > > Also, this patch does not fundamentally change any logic or funct=
ionality of the code. All it does is replace device_busy with a per CPU cou=
nter. In fast path, all cpu increment/decrement their own counter. In relat=
ively slow path. they call scsi_device_busy function to get the total no of=
 IO outstanding on a device. Only functional aspect it changes is that for =
non-rotating media, the number of IO to a device is not restricted. Control=
lers which can handle that, can set the use_per_cpu_device_busy flag in scs=
i_host_template to take advantage of this patch. Other controllers need not=
 modify any code and would work as usual.
> > > > > Since the patch does not modify any other functional aspects, it =
should not have any side effects even for drivers that do set the use_per_c=
pu_device_busy flag.
> > > > > ---
> > > > >  drivers/scsi/scsi_lib.c    | 151 +++++++++++++++++++++++++++++++=
+++---
> > > > >  drivers/scsi/scsi_scan.c   |  16 ++++
> > > > >  drivers/scsi/scsi_sysfs.c  |   9 ++-
> > > > >  drivers/scsi/sg.c          |   2 +-
> > > > >  include/scsi/scsi_device.h |  15 ++++
> > > > >  include/scsi/scsi_host.h   |  16 ++++
> > > > >  6 files changed, 197 insertions(+), 12 deletions(-)
> > > > >
> > > > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > > > index 2563b061f56b..5dc392914f9e 100644
> > > > > --- a/drivers/scsi/scsi_lib.c
> > > > > +++ b/drivers/scsi/scsi_lib.c
> > > > > @@ -52,6 +52,12 @@
> > > > >  #define  SCSI_INLINE_SG_CNT  2
> > > > >  #endif
> > > > >
> > > > > +#define MAX_PER_CPU_COUNTER_ABSOLUTE_VAL (0xFFFFFFFFFFF)
> > > > > +#define PER_CPU_COUNTER_OK_VAL (MAX_PER_CPU_COUNTER_ABSOLUTE_VAL=
>>16)
> > > > > +#define USE_DEVICE_BUSY(sdev)        (!(sdev)->host->hostt->use_=
per_cpu_device_busy \
> > > > > +                             || !blk_queue_nonrot((sdev)->reques=
t_queue))
> > > > > +
> > > > > +
> > > > >  static struct kmem_cache *scsi_sdb_cache;
> > > > >  static struct kmem_cache *scsi_sense_cache;
> > > > >  static struct kmem_cache *scsi_sense_isadma_cache;
> > > > > @@ -65,6 +71,111 @@ scsi_select_sense_cache(bool unchecked_isa_dm=
a)
> > > > >       return unchecked_isa_dma ? scsi_sense_isadma_cache : scsi_s=
ense_cache;
> > > > >  }
> > > > >
> > > > > +/*
> > > > > + *Generic helper function to decrement per cpu io counter.
> > > > > + *@per_cpu_counter: The per cpu counter array. Current cpu count=
er will be
> > > > > + * decremented
> > > > > + */
> > > > > +
> > > > > +static inline void dec_per_cpu_io_counter(atomic64_t __percpu *p=
er_cpu_counter)
> > > > > +{
> > > > > +     atomic64_t __percpu *io_count =3D get_cpu_ptr(per_cpu_count=
er);
> > > > > +
> > > > > +     if (unlikely(abs(atomic64_dec_return(io_count)) >
> > > > > +                             MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> > > > > +             scsi_rebalance_per_cpu_io_counters(per_cpu_counter,=
 io_count);
> > > > > +     put_cpu_ptr(per_cpu_counter);
> > > > > +}
> > > > > +/*
> > > > > + *Generic helper function to increment per cpu io counter.
> > > > > + *@per_cpu_counter: The per cpu counter array. Current cpu count=
er will be
> > > > > + * incremented
> > > > > + */
> > > > > +static inline void inc_per_cpu_io_counter(atomic64_t __percpu *p=
er_cpu_counter)
> > > > > +{
> > > > > +     atomic64_t __percpu *io_count =3D get_cpu_ptr(per_cpu_count=
er);
> > > > > +
> > > > > +     if (unlikely(abs(atomic64_inc_return(io_count)) >
> > > > > +                             MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> > > > > +             scsi_rebalance_per_cpu_io_counters(per_cpu_counter,=
 io_count);
> > > > > +     put_cpu_ptr(per_cpu_counter);
> > > > > +}
> > > > > +
> > > > > +
> > > > > +/**
> > > > > + * scsi_device_busy - Return the device_busy counter
> > > > > + * @sdev:    Pointer to scsi_device to get busy counter.
> > > > > + **/
> > > > > +int scsi_device_busy(struct scsi_device *sdev)
> > > > > +{
> > > > > +     long long total =3D 0;
> > > > > +     int i;
> > > > > +
> > > > > +     if (USE_DEVICE_BUSY(sdev))
> > > >
> > > > As Ewan and Bart commented, you can't use the NONROT queue flag sim=
ply
> > > > in IO path, given it may be changed somewhere.
> > > >
> > >
> > > I added the NONROT check just as an afterthought. This patch is
> > > designed for high end controllers, and most of them have some storage
> > > IO size limit.
> >
> > IO size usually depends on workloads, instead of controller.
> >
> > You can't assume that big size IO is always submitted from userspace
> > because HBA is high end.
> >
> > For sequential IO workloads, block layer tries best to run IO merge,
> > which is usually big win for HDD.
> >
> > > Also, for HDD sequential IO is almost always large and
> > > touch the controller max IO size limit.
> >
> > No, there are workloads, single IO size isn't big, but
> > they are sequential, it may not be hit by readahead, such as
> > write. That is exactly what block layer has to run IO merge
> > for these small IOs.
> >
> > > Thus, I am not sure merge
> > > matters for these kind of controllers. Database use REDO log and smal=
l
> > > sequential IO, but those are targeted to SSDs, where latency and IOPs
> > > are far more important than IO merging.
> > > Anyway, this patch is opt-in for drivers, so any LLD that cannot take
> > > advantage of the flag need not set it, and would work as-is.
> > > I can provide a new version of the patch with this check removed
> >
> > Frankly speaking, we should check NONROT flag instead of controller,
> > which may connect to slow HDD too, right?
> >
> > Thanks,
> > Ming
> >
>=20

--=20
Ming

