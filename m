From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 1/12] scsi: megaraid_sas - tape drive support fix
Date: Sun, 20 Sep 2009 20:21:19 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:52839 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257AbZIUCVi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Sep 2009 22:21:38 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Add the Tape drive fix to the megaraid_sas driver: If the command is fo=
r the tape device, set the FW pthru timeout to the os layer timeout val=
ue.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |=A0=A0 11 +++++++++++
=A01 file changed, 11 insertions(+)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux=
-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c=A0=A0=A0=A0=A0=
 2009-05-04 20:06:29.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c=A0=A0=A0=A0=A0=
=A0 2009-05-04 20:08:26.000000000 -0400
@@ -687,6 +687,17 @@ megasas_build_dcdb(struct megasas_instan
=A0=A0=A0=A0=A0=A0=A0 memcpy(pthru->cdb, scp->cmnd, scp->cmd_len);

=A0=A0=A0=A0=A0=A0=A0 /*
+=A0=A0=A0=A0=A0=A0 * If the command is for the tape device, set the
+=A0=A0=A0=A0=A0 =A0* pthru timeout to the os layer timeout value.
+=A0=A0=A0=A0=A0=A0 */
+=A0=A0=A0=A0=A0=A0 if (scp->device->type =3D=3D TYPE_TAPE) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((scp->request->timeout =
/ HZ) > 0xFFFF)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pth=
ru->timeout =3D 0xFFFF;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pth=
ru->timeout =3D scp->request->timeout / HZ;
+=A0=A0=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0=A0=A0 /*
=A0=A0=A0=A0=A0=A0=A0=A0 * Construct SGL
=A0=A0=A0=A0=A0=A0=A0=A0 */
=A0=A0=A0=A0=A0=A0=A0 if (IS_DMA64) {

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
