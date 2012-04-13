From: "Achim Leubner" <Achim_Leubner@pmc-sierra.com>
Subject: RE: [PATCH] aacraid: add an iounmap call to aac_src_ioremap
Date: Fri, 13 Apr 2012 02:03:24 -0700
Message-ID: <FD2BDBE06AC58549AE9E16C08B45675D0684F84E@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <4F747E82.2020805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:52786 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864Ab2DMJZs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Apr 2012 05:25:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4F747E82.2020805@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>, mark_salyzyn@xyratex.com

Acked-by: Achim Leubner<achim_leubner@pmc-sierra.com>

Thanks,
Achim


-----Original Message-----
=46rom: Tomas Henzl [mailto:thenzl@redhat.com]=20
Sent: Donnerstag, 29. M=E4rz 2012 17:24
To: 'linux-scsi@vger.kernel.org'
Cc: Achim Leubner; Mahesh Rajashekhara; mark_salyzyn@xyratex.com
Subject: [PATCH] aacraid: add an iounmap call to aac_src_ioremap

The patch 116046127d1a3bad2853d02781ad9fee33f05e5a [SCSI] aacraid: Adde=
d Sync.mode to support series 7/8/9 controllers
removed an iounmap call from  aac_src_ioremap. Before that, the iounmap=
 has been called twice with the same value
(dev->base and dev->regs.src.bar0) and the iounmap complained about it =
(iounmap: bad address ...).

The proper solution is a change the paremeter from bar0 to bar1.
=46ix this by adding a an iounmap(dev->regs.src.bar1) call.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>=20

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 2bee515..7628206 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -424,6 +424,8 @@ static int aac_src_deliver_message(struct fib *fib)
 static int aac_src_ioremap(struct aac_dev *dev, u32 size)
 {
 	if (!size) {
+		iounmap(dev->regs.src.bar1);
+		dev->regs.src.bar1 =3D NULL;
 		iounmap(dev->regs.src.bar0);
 		dev->base =3D dev->regs.src.bar0 =3D NULL;
 		return 0;


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
