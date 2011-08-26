From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH] lpfc: properly factor out debugfs code
Date: Fri, 26 Aug 2011 11:37:37 +0200
Message-ID: <20110826093737.GA22411@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.183.114.52] ([85.183.114.52]:35943 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754955Ab1HZK1c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2011 06:27:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, Alex Iannicelli <alex.iannicelli@emulex.com>, James Bottomley <JBottomley@Parallels.com>

Hello James!

I'm currently preparing a janitorial patch series and noticed that
this one already collides with some of your changes.  Can I leave it
to you to fix up the collision and send on?

J=C3=B6rn

--=20
All art is but imitation of nature.
-- Lucius Annaeus Seneca


Saves literally hundreds of calls to empty functions.  Surprisingly,
this also saves a few bytes in the debug-case.  Gcc had an imo valid
warning about reg_val being used uninitialized.  Fixed that up as
well.

Before, CONFIG_SCSI_LPFC_DEBUG_FS=3Dn:
   text    data     bss     dec     hex filename
 382377    7024    1604  391005   5f75d drivers/scsi/lpfc/built-in.o
After, CONFIG_SCSI_LPFC_DEBUG_FS=3Dn:
   text    data     bss     dec     hex filename
 374325    7024    1604  382953   5d7e9 drivers/scsi/lpfc/built-in.o

Before, CONFIG_SCSI_LPFC_DEBUG_FS=3Dy:
   text    data     bss     dec     hex filename
 401763    7032    1712  410507   6438b drivers/scsi/lpfc/built-in.o
After, CONFIG_SCSI_LPFC_DEBUG_FS=3Dy:
   text    data     bss     dec     hex filename
 401749    7032    1712  410493   6437d drivers/scsi/lpfc/built-in.o

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/lpfc/Makefile       |    5 +++--
 drivers/scsi/lpfc/lpfc_crtn.h    |   25 +++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_debugfs.c |   20 +++++---------------
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index 88928f0..c0f6b90 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -24,6 +24,7 @@ ccflags-$(GCOV) +=3D -O0
=20
 obj-$(CONFIG_SCSI_LPFC) :=3D lpfc.o
=20
-lpfc-objs :=3D lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o lpfc_hbadisc=
=2Eo	\
+lpfc-y :=3D lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o lpfc_hbadisc.o	=
\
 	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o lpfc_scsi.o lpfc_attr.o \
-	lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o
+	lpfc_vport.o lpfc_bsg.o
+lpfc-$(CONFIG_SCSI_LPFC_DEBUG_FS) +=3D lpfc_debugfs.o
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crt=
n.h
index fc20c24..2bbec9f 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -360,12 +360,33 @@ void destroy_port(struct lpfc_vport *);
 int lpfc_get_instance(void);
 void lpfc_host_attrib_init(struct Scsi_Host *);
=20
-extern void lpfc_debugfs_initialize(struct lpfc_vport *);
-extern void lpfc_debugfs_terminate(struct lpfc_vport *);
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 extern void lpfc_debugfs_disc_trc(struct lpfc_vport *, int, char *, ui=
nt32_t,
 	uint32_t, uint32_t);
 extern void lpfc_debugfs_slow_ring_trc(struct lpfc_hba *, char *, uint=
32_t,
 	uint32_t, uint32_t);
+extern void lpfc_debugfs_initialize(struct lpfc_vport *);
+extern void lpfc_debugfs_terminate(struct lpfc_vport *);
+#else
+static inline void lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int=
 mask, char *fmt,
+	uint32_t data1, uint32_t data2, uint32_t data3)
+{
+}
+
+static inline void lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, c=
har *fmt,
+	uint32_t data1, uint32_t data2, uint32_t data3)
+{
+}
+
+static inline void lpfc_debugfs_initialize(struct lpfc_vport *vport)
+{
+}
+
+static inline void lpfc_debugfs_terminate(struct lpfc_vport *vport)
+{
+}
+#endif
+
 extern struct lpfc_hbq_init *lpfc_hbq_defs[];
=20
 /* SLI4 if_type 2 externs. */
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_=
debugfs.c
index ffe82d1..b6faecb 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -18,6 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
=20
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -49,7 +50,6 @@
 #include "lpfc_compat.h"
 #include "lpfc_debugfs.h"
=20
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /*
  * debugfs interface
  *
@@ -584,7 +584,6 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport=
, char *buf, int size)
 	spin_unlock_irq(shost->host_lock);
 	return len;
 }
-#endif
=20
 /**
  * lpfc_debugfs_disc_trc - Store discovery trace log
@@ -602,11 +601,10 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vpo=
rt, char *buf, int size)
  * match will be thrown away. @fmt, @data1, @data2, and @data3 are use=
d like
  * printf when displaying the log.
  **/
-inline void
+void
 lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int mask, char *fmt,
 	uint32_t data1, uint32_t data2, uint32_t data3)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_debugfs_trc *dtp;
 	int index;
=20
@@ -626,7 +624,6 @@ lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int=
 mask, char *fmt,
 	dtp->data3 =3D data3;
 	dtp->seq_cnt =3D atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif =3D jiffies;
-#endif
 	return;
 }
=20
@@ -643,11 +640,10 @@ lpfc_debugfs_disc_trc(struct lpfc_vport *vport, i=
nt mask, char *fmt,
  * discovery trace buffer associated with @vport. @fmt, @data1, @data2=
, and
  * @data3 are used like printf when displaying the log.
  **/
-inline void
+void
 lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 	uint32_t data1, uint32_t data2, uint32_t data3)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_debugfs_trc *dtp;
 	int index;
=20
@@ -664,11 +660,9 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, =
char *fmt,
 	dtp->data3 =3D data3;
 	dtp->seq_cnt =3D atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif =3D jiffies;
-#endif
 	return;
 }
=20
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /**
  * lpfc_debugfs_disc_trc_open - Open the discovery trace log
  * @inode: The inode pointer that contains a vport pointer.
@@ -2256,7 +2250,7 @@ lpfc_idiag_drbacc_write(struct file *file, const =
char __user *buf,
 {
 	struct lpfc_debug *debug =3D file->private_data;
 	struct lpfc_hba *phba =3D (struct lpfc_hba *)debug->i_private;
-	uint32_t drb_reg_id, value, reg_val;
+	uint32_t drb_reg_id, value, reg_val =3D 0;
 	void __iomem *drb_reg;
 	int rc;
=20
@@ -2447,7 +2441,6 @@ static const struct file_operations lpfc_idiag_op=
_drbAcc =3D {
 	.release =3D      lpfc_idiag_cmd_release,
 };
=20
-#endif
=20
 /**
  * lpfc_debugfs_initialize - Initialize debugfs for a vport
@@ -2462,7 +2455,6 @@ static const struct file_operations lpfc_idiag_op=
_drbAcc =3D {
 inline void
 lpfc_debugfs_initialize(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_hba   *phba =3D vport->phba;
 	char name[64];
 	uint32_t num, i;
@@ -2750,7 +2742,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
=20
 debug_failed:
 	return;
-#endif
 }
=20
 /**
@@ -2767,7 +2758,6 @@ debug_failed:
 inline void
 lpfc_debugfs_terminate(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_hba   *phba =3D vport->phba;
=20
 	if (vport->disc_trc) {
@@ -2866,6 +2856,6 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 			lpfc_debugfs_root =3D NULL;
 		}
 	}
-#endif
 	return;
 }
+#endif
--=20
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
