From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.14-rc6
Date: Sat, 15 Mar 2014 10:39:21 -0700
Message-ID: <1394905161.2166.25.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of six fixes.  Two are instant crash/null deref types
(storvsc and isci reset fixes). The two qla2xxx are initialisation
problems that cause MSI-X failures and card misdetection, the isci
erroneous macro is actually illegal C that's causing a miscompile with
certain gcc versions and the be2iscsi bad if expression is a static
checker fix. 

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Ales Novak (1):
      storvsc: NULL pointer dereference fix

Chad Dupuis (1):
      qla2xxx: Fix multiqueue MSI-X registration.

Dan Williams (1):
      isci: fix reset timeout handling

Giridhar Malavali (1):
      qla2xxx: Poll during initialization for ISP25xx and ISP83xx

Lukasz Dorau (1):
      isci: correct erroneous for_each_isci_host macro

Mike Christie (1):
      be2iscsi: fix bad if expression

The diffstat is:

 drivers/scsi/be2iscsi/be_main.c |  2 +-
 drivers/scsi/isci/host.h        |  5 ++---
 drivers/scsi/isci/port_config.c |  7 -------
 drivers/scsi/isci/task.c        |  2 +-
 drivers/scsi/qla2xxx/qla_def.h  |  3 +--
 drivers/scsi/qla2xxx/qla_isr.c  | 46 +++++++++++++++++++++++++++--------------
 drivers/scsi/storvsc_drv.c      |  3 +++
 7 files changed, 38 insertions(+), 30 deletions(-)

With the full diff below.

James

---

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1f37505..5642a9b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -325,7 +325,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		if (!abrt_task->sc || abrt_task->state == ISCSI_TASK_FREE)
 			continue;
 
-		if (abrt_task->sc->device->lun != abrt_task->sc->device->lun)
+		if (sc->device->lun != abrt_task->sc->device->lun)
 			continue;
 
 		/* Invalidate WRB Posted for this Task */
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 4911310..22a9bb1 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -311,9 +311,8 @@ static inline struct Scsi_Host *to_shost(struct isci_host *ihost)
 }
 
 #define for_each_isci_host(id, ihost, pdev) \
-	for (id = 0, ihost = to_pci_info(pdev)->hosts[id]; \
-	     id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
-	     ihost = to_pci_info(pdev)->hosts[++id])
+	for (id = 0; id < SCI_MAX_CONTROLLERS && \
+	     (ihost = to_pci_info(pdev)->hosts[id]); id++)
 
 static inline void wait_for_start(struct isci_host *ihost)
 {
diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index 85c77f6..ac87974 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -615,13 +615,6 @@ static void sci_apc_agent_link_up(struct isci_host *ihost,
 					  SCIC_SDS_APC_WAIT_LINK_UP_NOTIFICATION);
 	} else {
 		/* the phy is already the part of the port */
-		u32 port_state = iport->sm.current_state_id;
-
-		/* if the PORT'S state is resetting then the link up is from
-		 * port hard reset in this case, we need to tell the port
-		 * that link up is recieved
-		 */
-		BUG_ON(port_state != SCI_PORT_RESETTING);
 		port_agent->phy_ready_mask |= 1 << phy_index;
 		sci_port_link_up(iport, iphy);
 	}
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 0d30ca8..5d6fda7 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -801,7 +801,7 @@ int isci_task_I_T_nexus_reset(struct domain_device *dev)
 		/* XXX: need to cleanup any ireqs targeting this
 		 * domain_device
 		 */
-		ret = TMF_RESP_FUNC_COMPLETE;
+		ret = -ENODEV;
 		goto out;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e1fe95e..266724b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2996,8 +2996,7 @@ struct qla_hw_data {
 				IS_QLA82XX(ha) || IS_QLA83XX(ha) || \
 				IS_QLA8044(ha))
 #define IS_MSIX_NACK_CAPABLE(ha) (IS_QLA81XX(ha) || IS_QLA83XX(ha))
-#define IS_NOPOLLING_TYPE(ha)	((IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
-			IS_QLA83XX(ha)) && (ha)->flags.msix_enabled)
+#define IS_NOPOLLING_TYPE(ha)	(IS_QLA81XX(ha) && (ha)->flags.msix_enabled)
 #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha) || IS_QLA83XX(ha))
 #define IS_NOCACHE_VPD_TYPE(ha)	(IS_QLA81XX(ha) || IS_QLA83XX(ha))
 #define IS_ALOGIO_CAPABLE(ha)	(IS_QLA23XX(ha) || IS_FWI2_CAPABLE(ha))
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9bc86b9..0a1dcb4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2880,6 +2880,7 @@ static int
 qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
 #define MIN_MSIX_COUNT	2
+#define ATIO_VECTOR	2
 	int i, ret;
 	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
@@ -2936,34 +2937,47 @@ msix_failed:
 	}
 
 	/* Enable MSI-X vectors for the base queue */
-	for (i = 0; i < ha->msix_count; i++) {
+	for (i = 0; i < 2; i++) {
 		qentry = &ha->msix_entries[i];
-		if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
-			ret = request_irq(qentry->vector,
-				qla83xx_msix_entries[i].handler,
-				0, qla83xx_msix_entries[i].name, rsp);
-		} else if (IS_P3P_TYPE(ha)) {
+		if (IS_P3P_TYPE(ha))
 			ret = request_irq(qentry->vector,
 				qla82xx_msix_entries[i].handler,
 				0, qla82xx_msix_entries[i].name, rsp);
-		} else {
+		else
 			ret = request_irq(qentry->vector,
 				msix_entries[i].handler,
 				0, msix_entries[i].name, rsp);
-		}
-		if (ret) {
-			ql_log(ql_log_fatal, vha, 0x00cb,
-			    "MSI-X: unable to register handler -- %x/%d.\n",
-			    qentry->vector, ret);
-			qla24xx_disable_msix(ha);
-			ha->mqenable = 0;
-			goto msix_out;
-		}
+		if (ret)
+			goto msix_register_fail;
 		qentry->have_irq = 1;
 		qentry->rsp = rsp;
 		rsp->msix = qentry;
 	}
 
+	/*
+	 * If target mode is enable, also request the vector for the ATIO
+	 * queue.
+	 */
+	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
+		qentry = &ha->msix_entries[ATIO_VECTOR];
+		ret = request_irq(qentry->vector,
+			qla83xx_msix_entries[ATIO_VECTOR].handler,
+			0, qla83xx_msix_entries[ATIO_VECTOR].name, rsp);
+		qentry->have_irq = 1;
+		qentry->rsp = rsp;
+		rsp->msix = qentry;
+	}
+
+msix_register_fail:
+	if (ret) {
+		ql_log(ql_log_fatal, vha, 0x00cb,
+		    "MSI-X: unable to register handler -- %x/%d.\n",
+		    qentry->vector, ret);
+		qla24xx_disable_msix(ha);
+		ha->mqenable = 0;
+		goto msix_out;
+	}
+
 	/* Enable MSI-X vector for response queue update for queue 0 */
 	if (IS_QLA83XX(ha)) {
 		if (ha->msixbase && ha->mqiobase &&
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 17d7404..9969fa1 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1419,6 +1419,9 @@ static void storvsc_device_destroy(struct scsi_device *sdevice)
 {
 	struct stor_mem_pools *memp = sdevice->hostdata;
 
+	if (!memp)
+		return;
+
 	mempool_destroy(memp->request_mempool);
 	kmem_cache_destroy(memp->request_pool);
 	kfree(memp);
