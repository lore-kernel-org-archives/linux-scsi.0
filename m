Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9ABC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 01:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C806A20885
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 01:07:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hjz5AzuF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKUBHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 20:07:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54995 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726784AbfKUBHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 20:07:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574298470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EMA1mi+epqlKukeQrbSFS2j99WJXSwyruMRk73Pu514=;
        b=Hjz5AzuFJHFN4rDuIXze8+DVW7Qn69NLDdgoi6lZgQ7gUSI7YDPQN5/n4nDlhtZr5u6te+
        /PnIUuOVnxXaQzyqpnRv1KPnUu4aCPaOOlVMEEfDFq8wgGWXf2+ARTtOJ0rF3GqSLEbOyS
        M6jjd1M3QdMwPcJJqYWwT8dAwqvW0hw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-91xZsREGMjyCsJxpFsUIfA-1; Wed, 20 Nov 2019 20:07:47 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 220BC1005509;
        Thu, 21 Nov 2019 01:07:45 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 051D03491F;
        Thu, 21 Nov 2019 01:07:34 +0000 (UTC)
Date:   Thu, 21 Nov 2019 09:07:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
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
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
Message-ID: <20191121010730.GD24548@ming.t460p>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
 <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
 <44644664-f7b6-facd-d1bb-f7cfc9524379@acm.org>
MIME-Version: 1.0
In-Reply-To: <44644664-f7b6-facd-d1bb-f7cfc9524379@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 91xZsREGMjyCsJxpFsUIfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2019 at 12:56:21PM -0800, Bart Van Assche wrote:
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
> How about changing the default behavior into ignoring sdev->queue_depth a=
nd
> only honoring sdev->queue_depth if a "quirk" flag is set or if overridden=
 by
> setting a sysfs attribute?

Using 'quirk' was my first idea in mind when we start to discuss the issue,=
 but
problem is that it isn't flexible, for example, one HBA may connects HDD. i=
n one
setting, and SSD. in another setting.

> My understanding is that the goal of the queue
> ramp-up/ramp-down mechanism is to reduce the number of times a SCSI devic=
e
> responds "BUSY".

I don't understand the motivation of ramp-up/ramp-down, maybe it is just
for fairness among LUNs. So far, blk-mq provides fair IO submission
among LUNs. One problem of ignoring it is that sequential IO performance
may be dropped much compared with before.

> An alternative for queue ramp-up/ramp-down is a delayed
> queue re-run. I think if scsi_queue_rq() returns BLK_STS_RESOURCE that th=
e
> queue is only rerun after a delay. From blk_mq_dispatch_rq_list():
>=20
> =09[ ... ]
> =09else if (needs_restart && (ret =3D=3D BLK_STS_RESOURCE))
> =09=09blk_mq_delay_run_hw_queue(hctx, BLK_MQ_RESOURCE_DELAY);

The delay re-run can't work given we call blk_mq_get_dispatch_budget()
before dequeuing request from scheduler/sw queue for improving IO merge.
At that time, run queue won't be involved.


Thanks,
Ming

