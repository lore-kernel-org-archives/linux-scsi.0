From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH] drivers/target/target_core_transport.c: Fix typo issue to
 use 'buf' instead of 'len'
Date: Wed, 03 Sep 2014 23:33:50 +0800
Message-ID: <540734DE.6090306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57672 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaICPdu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 11:33:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michal Simek <monstr@monstr.eu>

It is a typo issue, need use 'buf' instead of 'len', the related warnin=
g
with allmodconfig under microblaze:

drivers/target/target_core_transport.c: In function =91transport_dump_v=
pd_ident_type=92:
drivers/target/target_core_transport.c:956:9: warning: passing argument=
 1 of =91strlen=92 makes pointer from integer without a cast
   len =3D strlen(len);
         ^
In file included from include/linux/bitmap.h:8:0,
                 from include/linux/cpumask.h:11,
                 from include/linux/mm_types.h:12,
                 from include/linux/kmemcheck.h:4,
                 from include/linux/net.h:25,
                 from drivers/target/target_core_transport.c:26:
include/linux/string.h:83:24: note: expected =91const char *=92 but arg=
ument is of type =91int=92
 extern __kernel_size_t strlen(const char *);
                        ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/ta=
rget_core_transport.c
index 1dd1181..3ce85ed 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -953,7 +953,7 @@ int transport_dump_vpd_ident_type(
 		strlcat(buf, "SCSI name string\n", sizeof(buf));
 		break;
 	default:
-		len =3D strlen(len);
+		len =3D strlen(buf);
 		snprintf(&buf[len], sizeof(buf) - len, "Unsupported: 0x%02x\n",
 				vpd->device_identifier_type);
 		ret =3D -EINVAL;
--=20
1.9.3
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
