Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E694BC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 14:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CF5621734
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 14:07:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABXCpXkH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgKQOGY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 09:06:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729220AbgKQNIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 08:08:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605618483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Lg/Z4Afo5hxT/KugPsnPGAOmJRCi/NRgTpP62lvgaI=;
        b=ABXCpXkHBSTx4vv3w1h8VmnoHhRVuZBI51jG5goje4+GAUFbOxUQfVeYWFMO1MOnMNr49e
        20ENT+/hoh0kSdZUEU59mGEcBkj5YSoXv6N5HxPfhYD56DK0CX29VO/lw8n+ZXRJCw/wQG
        zz/Qm+4y29jPmh5szV1PA7kIioSHCG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-ptnvOMjXPqeBoGKu0-1OoQ-1; Tue, 17 Nov 2020 08:07:28 -0500
X-MC-Unique: ptnvOMjXPqeBoGKu0-1OoQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF769100747C;
        Tue, 17 Nov 2020 13:07:26 +0000 (UTC)
Received: from localhost (ovpn-115-113.ams2.redhat.com [10.36.115.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63558176BB;
        Tue, 17 Nov 2020 13:07:23 +0000 (UTC)
Date:   Tue, 17 Nov 2020 13:07:22 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 02/10] vhost scsi: remove extra flushes
Message-ID: <20201117130722.GL131917@stefanha-x1.localdomain>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <1605223150-10888-4-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1605223150-10888-4-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QWRRbczYj8mXuejp"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--QWRRbczYj8mXuejp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2020 at 05:19:02PM -0600, Mike Christie wrote:
> The vhost work flush function was flushing the entire work queue, so
> there is no need for the double vhost_work_dev_flush calls in
> vhost_scsi_flush.
>=20
> And we do not need to call vhost_poll_flush for each poller because
> that call also ends up flushing the same work queue thread the
> vhost_work_dev_flush call flushed.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/scsi.c | 8 --------
>  1 file changed, 8 deletions(-)

Ah, this was done as a separate step:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--QWRRbczYj8mXuejp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+zywoACgkQnKSrs4Gr
c8izTgf/dq+avFDuwW5m2oQ4Rd78KfOtpZtKTgCJtgIAJoOegflxIrOhYKpZTBnd
mY0WyFNOAhDu6FIUUYQeRz5jNtSVKlbqZRFfuAZFUaLbaaKrFQiNcQinILSO58xt
0kcOyUkve3Dt5EzXNTxfaXVMn9rvB38fkLNIbUprHcxXzyNJyGzKxhczSlQBSGWZ
2pf7mWHICtymczfFltMo6f8weScWg01NqQhzrEt4EcYGnIJ7jRyHYZiPfhiXoYjs
8pIeX6RiLImOh+tB+tCsGOwtMqVOft3e5vNoep1QMxoTZRqqPc5p7zuVXR8O/hnu
+3sqOIFOIgMgfa67qXaoRfKuVCH/Uw==
=9o1W
-----END PGP SIGNATURE-----

--QWRRbczYj8mXuejp--

