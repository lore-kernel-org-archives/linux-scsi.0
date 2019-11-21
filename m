Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A0AC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 01:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2557220855
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 01:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P4lID8zk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKUBWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 20:22:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36354 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726346AbfKUBWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 20:22:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574299327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IEFLIlfhwoUVEK6Uek4N7eIm7XgJ3ryQ9qhAM1JqzTM=;
        b=P4lID8zkjWe0/tJdjVJJodVLRz1qz5CRJJ+80PThnhXPvyJq40srT+jTmF15BErWKLf/Xh
        F6nH/J2x1Uip/2xrUa5hJ2JZ3v1EyvBOMeSqg2qmm573LFoXR7Bnquo9ES5o4JNz8gT1Ug
        TWppqAp+cKNb+P6jpfRrLVbNyDJCWW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-Y2FhLhehOBmtf6EiO_UL6Q-1; Wed, 20 Nov 2019 20:22:04 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41F0C1005509;
        Thu, 21 Nov 2019 01:22:02 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFCCE5F91F;
        Thu, 21 Nov 2019 01:21:52 +0000 (UTC)
Date:   Thu, 21 Nov 2019 09:21:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc:     emilne@redhat.com, axboe@kernel.dk, bart.vanassche@wdc.com,
        hare@suse.de, hch@lst.de, jejb@linux.ibm.com,
        kashyap.desai@broadcom.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        suganath-prabu.subramani@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
Message-ID: <20191121012148.GE24548@ming.t460p>
References: <c7c78e42173ad8bc6e8c775bf6e98f54@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <c7c78e42173ad8bc6e8c775bf6e98f54@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: Y2FhLhehOBmtf6EiO_UL6Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2019 at 02:58:40PM -0700, Sumanesh Samanta wrote:
> >Ordinarily I'd prefer a host template attribute as Sumanesh proposed,
> >but I dislike wrapping the examination of that and the queue flag in
> >a macro that makes it not obvious how the behavior is affected.
>=20
> I think we can have a host template attribute and discard this check
> altogether, that is not check device_busy for both SDD and HDDs.
>=20
> As both you and Hannes mentioned, this change affects high end controller=
s
> most, and most of them have some storage IO size limit. Also, for HDD
> sequential IO is almost always large and
> touch the controller max IO size limit.

You just see large IO size from driver side or device side, and do you
know why the big size IO is submitted to driver? Block layer's IO merge
contributes a lot for that, and IO merge usually starts to work
after queue becomes busy which can be signaled from !blk_mq_get_dispatch_bu=
dget().

That is why we implements .get_budget and .put_budget on SCSI for fixing
sequential IO performance regression.

0df21c86bdbf scsi: implement .get_budget and .put_budget for blk-mq
aeec77629a4a scsi: allow passing in null rq to scsi_prep_state_check()
b347689ffbca blk-mq-sched: improve dispatching from sw queue
de1482974080 blk-mq: introduce .get_budget and .put_budget in blk_mq_ops

Also HDD may be connected to high end HBA too.

> Thus, I am not sure merge matters
> for these kind of controllers.

Yeah, that is why my patches just bypass sdev->device_busy for SSD, and
looks you misunderstood the idea behind the patches, right?



Thanks,=20
Ming

