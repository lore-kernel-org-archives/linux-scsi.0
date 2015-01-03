From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] g_NCR5380: Kill compiler warning if builtin
Date: Sat,  3 Jan 2015 23:00:16 +0100
Message-ID: <1420322416-13960-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

If CONFIG_SCSI_GENERIC_NCR5380=3Dy:

drivers/scsi/g_NCR5380.c:727: warning: =E2=80=98id_table=E2=80=99 defin=
ed but not used

In the non-modular case, MODULE_DEVICE_TABLE() expands to nothing, and
id_table is not referenced.

Correct the existing #ifdef to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/g_NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index f35792f7051c0884..74ec2f5669aba5f5 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -723,7 +723,7 @@ module_param(ncr_53c400a, int, 0);
 module_param(dtc_3181e, int, 0);
 MODULE_LICENSE("GPL");
=20
-#ifndef SCSI_G_NCR5380_MEM
+#if !defined(SCSI_G_NCR5380_MEM) && defined(MODULE)
 static struct isapnp_device_id id_table[] =3D {
 	{
 	 ISAPNP_ANY_ID, ISAPNP_ANY_ID,
--=20
1.9.1
