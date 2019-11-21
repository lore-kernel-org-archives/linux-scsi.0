Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD66BC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 02:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A590E20878
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 02:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ng3E8MRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfKUCAF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 21:00:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46961 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfKUCAF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 21:00:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id b3so2283880wrs.13
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2019 18:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=En3FrEiY6hiSSzW5JBUus137S7wpywCMdukr025F8+M=;
        b=Ng3E8MRfGXyVmoyWbpHm6Lur+9o6EyzXZTVYKBptRmGlAr60vQI2WZGUmccv3kklUr
         5rx8xBxPZj2dr+AuYtm7l8KXvmQq7oSdWqg/aSclYAiNwSXLvikLVdXfNmMlwZV5UkZD
         XvbcG2n1kKwlZhNlWICzL11d/xck7jGysXB+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=En3FrEiY6hiSSzW5JBUus137S7wpywCMdukr025F8+M=;
        b=XVnHjK2bkOU/QQ2lEtTdGfF/Gla5TER0Sn1WyoONNVewcso2uo9/wrc/bZp7Ua/v17
         8Q3TdXCpns/vosURYT8p2moR/t1fWWqVb4pB2dd5Vo4/b1NvzyblgjqNLaGggC8jShVD
         NOPzm74e8VqyBTgHkrvUT2GBuXlTELprc8cgVNi39PYDMzU1t0sV421FVHj6m2fu5g5U
         XsvWNRO2nGee346ZcJVI5zN3DYPs/3OiQC6qgdcHoY2yWJaGx+U14j2SrRN1JM6rTNHt
         veTBPep5ZcLvr2JuohNnLoMb9+lLd9DVB3yjw2VBE8gGuRWqyyGjf5wgGh0OU0WetMQj
         Ct7g==
X-Gm-Message-State: APjAAAX+Yf6hZz4lZscn4PnZQdsg+CcM/V+TpGntZ0pITr6rk5q6/BPL
        PGWMXvwzx5J2A5X8rdCn753p04vBSaSJmJDBpIqmyw==
X-Google-Smtp-Source: APXvYqy29MT0+SSqq4K+tf+hGMYDx3lPVN2XoaBacpY01mUQ3t/rZRUaT6DZB+HnBM70GPzCc/IsclR8W48UDtNsRoY=
X-Received: by 2002:adf:ed4e:: with SMTP id u14mr7501515wro.132.1574301600898;
 Wed, 20 Nov 2019 18:00:00 -0800 (PST)
MIME-Version: 1.0
References: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
 <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
 <20191120072919.GB3664@ming.t460p> <CADbZ7FqP1EXrUOpD1QSd9MTRz1rgN6BLyhyd0i2r30bu_4xUCA@mail.gmail.com>
 <20191121013419.GF24548@ming.t460p>
In-Reply-To: <20191121013419.GF24548@ming.t460p>
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Date:   Wed, 20 Nov 2019 18:59:49 -0700
Message-ID: <CADbZ7FrW+4GvS7rpcKwhaO9bs6BPFMro4b30wXMO9ufxTNFG_g@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi core: limit overhead of device_busy counter for SSDs
To:     Ming Lei <ming.lei@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>IO size usually depends on workloads, instead of controller.
>>You can't assume that big size IO is always submitted from userspace
>>because HBA is high end.

Absolutely, and I did not try to say otherwise.

What I tried to say was that high end controllers normally have an IO
size limit that they can handle, and block layer cannot merge beyond
that anyway. And most sequential workload to HDD is large IO, because
and application reading/writing sequentially have no reason/incentive
to give small IO ( with the exception of DB REDO logs that go to SSD).
So, Sequential IO is generally large anyway, and they cannot be merged
too much by block layer, since controllers can support IO to only
specific size.
On top of that, many high end controllers have their own capability of
merging IO, and does not depend on upper layer.

>>Frankly speaking, we should check NONROT flag instead of controller,
>>which may connect to slow HDD too, right?

If you can find a way of checking NONROT without the problems being
discussed in this and the other thread, I am completely fine and happy
with that.
If, however, no acceptable solution is found then I would request
giving the flag to the controller so that the ones that are not
dependent on IO merge are not burdened with it.

thanks,
Sumanesh



On Wed, Nov 20, 2019 at 6:34 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Wed, Nov 20, 2019 at 12:59:56PM -0700, Sumanesh Samanta wrote:
> > On Wed, Nov 20, 2019 at 12:29 AM Ming Lei <ming.lei@redhat.com> wrote:
> > >
> > > On Tue, Nov 19, 2019 at 12:07:59PM -0800, Sumanesh Samanta wrote:
> > > > From: root <sumanesh.samanta@broadcom.com>
> > > >
> > > > Recently a patch was delivered to remove host_busy counter from SCS=
I mid layer. That was a major bottleneck, and helped improve SCSI stack per=
formance.
> > > > With that patch, bottle neck moved to the scsi_device device_busy c=
ounter. The performance issue with this counter is seen more in cases where=
 a single device can produce very high IOPs, for example h/w RAID devices w=
here OS sees one device, but there are many drives behind it, thus being ca=
pable of very high IOPs. The effect is also visible when cores from multipl=
e NUMA nodes send IO to the same device or same controller.
> > > > The device_busy counter is not needed by controllers which can mana=
ge as many IO as submitted to it. Rotating media still uses it for merging =
IO, but for non-rotating SSD drives it becomes a major bottleneck as descri=
bed above.
> > > >
> > > > A few weeks back, a patch was provided to address the device_busy c=
ounter also but unfortunately that had some issues:
> > > > 1. There was a functional issue discovered:
> > > > https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/VFKDTG=
4XC4VHWX5KKDJJI7P36EIGK526/
> > > > 2. There was some concern about existing drivers using the device_b=
usy counter.
> > >
> > > There are only two drivers(mpt3sas and megaraid_sas) which uses this
> > > counter. And there are two types of usage:
> > >
> > > 1) both use .device_busy to balance interrupt load among LUNs in
> > > fast path
> > >
> > > 2) mpt3sas uses .device_busy in its device reset handler(slow path), =
and
> > > this kind of usage can be replaced by blk_mq_queue_tag_busy_iter()
> > > easily.
> > >
> > > IMO, blk-mq has already considered IO load balance, see
> > > hctx_may_queue(), meantime managed IRQ can balance IO completion load
> > > among each IRQ vectors, not see obvious reason for driver to do that
> > > any more.
> > >
> > > However, if the two drivers still want to do that, I'd suggest to imp=
lement
> > > it inside the driver, and no reason to re-invent generic wheels just =
for
> > > two drivers.
> > >
> > > That is why I replace .device_busy uses in the two drivers with priva=
te
> > > counters in the patches posted days ago:
> > >
> > > https://lore.kernel.org/linux-scsi/20191118103117.978-1-ming.lei@redh=
at.com/T/#t
> > >
> >
> > Agreed, a private counter should be good enough.
> >
> > > And if drivers thought the private counter isn't good enough, they ca=
n
> > > improve it in any way, such as this percpu approach, or even kill the=
m.
> > >
> >
> > I was more concerned about the functional issue discovered in the
> > earlier patch and provided mine as an alternative without any side
> > effect or functional issue, since it does not modify any core logic.
> > Having said that, if your latest patch goes through and is accepted,
> > then agree that my patch is not needed. If however, some issue is
> > discovered in your latest patch, then I would request my patch to be
> > considered as an alternative, so that the device_busy counter overhead
> > can be avoided
> >
> > > >
> > > > This patch is an attempt to address both the above issues.
> > > > For this patch to be effective, LLDs need to set a specific flag us=
e_per_cpu_device_busy in the scsi_host_template. For other drivers ( who do=
es not set the flag), this patch would be a no-op, and should not affect th=
eir performance or functionality at all.
> > > >
> > > > Also, this patch does not fundamentally change any logic or functio=
nality of the code. All it does is replace device_busy with a per CPU count=
er. In fast path, all cpu increment/decrement their own counter. In relativ=
ely slow path. they call scsi_device_busy function to get the total no of I=
O outstanding on a device. Only functional aspect it changes is that for no=
n-rotating media, the number of IO to a device is not restricted. Controlle=
rs which can handle that, can set the use_per_cpu_device_busy flag in scsi_=
host_template to take advantage of this patch. Other controllers need not m=
odify any code and would work as usual.
> > > > Since the patch does not modify any other functional aspects, it sh=
ould not have any side effects even for drivers that do set the use_per_cpu=
_device_busy flag.
> > > > ---
> > > >  drivers/scsi/scsi_lib.c    | 151 +++++++++++++++++++++++++++++++++=
+---
> > > >  drivers/scsi/scsi_scan.c   |  16 ++++
> > > >  drivers/scsi/scsi_sysfs.c  |   9 ++-
> > > >  drivers/scsi/sg.c          |   2 +-
> > > >  include/scsi/scsi_device.h |  15 ++++
> > > >  include/scsi/scsi_host.h   |  16 ++++
> > > >  6 files changed, 197 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > > index 2563b061f56b..5dc392914f9e 100644
> > > > --- a/drivers/scsi/scsi_lib.c
> > > > +++ b/drivers/scsi/scsi_lib.c
> > > > @@ -52,6 +52,12 @@
> > > >  #define  SCSI_INLINE_SG_CNT  2
> > > >  #endif
> > > >
> > > > +#define MAX_PER_CPU_COUNTER_ABSOLUTE_VAL (0xFFFFFFFFFFF)
> > > > +#define PER_CPU_COUNTER_OK_VAL (MAX_PER_CPU_COUNTER_ABSOLUTE_VAL>>=
16)
> > > > +#define USE_DEVICE_BUSY(sdev)        (!(sdev)->host->hostt->use_pe=
r_cpu_device_busy \
> > > > +                             || !blk_queue_nonrot((sdev)->request_=
queue))
> > > > +
> > > > +
> > > >  static struct kmem_cache *scsi_sdb_cache;
> > > >  static struct kmem_cache *scsi_sense_cache;
> > > >  static struct kmem_cache *scsi_sense_isadma_cache;
> > > > @@ -65,6 +71,111 @@ scsi_select_sense_cache(bool unchecked_isa_dma)
> > > >       return unchecked_isa_dma ? scsi_sense_isadma_cache : scsi_sen=
se_cache;
> > > >  }
> > > >
> > > > +/*
> > > > + *Generic helper function to decrement per cpu io counter.
> > > > + *@per_cpu_counter: The per cpu counter array. Current cpu counter=
 will be
> > > > + * decremented
> > > > + */
> > > > +
> > > > +static inline void dec_per_cpu_io_counter(atomic64_t __percpu *per=
_cpu_counter)
> > > > +{
> > > > +     atomic64_t __percpu *io_count =3D get_cpu_ptr(per_cpu_counter=
);
> > > > +
> > > > +     if (unlikely(abs(atomic64_dec_return(io_count)) >
> > > > +                             MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> > > > +             scsi_rebalance_per_cpu_io_counters(per_cpu_counter, i=
o_count);
> > > > +     put_cpu_ptr(per_cpu_counter);
> > > > +}
> > > > +/*
> > > > + *Generic helper function to increment per cpu io counter.
> > > > + *@per_cpu_counter: The per cpu counter array. Current cpu counter=
 will be
> > > > + * incremented
> > > > + */
> > > > +static inline void inc_per_cpu_io_counter(atomic64_t __percpu *per=
_cpu_counter)
> > > > +{
> > > > +     atomic64_t __percpu *io_count =3D get_cpu_ptr(per_cpu_counter=
);
> > > > +
> > > > +     if (unlikely(abs(atomic64_inc_return(io_count)) >
> > > > +                             MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> > > > +             scsi_rebalance_per_cpu_io_counters(per_cpu_counter, i=
o_count);
> > > > +     put_cpu_ptr(per_cpu_counter);
> > > > +}
> > > > +
> > > > +
> > > > +/**
> > > > + * scsi_device_busy - Return the device_busy counter
> > > > + * @sdev:    Pointer to scsi_device to get busy counter.
> > > > + **/
> > > > +int scsi_device_busy(struct scsi_device *sdev)
> > > > +{
> > > > +     long long total =3D 0;
> > > > +     int i;
> > > > +
> > > > +     if (USE_DEVICE_BUSY(sdev))
> > >
> > > As Ewan and Bart commented, you can't use the NONROT queue flag simpl=
y
> > > in IO path, given it may be changed somewhere.
> > >
> >
> > I added the NONROT check just as an afterthought. This patch is
> > designed for high end controllers, and most of them have some storage
> > IO size limit.
>
> IO size usually depends on workloads, instead of controller.
>
> You can't assume that big size IO is always submitted from userspace
> because HBA is high end.
>
> For sequential IO workloads, block layer tries best to run IO merge,
> which is usually big win for HDD.
>
> > Also, for HDD sequential IO is almost always large and
> > touch the controller max IO size limit.
>
> No, there are workloads, single IO size isn't big, but
> they are sequential, it may not be hit by readahead, such as
> write. That is exactly what block layer has to run IO merge
> for these small IOs.
>
> > Thus, I am not sure merge
> > matters for these kind of controllers. Database use REDO log and small
> > sequential IO, but those are targeted to SSDs, where latency and IOPs
> > are far more important than IO merging.
> > Anyway, this patch is opt-in for drivers, so any LLD that cannot take
> > advantage of the flag need not set it, and would work as-is.
> > I can provide a new version of the patch with this check removed
>
> Frankly speaking, we should check NONROT flag instead of controller,
> which may connect to slow HDD too, right?
>
> Thanks,
> Ming
>
