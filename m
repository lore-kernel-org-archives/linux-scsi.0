Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5942C43215
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 20:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B0562075E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 20:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fXYHv7HW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfKTUAL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 15:00:11 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41956 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfKTUAL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 15:00:11 -0500
Received: by mail-wr1-f65.google.com with SMTP id b18so1381832wrj.8
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2019 12:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qel/Qp9Fo4wMUlCl4DO6D3RTsT7v4Klswcvp9ktFJ+o=;
        b=fXYHv7HW2Cu4Za7sgOU7gtmDy6miBHEWfa+rW4qNBYDGhzSIyTA2MnRhKwFSCeWftW
         POplkaSbT6FmP7mtK57mZTyrubyzgZMAyu9g5Rw/FWf3wMFIBQH5NxJPFQLH1GBE8trb
         ywGZCrXpiDg53E5lE+jZcGMLsBsVYSq5PSwaU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qel/Qp9Fo4wMUlCl4DO6D3RTsT7v4Klswcvp9ktFJ+o=;
        b=GfwNYIznIY49+ChbiExXHFk+SbnZ7pdBUcKLvl3qeisCPN41fEOO6m3wsHD7/MZHFj
         ULX8Ai3+BN+FLxOyxpHlvEKMhucrw/B4l429bPzp97LRsRNBbpHJ6gbYQOJ4w7aQSVU0
         8QQdqnTAhEPIPcW44Kx3DWCAAzSaNc2KlSomV6rsKO6k7VQHley1FJtTpnvituHEj4ZB
         pYHI4/VA1nDuxoDzFGVlZ23omHb96GIDi/0dLEOiXDAgsTYk/d0VBcDtSu6YExYSZqrU
         V/bo7sDfB2q9wRIDrhyZUETzfSv5HX5APVI6Ltu+1lKV8G+Fa0OFrgD+YrOSsPMXjfq6
         m+Pw==
X-Gm-Message-State: APjAAAVDPzUDaJH2RiAgmcgfSe3cPjd5EBDC3zqGGXYbIzi/RU2O2QIN
        EzswmQsLSBaVlJbGkz0uqWxmyS1QYO+Z4OH2D2XDXQ==
X-Google-Smtp-Source: APXvYqysLEYlp7kZ7WW4ZVjlUT5rXyQt8eif4tkNKyubxOdwTnU5T5LTpmyJPj49SGd/IPftQL+Fc5vyM7G9G/ZgQyE=
X-Received: by 2002:adf:db4e:: with SMTP id f14mr5543676wrj.257.1574280008151;
 Wed, 20 Nov 2019 12:00:08 -0800 (PST)
MIME-Version: 1.0
References: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
 <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com> <20191120072919.GB3664@ming.t460p>
In-Reply-To: <20191120072919.GB3664@ming.t460p>
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Date:   Wed, 20 Nov 2019 12:59:56 -0700
Message-ID: <CADbZ7FqP1EXrUOpD1QSd9MTRz1rgN6BLyhyd0i2r30bu_4xUCA@mail.gmail.com>
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

On Wed, Nov 20, 2019 at 12:29 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Tue, Nov 19, 2019 at 12:07:59PM -0800, Sumanesh Samanta wrote:
> > From: root <sumanesh.samanta@broadcom.com>
> >
> > Recently a patch was delivered to remove host_busy counter from SCSI mi=
d layer. That was a major bottleneck, and helped improve SCSI stack perform=
ance.
> > With that patch, bottle neck moved to the scsi_device device_busy count=
er. The performance issue with this counter is seen more in cases where a s=
ingle device can produce very high IOPs, for example h/w RAID devices where=
 OS sees one device, but there are many drives behind it, thus being capabl=
e of very high IOPs. The effect is also visible when cores from multiple NU=
MA nodes send IO to the same device or same controller.
> > The device_busy counter is not needed by controllers which can manage a=
s many IO as submitted to it. Rotating media still uses it for merging IO, =
but for non-rotating SSD drives it becomes a major bottleneck as described =
above.
> >
> > A few weeks back, a patch was provided to address the device_busy count=
er also but unfortunately that had some issues:
> > 1. There was a functional issue discovered:
> > https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/VFKDTG4XC4=
VHWX5KKDJJI7P36EIGK526/
> > 2. There was some concern about existing drivers using the device_busy =
counter.
>
> There are only two drivers(mpt3sas and megaraid_sas) which uses this
> counter. And there are two types of usage:
>
> 1) both use .device_busy to balance interrupt load among LUNs in
> fast path
>
> 2) mpt3sas uses .device_busy in its device reset handler(slow path), and
> this kind of usage can be replaced by blk_mq_queue_tag_busy_iter()
> easily.
>
> IMO, blk-mq has already considered IO load balance, see
> hctx_may_queue(), meantime managed IRQ can balance IO completion load
> among each IRQ vectors, not see obvious reason for driver to do that
> any more.
>
> However, if the two drivers still want to do that, I'd suggest to impleme=
nt
> it inside the driver, and no reason to re-invent generic wheels just for
> two drivers.
>
> That is why I replace .device_busy uses in the two drivers with private
> counters in the patches posted days ago:
>
> https://lore.kernel.org/linux-scsi/20191118103117.978-1-ming.lei@redhat.c=
om/T/#t
>

Agreed, a private counter should be good enough.

> And if drivers thought the private counter isn't good enough, they can
> improve it in any way, such as this percpu approach, or even kill them.
>

I was more concerned about the functional issue discovered in the
earlier patch and provided mine as an alternative without any side
effect or functional issue, since it does not modify any core logic.
Having said that, if your latest patch goes through and is accepted,
then agree that my patch is not needed. If however, some issue is
discovered in your latest patch, then I would request my patch to be
considered as an alternative, so that the device_busy counter overhead
can be avoided

> >
> > This patch is an attempt to address both the above issues.
> > For this patch to be effective, LLDs need to set a specific flag use_pe=
r_cpu_device_busy in the scsi_host_template. For other drivers ( who does n=
ot set the flag), this patch would be a no-op, and should not affect their =
performance or functionality at all.
> >
> > Also, this patch does not fundamentally change any logic or functionali=
ty of the code. All it does is replace device_busy with a per CPU counter. =
In fast path, all cpu increment/decrement their own counter. In relatively =
slow path. they call scsi_device_busy function to get the total no of IO ou=
tstanding on a device. Only functional aspect it changes is that for non-ro=
tating media, the number of IO to a device is not restricted. Controllers w=
hich can handle that, can set the use_per_cpu_device_busy flag in scsi_host=
_template to take advantage of this patch. Other controllers need not modif=
y any code and would work as usual.
> > Since the patch does not modify any other functional aspects, it should=
 not have any side effects even for drivers that do set the use_per_cpu_dev=
ice_busy flag.
> > ---
> >  drivers/scsi/scsi_lib.c    | 151 ++++++++++++++++++++++++++++++++++---
> >  drivers/scsi/scsi_scan.c   |  16 ++++
> >  drivers/scsi/scsi_sysfs.c  |   9 ++-
> >  drivers/scsi/sg.c          |   2 +-
> >  include/scsi/scsi_device.h |  15 ++++
> >  include/scsi/scsi_host.h   |  16 ++++
> >  6 files changed, 197 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 2563b061f56b..5dc392914f9e 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -52,6 +52,12 @@
> >  #define  SCSI_INLINE_SG_CNT  2
> >  #endif
> >
> > +#define MAX_PER_CPU_COUNTER_ABSOLUTE_VAL (0xFFFFFFFFFFF)
> > +#define PER_CPU_COUNTER_OK_VAL (MAX_PER_CPU_COUNTER_ABSOLUTE_VAL>>16)
> > +#define USE_DEVICE_BUSY(sdev)        (!(sdev)->host->hostt->use_per_cp=
u_device_busy \
> > +                             || !blk_queue_nonrot((sdev)->request_queu=
e))
> > +
> > +
> >  static struct kmem_cache *scsi_sdb_cache;
> >  static struct kmem_cache *scsi_sense_cache;
> >  static struct kmem_cache *scsi_sense_isadma_cache;
> > @@ -65,6 +71,111 @@ scsi_select_sense_cache(bool unchecked_isa_dma)
> >       return unchecked_isa_dma ? scsi_sense_isadma_cache : scsi_sense_c=
ache;
> >  }
> >
> > +/*
> > + *Generic helper function to decrement per cpu io counter.
> > + *@per_cpu_counter: The per cpu counter array. Current cpu counter wil=
l be
> > + * decremented
> > + */
> > +
> > +static inline void dec_per_cpu_io_counter(atomic64_t __percpu *per_cpu=
_counter)
> > +{
> > +     atomic64_t __percpu *io_count =3D get_cpu_ptr(per_cpu_counter);
> > +
> > +     if (unlikely(abs(atomic64_dec_return(io_count)) >
> > +                             MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> > +             scsi_rebalance_per_cpu_io_counters(per_cpu_counter, io_co=
unt);
> > +     put_cpu_ptr(per_cpu_counter);
> > +}
> > +/*
> > + *Generic helper function to increment per cpu io counter.
> > + *@per_cpu_counter: The per cpu counter array. Current cpu counter wil=
l be
> > + * incremented
> > + */
> > +static inline void inc_per_cpu_io_counter(atomic64_t __percpu *per_cpu=
_counter)
> > +{
> > +     atomic64_t __percpu *io_count =3D get_cpu_ptr(per_cpu_counter);
> > +
> > +     if (unlikely(abs(atomic64_inc_return(io_count)) >
> > +                             MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> > +             scsi_rebalance_per_cpu_io_counters(per_cpu_counter, io_co=
unt);
> > +     put_cpu_ptr(per_cpu_counter);
> > +}
> > +
> > +
> > +/**
> > + * scsi_device_busy - Return the device_busy counter
> > + * @sdev:    Pointer to scsi_device to get busy counter.
> > + **/
> > +int scsi_device_busy(struct scsi_device *sdev)
> > +{
> > +     long long total =3D 0;
> > +     int i;
> > +
> > +     if (USE_DEVICE_BUSY(sdev))
>
> As Ewan and Bart commented, you can't use the NONROT queue flag simply
> in IO path, given it may be changed somewhere.
>

I added the NONROT check just as an afterthought. This patch is
designed for high end controllers, and most of them have some storage
IO size limit. Also, for HDD sequential IO is almost always large and
touch the controller max IO size limit. Thus, I am not sure merge
matters for these kind of controllers. Database use REDO log and small
sequential IO, but those are targeted to SSDs, where latency and IOPs
are far more important than IO merging.
Anyway, this patch is opt-in for drivers, so any LLD that cannot take
advantage of the flag need not set it, and would work as-is.
I can provide a new version of the patch with this check removed

> Thanks,
> Ming
>
