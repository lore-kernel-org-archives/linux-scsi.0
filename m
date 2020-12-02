Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42D7C64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 14:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D22221EB
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 14:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgLBOtu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 09:49:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727629AbgLBOtu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 09:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606920504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3/ciYHLKJ3yILLDkyTRzHDrbddemmdv1ABt1jTeUwBY=;
        b=cbxIcb2ZQ+QplGyxzL6us2gWxLd+CdRgVQ1d1sEqLqRh3BvLVhKXUv5G1HVYzKf1pOqKxC
        IJtawwOo5rh4NTYaep+0IaITZzmQ/6CzOR1z2ZpTJoZNvhWNZHG0QzesvENeDDs0PalwqO
        F+nCSveuR+gmUgDiOw6b5pbUW2w3PuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-D1PchtsSN9eOsqlRyAadYQ-1; Wed, 02 Dec 2020 09:48:21 -0500
X-MC-Unique: D1PchtsSN9eOsqlRyAadYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86DBD185E48E;
        Wed,  2 Dec 2020 14:48:20 +0000 (UTC)
Received: from localhost (ovpn-114-255.ams2.redhat.com [10.36.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2C0C5D6BA;
        Wed,  2 Dec 2020 14:48:16 +0000 (UTC)
Date:   Wed, 2 Dec 2020 14:48:15 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/1 V2] vhost scsi: fix lun reset completion handling
Message-ID: <20201202144815.GN655829@stefanha-x1.localdomain>
References: <1605716857-4949-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1605716857-4949-1-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dPW7zu3hTOhZvCDO"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--dPW7zu3hTOhZvCDO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2020 at 10:27:37AM -0600, Mike Christie wrote:
> vhost scsi owns the scsi se_cmd but lio frees the se_cmd->se_tmr
> before calling release_cmd, so while with normal cmd completion we
> can access the se_cmd from the vhost work, we can't do the same with
> se_cmd->se_tmr. This has us copy the tmf response in
> vhost_scsi_queue_tm_rsp to our internal vhost-scsi tmf struct for
> when it gets sent to the guest from our worker thread.
>=20
> Fixes: Fixes: efd838fec17b ("vhost scsi: Add support for LUN resets.")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>=20
> V2:
> - Added fixes line.
>=20
>  drivers/vhost/scsi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

This will go through Michael Tsirkin or Martin K. Petersen's tree.

--dPW7zu3hTOhZvCDO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/HqS8ACgkQnKSrs4Gr
c8jtgggAxim0I6O6jk2HCjqRjI0QXlKtp0ziC1scmHzQSibKHY+nJ5CiZ45ec5lV
mZofBAD7UDhyo+nBTxZN1eTWsE42CPBEcicLX8ZmUCUfjtUtM1o7MumfdTJ0ezt2
MtVi00JVN4AIrJYG74a9V7v/KCctNHoaCUCy/kXJYb++tuPFBFKWe2OuNncKVJe5
f6QvCIHvdTAHDDnjz4HvVlJZLBOjzbGenPntQ6NxYFCm9Lsk1WyPJEQhxdUvfvBL
wzbSC2Wzbqp7h06WXoQMZxTbFfl1sA4KnQM+aT1u+O54YCck7UoxnYo8sj9JzYqa
g8+8MjtpZxwB3tmuKFcCEzE25ZHQ3g==
=SZ59
-----END PGP SIGNATURE-----

--dPW7zu3hTOhZvCDO--

