Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE43C63798
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 08:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4570324248
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 08:52:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iyCdp0Eu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgKRIwE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 03:52:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgKRIwD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Nov 2020 03:52:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605689522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AGZAWOOKsaOMtTPLmfavfmom9OBpCpjkv96nXQO85ew=;
        b=iyCdp0Eu5tT7ounoky71QnPShI0EyEg41Q2VaQCTqO+kGQG6FmglAyqn0ps3ADYeznM9PY
        ogWsjOlSyTmMCREepoCIEa7028p8MK9fIo7QTrawF1eTkMjKZS6LkB1bwKtNEqMMWEHajw
        qtyG4pfPjPEl9UYDhfjF+sbK+LQ8ezs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-i_0NcwotPZOABUEPm69HuA-1; Wed, 18 Nov 2020 03:52:00 -0500
X-MC-Unique: i_0NcwotPZOABUEPm69HuA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3691B10B9CB6;
        Wed, 18 Nov 2020 08:51:59 +0000 (UTC)
Received: from localhost (ovpn-114-60.ams2.redhat.com [10.36.114.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCD6C5D9CD;
        Wed, 18 Nov 2020 08:51:55 +0000 (UTC)
Date:   Wed, 18 Nov 2020 08:51:54 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] vhost scsi: fix lun reset completion handling
Message-ID: <20201118085154.GB182763@stefanha-x1.localdomain>
References: <1605680660-3671-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1605680660-3671-1-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2020 at 12:24:20AM -0600, Mike Christie wrote:
> vhost scsi owns the scsi se_cmd but lio frees the se_cmd->se_tmr
> before calling release_cmd, so while with normal cmd completion we
> can access the se_cmd from the vhost work, we can't do the same with
> se_cmd->se_tmr. This has us copy the tmf response in
> vhost_scsi_queue_tm_rsp to our internal vhost-scsi tmf struct for
> when it gets sent to the guest from our worker thread.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/scsi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+04KoACgkQnKSrs4Gr
c8i6xQf/WGTmSkaZz3wjoFmuGQ0KePZY+uEW6Z7F4/QjhABFHREnOU3K37aawDrb
eDky5KvUxkFhkNJ0zkfoao9NQSIBNwWAm2mACVHKaYf2q6V6s7Slxtqb1tmvA0T9
rc1Sfm10qvQdCQgqwrPn3HPFTPLkub5JanfhHqAZsmh2BDFX7mWiLQ91b/uQ4t9T
7s9K7blSuufG6awOBM0vLi3PWNHCginHDHLD/bjaV5ntRH8CF5vxoqVzYtPxDtMr
N9RFqAHqLLXvi2kV/Ik4/+B4Xmk0jUZPBHemXSbX5I0Q00ksv1Ql+2ciU5A9agtw
ThFXOBEDFoHmIPRib6Gn/Cgt/7+22g==
=LX+f
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--

