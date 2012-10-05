From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH v3] qla2xxx: silence two GCC warnings
Date: Fri, 05 Oct 2012 14:23:30 +0200
Message-ID: <1349439810.1491.18.camel@x61.thuisdomein>
References: <CC93C7DD.EB60%saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CC93C7DD.EB60%saurav.kashyap@qlogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-driver@qlogic.com, Rolf Eike Beer <eike-kernel@sf-tec.de>, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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

An easy way to silence these warnings is to use preprocessor macros and
strncpy, as that apparently gives GCC enough information to keep track
of array bounds.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Updated for Saurav's request to use strncpy().

1) Still only compile tested.

 drivers/scsi/qla2xxx/qla_def.h | 1 +
 drivers/scsi/qla2xxx/qla_gs.c  | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_=
def.h
index 39007f5..8895038 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -37,6 +37,7 @@
 #include "qla_nx.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
+#define QLA2XXX_MANUFACTURER	"QLogic Corporation"
=20
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_g=
s.c
index 05260d2..824cbcf 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1325,8 +1325,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Manufacturer. */
 	eiter =3D (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type =3D __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
-	strcpy(eiter->a.manufacturer, "QLogic Corporation");
-	alen =3D strlen(eiter->a.manufacturer);
+	alen =3D strlen(QLA2XXX_MANUFACTURER);
+	strncpy(eiter->a.manufacturer, QLA2XXX_MANUFACTURER, alen + 1);
 	alen +=3D (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len =3D cpu_to_be16(4 + alen);
 	size +=3D 4 + alen;
@@ -1646,8 +1646,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	/* OS device name. */
 	eiter =3D (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type =3D __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
-	strcpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME);
-	alen =3D strlen(eiter->a.os_dev_name);
+	alen =3D strlen(QLA2XXX_DRIVER_NAME);
+	strncpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME, alen + 1);
 	alen +=3D (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len =3D cpu_to_be16(4 + alen);
 	size +=3D 4 + alen;
--=20
1.7.11.4
