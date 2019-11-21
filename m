Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CD7C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 01:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C49F2089D
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 01:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SK0QEABb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfKUBem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 20:34:42 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40189 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbfKUBem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 20:34:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574300079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vdMMqIUW+n8fYrxJrWczQe7ROLNVgbAjr9VVaidR2SE=;
        b=SK0QEABbgMy6HnzG0Hevxg5xBiZJEskLDoYaUoGTRUNiblvRnWPMQ65bJAW4sjHYoZg4rA
        slNLiyWbZy2Hua9p+AvgF+/g3W6mYD1Mq4UoJPUqJhSX4Dd6N4WvJPlMIWD5GGZxqZqL6d
        QKbxKaEsKa80ClnUYhN1teuFuoKia+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-ffBQsPYjNWa1dlbdphx-CQ-1; Wed, 20 Nov 2019 20:34:36 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 205961800D45;
        Thu, 21 Nov 2019 01:34:34 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2971D34941;
        Thu, 21 Nov 2019 01:34:23 +0000 (UTC)
Date:   Thu, 21 Nov 2019 09:34:19 +0800
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
Message-ID: <20191121013419.GF24548@ming.t460p>
References: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
 <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
 <20191120072919.GB3664@ming.t460p>
 <CADbZ7FqP1EXrUOpD1QSd9MTRz1rgN6BLyhyd0i2r30bu_4xUCA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CADbZ7FqP1EXrUOpD1QSd9MTRz1rgN6BLyhyd0i2r30bu_4xUCA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: ffBQsPYjNWa1dlbdphx-CQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2019 at 12:59:56PM -0700, Sumanesh Samanta wrote:
> On Wed, Nov 20, 2019 at 12:29 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Tue, Nov 19, 2019 at 12:07:59PM -0800, Sumanesh Samanta wrote:
> > > From: root <sumanesh.samanta@broadcom.com>
> > >
> > > Recently a patch was delivered to remove host_busy counter from SCSI =
mid layer. That was a major bottleneck, and helped improve SCSI stack perfo=
rmance.
> > > With that patch, bottle neck moved to the scsi_device device_busy cou=
nter. The performance issue with this counter is seen more in cases where a=
 single device can produce very high IOPs, for example h/w RAID devices whe=
re OS sees one device, but there are many drives behind it, thus being capa=
ble of very high IOPs. The effect is also visible when cores from multiple =
NUMA nodes send IO to the same device or same controller.
> > > The device_busy counter is not needed by controllers which can manage=
 as many IO as submitted to it. Rotating media still uses it for merging IO=
, but for non-rotating SSD drives it becomes a major bottleneck as describe=
d above.
> > >
> > > A few weeks back, a patch was provided to address the device_busy cou=
nter also but unfortunately that had some issues:
> > > 1. There was a functional issue discovered:
> > > https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/VFKDTG4X=
C4VHWX5KKDJJI7P36EIGK526/
> > > 2. There was some concern about existing drivers using the device_bus=
y counter.
> >
> > There are only two drivers(mpt3sas and megaraid_sas) which uses this
> > counter. And there are two types of usage:
> >
> > 1) both use .device_busy to balance interrupt load among LUNs in
> > fast path
> >
> > 2) mpt3sas uses .device_busy in its device reset handler(slow path), an=
d
> > this kind of usage can be replaced by blk_mq_queue_tag_busy_iter()
> > easily.
> >
> > IMO, blk-mq has already considered IO load balance, see
> > hctx_may_queue(), meantime managed IRQ can balance IO completion load
> > among each IRQ vectors, not see obvious reason for driver to do that
> > any more.
> >
> > However, if the two drivers still want to do that, I'd suggest to imple=
ment
> > it inside the driver, and no reason to re-invent generic wheels just fo=
r
> > two drivers.
> >
> > That is why I replace .device_busy uses in the two drivers with private
> > counters in the patches posted days ago:
> >
> > https://lore.kernel.org/linux-scsi/20191118103117.978-1-ming.lei@redhat=
.com/T/#t
> >
>=20
> Agreed, a private counter should be good enough.
>=20
> > And if drivers thought the private counter isn't good enough, they can
> > improve it in any way, such as this percpu approach, or even kill them.
> >
>=20
> I was more concerned about the functional issue discovered in the
> earlier patch and provided mine as an alternative without any side
> effect or functional issue, since it does not modify any core logic.
> Having said that, if your latest patch goes through and is accepted,
> then agree that my patch is not needed. If however, some issue is
> discovered in your latest patch, then I would request my patch to be
> considered as an alternative, so that the device_busy counter overhead
> can be avoided
>=20
> > >
> > > This patch is an attempt to address both the above issues.
> > > For this patch to be effective, LLDs need to set a specific flag use_=
per_cpu_device_busy in the scsi_host_template. For other drivers ( who does=
 not set the flag), this patch would be a no-op, and should not affect thei=
r performance or functionality at all.
> > >
> > > Also, this patch does not fundamentally change any logic or functiona=
lity of the code. All it does is replace device_busy with a per CPU counter=
. In fast path, all cpu increment/decrement their own counter. In relativel=
y slow path. they call scsi_device_busy function to get the total no of IO =
outstanding on a device. Only functional aspect it changes is that for non-=
rotating media, the number of IO to a device is not restricted. Controllers=
 which can handle that, can set the use_per_cpu_device_busy flag in scsi_ho=
st_template to take advantage of this patch. Other controllers need not mod=
ify any code and would work as usual.
> > > Since the patch does not modify any other functional aspects, it shou=
ld not have any side effects even for drivers that do set the use_per_cpu_d=
evice_busy flag.
> > > ---
> > >  drivers/scsi/scsi_lib.c    | 151 ++++++++++++++++++++++++++++++++++-=
--
> > >  drivers/scsi/scsi_scan.c   |  16 ++++
> > >  drivers/scsi/scsi_sysfs.c  |   9 ++-
> > >  drivers/scsi/sg.c          |   2 +-
> > >  include/scsi/scsi_device.h |  15 ++++
> > >  include/scsi/scsi_host.h   |  16 ++++
> > >  6 files changed, 197 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 2563b061f56b..5dc392914f9e 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -52,6 +52,12 @@
> > >  #define  SCSI_INLINE_SG_CNT  2
> > >  #endif
> > >
> > > +#define MAX_PER_CPU_COUNTER_ABSOLUTE_VAL (0xFFFFFFFFFFF)
> > > +#define PER_CPU_COUNTER_OK_VAL (MAX_PER_CPU_COUNTER_ABSOLUTE_VAL>>16=
)
> > > +#define USE_DEVICE_BUSY(sdev)        (!(sdev)->host->hostt->use_per_=
cpu_device_busy \
> > > +                             || !blk_queue_nonrot((sdev)->request_qu=
eue))
> > > +
> > > +
> > >  static struct kmem_cache *scsi_sdb_cache;
> > >  static struct kmem_cache *scsi_sense_cache;
> > >  static struct kmem_cache *scsi_sense_isadma_cache;
> > > @@ -65,6 +71,111 @@ scsi_select_sense_cache(bool unchecked_isa_dma)
> > >       return unchecked_isa_dma ? scsi_sense_isadma_cache : scsi_sense=
_cache;
> > >  }
> > >
> > > +/*
> > > + *Generic helper function to decrement per cpu io counter.
> > > + *@per_cpu_counter: The per cpu counter array. Current cpu counter w=
ill be
> > > + * decremented
> > > + */
> > > +
> > > +static inline void dec_per_cpu_io_counter(atomic64_t __percpu *per_c=
pu_counter)
> > > +{
> > > +     atomic64_t __percpu *io_count =3D get_cpu_ptr(per_cpu_counter);
> > > +
> > > +     if (unlikely(abs(atomic64_dec_return(io_count)) >
> > > +                             MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> > > +             scsi_rebalance_per_cpu_io_counters(per_cpu_counter, io_=
count);
> > > +     put_cpu_ptr(per_cpu_counter);
> > > +}
> > > +/*
> > > + *Generic helper function to increment per cpu io counter.
> > > + *@per_cpu_counter: The per cpu counter array. Current cpu counter w=
ill be
> > > + * incremented
> > > + */
> > > +static inline void inc_per_cpu_io_counter(atomic64_t __percpu *per_c=
pu_counter)
> > > +{
> > > +     atomic64_t __percpu *io_count =3D get_cpu_ptr(per_cpu_counter);
> > > +
> > > +     if (unlikely(abs(atomic64_inc_return(io_count)) >
> > > +                             MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> > > +             scsi_rebalance_per_cpu_io_counters(per_cpu_counter, io_=
count);
> > > +     put_cpu_ptr(per_cpu_counter);
> > > +}
> > > +
> > > +
> > > +/**
> > > + * scsi_device_busy - Return the device_busy counter
> > > + * @sdev:    Pointer to scsi_device to get busy counter.
> > > + **/
> > > +int scsi_device_busy(struct scsi_device *sdev)
> > > +{
> > > +     long long total =3D 0;
> > > +     int i;
> > > +
> > > +     if (USE_DEVICE_BUSY(sdev))
> >
> > As Ewan and Bart commented, you can't use the NONROT queue flag simply
> > in IO path, given it may be changed somewhere.
> >
>=20
> I added the NONROT check just as an afterthought. This patch is
> designed for high end controllers, and most of them have some storage
> IO size limit.

IO size usually depends on workloads, instead of controller.

You can't assume that big size IO is always submitted from userspace
because HBA is high end.

For sequential IO workloads, block layer tries best to run IO merge,
which is usually big win for HDD.

> Also, for HDD sequential IO is almost always large and
> touch the controller max IO size limit.

No, there are workloads, single IO size isn't big, but
they are sequential, it may not be hit by readahead, such as
write. That is exactly what block layer has to run IO merge
for these small IOs.

> Thus, I am not sure merge
> matters for these kind of controllers. Database use REDO log and small
> sequential IO, but those are targeted to SSDs, where latency and IOPs
> are far more important than IO merging.
> Anyway, this patch is opt-in for drivers, so any LLD that cannot take
> advantage of the flag need not set it, and would work as-is.
> I can provide a new version of the patch with this check removed

Frankly speaking, we should check NONROT flag instead of controller,
which may connect to slow HDD too, right?

Thanks,
Ming

