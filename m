From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: lpfc build failure in latest git
Date: Sat, 02 Feb 2008 09:54:29 -0600
Message-ID: <1201967669.3187.1.camel@localhost.localdomain>
References: <20080202143613.GA4941@stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53835 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbYBBPye (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2008 10:54:34 -0500
In-Reply-To: <20080202143613.GA4941@stro.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: maximilian attems <max@stro.at>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>


On Sat, 2008-02-02 at 15:36 +0100, maximilian attems wrote:
> CC [M]  drivers/scsi/lpfc/lpfc_init.o
>   drivers/scsi/lpfc/lpfc_init.c: In function =E2=80=98lpfc_pci_probe_=
one=E2=80=99:
>   drivers/scsi/lpfc/lpfc_init.c:1897: error: implicit declaration of =
function =E2=80=98pci_enable_device_bars=E2=80=99
>   make[6]: *** [drivers/scsi/lpfc/lpfc_init.o] Error 1
>=20
> seen on both x86 archs.

Oh, Greg was supposed to add this if he merged last.  I'll send it
through the SCSI tree.

James

Subject: git-scsi-misc vs gregkh-pci-pci-remove-users-of-pci_enable_dev=
ice_bars
=46rom: Andrew Morton <akpm@linux-foundation.org>

Whoever merges last needs this.

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_init.c~git-scsi-misc-vs-gregkh-pci-pci=
-remove-users-of-pci_enable_device_bars drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~git-scsi-misc-vs-gregkh-pci-pci-rem=
ove-users-of-pci_enable_device_bars
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -1894,7 +1894,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	uint16_t iotag;
 	int bars =3D pci_select_bars(pdev, IORESOURCE_MEM);
=20
-	if (pci_enable_device_bars(pdev, bars))
+	if (pci_enable_device_mem(pdev))
 		goto out;
 	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
 		goto out_disable_device;
_



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
