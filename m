Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76349C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 08:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A9B620842
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 08:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392776AbfIFIyN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 04:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbfIFIyN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 04:54:13 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6BCED308FBAC;
        Fri,  6 Sep 2019 08:54:13 +0000 (UTC)
Received: from localhost (ovpn-117-208.ams2.redhat.com [10.36.117.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 862C2600CC;
        Fri,  6 Sep 2019 08:54:10 +0000 (UTC)
Date:   Fri, 6 Sep 2019 09:54:09 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Matt Lupfer <mlupfer@ddn.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: virtio_scsi: unplug LUNs when events missed
Message-ID: <20190906085409.GC5900@stefanha-x1.localdomain>
References: <20190905181903.29756-1-mlupfer@ddn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <20190905181903.29756-1-mlupfer@ddn.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 06 Sep 2019 08:54:13 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 06:19:28PM +0000, Matt Lupfer wrote:
> The event handler calls scsi_scan_host() when events are missed, which
> will hotplug new LUNs.  However, this function won't remove any
> unplugged LUNs.  The result is that hotunplug doesn't work properly when
> the number of unplugged LUNs exceeds the event queue size (currently 8).
>=20
> Scan existing LUNs when events are missed to check if they are still
> present.  If not, remove them.
>=20
> Signed-off-by: Matt Lupfer <mlupfer@ddn.com>
> ---
>  drivers/scsi/virtio_scsi.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)

Please include a changelog in future patch revisions.  For example:

  Signed-off-by: ...
  ---
  v2:
    * Replaced magic constants with sd.h constants [Michael]

Just C and virtio code review, no SCSI specifics:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yHrEACgkQnKSrs4Gr
c8gzzAgAuYSjHn9hrs1cMsy6ox6Yq6EuWDPA1QLCT8w5U0wDuEYZNyEcXwfjz9YX
UTUP5SvIxTPY0h1xkG+xZBWzxeGSzO8+24810N6QeJJLbmXqLJT1YATxntwvp+wa
Y0pP8RmHry+TLkuq7kH87eFrp5+kml6Cxq3mTAx8ELSpikGl8GGK6SQN958+5Tgv
NfI9iko4E3c8hSbRthCUMt6ZQpJEpMIoh2DsIkFeY5OI+ZXs4uCUMqc8u9oVCDwf
sj3CrN+r27WQ5oGlXrg3MA4w9Ng6+hvpPRbhbLli4v7NeFUyswz2qJDQWM2e87Pt
vJ2fssWWXnh3m7u5LraZwstLo3ainA==
=6rpq
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
