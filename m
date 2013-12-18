From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 1/4] drivers: target: Move prototype declaration of function
 to header file target_core_pr.h
Date: Wed, 18 Dec 2013 23:54:32 +0530
Message-ID: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Move prototype declaration of function
spc_parse_naa_6h_vendor_specific() from target_core_xcopy.c to header
file target_core_pr.h because it is used by more than one file.

This eliminates the following warning in target_core_spc.c:
drivers/target/target_core_spc.c:138:6: warning: no previous prototype =
for =E2=80=98spc_parse_naa_6h_vendor_specific=E2=80=99 [-Wmissing-proto=
types]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/target/target_core_pr.h    |    5 +++++
 drivers/target/target_core_xcopy.c |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_co=
re_pr.h
index ed75cdd..2ee2936 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -43,6 +43,11 @@
 #define PR_APTPL_MAX_IPORT_LEN			256
 #define PR_APTPL_MAX_TPORT_LEN			256
=20
+/*
+ *  Function defined in target_core_spc.c
+ */
+void spc_parse_naa_6h_vendor_specific(struct se_device *, unsigned cha=
r *);
+
 extern struct kmem_cache *t10_pr_reg_cache;
=20
 extern void core_pr_dump_initiator_port(struct t10_pr_registration *,
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target=
_core_xcopy.c
index 6b88a99..669c536 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -40,10 +40,6 @@
=20
 static struct workqueue_struct *xcopy_wq =3D NULL;
 /*
- * From target_core_spc.c
- */
-extern void spc_parse_naa_6h_vendor_specific(struct se_device *, unsig=
ned char *);
-/*
  * From target_core_device.c
  */
 extern struct mutex g_device_mutex;
--=20
1.7.9.5
