From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi-misc build breakage
Date: Wed, 26 Sep 2007 09:30:19 -0500
Message-ID: <1190817019.3359.14.camel@localhost.localdomain>
References: <46F9E1D8.2070106@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47827 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762112AbXIZOaY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 10:30:24 -0400
In-Reply-To: <46F9E1D8.2070106@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2007-09-26 at 00:36 -0400, Jeff Garzik wrote:
> current scsi-misc on i386 says:
>=20
> drivers/scsi/arcmsr/arcmsr_hba.c:129: error: =E2=80=98arcmsr_pci_erro=
r_detected=E2=80=99=20
> undeclared here (not in a function)
> drivers/scsi/arcmsr/arcmsr_hba.c:130: error: =E2=80=98arcmsr_pci_slot=
_reset=E2=80=99=20
> undeclared here (not in a function)
> make[2]: *** [drivers/scsi/arcmsr/arcmsr_hba.o] Error 1
> make[1]: *** [drivers/scsi/arcmsr] Error 2

That's my fault ... I took the templates out of the code because it was
giving warnings about static defined but unused functions.  I must be
compiling without CONFIG_SCSI_ARCMSR_AER.

This should fix it.

James

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arc=
msr_hba.c
index f4d2d52..449bceb 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -125,6 +125,10 @@ static struct scsi_host_template arcmsr_scsi_host_=
template =3D {
 	.shost_attrs		=3D arcmsr_host_attrs,
 };
 #ifdef CONFIG_SCSI_ARCMSR_AER
+static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev=
,
+						  pci_channel_state_t state);
+static pci_ers_result_t arcmsr_pci_slot_reset(struct pci_dev *pdev);
+
 static struct pci_error_handlers arcmsr_pci_error_handlers =3D {
 	.error_detected		=3D arcmsr_pci_error_detected,
 	.slot_reset		=3D arcmsr_pci_slot_reset,


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
