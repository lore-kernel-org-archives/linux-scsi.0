From: zwu.kernel@gmail.com
Subject: [PATCH] scsi: fix the build warning
Date: Thu, 22 Aug 2013 08:44:22 +0800
Message-ID: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:54209 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3HVAqn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2013 20:46:43 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Wed, 21 Aug 2013 18:46:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

=46rom: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Initialize csum variable to fix the build warning.

drivers/scsi/scsi_debug.c: In function =E2=80=98dif_verify=E2=80=99:
drivers/scsi/scsi_debug.c:1755:3: warning: =E2=80=98csum=E2=80=99 may b=
e used uninitialized in this function [-Wmaybe-uninitialized]
  LD      drivers/built-in.o
  CHK     include/generated/uapi/linux/version.h
make[2]: Nothing to be done for `all'.
make[2]: Nothing to be done for `relocs'.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..50d70c3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1733,7 +1733,7 @@ static int do_device_access(struct scsi_cmnd *scm=
d,
=20
 static u16 dif_compute_csum(const void *buf, int len)
 {
-	u16 csum;
+	u16 csum =3D -1;
=20
 	switch (scsi_debug_guard) {
 	case 1:
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
