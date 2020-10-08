Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C892C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 18:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 591DE221FE
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 18:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgJHSlI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 14:41:08 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54270 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729235AbgJHSlH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 14:41:07 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8C1F41C0B88; Thu,  8 Oct 2020 20:41:05 +0200 (CEST)
Date:   Thu, 8 Oct 2020 20:41:05 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Colin King <colin.king@canonical.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Pavel Machek <pavel@denx.de>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: fix return of uninitialized value in rval
Message-ID: <20201008184105.GA25478@duo.ucw.cz>
References: <20201008183239.200358-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20201008183239.200358-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-10-08 19:32:39, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> A previous change removed the initialization of rval and there is
> now an error where an uninitialized rval is being returned on an
> error return path. Fix this by returning -ENODEV.
>=20
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: b994718760fa ("scsi: qla2xxx: Use constant when it is known")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Pavel Machek (CIP) <pavel@denx.de>

And sorry, I did patch against mainline, and this got added in -next
in the meantime.

> index ae47e0eb0311..1f9005125313 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -561,7 +561,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_por=
t *lport,
>  	vha =3D fcport->vha;
> =20
>  	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
> -		return rval;
> +		return -ENODEV;
> =20
>  	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
>  	    (qpair && !qpair->fw_started) || fcport->deleted)
> --=20
> 2.27.0
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX39dQQAKCRAw5/Bqldv6
8ubJAJ9uH8LPqGBKU/7lXMlanF7poxaB7ACfTuzPpcPJVYHRQWYJQsEYlmq+bnY=
=D4l5
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
