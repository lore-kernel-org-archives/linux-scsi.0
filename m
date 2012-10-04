From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH v2] qla2xxx: silence two GCC warnings
Date: Thu, 4 Oct 2012 12:42:42 -0500
Message-ID: <CC93C7DD.EB60%saurav.kashyap@qlogic.com>
References: <1349163768.1414.32.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349163768.1414.32.camel@x61.thuisdomein>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org





>Compiling qla_gs.o (part of the qla2xxx module) triggers two GCC
>warnings:
>    drivers/scsi/qla2xxx/qla_gs.c: In function =8Cqla2x00_fdmi_rhba=B9=
:
>    drivers/scsi/qla2xxx/qla_gs.c:1339:7: warning: array subscript is
>above array bounds [-Warray-bounds]
>    drivers/scsi/qla2xxx/qla_gs.c: In function =8Cqla2x00_fdmi_registe=
r=B9:
>    drivers/scsi/qla2xxx/qla_gs.c:1663:15: warning: array subscript is
>above array bounds [-Warray-bounds]
>
>It seems that the sequence of a strcpy followed by a strlen confuses G=
CC
>when it is keeping track of array bounds here. (It is not clear to me
>which array triggers this warning and by how much GCC thinks the
>subscript is above its bounds. Neither is it clear to me why comparabl=
e
>code in these two functions doesn't trigger this warning.)
>
>An easy way to silence these warnings is to use preprocessor macros
>here, as that apparently gives GCC enough information to keep track of
>array bounds.
>
>Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>---
>0) Rolf suggested to not use magic constants, to make sure things keep
>working when these strings change in the future. A trivial solution is
>to use preprocessor macros. I needed to add one for the manufacturer
>string.
>
>1) Still only compile tested.
>
> drivers/scsi/qla2xxx/qla_def.h | 1 +
> drivers/scsi/qla2xxx/qla_gs.c  | 6 +++---
> 2 files changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_def.h
>b/drivers/scsi/qla2xxx/qla_def.h
>index 39007f5..8895038 100644
>--- a/drivers/scsi/qla2xxx/qla_def.h
>+++ b/drivers/scsi/qla2xxx/qla_def.h
>@@ -37,6 +37,7 @@
> #include "qla_nx.h"
> #define QLA2XXX_DRIVER_NAME   "qla2xxx"
> #define QLA2XXX_APIDEV                "ql2xapidev"
>+#define QLA2XXX_MANUFACTURER  "QLogic Corporation"
>
> /*
>  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
>diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_=
gs.c
>index 05260d2..1714035 100644
>--- a/drivers/scsi/qla2xxx/qla_gs.c
>+++ b/drivers/scsi/qla2xxx/qla_gs.c
>@@ -1325,8 +1325,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
>       /* Manufacturer. */
>       eiter =3D (struct ct_fdmi_hba_attr *) (entries + size);
>       eiter->type =3D __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
>-      strcpy(eiter->a.manufacturer, "QLogic Corporation");
>-      alen =3D strlen(eiter->a.manufacturer);
>+      strcpy(eiter->a.manufacturer, QLA2XXX_MANUFACTURER);
>+      alen =3D strlen(QLA2XXX_MANUFACTURER);

Hi Paul,
It looks fine except one small thing. Instead of strcpy, strncpy will b=
e
better option something like this

+       alen =3D strlen(QLA2XXX_MANUFACTURER);
+       strncpy(eiter->a.manufacturer, QLA2XXX_MANUFACTURER, alen);

Thanks,
~Saurav


>       alen +=3D (alen & 3) ? (4 - (alen & 3)) : 4;
>       eiter->len =3D cpu_to_be16(4 + alen);
>       size +=3D 4 + alen;
>@@ -1647,7 +1647,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
>       eiter =3D (struct ct_fdmi_port_attr *) (entries + size);
>       eiter->type =3D __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME=
);
>       strcpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME);
>-      alen =3D strlen(eiter->a.os_dev_name);
>+      alen =3D strlen(QLA2XXX_DRIVER_NAME);
>       alen +=3D (alen & 3) ? (4 - (alen & 3)) : 4;
>       eiter->len =3D cpu_to_be16(4 + alen);
>       size +=3D 4 + alen;
>--
>1.7.11.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" =
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic=
 Corporation or its wholly-owned subsidiaries that may be confidential.=
 If you are not the intended recipient, you may not read, copy, distrib=
ute, or use this information. If you have received this transmission in=
 error, please notify the sender immediately by reply e-mail and then d=
elete this message.
