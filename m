Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88305C56202
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 08:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A6720B80
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 08:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMOzUjje"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgKZIOD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 03:14:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729107AbgKZIOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Nov 2020 03:14:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606378442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lzOZ0+ORGJBLPor/ndG4DzkjsuKwEIa25PWAxEo/TLA=;
        b=VMOzUjjeTXLKyuJmAgCzxX5K4iP1hgTIWzKg8zXPGg4WKu9D/Fnx1OZFkR4C2bcEOqzI3u
        jvh5jfzUwb8fjTorzS5WFCz2G6usRtqf0VFqYfT4Xl4cE0MQLjICqp4rbD+Anfts2oMRGs
        ewWv1rvpTYruzr7HEJ1/ZwMSPyeBgFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-o6oKrDUFPBex5xHfYOV6ew-1; Thu, 26 Nov 2020 03:13:59 -0500
X-MC-Unique: o6oKrDUFPBex5xHfYOV6ew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15B1E8143E5;
        Thu, 26 Nov 2020 08:13:58 +0000 (UTC)
Received: from gondolin (ovpn-113-125.ams2.redhat.com [10.36.113.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38D7860855;
        Thu, 26 Nov 2020 08:13:55 +0000 (UTC)
Date:   Thu, 26 Nov 2020 09:13:53 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: zfcp: fix use-after-free in zfcp_unit_remove
Message-ID: <20201126091353.50cf6ab6.cohuck@redhat.com>
In-Reply-To: <4c65bead-2553-171e-54d2-87a9de0330e8@huawei.com>
References: <20201120074854.31754-1-miaoqinglang@huawei.com>
        <20201125170658.GB8578@t480-pf1aa2c2>
        <4c65bead-2553-171e-54d2-87a9de0330e8@huawei.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 26 Nov 2020 09:27:41 +0800
Qinglang Miao <miaoqinglang@huawei.com> wrote:

> =E5=9C=A8 2020/11/26 1:06, Benjamin Block =E5=86=99=E9=81=93:
> > On Fri, Nov 20, 2020 at 03:48:54PM +0800, Qinglang Miao wrote: =20
> >> kfree(port) is called in put_device(&port->dev) so that following
> >> use would cause use-after-free bug.
> >>
> >> The former put_device is redundant for device_unregister contains
> >> put_device already. So just remove it to fix this.
> >>
> >> Fixes: 86bdf218a717 ("[SCSI] zfcp: cleanup unit sysfs attribute usage")
> >> Reported-by: Hulk Robot <hulkci@huawei.com>
> >> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> >> ---
> >>   drivers/s390/scsi/zfcp_unit.c | 2 --
> >>   1 file changed, 2 deletions(-)
> >>
> >> diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_un=
it.c
> >> index e67bf7388..664b77853 100644
> >> --- a/drivers/s390/scsi/zfcp_unit.c
> >> +++ b/drivers/s390/scsi/zfcp_unit.c
> >> @@ -255,8 +255,6 @@ int zfcp_unit_remove(struct zfcp_port *port, u64 f=
cp_lun)
> >>   		scsi_device_put(sdev);
> >>   	}
> >>  =20
> >> -	put_device(&unit->dev);
> >> -
> >>   	device_unregister(&unit->dev); =20
> >>  >>   	return 0; =20
> >=20
> > Same as in the other mail for `zfcp_sysfs_port_remove_store()`. We
> > explicitly get a new ref in `_zfcp_unit_find()`, so we also need to put
> > that away again.
> > =20
> Sorry, Benjamin, I don't think so, because device_unregister calls=20
> put_device inside.
>=20
> It seem's that another put_device before or after device_unregister is=20
> useless and even might cause an use-after-free.

The issue here (and in the other patches that I had commented on) is
that the references have different origins. device_register() acquires
a reference, and that reference is given up when you call
device_unregister(). However, the code here grabs an extra reference,
and it of course has to give it up again when it no longer needs it.

This is something that is not that easy to spot by an automated check,
I guess?

