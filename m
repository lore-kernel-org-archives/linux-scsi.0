From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.17-rc6
Date: Mon, 21 May 2018 14:57:00 -0700
Message-ID: <1526939820.3215.32.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two driver fixes (zfcp and target core), one information leak in sg and
one build clean up.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alexander Potapenko (1):
      scsi: sg: allocate with __GFP_ZERO in sg_build_indirect()

Jens Remus (1):
      scsi: zfcp: fix infinite iteration on ERP ready list

Prasanna Kumar Kalever (1):
      scsi: target: tcmu: fix error resetting qfull_time_out to default

Randy Dunlap (1):
      scsi: core: clean up generated file scsi_devinfo_tbl.c

And the diffstat:

 drivers/s390/scsi/zfcp_dbf.c      | 23 ++++++++++++++++++++++-
 drivers/s390/scsi/zfcp_ext.h      |  5 ++++-
 drivers/s390/scsi/zfcp_scsi.c     | 14 +++++++-------
 drivers/scsi/Makefile             |  2 +-
 drivers/scsi/sg.c                 |  2 +-
 drivers/target/target_core_user.c |  2 ++
 6 files changed, 37 insertions(+), 11 deletions(-)

With full diff below.

James

---

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index a8b831000b2d..18c4f933e8b9 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -4,7 +4,7 @@
  *
  * Debug traces for zfcp.
  *
- * Copyright IBM Corp. 2002, 2017
+ * Copyright IBM Corp. 2002, 2018
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -308,6 +308,27 @@ void zfcp_dbf_rec_trig(char *tag, struct zfcp_adapter *adapter,
 	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
+/**
+ * zfcp_dbf_rec_trig_lock - trace event related to triggered recovery with lock
+ * @tag: identifier for event
+ * @adapter: adapter on which the erp_action should run
+ * @port: remote port involved in the erp_action
+ * @sdev: scsi device involved in the erp_action
+ * @want: wanted erp_action
+ * @need: required erp_action
+ *
+ * The adapter->erp_lock must not be held.
+ */
+void zfcp_dbf_rec_trig_lock(char *tag, struct zfcp_adapter *adapter,
+			    struct zfcp_port *port, struct scsi_device *sdev,
+			    u8 want, u8 need)
+{
+	unsigned long flags;
+
+	read_lock_irqsave(&adapter->erp_lock, flags);
+	zfcp_dbf_rec_trig(tag, adapter, port, sdev, want, need);
+	read_unlock_irqrestore(&adapter->erp_lock, flags);
+}
 
 /**
  * zfcp_dbf_rec_run_lvl - trace event related to running recovery
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index bf8ea4df2bb8..e5eed8aac0ce 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -4,7 +4,7 @@
  *
  * External function declarations.
  *
- * Copyright IBM Corp. 2002, 2016
+ * Copyright IBM Corp. 2002, 2018
  */
 
 #ifndef ZFCP_EXT_H
@@ -35,6 +35,9 @@ extern int zfcp_dbf_adapter_register(struct zfcp_adapter *);
 extern void zfcp_dbf_adapter_unregister(struct zfcp_adapter *);
 extern void zfcp_dbf_rec_trig(char *, struct zfcp_adapter *,
 			      struct zfcp_port *, struct scsi_device *, u8, u8);
+extern void zfcp_dbf_rec_trig_lock(char *tag, struct zfcp_adapter *adapter,
+				   struct zfcp_port *port,
+				   struct scsi_device *sdev, u8 want, u8 need);
 extern void zfcp_dbf_rec_run(char *, struct zfcp_erp_action *);
 extern void zfcp_dbf_rec_run_lvl(int level, char *tag,
 				 struct zfcp_erp_action *erp);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 4d2ba5682493..22f9562f415c 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -4,7 +4,7 @@
  *
  * Interface to Linux SCSI midlayer.
  *
- * Copyright IBM Corp. 2002, 2017
+ * Copyright IBM Corp. 2002, 2018
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -618,9 +618,9 @@ static void zfcp_scsi_rport_register(struct zfcp_port *port)
 	ids.port_id = port->d_id;
 	ids.roles = FC_RPORT_ROLE_FCP_TARGET;
 
-	zfcp_dbf_rec_trig("scpaddy", port->adapter, port, NULL,
-			  ZFCP_PSEUDO_ERP_ACTION_RPORT_ADD,
-			  ZFCP_PSEUDO_ERP_ACTION_RPORT_ADD);
+	zfcp_dbf_rec_trig_lock("scpaddy", port->adapter, port, NULL,
+			       ZFCP_PSEUDO_ERP_ACTION_RPORT_ADD,
+			       ZFCP_PSEUDO_ERP_ACTION_RPORT_ADD);
 	rport = fc_remote_port_add(port->adapter->scsi_host, 0, &ids);
 	if (!rport) {
 		dev_err(&port->adapter->ccw_device->dev,
@@ -642,9 +642,9 @@ static void zfcp_scsi_rport_block(struct zfcp_port *port)
 	struct fc_rport *rport = port->rport;
 
 	if (rport) {
-		zfcp_dbf_rec_trig("scpdely", port->adapter, port, NULL,
-				  ZFCP_PSEUDO_ERP_ACTION_RPORT_DEL,
-				  ZFCP_PSEUDO_ERP_ACTION_RPORT_DEL);
+		zfcp_dbf_rec_trig_lock("scpdely", port->adapter, port, NULL,
+				       ZFCP_PSEUDO_ERP_ACTION_RPORT_DEL,
+				       ZFCP_PSEUDO_ERP_ACTION_RPORT_DEL);
 		fc_remote_port_delete(rport);
 		port->rport = NULL;
 	}
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index e29f9b8fd66d..56c940394729 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -182,7 +182,7 @@ zalon7xx-objs	:= zalon.o ncr53c8xx.o
 NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o
 
 # Files generated that shall be removed upon make clean
-clean-files :=	53c700_d.h 53c700_u.h
+clean-files :=	53c700_d.h 53c700_u.h scsi_devinfo_tbl.c
 
 $(obj)/53c700.o $(MODVERDIR)/$(obj)/53c700.ver: $(obj)/53c700_d.h
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c198b96368dd..5c40d809830f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1894,7 +1894,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 		num = (rem_sz > scatter_elem_sz_prev) ?
 			scatter_elem_sz_prev : rem_sz;
 
-		schp->pages[k] = alloc_pages(gfp_mask, order);
+		schp->pages[k] = alloc_pages(gfp_mask | __GFP_ZERO, order);
 		if (!schp->pages[k])
 			goto out;
 
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 4ad89ea71a70..4f26bdc3d1dc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2121,6 +2121,8 @@ static ssize_t tcmu_qfull_time_out_store(struct config_item *item,
 
 	if (val >= 0) {
 		udev->qfull_time_out = val * MSEC_PER_SEC;
+	} else if (val == -1) {
+		udev->qfull_time_out = val;
 	} else {
 		printk(KERN_ERR "Invalid qfull timeout value %d\n", val);
 		return -EINVAL;
