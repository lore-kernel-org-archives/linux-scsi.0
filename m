Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED4EC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 21:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 340802070C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 21:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgGBVQ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 17:16:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41860 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgGBVQ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 17:16:57 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 356E01C0BD2; Thu,  2 Jul 2020 23:16:55 +0200 (CEST)
Date:   Thu, 2 Jul 2020 23:16:54 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <20200702211653.GB5787@amd>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623204234.GA16156@khazad-dum.debian.net>
 <CACVXFVNdC1U-gXdMr-B6i0WJdiYF+JvBcF3MkhFApEw_ZPx7pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <CACVXFVNdC1U-gXdMr-B6i0WJdiYF+JvBcF3MkhFApEw_ZPx7pA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > during a FLASH write or erase can cause from weakened cells, to much
> > larger damage.  It is possible to harden the chip or the design against
> > this, but it is *expensive*.  And even if warded off by hardening and no
> > FLASH damage happens, an erase/program cycle must be done on the whole
> > erase block to clean up the incomplete program cycle.
>=20
> It should have been SSD's(including FW) responsibility to avoid data loss=
 when
> the SSD is doing its own BG writing, because power cut can happen any time
> from SSD's viewpoint.

It should be their responsibility. But we know how well that works
(not well), so we try hard (and should try hard) to power SSDs down
cleanly.

In a similar way, it is ext4's responsibility not to corrupt itself,
and we still prefer clean shutdowns.

Plus, HDDs normally do handle unexpected power offs well, but it puts
extra stress on their hardware, so we should avoid that...

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7+TsUACgkQMOfwapXb+vKGzACgk0GX74ERX5Pl/uVrV+tG1mWX
ZGYAniwvujTlx/B3a4xN4uas0M1MVcwW
=dm1G
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
