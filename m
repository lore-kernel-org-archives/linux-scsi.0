Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DC9C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 02:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01ACB206A4
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 02:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FmXa9fYm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfKUCaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 21:30:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38697 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725819AbfKUCaV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 21:30:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574303420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tV0z8tD74raQUE/RldsvuzKkMSOMH3lprBVwapvdajw=;
        b=FmXa9fYmsETnZfgaihgEZci/zQ3TCdDp+mhUpp63c0zmvjGDlQoCYkzLjnXhEAG+AqY8ue
        jCzgoOfKaBqHYtmHjd/Xt/Wv6ATSqYr38ES5kZixEqtR9fAKvX8XWSISmMYu6gNjuVEq+t
        fS1EzV3xCC4raLa/GEzRhWZIgGofC3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-G54DyUyuOBKajZXgmttXbQ-1; Wed, 20 Nov 2019 21:24:10 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94285107ACC4;
        Thu, 21 Nov 2019 02:24:07 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 674EB5E268;
        Thu, 21 Nov 2019 02:23:58 +0000 (UTC)
Date:   Thu, 21 Nov 2019 10:23:53 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc:     Ewan Milne <emilne@redhat.com>, axboe@kernel.dk,
        bart.vanassche@wdc.com, hare@suse.de, hch@lst.de,
        jejb@linux.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
Message-ID: <20191121022353.GH24548@ming.t460p>
References: <c7c78e42173ad8bc6e8c775bf6e98f54@mail.gmail.com>
 <20191121012148.GE24548@ming.t460p>
 <CADbZ7Fqcx4rWLB7MMVj+J+9n0bMGENj-WZZijiOHN0WrL6OV0A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CADbZ7Fqcx4rWLB7MMVj+J+9n0bMGENj-WZZijiOHN0WrL6OV0A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: G54DyUyuOBKajZXgmttXbQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2019 at 06:50:02PM -0700, Sumanesh Samanta wrote:
> >>You just see large IO size from driver side or device side, and do you
> >>know why the big size IO is submitted to driver? Block layer's IO merge
> >>contributes a lot for that, and IO merge usually starts to work
>=20
> May be it contribute to some extent, but I do not think streaming
> applications have any incentive/reason to give small IO. An
> application like Netflix need to read as much data as soon as possible
> and serve to customers, they have no reason to read in small chunks.
> In fact, they read in huge chunks.
> That is why sequential IO is normally large chunks and random IO (
> which is more DB kind of operations ) is small IO.
> Only exception I know of is database REDO logs, that are small
> sequential IO, because there the DB is logging small transactions --
> but they go to SSDs.

We can't cover all typical workloads here, and I can write a application
easily to generate such sequential IO. Even though it is an unusual
workloads or application, someone still may report it as one regression,
so we can't risk to bypass .device_busy for HDD.

>=20
> >>Yeah, that is why my patches just bypass sdev->device_busy for SSD, and
> >>looks you misunderstood the idea behind the patches, right?
>=20
> No, I got the idea, I am just saying most high end controllers have an
> IO size limit  , and even if the block layer merges IO, it does not
> help, since they have to be broken to the max size the controller
> supports. Also, most high end controllers have their own merging
> logic, and hence not too much dependent on upper layer merging for
> them

If the controller's max size is exposed to block layer, block will
make a proper size IO for controller. I believe all sane drivers do
that.

Anyway using per-LUN NONROT flag is flexible and reasonable, which
won't need driver's change.=20


Thanks,=20
Ming

