From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: [PATCH] mmc_block: use generic helper to print capacities
Date: Sun, 31 Aug 2008 20:54:48 +0200
Message-ID: <20080831205448.5b23507d@mjolnir.drzeus.cx>
References: <48B9546B.4010004@simon.arlott.org.uk>
	<1220117091.3615.3.camel@localhost.localdomain>
	<20080830174516.GD1239@parisc-linux.org>
	<48B9B552.8060406@simon.arlott.org.uk>
	<48B9B588.7060709@simon.arlott.org.uk>
	<1220147947.3615.18.camel@localhost.localdomain>
	<20080831025412.GJ1239@parisc-linux.org>
	<1220195310.4021.4.camel@localhost.localdomain>
	<1220195634.4021.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-27280-1220208895-0001-2"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757436AbYHaSzO@vger.kernel.org>
In-Reply-To: <1220195634.4021.9.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-27280-1220208895-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

From: Pierre Ossman <drzeus@drzeus.cx>

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

---

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 62a4c91..dad8edb 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -29,6 +29,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
+#include <linux/string_helpers.h>
=20
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -496,6 +497,8 @@ static int mmc_blk_probe(struct mmc_card *card)
        struct mmc_blk_data *md;
        int err;
=20
+       char cap_str[10];
+
        /*
         * Check that the card supports the command class(es) we need.
         */
@@ -510,10 +513,11 @@ static int mmc_blk_probe(struct mmc_card *card)
        if (err)
                goto out;
=20
-       printk(KERN_INFO "%s: %s %s %lluKiB %s\n",
+       string_get_size(get_capacity(md->disk) << 9, STRING_UNITS_2,
+                       cap_str, sizeof(cap_str));
+       printk(KERN_INFO "%s: %s %s %s %s\n",
                md->disk->disk_name, mmc_card_id(card), mmc_card_name(card),
-               (unsigned long long)(get_capacity(md->disk) >> 1),
-               md->read_only ? "(ro)" : "");
+               cap_str, md->read_only ? "(ro)" : "");
=20
        mmc_set_drvdata(card, md);
        add_disk(md->disk);


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-27280-1220208895-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAki66PwACgkQ7b8eESbyJLhZWwCfb3D89aa4WJz8tnEtU/2NuPCR
7/4Anj/91OnqfPFeWsOjgNsRyyzyzTlE
=ajmH
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-27280-1220208895-0001-2--
