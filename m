From: Kurt Garloff <garloff@suse.de>
Subject: [robert@philosys.de: Re: [PATCH] Additional BLIST_LARGELUN device]
Date: Tue, 16 Jul 2002 16:12:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020716141210.GA19710@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Hubert Mantel <mantel@suse.de>, Dave Jones <davej@suse.de>, Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcelo, Dave, Hubert,

this patch is for your kernels.

I find it quite lousy that FSC does adapt their firmware to the needs of
stupid software instead of doing it correctly (acc. to the specs) and have
those vendors of screwware adapt their products to the specs.

Anyway, I'm afraid we can't change that and the best thing we can do about
it is to support the device anyway by BLISTing it.

We should introduce a system where vendors have to pay for every entry they
need in the list. If only I was king ... ;-)

----- Forwarded message from Robert Sertic <robert@philosys.de> -----

X-Authentication-Warning: ftp.philosys.de: robert owned process doing -bs
Date: Tue, 16 Jul 2002 15:24:04 +0200 (CEST)
From: Robert Sertic <robert@philosys.de>
To: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] Additional BLIST_LARGELUN device
In-Reply-To: <20020716122733.GH16031@nbkurt.etpnet.phys.tue.nl>
X-Spam-Status: No, hits=3D-9.4 required=3D5.0 tests=3DIN_REP_TO,UNIFIED_PAT=
CH version=3D2.20



Hi Kurt,

Kurt Garloff <garloff@suse.de> wrote:
> More or less. I can pass it to Hubert Mantel for SuSE/UL kernels,
> to Marcelo Tosatti for 2.4.19 and to Dave Jones for 2.5.

Thanks in advance for that;)=20
>=20
> Sure.
> However, I doubt you patch is completely correct: I'd say that you need
> BLIST_SPARSELUN as well. Which means that the kernel scans further after a
> missing LUN. Which you often have in FC environments (SANs), where some L=
UNs
> are mapped to other machines. Can't this possibly happen with your
> CentricStor?

Yes, you are absolutely right, this is really possible.
Thanks for that;)

> Is there a reason you can't properly have your device report SCSI-3?

They made a lot of Test with the Hardware and it is already sold
and delivered to several customers. It was tested with about 6
different BackupTools and about 6 Plattforms. They fear that=20
complications could occur with some of the Backup-Applications if it were
changed. Tools like Omniback are very restrictive in the use of
"foreign" hardware.;)


I made a new patch :=20

--- linux/drivers/scsi/scsi_scan.c      Tue Jul 16 14:25:26 2002
+++ linux-patched/drivers/scsi/scsi_scan.c      Tue Jul 16 14:22:32 2002
@@ -172,6 +172,7 @@
        {"COMPAQ", "MSA1000", "*", BLIST_FORCELUN},
        {"HP", "C1557A", "*", BLIST_FORCELUN},
        {"IBM", "AuSaV1S2", "*", BLIST_FORCELUN},
+       {"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
=20
        /*
         * Must be at end of list...

---

I already build a new kernel and tested it ...

Thanks for all ;)


Greetings,
	Robert

----- End forwarded message -----

--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9NCm5xmLh6hyYd04RAk2MAKCH7+Kw0cDwgDbM/yfF6AgTbeR4FgCfR/8N
foxcQ3ZZEqjKry7VjZCF7tA=
=v6BG
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
