From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] lpfc: properly factor out debugfs code
Date: Fri, 26 Aug 2011 12:15:25 +0200
Message-ID: <20110826101525.GC22411@logfs.org>
References: <20110826093737.GA22411@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.183.114.52] ([85.183.114.52]:45408 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306Ab1HZKOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2011 06:14:45 -0400
Content-Disposition: inline
In-Reply-To: <20110826093737.GA22411@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, Alex Iannicelli <alex.iannicelli@emulex.com>, James Bottomley <JBottomley@Parallels.com>

On Fri, 26 August 2011 11:37:37 +0200, J=C3=B6rn Engel wrote:
>=20
> I'm currently preparing a janitorial patch series and noticed that
> this one already collides with some of your changes.  Can I leave it
> to you to fix up the collision and send on?

Actually here is a fixed version - or at least one that applies to
Linus' current tree.  I'm rather impressed that this reduces your
object code by 6%.  Wouldn't be surprised if it even shows itself in
some benchmarks.

J=C3=B6rn

--=20
=46antasy is more important than knowledge. Knowledge is limited,
while fantasy embraces the whole world.
-- Albert Einstein

Before:
   text    data     bss     dec     hex filename
 414641    7080    1712  423433   67609 drivers/scsi/lpfc/built-in.o
After:
   text    data     bss     dec     hex filename
 387057    7072    1604  395733   609d5 drivers/scsi/lpfc/built-in.o

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/lpfc/Makefile       |    3 ++-
 drivers/scsi/lpfc/lpfc_crtn.h    |   20 ++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_debugfs.c |   25 ++++---------------------
 drivers/scsi/lpfc/lpfc_vport.c   |    2 +-
 4 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index 88928f0..065e332 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -26,4 +26,5 @@ obj-$(CONFIG_SCSI_LPFC) :=3D lpfc.o
=20
 lpfc-objs :=3D lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o lpfc_hbadisc=
=2Eo	\
 	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o lpfc_scsi.o lpfc_attr.o \
-	lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o
+	lpfc_vport.o lpfc_bsg.o
+lpfc-$(CONFIG_SCSI_LPFC_DEBUG_FS) +=3D lpfc_debugfs.o
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crt=
n.h
index a6db6ae..c9a1472 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -362,12 +362,32 @@ void destroy_port(struct lpfc_vport *);
 int lpfc_get_instance(void);
 void lpfc_host_attrib_init(struct Scsi_Host *);
=20
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 extern void lpfc_debugfs_initialize(struct lpfc_vport *);
 extern void lpfc_debugfs_terminate(struct lpfc_vport *);
 extern void lpfc_debugfs_disc_trc(struct lpfc_vport *, int, char *, ui=
nt32_t,
 	uint32_t, uint32_t);
 extern void lpfc_debugfs_slow_ring_trc(struct lpfc_hba *, char *, uint=
32_t,
 	uint32_t, uint32_t);
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
 extern struct lpfc_hbq_init *lpfc_hbq_defs[];
=20
 /* SLI4 if_type 2 externs. */
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_=
debugfs.c
index a0424dd..2ce9cd6 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -50,7 +50,6 @@
 #include "lpfc_debugfs.h"
 #include "lpfc_bsg.h"
=20
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /*
  * debugfs interface
  *
@@ -602,7 +601,6 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport=
, char *buf, int size)
 	spin_unlock_irq(shost->host_lock);
 	return len;
 }
-#endif
=20
 /**
  * lpfc_debugfs_disc_trc - Store discovery trace log
@@ -620,11 +618,10 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vpo=
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
@@ -644,7 +641,6 @@ lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int=
 mask, char *fmt,
 	dtp->data3 =3D data3;
 	dtp->seq_cnt =3D atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif =3D jiffies;
-#endif
 	return;
 }
=20
@@ -661,11 +657,10 @@ lpfc_debugfs_disc_trc(struct lpfc_vport *vport, i=
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
@@ -682,11 +677,9 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, =
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
@@ -3473,8 +3466,6 @@ static const struct file_operations lpfc_idiag_op=
_extAcc =3D {
 	.release =3D      lpfc_idiag_cmd_release,
 };
=20
-#endif
-
 /* lpfc_idiag_mbxacc_dump_bsg_mbox - idiag debugfs dump bsg mailbox co=
mmand
  * @phba: Pointer to HBA context object.
  * @dmabuf: Pointer to a DMA buffer descriptor.
@@ -3489,7 +3480,6 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *=
phba, enum nemb_type nemb_tp,
 				enum sta_type sta_tp,
 				struct lpfc_dmabuf *dmabuf, uint32_t ext_buf)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t *mbx_mbox_cmd, *mbx_dump_map, *mbx_dump_cnt, *mbx_word_cnt;
 	char line_buf[LPFC_MBX_ACC_LBUF_SZ];
 	int len =3D 0;
@@ -3571,7 +3561,6 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *=
phba, enum nemb_type nemb_tp,
 	if (*mbx_dump_cnt =3D=3D 0)
 		memset(&idiag, 0, sizeof(idiag));
 	return;
-#endif
 }
=20
 /* lpfc_idiag_mbxacc_dump_issue_mbox - idiag debugfs dump issue mailbo=
x command
@@ -3585,7 +3574,6 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *=
phba, enum nemb_type nemb_tp,
 void
 lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pm=
box)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t *mbx_dump_map, *mbx_dump_cnt, *mbx_word_cnt, *mbx_mbox_cmd;
 	char line_buf[LPFC_MBX_ACC_LBUF_SZ];
 	int len =3D 0;
@@ -3668,7 +3656,6 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba=
 *phba, MAILBOX_t *pmbox)
 	if (*mbx_dump_cnt =3D=3D 0)
 		memset(&idiag, 0, sizeof(idiag));
 	return;
-#endif
 }
=20
 /**
@@ -3681,10 +3668,9 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hb=
a *phba, MAILBOX_t *pmbox)
  * lpfcX directory (for this HBA), and vportX directory for this vport=
=2E It will
  * also create each file used to access lpfc specific debugfs informat=
ion.
  **/
-inline void
+void
 lpfc_debugfs_initialize(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_hba   *phba =3D vport->phba;
 	char name[64];
 	uint32_t num, i;
@@ -4030,7 +4016,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
=20
 debug_failed:
 	return;
-#endif
 }
=20
 /**
@@ -4044,10 +4029,9 @@ debug_failed:
  * this is the last user of the HBA directory or driver directory then=
 it will
  * remove those from the debugfs infrastructure as well.
  **/
-inline void
+void
 lpfc_debugfs_terminate(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_hba   *phba =3D vport->phba;
=20
 	if (vport->disc_trc) {
@@ -4165,6 +4149,5 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 			lpfc_debugfs_root =3D NULL;
 		}
 	}
-#endif
 	return;
 }
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vp=
ort.c
index 1feb551..e0a58be 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -46,7 +46,7 @@
 #include "lpfc_version.h"
 #include "lpfc_vport.h"
=20
-inline void lpfc_vport_set_state(struct lpfc_vport *vport,
+void lpfc_vport_set_state(struct lpfc_vport *vport,
 				 enum fc_vport_state new_state)
 {
 	struct fc_vport *fc_vport =3D vport->fc_vport;
--=20
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
