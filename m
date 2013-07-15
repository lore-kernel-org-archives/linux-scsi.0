From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] [SCSI] scsi_debug: silence GCC warning
Date: Mon, 15 Jul 2013 11:18:40 +0200
Message-ID: <1373879920.2591.13.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Building scsi_debug.o triggers a GCC warning:
    drivers/scsi/scsi_debug.c: In function =E2=80=98dif_verify=E2=80=99=
:
    drivers/scsi/scsi_debug.c:1755:3: warning: =E2=80=98csum=E2=80=99 m=
ay be used uninitialized in this function [-Wmaybe-uninitialized]

This is a false positive, but if we make scsi_debug_guard a bool, we
supply GCC with enough information to determine that csum will not be
used uninitialized. It also allows for a minor cleanup.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) This warning is apparently introduced in v3.11-rc1 by commit beb40ea=
42b
("[SCSI] scsi_debug: reduce duplication between prot_verify_read and
prot_verify_write")

 drivers/scsi/scsi_debug.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..98e6436 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -169,7 +169,7 @@ static int scsi_debug_dix =3D DEF_DIX;
 static int scsi_debug_dsense =3D DEF_D_SENSE;
 static int scsi_debug_every_nth =3D DEF_EVERY_NTH;
 static int scsi_debug_fake_rw =3D DEF_FAKE_RW;
-static int scsi_debug_guard =3D DEF_GUARD;
+static bool scsi_debug_guard =3D DEF_GUARD;
 static int scsi_debug_lowest_aligned =3D DEF_LOWEST_ALIGNED;
 static int scsi_debug_max_luns =3D DEF_MAX_LUNS;
 static int scsi_debug_max_queue =3D SCSI_DEBUG_CANQUEUE;
@@ -1736,10 +1736,10 @@ static u16 dif_compute_csum(const void *buf, in=
t len)
 	u16 csum;
=20
 	switch (scsi_debug_guard) {
-	case 1:
+	case true:
 		csum =3D ip_compute_csum(buf, len);
 		break;
-	case 0:
+	case false:
 		csum =3D cpu_to_be16(crc_t10dif(buf, len));
 		break;
 	}
@@ -2736,7 +2736,7 @@ module_param_named(dix, scsi_debug_dix, int, S_IR=
UGO);
 module_param_named(dsense, scsi_debug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_I=
WUSR);
 module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR=
);
-module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
+module_param_named(guard, scsi_debug_guard, bool, S_IRUGO);
 module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
@@ -3312,11 +3312,6 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
=20
-	if (scsi_debug_guard > 1) {
-		printk(KERN_ERR "scsi_debug_init: guard must be 0 or 1\n");
-		return -EINVAL;
-	}
-
 	if (scsi_debug_ato > 1) {
 		printk(KERN_ERR "scsi_debug_init: ato must be 0 or 1\n");
 		return -EINVAL;
@@ -4028,7 +4023,7 @@ static int sdebug_driver_probe(struct device * de=
v)
 	       (host_prot & SHOST_DIX_TYPE2_PROTECTION) ? " DIX2" : "",
 	       (host_prot & SHOST_DIX_TYPE3_PROTECTION) ? " DIX3" : "");
=20
-	if (scsi_debug_guard =3D=3D 1)
+	if (scsi_debug_guard =3D=3D true)
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_IP);
 	else
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_CRC);
--=20
1.8.1.4
