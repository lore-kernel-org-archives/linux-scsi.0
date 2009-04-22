From: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: ipr_remove() marked __devexit
Date: Wed, 22 Apr 2009 10:50:28 -0300
Message-ID: <1240408230.8289.3.camel@zeppelin.austin.ibm.com>
References: <1237839145.13011.54.camel@zeppelin.austin.ibm.com>
	 <1239995314.6143.1.camel@zeppelin.austin.ibm.com>
	 <1240020307.5763.1.camel@mulgrave>
	 <1240235787.7458.13.camel@zeppelin.austin.ibm.com>
	 <1240237018.3315.14.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:44828 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZDVNwG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 09:52:06 -0400
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by e24smtp04.br.ibm.com (8.13.1/8.13.1) with ESMTP id n3MDlY9C031099
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 10:47:34 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.18.232.47])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3MEpLhd3190828
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 11:51:21 -0300
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3MDq3c3009644
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 10:52:03 -0300
In-Reply-To: <1240237018.3315.14.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2009-04-20 at 14:16 +0000, James Bottomley wrote:
> On Mon, 2009-04-20 at 10:56 -0300, Kleber S. Souza wrote:
> > On Fri, 2009-04-17 at 22:05 -0400, James Bottomley wrote:
> > > On Fri, 2009-04-17 at 16:08 -0300, Kleber S. Souza wrote:
> > > > Hi,
> > > >=20
> > > > Any comments on this patch?=20
> > > >=20
> > > > It was acked by Brian King, do I need to do anything else to ge=
t it
> > > > accepted?
> > >=20
> > > No ... looks OK to me:
> > >=20
> > > > Thanks,
> > > > Kleber
> > > >=20
> > > > On Mon, 2009-03-23 at 17:12 -0300, Kleber Sacilotto de Souza wr=
ote:
> > > > > Marking the ipr clean up function ipr_remove() as __devexit a=
nd using
> > > > > __devexit_p() macro in its address reference.
> > > > >=20
> > > > >=20
> > > > > Signed-off-by: Kleber Sacilotto de Souza <kleber@linux.vnet.i=
bm.com>
> > > > > Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
> > >=20
> > > Just explain this signoff?  signed-off-by is supposed to document=
 the
> > > hands the patch has passed through ... it's not clear what Breno =
Leitao
> > > has to do with the transmission of this patch.
> > >=20
> >=20
> > Breno Leit=C3=A3o pointed out to me that this change needed to be m=
ade based
> > on the kernel documentation <Documentation/PCI/pci.txt>. I wrote th=
e
> > patch, got the ack from Brian King and sent it to the list.
>=20
> So that should be Reported-by: not Signed-off-by for Breno.
>=20
> There's no actual ack from Brian King on this email.
>=20
> James
>=20

Resending the patch with the proper tags. Sorry for the confusion.




Marking the ipr clean up function ipr_remove() as __devexit and using
__devexit_p() macro in its address reference.


Signed-off-by: Kleber Sacilotto de Souza <kleber@linux.vnet.ibm.com>
Reported-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 0782900..bc39ac6 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7674,7 +7674,7 @@ static void __ipr_remove(struct pci_dev *pdev)
  * Return value:
  *     none
  **/
-static void ipr_remove(struct pci_dev *pdev)
+static void __devexit ipr_remove(struct pci_dev *pdev)
 {
        struct ipr_ioa_cfg *ioa_cfg =3D pci_get_drvdata(pdev);

@@ -7850,7 +7850,7 @@ static struct pci_driver ipr_driver =3D {
        .name =3D IPR_NAME,
        .id_table =3D ipr_pci_table,
        .probe =3D ipr_probe,
-       .remove =3D ipr_remove,
+       .remove =3D __devexit_p(ipr_remove),
        .shutdown =3D ipr_shutdown,
        .err_handler =3D &ipr_err_handler,
 };
--

--=20
Kleber S. Souza
IBM Linux Technology Center

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
