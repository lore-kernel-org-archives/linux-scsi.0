From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] qla2xxx: silence two GCC warnings
Date: Sun, 30 Sep 2012 13:07:54 +0200
Message-ID: <1349003274.15306.6.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:4525 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab2I3LIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2012 07:08:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Compiling qla_gs.o (part of the qla2xxx module) triggers two GCC
warnings:
    drivers/scsi/qla2xxx/qla_gs.c: In function =E2=80=98qla2x00_fdmi_rh=
ba=E2=80=99:
    drivers/scsi/qla2xxx/qla_gs.c:1339:7: warning: array subscript is a=
bove array bounds [-Warray-bounds]
    drivers/scsi/qla2xxx/qla_gs.c: In function =E2=80=98qla2x00_fdmi_re=
gister=E2=80=99:
    drivers/scsi/qla2xxx/qla_gs.c:1663:15: warning: array subscript is =
above array bounds [-Warray-bounds]

It seems that the sequence of a strcpy followed by a strlen confuses GC=
C
when it is keeping track of array bounds here. (It is not clear to me
which array triggers this warning and by how much GCC thinks the
subscript is above its bounds. Neither is it clear to me why comparable
code in these two functions doesn't trigger this warning.)

The easiest way to silence these warnings is to hardcode the length of
these two strings in the code here. The length used here is the length
of the string, including its NUL terminator, rounded up to the next
multiple of four.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed this warning while building v3.6-rc7 on current Fedora
17, using Fedora's default config.

1) Compile tested only.=20

 drivers/scsi/qla2xxx/qla_gs.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_g=
s.c
index 05260d2..a3ef5d0 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1326,10 +1326,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter =3D (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type =3D __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
 	strcpy(eiter->a.manufacturer, "QLogic Corporation");
-	alen =3D strlen(eiter->a.manufacturer);
-	alen +=3D (alen & 3) ? (4 - (alen & 3)) : 4;
-	eiter->len =3D cpu_to_be16(4 + alen);
-	size +=3D 4 + alen;
+	eiter->len =3D cpu_to_be16(4 + 20);
+	size +=3D 4 + 20;
=20
 	ql_dbg(ql_dbg_disc, vha, 0x2026,
 	    "Manufacturer =3D %s.\n", eiter->a.manufacturer);
@@ -1647,10 +1645,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	eiter =3D (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type =3D __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
 	strcpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME);
-	alen =3D strlen(eiter->a.os_dev_name);
-	alen +=3D (alen & 3) ? (4 - (alen & 3)) : 4;
-	eiter->len =3D cpu_to_be16(4 + alen);
-	size +=3D 4 + alen;
+	eiter->len =3D cpu_to_be16(4 + 8);
+	size +=3D 4 + 8;
=20
 	ql_dbg(ql_dbg_disc, vha, 0x204b,
 	    "OS_Device_Name=3D%s.\n", eiter->a.os_dev_name);
--=20
1.7.11.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
