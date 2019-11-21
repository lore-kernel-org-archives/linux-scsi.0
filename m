Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543B7C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 19:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C289206CC
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 19:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AJ/eclEn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKUTTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 14:19:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45873 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726546AbfKUTTi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 14:19:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574363976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zv/iZ/7iNVXktTSWMBYCInxJ10DtWIchWCIKy4SGAIk=;
        b=AJ/eclEnSTG/+MJo4bVeDsHdGEPCBdnrXPAaZ1KZqS2D9LWerf003FyL1XnzFDsmewGK80
        q9FeQIEx2W4BnFSbdef8I0gfS53nhXD2X12zLs+0PRmCPLENfedVTqjmon65SySnoKmraE
        OpHnK1SFphPPuUwCzxfe3ZJ1wwHR03s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-2Gk-B0iePGudDSZSjCBsPg-1; Thu, 21 Nov 2019 14:19:33 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BF3918C897A;
        Thu, 21 Nov 2019 19:19:31 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA6B51037AB1;
        Thu, 21 Nov 2019 19:19:27 +0000 (UTC)
Message-ID: <5f2a9e5cc4e7832874d5d9ebd204cd8a53695b04.camel@redhat.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
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
Date:   Thu, 21 Nov 2019 14:19:26 -0500
In-Reply-To: <20191121005458.GC24548@ming.t460p>
References: <20191118103117.978-1-ming.lei@redhat.com>
         <20191118103117.978-5-ming.lei@redhat.com>
         <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
         <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
         <20191121005458.GC24548@ming.t460p>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 2Gk-B0iePGudDSZSjCBsPg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2019-11-21 at 08:54 +0800, Ming Lei wrote:
> On Wed, Nov 20, 2019 at 12:00:19PM -0500, Ewan D. Milne wrote:
> > On Wed, 2019-11-20 at 11:05 +0100, Hannes Reinecke wrote:
> > >=20
> > > Hmm.
> > >=20
> > > I must admit I patently don't like this explicit dependency on
> > > blk_nonrot(). Having a conditional counter is just an open invitation=
 to
> > > getting things wrong...
> > >=20
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
> The queue freeze is applied in sd_revalidate_disk() too, isn't it?
>=20

Yes, sorry, you are right, your patch does add this.  But if anything else =
changes
the NONROT attribute for a queue associated with a SCSI device in the futur=
e
it would have to freeze the queue.  Because the device_busy counter mechani=
sm
would rely on it to work right.  This isn't an obvious connection, it seems=
 to me.

-Ewan

