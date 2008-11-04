From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/8] zfcp: Fix cast warning
Date: Tue, 04 Nov 2008 16:35:09 +0100
Message-ID: <20081104153628.925145000@de.ibm.com>
References: <20081104153504.606043000@de.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:37060 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYKDPiV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 10:38:21 -0500
Content-Disposition: inline; filename=fix-cast.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

=46rom: Christof Schmitt <christof.schmitt@de.ibm.com>

=46ix leftover from last typecast patch:

drivers/s390/scsi/zfcp_aux.c: In function =E2=80=98zfcp_port_enqueue=E2=
=80=99:
drivers/s390/scsi/zfcp_aux.c:629: warning: format =E2=80=98%016llx=E2=80=
=99 expects
type =E2=80=98long long unsigned int=E2=80=99, but argument 3 has type =
=E2=80=98u64=E2=80=99

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-11-04 14:44:04.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-11-04 14:44:24.000000000 +0100
@@ -610,7 +610,8 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	atomic_set_mask(status | ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set(&port->refcount, 0);
=20
-	dev_set_name(&port->sysfs_device, "0x%016llx", wwpn);
+	dev_set_name(&port->sysfs_device, "0x%016llx",
+		     (unsigned long long)wwpn);
 	port->sysfs_device.parent =3D &adapter->ccw_device->dev;
=20
 	port->sysfs_device.release =3D zfcp_sysfs_port_release;

--=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
