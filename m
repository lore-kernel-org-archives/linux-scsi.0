From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the pci tree
Date: Tue, 6 Nov 2012 11:27:29 +1100
Message-ID: <20121106112729.994c25ccce521ab5aaf1f060@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Nov_2012_11_27_29_+1100_InCLfc68274ZUfAg"
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org, Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Tue__6_Nov_2012_11_27_29_+1100_InCLfc68274ZUfAg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

After merging the pci tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/staging/telephony/ixj.c: In function 'ixj_probe_pci':
drivers/staging/telephony/ixj.c:7732:13: warning: assignment makes integer =
from pointer without a cast [enabled by default]
drivers/staging/telephony/ixj.c:7732:38: error: expected ';' before 'pci_re=
source_start'

Exposed by commit 545974a28f78 ("PCI: Convert pci_resource_<foo> macros to
static inlines").  The macro version of pci_resource_start() made this
RHS look like a function call and now it isn't.

Maybe it is time this driver just went away.

drivers/scsi/gdth.c: In function 'gdth_init_pci':
drivers/scsi/gdth.c:1111:34: error: lvalue required as left operand of assi=
gnment

This was also exposed by the above commit, but is caused by the driver
expecting to be able to assign to the result of pci_resource_start().

I have applied the following patch for today (the scsi one could probably
be done more correctly):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 6 Nov 2012 11:23:45 +1100
Subject: [PATCH] PCI: fixups for pci_resource_start conversion

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/gdth.c               |    2 +-
 drivers/staging/telephony/Kconfig |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d72274..5209e81 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -1108,7 +1108,7 @@ static int __devinit gdth_init_pci(struct pci_dev *pd=
ev, gdth_pci_str *pcistr,
         command |=3D 6;
 	pci_write_config_word(pdev, PCI_COMMAND, command);
 	if (pci_resource_start(pdev, 8) =3D=3D 1UL)
-	    pci_resource_start(pdev, 8) =3D 0UL;
+	    pdev->resource[8].start =3D 0UL;
         i =3D 0xFEFF0001UL;
 	pci_write_config_dword(pdev, PCI_ROM_ADDRESS, i);
         gdth_delay(1);
diff --git a/drivers/staging/telephony/Kconfig b/drivers/staging/telephony/=
Kconfig
index b5f78b6..c5893e2 100644
--- a/drivers/staging/telephony/Kconfig
+++ b/drivers/staging/telephony/Kconfig
@@ -20,6 +20,7 @@ if PHONE
 config PHONE_IXJ
 	tristate "QuickNet Internet LineJack/PhoneJack support"
 	depends on ISA || PCI
+	depends on BROKEN
 	---help---
 	  Say M if you have a telephony card manufactured by Quicknet
 	  Technologies, Inc.  These include the Internet PhoneJACK and
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__6_Nov_2012_11_27_29_+1100_InCLfc68274ZUfAg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQmFlxAAoJEECxmPOUX5FEM+4QAIJf1u4/ic3IKWavK8P8n5fP
Scl8uAeQdBYzx8fMT/UHBFLBndizG0orfzufT9ZygBrfc1uvB+T8RsdWN9EjEa8z
OGSmAlfhTiAyGwKML8bsGWABhd6hxgbihCkHg/U1ofYCbae7BtXUX3qohhamE1Wi
shV6U1OqxsM2e1/PPAWXCC0jl/i75Z0kbhI1ZF/XMN474CVls7ZXbGRUb9yqRgsp
qjU5Zyzf9/jdQ0rl3yYu8hDAN/saADOtLFHwooDQ33gnxRXd+XWSwFnAbsKbqmpZ
/NcN7Mts0fMRRPfWgjPh8uI7TgGUdx/b3wM0PqFDmHf45KtmfL3Dfz8BlgDvNIPG
qTywxztRIPs0XvgXPIofH1xCIt9UBP/2Wn4TT+J5FzIGKVyRAhYkjd5UdUM8N6wI
Jj/DirVW9NbAgAqpEJwprK8aMHGf0kqTjRK179GOY4cWVOKmtWQQO7XlD8SjIxm6
x+oSBESqAFYxXbm11x226TW6hL/P4Sn0BYIXIwgjEl5a6VC5lByqpg4IM8Nfe48c
LILinVr/NG1xM5b24+Hs2lBN6PlppEWasWeZ9NwXE2tEYHbzYX12U3/WGx8/pKVP
uDiTBOkWE52wSUnDrnl7BvZ6q1Xz8g4f60DIy6rKpqKyz7hP26DG4nva4SWaC6ja
qEqp6BR3RnJX9TDloJal
=prS+
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Nov_2012_11_27_29_+1100_InCLfc68274ZUfAg--
