Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14122C43215
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 03:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD3A02082F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 03:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WLrrl7Zi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfKZDiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 22:38:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20402 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727130AbfKZDiQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 22:38:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574739495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+n9SatzmowdgG7REE3dGVmFt6Fy1TIxHGjnbYR/7jZA=;
        b=WLrrl7ZiOd7bFvQYG/oKv4nxdFti/a6IfQ0CqYwTHE1cgy8f+uYZv5YNOPbZdNehcrVbVk
        MGdRIcsMSEPvxQrLbBkJm4VXxydi1j20sY7EQJ4M+4cpaX726/yto3ovSqPwUlNedkTfsG
        5PN/TePcCid6c32xG+U8CVmPjfXQVOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-RMlPUSE9MeG-LACu4BYSTg-1; Mon, 25 Nov 2019 22:38:12 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35EF7100726C;
        Tue, 26 Nov 2019 03:38:10 +0000 (UTC)
Received: from ming.t460p (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90EC0600C6;
        Tue, 26 Nov 2019 03:38:00 +0000 (UTC)
Date:   Tue, 26 Nov 2019 11:37:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 1/4] scsi: megaraid_sas: use private counter for tracking
 inflight per-LUN commands
Message-ID: <20191126033755.GE24501@ming.t460p>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-2-ming.lei@redhat.com>
 <97bf460e-62c9-dc64-db4c-fb5540e70ae9@suse.de>
 <252362ee5ac748694d205441729c433f@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <252362ee5ac748694d205441729c433f@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: RMlPUSE9MeG-LACu4BYSTg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 26, 2019 at 08:42:59AM +0530, Kashyap Desai wrote:
> > >  drivers/scsi/megaraid/megaraid_sas.h        |  1 +
> > >  drivers/scsi/megaraid/megaraid_sas_base.c   | 15 +++++++++++++--
> > >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 13 +++++++++----
> > >  3 files changed, 23 insertions(+), 6 deletions(-)
> > >
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
>=20
> Ming - Sorry for delay. I will update this Patch. We prefer driver to
> avoid counter for per sdev if possible. We are currently testing driver
> using below changes.
>=20
> inline unsigned long sdev_nr_inflight_request(struct request_queue *q) {
>     struct blk_mq_hw_ctx *hctx =3D q->queue_hw_ctx[0]
>=20
>     return atomic_read(&hctx->nr_active);
> }

OK, I am fine with this way, given it is just used for balancing irq load.


Thanks,
Ming

