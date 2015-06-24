From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] advansys: Make sure ret and share_irq are initialized
Date: Wed, 24 Jun 2015 10:29:49 +0200
Message-ID: <1435134589-16601-2-git-send-email-geert@linux-m68k.org>
References: <1435134589-16601-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:57117 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbbFXI3x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2015 04:29:53 -0400
In-Reply-To: <1435134589-16601-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

If CONFIG_PCI=3Dn:

    drivers/scsi/advansys.c: In function =E2=80=98advansys_board_found=E2=
=80=99:
    drivers/scsi/advansys.c:11037: warning: =E2=80=98ret=E2=80=99 is us=
ed uninitialized in this function
    drivers/scsi/advansys.c:10929: warning: =E2=80=98share_irq=E2=80=99=
 may be used uninitialized in this function

If CONFIG_PCI=3Dn, ret and share_irq are indeed not initialized.
Pre-initialize them to zero, and drop the now superfluous setting of
share_irq to zero.

Note that this is sort-of a false positive, as apparently
ASC_NARROW_BOARD(boardp) can only be false for PCI boards, e.g. if
CONFIG_PCI=3Dy.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/advansys.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 1c1cd657c380c2e0..a056226d3f35e863 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -10926,7 +10926,7 @@ static int advansys_board_found(struct Scsi_Hos=
t *shost, unsigned int iop,
 	struct asc_board *boardp =3D shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp =3D NULL;
 	ADV_DVC_VAR *adv_dvc_varp =3D NULL;
-	int share_irq, warn_code, ret;
+	int share_irq =3D 0, warn_code, ret =3D 0;
=20
 	pdev =3D (bus_type =3D=3D ASC_IS_PCI) ? to_pci_dev(boardp->dev) : NUL=
L;
=20
@@ -10987,11 +10987,9 @@ static int advansys_board_found(struct Scsi_Ho=
st *shost, unsigned int iop,
 #ifdef CONFIG_ISA
 		case ASC_IS_ISA:
 			shost->unchecked_isa_dma =3D true;
-			share_irq =3D 0;
 			break;
 		case ASC_IS_VL:
 			shost->unchecked_isa_dma =3D false;
-			share_irq =3D 0;
 			break;
 		case ASC_IS_EISA:
 			shost->unchecked_isa_dma =3D false;
@@ -11008,7 +11006,6 @@ static int advansys_board_found(struct Scsi_Hos=
t *shost, unsigned int iop,
 			shost_printk(KERN_ERR, shost, "unknown adapter type: "
 					"%d\n", asc_dvc_varp->bus_type);
 			shost->unchecked_isa_dma =3D false;
-			share_irq =3D 0;
 			break;
 		}
=20
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
