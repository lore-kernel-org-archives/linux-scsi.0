Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920F7C43215
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 07:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66E3A2245D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 07:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gj76bub4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfKTH3m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 02:29:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726380AbfKTH3m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 02:29:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574234980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qh1jIN8T5r6Yn1nEjc291k5Sa/J7IM0gritglFe5gJM=;
        b=Gj76bub49uMXUOJJQYaKQQ0X2Tvj+yz7vjkeAODp8ttrEZqmUNAi3u2Djcx5UnnfTetcop
        rKBIDpV4Kcb9pTUMgWYcQuBI+ECVBQ2/VCKRzrme7bOMpAe097V7YQjwGzf9FQykHC+t4e
        TsFmALWpqlgl0LQWgskMI0dJBb49M1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-1isBW-BSMnCFB7TppGgU9A-1; Wed, 20 Nov 2019 02:29:36 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 936E01005509;
        Wed, 20 Nov 2019 07:29:34 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A8EED6049A;
        Wed, 20 Nov 2019 07:29:24 +0000 (UTC)
Date:   Wed, 20 Nov 2019 15:29:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com,
        suganath-prabu.subramani@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        emilne@redhat.com, hch@lst.de, hare@suse.de, bart.vanassche@wdc.com
Subject: Re: [PATCH 1/1] scsi core: limit overhead of device_busy counter for
 SSDs
Message-ID: <20191120072919.GB3664@ming.t460p>
References: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
 <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
MIME-Version: 1.0
In-Reply-To: <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 1isBW-BSMnCFB7TppGgU9A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 19, 2019 at 12:07:59PM -0800, Sumanesh Samanta wrote:
> From: root <sumanesh.samanta@broadcom.com>
>=20
> Recently a patch was delivered to remove host_busy counter from SCSI mid =
layer. That was a major bottleneck, and helped improve SCSI stack performan=
ce.
> With that patch, bottle neck moved to the scsi_device device_busy counter=
. The performance issue with this counter is seen more in cases where a sin=
gle device can produce very high IOPs, for example h/w RAID devices where O=
S sees one device, but there are many drives behind it, thus being capable =
of very high IOPs. The effect is also visible when cores from multiple NUMA=
 nodes send IO to the same device or same controller.
> The device_busy counter is not needed by controllers which can manage as =
many IO as submitted to it. Rotating media still uses it for merging IO, bu=
t for non-rotating SSD drives it becomes a major bottleneck as described ab=
ove.
>=20
> A few weeks back, a patch was provided to address the device_busy counter=
 also but unfortunately that had some issues:
> 1. There was a functional issue discovered:
> https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/VFKDTG4XC4VH=
WX5KKDJJI7P36EIGK526/
> 2. There was some concern about existing drivers using the device_busy co=
unter.

There are only two drivers(mpt3sas and megaraid_sas) which uses this
counter. And there are two types of usage:

1) both use .device_busy to balance interrupt load among LUNs in
fast path

2) mpt3sas uses .device_busy in its device reset handler(slow path), and
this kind of usage can be replaced by blk_mq_queue_tag_busy_iter()
easily.

IMO, blk-mq has already considered IO load balance, see
hctx_may_queue(), meantime managed IRQ can balance IO completion load
among each IRQ vectors, not see obvious reason for driver to do that
any more.

However, if the two drivers still want to do that, I'd suggest to implement
it inside the driver, and no reason to re-invent generic wheels just for
two drivers.

That is why I replace .device_busy uses in the two drivers with private
counters in the patches posted days ago:

https://lore.kernel.org/linux-scsi/20191118103117.978-1-ming.lei@redhat.com=
/T/#t

And if drivers thought the private counter isn't good enough, they can
improve it in any way, such as this percpu approach, or even kill them.

>=20
> This patch is an attempt to address both the above issues.
> For this patch to be effective, LLDs need to set a specific flag use_per_=
cpu_device_busy in the scsi_host_template. For other drivers ( who does not=
 set the flag), this patch would be a no-op, and should not affect their pe=
rformance or functionality at all.
>=20
> Also, this patch does not fundamentally change any logic or functionality=
 of the code. All it does is replace device_busy with a per CPU counter. In=
 fast path, all cpu increment/decrement their own counter. In relatively sl=
ow path. they call scsi_device_busy function to get the total no of IO outs=
tanding on a device. Only functional aspect it changes is that for non-rota=
ting media, the number of IO to a device is not restricted. Controllers whi=
ch can handle that, can set the use_per_cpu_device_busy flag in scsi_host_t=
emplate to take advantage of this patch. Other controllers need not modify =
any code and would work as usual.
> Since the patch does not modify any other functional aspects, it should n=
ot have any side effects even for drivers that do set the use_per_cpu_devic=
e_busy flag.
> ---
>  drivers/scsi/scsi_lib.c    | 151 ++++++++++++++++++++++++++++++++++---
>  drivers/scsi/scsi_scan.c   |  16 ++++
>  drivers/scsi/scsi_sysfs.c  |   9 ++-
>  drivers/scsi/sg.c          |   2 +-
>  include/scsi/scsi_device.h |  15 ++++
>  include/scsi/scsi_host.h   |  16 ++++
>  6 files changed, 197 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2563b061f56b..5dc392914f9e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -52,6 +52,12 @@
>  #define  SCSI_INLINE_SG_CNT  2
>  #endif
> =20
> +#define MAX_PER_CPU_COUNTER_ABSOLUTE_VAL (0xFFFFFFFFFFF)
> +#define PER_CPU_COUNTER_OK_VAL (MAX_PER_CPU_COUNTER_ABSOLUTE_VAL>>16)
> +#define USE_DEVICE_BUSY(sdev)=09(!(sdev)->host->hostt->use_per_cpu_devic=
e_busy \
> +=09=09=09=09|| !blk_queue_nonrot((sdev)->request_queue))
> +
> +
>  static struct kmem_cache *scsi_sdb_cache;
>  static struct kmem_cache *scsi_sense_cache;
>  static struct kmem_cache *scsi_sense_isadma_cache;
> @@ -65,6 +71,111 @@ scsi_select_sense_cache(bool unchecked_isa_dma)
>  =09return unchecked_isa_dma ? scsi_sense_isadma_cache : scsi_sense_cache=
;
>  }
> =20
> +/*
> + *Generic helper function to decrement per cpu io counter.
> + *@per_cpu_counter: The per cpu counter array. Current cpu counter will =
be
> + * decremented
> + */
> +
> +static inline void dec_per_cpu_io_counter(atomic64_t __percpu *per_cpu_c=
ounter)
> +{
> +=09atomic64_t __percpu *io_count =3D get_cpu_ptr(per_cpu_counter);
> +
> +=09if (unlikely(abs(atomic64_dec_return(io_count)) >
> +=09=09=09=09MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> +=09=09scsi_rebalance_per_cpu_io_counters(per_cpu_counter, io_count);
> +=09put_cpu_ptr(per_cpu_counter);
> +}
> +/*
> + *Generic helper function to increment per cpu io counter.
> + *@per_cpu_counter: The per cpu counter array. Current cpu counter will =
be
> + * incremented
> + */
> +static inline void inc_per_cpu_io_counter(atomic64_t __percpu *per_cpu_c=
ounter)
> +{
> +=09atomic64_t __percpu *io_count =3D=09get_cpu_ptr(per_cpu_counter);
> +
> +=09if (unlikely(abs(atomic64_inc_return(io_count)) >
> +=09=09=09=09MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
> +=09=09scsi_rebalance_per_cpu_io_counters(per_cpu_counter, io_count);
> +=09put_cpu_ptr(per_cpu_counter);
> +}
> +
> +
> +/**
> + * scsi_device_busy - Return the device_busy counter
> + * @sdev:=09Pointer to scsi_device to get busy counter.
> + **/
> +int scsi_device_busy(struct scsi_device *sdev)
> +{
> +=09long long total =3D 0;
> +=09int i;
> +
> +=09if (USE_DEVICE_BUSY(sdev))

As Ewan and Bart commented, you can't use the NONROT queue flag simply
in IO path, given it may be changed somewhere.

Thanks,
Ming

