Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B1DC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 21:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD6382133F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 21:36:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uzxh/XTt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKTVgw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 16:36:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21387 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbfKTVgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 16:36:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574285811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nl2xOgfKjuO8T4/NhaJ5YOwJbKZiJYEWxcxD/Ki4XI4=;
        b=Uzxh/XTtIJ4rkbojHRKe6AlN8Qodzfz+tRIAI9Xy9NBcR6pD9ZBjMCXRxcmVYze4gfa3RG
        JiXwgny67BxvJpqpvp3ndMZ9/yqeGzXAVHBbHjZ/pdni8BFEWNh7mx2SCnGcxe7H+KK/Fe
        sNyoLIiiFiNMvhXD/cLFaM9JJiW2ATE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-1AJYuSgKOz6C9gtntwd3ig-1; Wed, 20 Nov 2019 16:36:48 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B85E1802D14;
        Wed, 20 Nov 2019 21:36:46 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C024F5D6D0;
        Wed, 20 Nov 2019 21:36:41 +0000 (UTC)
Message-ID: <f5b78ec7c0e6fec69950cace8531eb342987c0b9.camel@redhat.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Date:   Wed, 20 Nov 2019 16:36:41 -0500
In-Reply-To: <44644664-f7b6-facd-d1bb-f7cfc9524379@acm.org>
References: <20191118103117.978-1-ming.lei@redhat.com>
         <20191118103117.978-5-ming.lei@redhat.com>
         <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
         <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
         <44644664-f7b6-facd-d1bb-f7cfc9524379@acm.org>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 1AJYuSgKOz6C9gtntwd3ig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2019-11-20 at 12:56 -0800, Bart Van Assche wrote:
> On 11/20/19 9:00 AM, Ewan D. Milne wrote:
> > On Wed, 2019-11-20 at 11:05 +0100, Hannes Reinecke wrote:
> > > I must admit I patently don't like this explicit dependency on
> > > blk_nonrot(). Having a conditional counter is just an open invitation=
 to
> > > getting things wrong...
> >=20
> > This concerns me as well, it seems like the SCSI ML should have it's
> > own per-device attribute if we actually need to control this per-device
> > instead of on a per-host or per-driver basis.  And it seems like this
> > is something that is specific to high-performance drivers, so changing
> > the way this works for all drivers seems a bit much.
> >=20
> > Ordinarily I'd prefer a host template attribute as Sumanesh proposed,
> > but I dislike wrapping the examination of that and the queue flag in
> > a macro that makes it not obvious how the behavior is affected.
> > (Plus Hannes just submitted submitted the patches to remove .use_cmd_li=
st,
> > which was another piece of ML functionality used by only a few drivers.=
)
> >=20
> > Ming's patch does freeze the queue if NONROT is changed by sysfs, but
> > the flag can be changed by other kernel code, e.g. sd_revalidate_disk()
> > clears it and then calls sd_read_block_characteristics() which may set
> > it again.  So it's not clear to me how reliable this is.
>=20
> How about changing the default behavior into ignoring sdev->queue_depth=
=20
> and only honoring sdev->queue_depth if a "quirk" flag is set or if=20
> overridden by setting a sysfs attribute? My understanding is that the=20
> goal of the queue ramp-up/ramp-down mechanism is to reduce the number of=
=20
> times a SCSI device responds "BUSY". An alternative for queue=20
> ramp-up/ramp-down is a delayed queue re-run. I think if scsi_queue_rq()=
=20
> returns BLK_STS_RESOURCE that the queue is only rerun after a delay.=20
>  From blk_mq_dispatch_rq_list():
>=20
> =09[ ... ]
> =09else if (needs_restart && (ret =3D=3D BLK_STS_RESOURCE))
> =09=09blk_mq_delay_run_hw_queue(hctx, BLK_MQ_RESOURCE_DELAY);
>=20
> Bart.

In general it is better not to put in changes that affect older drivers
that are not regularly tested, I think.  I would prefer an opt-in for
drivers desiring higher performance.

Delaying the queue re-run vs. a ramp down might negatively affect performan=
ce.
I'm not sure how accurate the ramp is at discovering the optimum though.

-Ewan

