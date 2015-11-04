From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 2/3] aic94xx: remove SCSI host before detaching from SAS transport
Date: Wed, 4 Nov 2015 17:51:03 +0100
Message-ID: <CAMGffEnkHVrUwFoHsttTc86HHJQtQukQd0mYjUuL3iuBXpU73w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33251 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbbKDQvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 11:51:23 -0500
Received: by wmeg8 with SMTP id g8so115681207wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2015 08:51:22 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jej B <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
Cc: hch <hch@lst.de>, brood <brood@attotech.com>

=46rom 3aae177e7aa833339fa84ae5c60ed5f10056610d Mon Sep 17 00:00:00 200=
1
=46rom: Jack Wang <jinpu.wang@profitbricks.com>
Date: Wed, 4 Nov 2015 10:01:41 +0100
Subject: [PATCH 2/3] aic94xx: remove SCSI host before detaching from SA=
S
 transport

commit cff549e4860f ("scsi: proper state checking and module refcount
handling in scsi_device_get")
the reference count of scsi device was changed, which could lead to
when rmmod with at least on drive attached, SCSI error handle will
run into infinite loop, and lockup the system.

=46ix it by remove scsi host first, this way scsi core will not send
commands down after detaching SAS transport.

This is a follow up fix for Benjamin's fix for pm80xx.

See also:
http://www.spinics.net/lists/linux-scsi/msg90088.html

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c
b/drivers/scsi/aic94xx/aic94xx_init.c
index f6c336b..4b56976 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -704,10 +704,10 @@ static int asd_unregister_sas_ha(struct
asd_ha_struct *asd_ha)
 {
  int err;

+ scsi_remove_host(asd_ha->sas_ha.core.shost);
  err =3D sas_unregister_ha(&asd_ha->sas_ha);

  sas_remove_host(asd_ha->sas_ha.core.shost);
- scsi_remove_host(asd_ha->sas_ha.core.shost);
  scsi_host_put(asd_ha->sas_ha.core.shost);

  kfree(asd_ha->sas_ha.sas_phy);
--=20
1.9.1


--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang@profitbricks.com
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
