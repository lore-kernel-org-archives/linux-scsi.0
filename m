From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 3/5] fc_transport: add target driver support
Date: Sat, 01 Sep 2007 02:02:27 +0900
Message-ID: <200708311702.l7VH2RO9016097@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:59615 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965653AbXHaRCx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 13:02:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, James.Smart@Emulex.Com, andrew.vasquez@qlogic.com, hare@suse.de, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

This adds minimum target driver support like the srp transport does:

- fc_remote_port_{rolechg,delete} calls
scsi_tgt_it_nexus_{create,destroy} for target drivers.

- add callbacks to notify target drivers of the nexus and tmf
operation results to fc_function_template.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Kconfig                      |    7 +++++++
 drivers/scsi/scsi_transport_fc.c          |   29 +++++++++++++++++++++++++++++
 drivers/scsi/scsi_transport_fc_internal.h |   26 ++++++++++++++++++++++++++
 include/scsi/scsi_transport_fc.h          |    4 ++++
 4 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/scsi_transport_fc_internal.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 7877dfd..e1efa0e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -272,6 +272,13 @@ config SCSI_FC_ATTRS
 	  each attached FiberChannel device to sysfs, say Y.
 	  Otherwise, say N.
 
+config SCSI_FC_TGT_ATTRS
+	bool "SCSI target support for FiberChannel Transport Attributes"
+	depends on SCSI_FC_ATTRS
+	depends on SCSI_TGT = y || SCSI_TGT = SCSI_FC_ATTRS
+	help
+		If you want to use SCSI target mode drivers enable this option.
+
 config SCSI_ISCSI_ATTRS
 	tristate "iSCSI Transport Attributes"
 	depends on SCSI && NET
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4705725..1605a80 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -36,6 +36,7 @@
 #include <net/netlink.h>
 #include <scsi/scsi_netlink_fc.h>
 #include "scsi_priv.h"
+#include "scsi_transport_fc_internal.h"
 
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
 static void fc_vport_sched_delete(struct work_struct *work);
@@ -1956,6 +1957,19 @@ static int fc_user_scan(struct Scsi_Host *shost, uint channel,
 	return 0;
 }
 
+static int fc_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,
+				int result)
+{
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	return i->f->tsk_mgmt_response(shost, nexus, tm_id, result);
+}
+
+static int fc_it_nexus_response(struct Scsi_Host *shost, u64 nexus, int result)
+{
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	return i->f->it_nexus_response(shost, nexus, result);
+}
+
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
@@ -1999,6 +2013,10 @@ fc_attach_transport(struct fc_function_template *ft)
 
 	i->t.user_scan = fc_user_scan;
 
+	/* target-mode drivers' functions */
+	i->t.tsk_mgmt_response = fc_tsk_mgmt_response;
+	i->t.it_nexus_response = fc_it_nexus_response;
+
 	/*
 	 * Setup SCSI Target Attributes.
 	 */
@@ -2756,6 +2774,10 @@ fc_remote_port_delete(struct fc_rport  *rport)
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
+	if (rport->roles & FC_PORT_ROLE_FCP_INITIATOR &&
+	    shost->active_mode & MODE_TARGET)
+		fc_tgt_it_nexus_destroy(shost, (unsigned long)rport);
+
 	scsi_target_block(&rport->dev);
 
 	/* see if we need to kill io faster than waiting for device loss */
@@ -2796,6 +2818,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
 	int create = 0;
+	int ret;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (roles & FC_PORT_ROLE_FCP_TARGET) {
@@ -2804,6 +2827,12 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 			create = 1;
 		} else if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
 			create = 1;
+	} else if (shost->active_mode & MODE_TARGET) {
+		ret = fc_tgt_it_nexus_create(shost, (unsigned long)rport,
+					     (char *)&rport->node_name);
+		if (ret)
+			printk(KERN_ERR "FC Remore Port tgt nexus failed %d\n",
+			       ret);
 	}
 
 	rport->roles = roles;
diff --git a/drivers/scsi/scsi_transport_fc_internal.h b/drivers/scsi/scsi_transport_fc_internal.h
new file mode 100644
index 0000000..e7bfbe7
--- /dev/null
+++ b/drivers/scsi/scsi_transport_fc_internal.h
@@ -0,0 +1,26 @@
+#include <scsi/scsi_tgt.h>
+
+#ifdef CONFIG_SCSI_FC_TGT_ATTRS
+static inline int fc_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
+					 char *initiator)
+{
+	return scsi_tgt_it_nexus_create(shost, itn_id, initiator);
+}
+
+static inline int fc_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
+{
+	return scsi_tgt_it_nexus_destroy(shost, itn_id);
+}
+#else
+static inline int fc_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
+					 char *initiator)
+{
+	return 0;
+}
+
+static inline int fc_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
+{
+	return 0;
+}
+
+#endif
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index a0d80bc..594d7f2 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -589,6 +589,10 @@ struct fc_function_template {
 	int	(*vport_disable)(struct fc_vport *, bool);
 	int  	(*vport_delete)(struct fc_vport *);
 
+	/* target-mode drivers' functions */
+	int     (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
+	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);
+
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
 	u32	 			dd_fcvport_size;
-- 
1.5.2.4

