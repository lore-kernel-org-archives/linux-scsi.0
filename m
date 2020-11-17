Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99A6C64E69
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A85C32467A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7ayO/c/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgKQQJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 11:09:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727088AbgKQQJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 11:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605629345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3i2vVvvOi2W9Eple+UW0eM1PUkTGmgXQgzpxOR9aJuE=;
        b=Z7ayO/c/zK/XAYhq8fZTHgaN3BiH/fJup/75r6dlHGXjTXAvb71FQGMomtxsi9TZ/vgk53
        EiGG5XcgdtAJQTyW6TLCyOOgH3yPs57P6hcZlrMP1iuFyZ/P5EayopCBQVAt7Rlu39w+hK
        qAGlQDOYXzf5rivHbd748Q1Vqw85PJs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-VpFiKt-KOiC96pjbfOimbw-1; Tue, 17 Nov 2020 11:09:01 -0500
X-MC-Unique: VpFiKt-KOiC96pjbfOimbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31C6B803639;
        Tue, 17 Nov 2020 16:08:59 +0000 (UTC)
Received: from localhost (ovpn-115-113.ams2.redhat.com [10.36.115.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A08695D9CC;
        Tue, 17 Nov 2020 16:08:55 +0000 (UTC)
Date:   Tue, 17 Nov 2020 16:08:54 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 08/10] vhost: move msg_handler to new ops struct
Message-ID: <20201117160854.GQ131917@stefanha-x1.localdomain>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <1605223150-10888-10-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1605223150-10888-10-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZqRzwd/9tauJXEMK"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--ZqRzwd/9tauJXEMK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2020 at 05:19:08PM -0600, Mike Christie wrote:
> The next patch adds a callout so drivers can perform some action when we
> get a VHOST_SET_VRING_ENABLE, so this patch moves the msg_handler callout
> to a new vhost_dev_ops struct just to keep all the callouts better
> organized.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/vdpa.c  |  7 +++++--
>  drivers/vhost/vhost.c | 10 ++++------
>  drivers/vhost/vhost.h | 11 ++++++-----
>  3 files changed, 15 insertions(+), 13 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ZqRzwd/9tauJXEMK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+z9ZYACgkQnKSrs4Gr
c8iTLAf/SIfQoFH/hado2LWXqJUBjlFoJBf3G+Xc4B9v2c6vKOYX4BYDwU3J+Pq3
qlKZK8jppabIJ78gjFaGio8UcAnhgv2ee104+8VTYttjWYArerGwkS3MaOkX+W9s
yP1Z3P0cFHVDacOvjLsnO4V5pNjLRhWLtQ3iMO0Uz5Q9ezQ/sGfZ2oifLd67WWyK
HwTJCrYeul1A7BkJOek6rSstc3B/W5Ab1mb/Ne2ecSiS/R7jfxbns7HiKYzyz6dS
KgheSYDIEDobKmsfjtN4lSktSbB0N9/mLb8gKqFslgyxgk2KHMljlu/YyXmezWOC
e79+SiNJGPuLU9uHvUonogGzkY+4uA==
=g9Qu
-----END PGP SIGNATURE-----

--ZqRzwd/9tauJXEMK--

