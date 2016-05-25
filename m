From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ibmvscsis: Addressing Bart's comments
Date: Wed, 25 May 2016 09:17:33 -0500
Message-ID: <1464185854-19761-2-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1464185854-19761-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464185854-19761-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tyreld@linux.vnet.ibm.com, bart.vanassche@sandisk.com, joe@perches.com
Cc: martin.petersen@oracle.com, akpm@linux-foundation.org, kvalo@codeaurora.org, davem@davemloft.net, mchehab@osg.samsung.com, jslaby@suse.com, bp@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bryantly <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: bryantly <bryantly@linux.vnet.ibm.com>

This patch contains cleaning up the code for styling and also addresses Bart's comments.

Signed-off-by: bryantly <bryantly@linux.vnet.ibm.com>
---
 MAINTAINERS                       |   4 +-
 drivers/scsi/Kconfig              |  36 +--
 drivers/scsi/Makefile             |   4 +-
 drivers/scsi/ibmvscsi/Makefile    |   3 +-
 drivers/scsi/ibmvscsi/ibmvscsis.c | 450 ++++++++++++++++++--------------------
 drivers/scsi/ibmvscsi/ibmvscsis.h |  40 ++--
 drivers/scsi/ibmvscsi/libsrp.c    | 386 ++++++++++++++++++++++++++++++++
 drivers/scsi/ibmvscsi/libsrp.h    |  91 ++++++++
 drivers/scsi/libsrp.c             | 387 --------------------------------
 include/scsi/libsrp.h             |  95 --------
 10 files changed, 737 insertions(+), 759 deletions(-)
 create mode 100644 drivers/scsi/ibmvscsi/libsrp.c
 create mode 100644 drivers/scsi/ibmvscsi/libsrp.h
 delete mode 100644 drivers/scsi/libsrp.c
 delete mode 100644 include/scsi/libsrp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index b520e6c..a11905c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5387,9 +5387,9 @@ L:	linux-scsi@vger.kernel.org
 L:	target-devel@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvscsis.c
-F:      drivers/scsi/ibmvscsi/ibmvscsis.h
+F:	drivers/scsi/ibmvscsi/ibmvscsis.h
 F:	drivers/scsi/libsrp.h
-F:      drivers/scsi/libsrp.c
+F:	drivers/scsi/libsrp.c
 
 IBM Power Virtual FC Device Drivers
 M:	Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6adf8f1..1221f6b 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -848,18 +848,21 @@ config SCSI_IBMVSCSI
 	  module will be called ibmvscsi.
 
 config SCSI_IBMVSCSIS
-  	tristate "IBM Virtual SCSI Server support"
-  	depends on PPC_PSERIES && SCSI_SRP && TARGET_CORE
-  	help
-  	  This is the IBM POWER Virtual SCSI Target Server
+	tristate "IBM Virtual SCSI Server support"
+	depends on PPC_PSERIES && SCSI_SRP && TARGET_CORE
+	help
+	  This is the IBM POWER Virtual SCSI Target Server
+	  This driver uses the SRP protocol for communication betwen servers
+	  guest and/or the host that run on the same server.
+	  More information on VSCSI protocol can be found at www.power.org
 
-          The userspace component needed to initialize the driver and
-  	  documentation can be found:
+	  The userspace component needed to initialize the driver and
+	  documentation can be found:
 
-          https://github.com/powervm/ibmvscsis
+	  https://github.com/powervm/ibmvscsis
 
-          To compile this driver as a module, choose M here: the
-  	  module will be called ibmvstgt.
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibmvstgt.
 
 config SCSI_IBMVFC
 	tristate "IBM Virtual FC support"
@@ -1743,14 +1746,17 @@ config SCSI_PM8001
 	  based host adapters.
 
 config SCSI_SRP
-  	tristate "SCSI RDMA Protocol helper library"
-  	depends on SCSI && PCI
-  	help
-  	  This scsi srp module is a library for ibmvscsi target driver.
+	tristate "SCSI RDMA Protocol helper library"
+	depends on SCSI && PCI
+	help
+	  This SCSI SRP module is a library for ibmvscsi target driver.
+	  This module can only be used by SRP drivers that utilize synchronous
+	  data transfers and not by SRP drivers that use asynchronous.
+
 	  If you wish to use SRP target drivers, say Y.
 
-  	  To compile this driver as a module, choose M here. The module will
-  	  be called libsrp.
+	  To compile this driver as a module, choose M here. The module will
+	  be called libsrp.
 
 config SCSI_BFA_FC
 	tristate "Brocade BFA Fibre Channel Support"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 8692dd4..9dfa4da 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -127,9 +127,9 @@ obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
 obj-$(CONFIG_SCSI_SNI_53C710)	+= 53c700.o sni_53c710.o
 obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
 obj-$(CONFIG_SCSI_IPR)		+= ipr.o
-obj-$(CONFIG_SCSI_SRP)          += libsrp.o
+obj-$(CONFIG_SCSI_SRP)		+= ibmvscsi/
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi/
-obj-$(CONFIG_SCSI_IBMVSCSIS)    += ibmvscsi/
+obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
 obj-$(CONFIG_SCSI_STEX)		+= stex.o
diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
index b241a567..e7a1663 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi.o
-obj-$(CONFIG_SCSI_IBMVSCSIS)    += ibmvscsis.o
+obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsis.o
 obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvfc.o
+obj-$(CONFIG_SCSI_SRP)          += libsrp.o
diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.c b/drivers/scsi/ibmvscsi/ibmvscsis.c
index c7eb347..6f9e9ba 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsis.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsis.c
@@ -22,13 +22,14 @@
  *
  ****************************************************************************/
 
+#define pr_fmt(fmt)     KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/types.h>
 #include <linux/list.h>
-#include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
@@ -38,8 +39,6 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
-#include <scsi/libsrp.h>
-#include <generated/utsrelease.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
@@ -50,16 +49,16 @@
 #include <asm/prom.h>
 #include <asm/vio.h>
 
-#include "ibmvscsi.h"
 #include "ibmvscsis.h"
 #include "viosrp.h"
+#include "libsrp.h"
 
 #define IBMVSCSIS_VERSION	"v0.1"
 
 #define	INITIAL_SRP_LIMIT	15
 #define	DEFAULT_MAX_SECTORS	256
 
-#define MAX_H_COPY_RDMA		(128*1024)
+#define MAX_H_COPY_RDMA		(128 * 1024)
 
 #define SRP_RSP_SENSE_DATA_LEN	18
 
@@ -75,7 +74,7 @@ static void ibmvscsis_dev_release(struct device *dev);
 static void ibmvscsis_modify_rep_luns(struct se_cmd *se_cmd);
 static void ibmvscsis_modify_std_inquiry(struct se_cmd *se_cmd);
 static int read_dma_window(struct vio_dev *vdev,
-				struct ibmvscsis_adapter *adapter);
+			   struct ibmvscsis_adapter *adapter);
 static char *ibmvscsis_get_fabric_name(void);
 static char *ibmvscsis_get_fabric_wwn(struct se_portal_group *se_tpg);
 static u16 ibmvscsis_get_tag(struct se_portal_group *se_tpg);
@@ -137,7 +136,7 @@ static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg,
 			  enum dma_data_direction dir, unsigned int rest);
 static int ibmvscsis_queuecommand(struct ibmvscsis_adapter *adapter,
 				  struct iu_entry *iue);
-static uint64_t ibmvscsis_unpack_lun(const uint8_t *lun, int len);
+static u64 ibmvscsis_unpack_lun(const u8 *lun, int len);
 static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
 			    struct ibmvscsis_cmnd *vsc,
 			    struct srp_cmd *scmd);
@@ -146,7 +145,7 @@ static void ibmvscsis_determine_resid(struct se_cmd *se_cmd,
 static bool connection_broken(struct ibmvscsis_adapter *adapter);
 
 static inline long h_copy_rdma(s64 length, u64 sliobn, u64 slioba,
-	u64 dliobn, u64 dlioba)
+			       u64 dliobn, u64 dlioba)
 {
 	long rc = 0;
 
@@ -154,11 +153,11 @@ static inline long h_copy_rdma(s64 length, u64 sliobn, u64 slioba,
 	mb();
 
 	rc = plpar_hcall_norets(H_COPY_RDMA, length, sliobn, slioba,
-			dliobn, dlioba);
+				dliobn, dlioba);
 	return rc;
 }
 
-static inline void h_free_crq(uint32_t unit_address)
+static inline void h_free_crq(u32 unit_address)
 {
 	long rc = 0;
 
@@ -171,13 +170,13 @@ static inline void h_free_crq(uint32_t unit_address)
 }
 
 static inline long h_send_crq(struct ibmvscsis_adapter *adapter,
-			u64 word1, u64 word2)
+			      u64 word1, u64 word2)
 {
 	long rc;
 	struct vio_dev *vdev = adapter->dma_dev;
 
-	pr_debug("ibmvscsis: ibmvscsis_send_crq(0x%x, 0x%016llx, 0x%016llx)\n",
-			vdev->unit_address, word1, word2);
+	pr_debug("ibmvscsis_send_crq(0x%x, 0x%016llx, 0x%016llx)\n",
+		 vdev->unit_address, word1, word2);
 
 	/*
 	 * Ensure the command buffer is flushed to memory before handing it
@@ -185,7 +184,7 @@ static inline long h_send_crq(struct ibmvscsis_adapter *adapter,
 	 */
 	mb();
 	rc = plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
-	pr_debug("ibmvscsis: ibmvcsis_send_crq rc = 0x%lx\n", rc);
+	pr_debug("ibmvcsis_send_crq rc = 0x%lx\n", rc);
 
 	return rc;
 }
@@ -195,8 +194,8 @@ static inline long h_send_crq(struct ibmvscsis_adapter *adapter,
 /*****************************************************************************/
 
 static const char ibmvscsis_driver_name[] = "ibmvscsis";
-static char system_id[64] = "";
-static char partition_name[97] = "UNKNOWN";
+static char system_id[SYS_ID_NAME_LEN] = "";
+static char partition_name[PARTITION_NAMELEN] = "UNKNOWN";
 static unsigned int partition_number = -1;
 
 static struct class_attribute ibmvscsis_class_attrs[] = {
@@ -227,11 +226,9 @@ static struct class ibmvscsis_class = {
 };
 
 static ssize_t ibmvscsis_wwn_version_show(struct config_item *item,
-					       char *page)
+					  char *page)
 {
-	return sprintf(page, "IBMVSCSIS fabric %s on %s/%s on "UTS_RELEASE"\n",
-		       IBMVSCSIS_VERSION, utsname()->sysname,
-		       utsname()->machine);
+	return scnprintf(page, PAGE_SIZE, "%s\n", IBMVSCSIS_VERSION);
 }
 CONFIGFS_ATTR_RO(ibmvscsis_wwn_, version);
 
@@ -241,21 +238,23 @@ static struct configfs_attribute *ibmvscsis_wwn_attrs[] = {
 };
 
 static ssize_t ibmvscsis_tpg_enable_show(struct config_item *item,
-				char *page)
+					 char *page)
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
 	struct ibmvscsis_tport *tport = container_of(se_tpg,
-						struct ibmvscsis_tport, se_tpg);
+						     struct ibmvscsis_tport,
+						     se_tpg);
 
 	return snprintf(page, PAGE_SIZE, "%d\n", (tport->enabled) ? 1 : 0);
 }
 
 static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
-		const char *page, size_t count)
+					  const char *page, size_t count)
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
 	struct ibmvscsis_tport *tport = container_of(se_tpg,
-						struct ibmvscsis_tport, se_tpg);
+						     struct ibmvscsis_tport,
+						     se_tpg);
 	unsigned long tmp;
 	int ret;
 
@@ -267,7 +266,7 @@ static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
 
 	if ((tmp != 0) && (tmp != 1)) {
 		pr_err("Illegal value for ibmvscsis_tpg_store_enable: %lu\n",
-			tmp);
+		       tmp);
 		return -EINVAL;
 	}
 
@@ -320,7 +319,7 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
 	.fabric_drop_tpg		= ibmvscsis_drop_tpg,
 
 	.tfc_wwn_attrs			= ibmvscsis_wwn_attrs,
-	.tfc_tpg_base_attrs             = ibmvscsis_tpg_attrs,
+	.tfc_tpg_base_attrs		= ibmvscsis_tpg_attrs,
 };
 
 static struct vio_device_id ibmvscsis_device_table[] = {
@@ -340,7 +339,7 @@ static struct vio_driver ibmvscsis_driver = {
 /* End of global device driver data areas                                    */
 /*****************************************************************************/
 static int crq_queue_create(struct crq_queue *queue,
-				struct ibmvscsis_adapter *adapter)
+			    struct ibmvscsis_adapter *adapter)
 {
 	int retrc;
 	int err;
@@ -360,8 +359,9 @@ static int crq_queue_create(struct crq_queue *queue,
 	if (dma_mapping_error(&vdev->dev, queue->msg_token))
 		goto map_failed;
 
-	retrc = err = h_reg_crq(vdev->unit_address, queue->msg_token,
+	err = h_reg_crq(vdev->unit_address, queue->msg_token,
 			PAGE_SIZE);
+	retrc = err;
 
 	/* If the adapter was left active for some reason (like kexec)
 	 * try freeing and re-registering
@@ -369,10 +369,10 @@ static int crq_queue_create(struct crq_queue *queue,
 	if (err == H_RESOURCE)
 		err = ibmvscsis_reset_crq_queue(adapter);
 	if (err == 2) {
-		pr_warn("ibmvscsis: Partner adapter not ready\n");
+		pr_warn("Partner adapter not ready\n");
 		retrc = 0;
 	} else if (err != 0) {
-		pr_err("ibmvscsis: Error 0x%x opening virtual adapter\n", err);
+		pr_err("Error 0x%x opening virtual adapter\n", err);
 		goto reg_crq_failed;
 	}
 
@@ -384,13 +384,13 @@ static int crq_queue_create(struct crq_queue *queue,
 	err = request_irq(vdev->irq, &ibmvscsis_interrupt,
 			  0, "ibmvscsis", adapter);
 	if (err) {
-		pr_err("ibmvscsis: Error 0x%x h_send_crq\n", err);
+		pr_err("Error 0x%x h_send_crq\n", err);
 		goto req_irq_failed;
 	}
 
 	err = vio_enable_interrupts(vdev);
 	if (err != 0) {
-		pr_err("ibmvscsis: Error %d enabling interrupts!!!\n", err);
+		pr_err("Error %d enabling interrupts!!!\n", err);
 		goto req_irq_failed;
 	}
 
@@ -402,18 +402,11 @@ reg_crq_failed:
 	dma_unmap_single(&vdev->dev, queue->msg_token,
 			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
 map_failed:
-	free_page((unsigned long) queue->msgs);
+	free_page((unsigned long)queue->msgs);
 malloc_failed:
 	return -1;
 }
 
-/*
- * ibmvscsis_probe - ibm vscsis target initialize entry point
- * @param  dev vio device struct
- * @param  id  vio device id struct
- * @return	0 - Success
- *		Non-zero - Failure
- */
 static int ibmvscsis_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 {
 	int ret = -ENOMEM;
@@ -422,12 +415,12 @@ static int ibmvscsis_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	struct ibmvscsis_tport *tport;
 	unsigned long flags;
 
-	pr_debug("ibmvscsis: Probe for UA 0x%x\n", vdev->unit_address);
+	pr_debug("Probe for UA 0x%x\n", vdev->unit_address);
 
-	adapter = kzalloc(sizeof(struct ibmvscsis_adapter), GFP_KERNEL);
+	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
 	if (!adapter)
 		return ret;
-	target = kzalloc(sizeof(struct srp_target), GFP_KERNEL);
+	target = kzalloc(sizeof(*target), GFP_KERNEL);
 	if (!target)
 		goto free_adapter;
 
@@ -443,33 +436,33 @@ static int ibmvscsis_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	if (ret != 0)
 		goto free_target;
 
-	pr_debug("ibmvscsis: Probe: liobn 0x%x, riobn 0x%x\n", adapter->liobn,
-			adapter->riobn);
+	pr_debug("Probe: liobn 0x%x, riobn 0x%x\n", adapter->liobn,
+		 adapter->riobn);
 
 	spin_lock_irqsave(&ibmvscsis_dev_lock, flags);
 	list_add_tail(&adapter->list, &ibmvscsis_dev_list);
 	spin_unlock_irqrestore(&ibmvscsis_dev_lock, flags);
 
 	ret = srp_target_alloc(target, &vdev->dev,
-				INITIAL_SRP_LIMIT,
-				SRP_MAX_IU_LEN);
+			       INITIAL_SRP_LIMIT,
+			       SRP_MAX_IU_LEN);
 
 	adapter->target->ldata = adapter;
 
 	if (ret) {
-		pr_err("ibmvscsis: failed target alloc ret: %d\n", ret);
+		pr_err("failed target alloc ret: %d\n", ret);
 		goto free_srp_target;
 	}
 
 	ret = crq_queue_create(&adapter->crq_queue, adapter);
 	if (ret != 0 && ret != H_RESOURCE) {
-		pr_err("ibmvscsis: failed crq_queue_create ret: %d\n", ret);
+		pr_err("failed crq_queue_create ret: %d\n", ret);
 		ret = -1;
 	}
 
-	if (h_send_crq(adapter, 0xC001000000000000LL, 0) != 0
-			&& ret != H_RESOURCE) {
-		pr_warn("ibmvscsis: Failed to send CRQ message\n");
+	if (h_send_crq(adapter, 0xC001000000000000LL, 0) != 0 &&
+	    ret != H_RESOURCE) {
+		pr_warn("Failed to send CRQ message\n");
 		ret = 0;
 	}
 
@@ -520,8 +513,8 @@ static void ibmvscsis_modify_rep_luns(struct se_cmd *se_cmd)
 	buf = transport_kmap_data_sg(se_cmd);
 	if (buf) {
 		data_len = be32_to_cpu(*(u32 *)buf);
-		pr_debug("ibmvscsis: modify_rep_luns: len %d data_len %hud\n",
-			len, data_len);
+		pr_debug("modify_rep_luns: len %d data_len %hud\n",
+			 len, data_len);
 		if (data_len < len)
 			len = data_len;
 		buf += 8;
@@ -534,6 +527,12 @@ static void ibmvscsis_modify_rep_luns(struct se_cmd *se_cmd)
 	}
 }
 
+/*
+ * This function modifies the inquiry data prior to sending to initiator
+ * so that we can make support current AIX. Internally we are going to
+ * add new ODM entries to support the emulation from LIO. This function
+ * is temporary until those changes are done.
+ */
 static void ibmvscsis_modify_std_inquiry(struct se_cmd *se_cmd)
 {
 	struct se_device *dev = se_cmd->se_dev;
@@ -556,7 +555,7 @@ static void ibmvscsis_modify_std_inquiry(struct se_cmd *se_cmd)
 }
 
 static int read_dma_window(struct vio_dev *vdev,
-				struct ibmvscsis_adapter *adapter)
+			   struct ibmvscsis_adapter *adapter)
 {
 	const __be32 *dma_window;
 	const __be32 *prop;
@@ -567,9 +566,9 @@ static int read_dma_window(struct vio_dev *vdev,
 	 */
 	dma_window =
 		(const __be32 *)vio_get_attribute(vdev, "ibm,my-dma-window",
-						NULL);
+						  NULL);
 	if (!dma_window) {
-		pr_err("ibmvscsis: Couldn't find ibm,my-dma-window property\n");
+		pr_err("Couldn't find ibm,my-dma-window property\n");
 		return -1;
 	}
 
@@ -577,20 +576,22 @@ static int read_dma_window(struct vio_dev *vdev,
 	dma_window++;
 
 	prop = (const __be32 *)vio_get_attribute(vdev, "ibm,#dma-address-cells",
-						NULL);
+						 NULL);
 	if (!prop) {
-		pr_warn("ibmvscsis: Couldn't find ibm, #dma-address-cells property\n");
+		pr_warn("Couldn't find ibm, #dma-address-cells property\n");
 		dma_window++;
-	} else
+	} else {
 		dma_window += be32_to_cpu(*prop);
+	}
 
 	prop = (const __be32 *)vio_get_attribute(vdev, "ibm,#dma-size-cells",
-						NULL);
+						 NULL);
 	if (!prop) {
-		pr_warn("ibmvscsis: Couldn't find ibm, #dma-size-cells property\n");
+		pr_warn("Couldn't find ibm, #dma-size-cells property\n");
 		dma_window++;
-	} else
+	} else {
 		dma_window += be32_to_cpu(*prop);
+	}
 
 	/* dma_window should point to the second window now */
 	adapter->riobn = be32_to_cpu(*dma_window);
@@ -644,7 +645,8 @@ static u32 ibmvscsis_tpg_get_inst_index(struct se_portal_group *se_tpg)
 static int ibmvscsis_check_stop_free(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
-			struct ibmvscsis_cmnd, se_cmd);
+						  struct ibmvscsis_cmnd,
+						  se_cmd);
 
 	return target_put_sess_cmd(&cmd->se_cmd);
 }
@@ -674,12 +676,12 @@ static u32 ibmvscsis_sess_get_index(struct se_session *se_sess)
 static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
-			struct ibmvscsis_cmnd, se_cmd);
+						  struct ibmvscsis_cmnd,
+						  se_cmd);
 	struct scsi_cmnd *sc = &cmd->sc;
 	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
 	int ret;
 
-	pr_debug("ibmvscsis: ibmvscsis_write_pending\n");
 	sc->sdb.length = se_cmd->data_length;
 	sc->sdb.table.nents = se_cmd->t_data_nents;
 	sc->sdb.table.sgl = se_cmd->t_data_sg;
@@ -687,7 +689,7 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 	ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd,
 				ibmvscsis_rdma, 1, 1);
 	if (ret) {
-		pr_err("ibmvscsis: srp_transfer_data() failed: %d\n", ret);
+		pr_err("srp_transfer_data() failed: %d\n", ret);
 		return -EAGAIN;
 	}
 	/*
@@ -748,7 +750,8 @@ static void ibmvscsis_determine_resid(struct se_cmd *se_cmd,
 static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
-			struct ibmvscsis_cmnd, se_cmd);
+						  struct ibmvscsis_cmnd,
+						  se_cmd);
 	struct scsi_cmnd *sc = &cmd->sc;
 	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
 	struct srp_cmd *srp = (struct srp_cmd *)iue->sbuf->buf;
@@ -764,7 +767,6 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 	/*
 	 * Check for overflow residual count
 	 */
-	pr_debug("ibmvscsis: ibmvscsis_queue_data_in\n");
 
 	if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
 		scsi_set_resid(sc, se_cmd->residual_count);
@@ -775,19 +777,18 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 
 	if (scsi_sg_count(sc)) {
 		if (srp->cdb[0] == REPORT_LUNS &&
-					adapter->client_data.os_type != LINUX)
+		    adapter->client_data.os_type != LINUX)
 			ibmvscsis_modify_rep_luns(se_cmd);
 		if ((srp->cdb[0] == INQUIRY) && ((srp->cdb[1] & 0x1) == 0))
 			ibmvscsis_modify_std_inquiry(se_cmd);
 		ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd,
 					ibmvscsis_rdma, 1, 1);
 		if (ret) {
-			pr_err("ibmvscsis: srp_transfer_data failed: %d\n",
-				ret);
+			pr_err("srp_transfer_data failed: %d\n", ret);
 			sd = cmd->se_cmd.sense_buffer;
 			cmd->se_cmd.scsi_sense_length = 18;
 			memset(cmd->se_cmd.sense_buffer, 0,
-				cmd->se_cmd.scsi_sense_length);
+			       cmd->se_cmd.scsi_sense_length);
 			sd[0] = 0x70;
 			sd[2] = 3;
 			sd[7] = 10;
@@ -822,9 +823,10 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 static int ibmvscsis_queue_status(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
-					struct ibmvscsis_cmnd, se_cmd);
+						  struct ibmvscsis_cmnd,
+						  se_cmd);
 	struct scsi_cmnd *sc = &cmd->sc;
-	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
 	struct srp_rsp *rsp;
 	uint len;
 	char *data;
@@ -834,7 +836,6 @@ static int ibmvscsis_queue_status(struct se_cmd *se_cmd)
 	 * set the appropriate sc->result to be translated by
 	 * ibmvscsis_cmnd_done()
 	 */
-	pr_debug("ibmvscsis: ibmvscsis_queue_status\n");
 
 	rsp = &vio_iu(iue)->srp.rsp;
 	len = sizeof(*rsp);
@@ -861,9 +862,10 @@ static int ibmvscsis_queue_status(struct se_cmd *se_cmd)
 static void ibmvscsis_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
-			struct ibmvscsis_cmnd, se_cmd);
+						  struct ibmvscsis_cmnd,
+						  se_cmd);
 	struct scsi_cmnd *sc = &cmd->sc;
-	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
 	struct srp_target *target = iue->target;
 	struct ibmvscsis_adapter *adapter = target->ldata;
 	struct srp_rsp *rsp;
@@ -872,16 +874,16 @@ static void ibmvscsis_queue_tm_rsp(struct se_cmd *se_cmd)
 	u32 *tsk_status;
 	u32 rsp_code;
 
-	pr_debug("ibmvscsis: ibmvscsis_queue_tm_rsp\n");
 	rsp = &vio_iu(iue)->srp.rsp;
 
 	if (transport_check_aborted_status(se_cmd, false) != 0) {
-		pr_debug("ibmvscsis: queue_tm_rsp aborted\n");
+		pr_debug("queue_tm_rsp aborted\n");
 		atomic_inc(&adapter->req_lim_delta);
 		srp_iu_put(iue);
 	} else {
-		rsp->req_lim_delta = cpu_to_be32(1
-				+ atomic_xchg(&adapter->req_lim_delta, 0));
+		rsp->req_lim_delta = cpu_to_be32(1 +
+						 atomic_xchg(&adapter->
+							     req_lim_delta, 0));
 	}
 
 	len = sizeof(*rsp);
@@ -923,13 +925,12 @@ static void ibmvscsis_aborted_task(struct se_cmd *se_cmd)
 {
 }
 
-static struct se_portal_group *ibmvscsis_make_nexus(
-				struct ibmvscsis_tport *tport,
-				const char *name)
+static struct se_portal_group *ibmvscsis_make_nexus(struct ibmvscsis_tport
+						    *tport,
+						    const char *name)
 {
 	struct se_node_acl *acl;
 
-	pr_debug("ibmvscsis: make nexus");
 	if (tport->se_sess) {
 		pr_debug("tport->se_sess already exists\n");
 		return &tport->se_tpg;
@@ -950,10 +951,10 @@ static struct se_portal_group *ibmvscsis_make_nexus(
 	 */
 
 	acl = core_tpg_check_initiator_node_acl(&tport->se_tpg,
-				(unsigned char *)name);
+						(unsigned char *)name);
 	if (!acl) {
 		pr_debug("core_tpg_check_initiator_node_acl() failed for %s\n",
-			name);
+			 name);
 		goto acl_failed;
 	}
 	tport->se_sess->se_node_acl = acl;
@@ -962,8 +963,8 @@ static struct se_portal_group *ibmvscsis_make_nexus(
 	 * Now register the TCM ibmvscsis virtual I_T Nexus as active.
 	 */
 	transport_register_session(&tport->se_tpg,
-					tport->se_sess->se_node_acl,
-					tport->se_sess, tport);
+				   tport->se_sess->se_node_acl,
+				   tport->se_sess, tport);
 
 	tport->se_sess->se_tpg = &tport->se_tpg;
 
@@ -1027,8 +1028,8 @@ static struct se_wwn *ibmvscsis_make_tport(struct target_fabric_configfs *tf,
 		goto err;
 
 	tport->tport_proto_id = SCSI_PROTOCOL_SRP;
-	pr_debug("ibmvscsis: make_tport(%s), pointer:%p tport_id:%x\n", name,
-					tport, tport->tport_proto_id);
+	pr_debug("make_tport(%s), pointer:%p tport_id:%x\n", name, tport,
+		 tport->tport_proto_id);
 
 	return &tport->tport_wwn;
 err:
@@ -1038,10 +1039,11 @@ err:
 static void ibmvscsis_drop_tport(struct se_wwn *wwn)
 {
 	struct ibmvscsis_tport *tport = container_of(wwn,
-				struct ibmvscsis_tport, tport_wwn);
+						     struct ibmvscsis_tport,
+						     tport_wwn);
 
 	pr_debug("drop_tport(%s\n",
-		config_item_name(&tport->tport_wwn.wwn_group.cg_item));
+		 config_item_name(&tport->tport_wwn.wwn_group.cg_item));
 }
 
 static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
@@ -1066,7 +1068,8 @@ static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
 static void ibmvscsis_drop_tpg(struct se_portal_group *se_tpg)
 {
 	struct ibmvscsis_tport *tport = container_of(se_tpg,
-				struct ibmvscsis_tport, se_tpg);
+						     struct ibmvscsis_tport,
+						     se_tpg);
 
 	tport->releasing = true;
 	tport->enabled = false;
@@ -1108,7 +1111,6 @@ static int get_system_info(void)
 	const char *id, *model, *name;
 	const unsigned int *num;
 
-	pr_debug("ibmvscsis: getsysteminfo");
 	rootdn = of_find_node_by_path("/");
 	if (!rootdn)
 		return -ENOENT;
@@ -1147,7 +1149,6 @@ static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
 {
 	struct ibmvscsis_adapter *adapter = data;
 
-	pr_debug("ibmvscsis: there is an interrupt\n");
 	vio_disable_interrupts(adapter->dma_dev);
 	queue_work(vtgtd, &adapter->crq_work);
 
@@ -1164,14 +1165,14 @@ static int process_srp_iu(struct iu_entry *iue)
 	int err = 1;
 
 	spin_lock_irqsave(&target->lock, flags);
-	if (adapter->tport.releasing == true) {
-		pr_err("ibmvscsis: process_srp_iu error, tport is released:%x\n",
-			adapter->tport.releasing);
+	if (adapter->tport.releasing) {
+		pr_err("process_srp_iu error, tport is released:%x\n",
+		       adapter->tport.releasing);
 		goto done;
 	}
-	if (adapter->tport.enabled == false) {
-		pr_err("ibmvscsis: process_srp_iu, tport not enabled:%x\n",
-			adapter->tport.enabled);
+	if (!adapter->tport.enabled) {
+		pr_err("process_srp_iu, tport not enabled:%x\n",
+		       adapter->tport.enabled);
 		goto done;
 	}
 	spin_unlock_irqrestore(&target->lock, flags);
@@ -1187,7 +1188,7 @@ static int process_srp_iu(struct iu_entry *iue)
 		err = ibmvscsis_queuecommand(adapter, iue);
 		if (err) {
 			srp_iu_put(iue);
-			pr_err("ibmvscsis: can't queue cmd\n");
+			pr_err("can't queue cmd\n");
 		}
 		break;
 	case SRP_LOGIN_RSP:
@@ -1200,10 +1201,10 @@ static int process_srp_iu(struct iu_entry *iue)
 	case SRP_CRED_RSP:
 	case SRP_AER_REQ:
 	case SRP_AER_RSP:
-		pr_err("ibmvscsis: Unsupported type %u\n", opcode);
+		pr_err("Unsupported type %u\n", opcode);
 		break;
 	default:
-		pr_err("ibmvscsis: Unknown type %u\n", opcode);
+		pr_err("Unknown type %u\n", opcode);
 	}
 	return err;
 
@@ -1221,15 +1222,15 @@ static void process_iu(struct viosrp_crq *crq,
 
 	iue = srp_iu_get(adapter->target);
 	if (!iue) {
-		pr_err("ibmvscsis: Error getting IU from pool %p\n", iue);
+		pr_err("Error getting IU from pool %p\n", iue);
 		return;
 	}
 
 	iue->remote_token = crq->IU_data_ptr;
 
 	err = h_copy_rdma(be16_to_cpu(crq->IU_length), adapter->riobn,
-				be64_to_cpu(crq->IU_data_ptr),
-				adapter->liobn, iue->sbuf->dma);
+			  be64_to_cpu(crq->IU_data_ptr),
+			  adapter->liobn, iue->sbuf->dma);
 
 	switch (err) {
 	case H_SUCCESS:
@@ -1238,16 +1239,16 @@ static void process_iu(struct viosrp_crq *crq,
 	case H_SOURCE_PARM:
 	case H_DEST_PARM:
 		if (connection_broken(adapter))
-			pr_debug("ibmvscsis: rdma connection broken\n");
+			pr_debug("rdma connection broken\n");
 	default:
-		pr_err("ibmvscsis: process iu error\n");
+		pr_err("process iu error\n");
 		break;
 	}
 
-	if (crq->format == VIOSRP_MAD_FORMAT)
+	if (crq->format == VIOSRP_MAD_FORMAT) {
 		process_mad_iu(iue);
-	else {
-		pr_debug("ibmvscsis: process srpiu");
+	} else {
+		pr_debug("process srpiu");
 		process_srp_iu(iue);
 	}
 }
@@ -1265,7 +1266,7 @@ static void process_crq(struct viosrp_crq *crq,
 		case 0x02:
 			break;
 		default:
-			pr_err("ibmvscsis: Unknown format %u\n", crq->format);
+			pr_err("Unknown format %u\n", crq->format);
 		}
 		break;
 	case 0xFF:
@@ -1275,12 +1276,12 @@ static void process_crq(struct viosrp_crq *crq,
 		case PARTNER_FAILED:
 		case PARTNER_DEREGISTER:
 			adapter->client_data.os_type = 0;
-			pr_debug("ibmvscsis (%s):trans_event:good format %d\n",
-			dev_name(&adapter->dma_dev->dev), (uint)crq->format);
+			pr_debug("trans_event:good format %d\n",
+				 (uint)crq->format);
 			break;
 		default:
-			pr_err("ibmvscsis (%s):trans_event:invalid format %d\n",
-			dev_name(&adapter->dma_dev->dev), (uint)crq->format);
+			pr_err("trans_event:invalid format %d\n",
+			       (uint)crq->format);
 		}
 		break;
 	case 0x80:
@@ -1294,17 +1295,14 @@ static void process_crq(struct viosrp_crq *crq,
 		case VIOSRP_AIX_FORMAT:
 		case VIOSRP_LINUX_FORMAT:
 		case VIOSRP_INLINE_FORMAT:
-			pr_err("ibmvscsis: Unsupported format %u\n",
-					crq->format);
+			pr_err("Unsupported format %u\n", crq->format);
 			break;
 		default:
-			pr_err("ibmvscsis: Unknown format %u\n",
-					crq->format);
+			pr_err("Unknown format %u\n", crq->format);
 		}
 		break;
 	default:
-		pr_err("ibmvscsis: unknown message type 0x%02x!?\n",
-				crq->valid);
+		pr_err("Unknown message type 0x%02x!?\n", crq->valid);
 	}
 }
 
@@ -1328,8 +1326,9 @@ static void handle_crq(struct work_struct *work)
 			vio_disable_interrupts(adapter->dma_dev);
 			process_crq(crq, adapter);
 			crq->valid = 0x00;
-		} else
+		} else {
 			done = 1;
+		}
 	}
 }
 
@@ -1347,13 +1346,12 @@ static int ibmvscsis_reset_crq_queue(struct ibmvscsis_adapter *adapter)
 	queue->cur = 0;
 
 	/* And re-open it again */
-	rc = h_reg_crq(vdev->unit_address, queue->msg_token,
-			PAGE_SIZE);
+	rc = h_reg_crq(vdev->unit_address, queue->msg_token, PAGE_SIZE);
 	if (rc == 2)
 		/* Adapter is good, but other end is not ready */
-		pr_warn("ibmvscsis: Partner adapter not ready\n");
+		pr_warn("Partner adapter not ready\n");
 	else if (rc != 0)
-		pr_err("ibmvscsis: couldn't register crq--rc 0x%x\n", rc);
+		pr_err("Couldn't register crq--rc 0x%x\n", rc);
 
 	return rc;
 }
@@ -1388,8 +1386,9 @@ static inline struct viosrp_crq *next_crq(struct crq_queue *queue)
 		 * other bits of the CRQ entry
 		 */
 		rmb();
-	} else
+	} else {
 		crq = NULL;
+	}
 	spin_unlock_irqrestore(&queue->lock, flags);
 
 	return crq;
@@ -1405,12 +1404,12 @@ static int send_iu(struct iu_entry *iue, u64 length, u8 format)
 	long rc, rc1;
 
 	rsp = &vio_iu(iue)->srp.rsp;
-	pr_debug("ibmvscsis: send_iu: 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
-			(unsigned long)length,
-			(unsigned long)adapter->liobn,
-			(unsigned long)iue->sbuf->dma,
-			(unsigned long)adapter->riobn,
-			(unsigned long)be64_to_cpu(iue->remote_token));
+	pr_debug("send_iu: 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
+		 (unsigned long)length,
+		 (unsigned long)adapter->liobn,
+		 (unsigned long)iue->sbuf->dma,
+		 (unsigned long)adapter->riobn,
+		 (unsigned long)be64_to_cpu(iue->remote_token));
 
 	/* First copy the SRP */
 	rc = h_copy_rdma(length, adapter->liobn, iue->sbuf->dma,
@@ -1423,18 +1422,18 @@ static int send_iu(struct iu_entry *iue, u64 length, u8 format)
 	case H_SOURCE_PARM:
 	case H_DEST_PARM:
 		if (connection_broken(adapter)) {
-			pr_debug("ibmvscsis: rdma connection broken\n");
+			pr_debug("rdma connection broken\n");
 			goto end;
 		}
 		break;
 	default:
-		pr_err("ibmvscsis: Error %ld transferring data\n", rc);
+		pr_err("Error %ld transferring data\n", rc);
 		length = 0;
 		break;
 	}
 
-	pr_debug("ibmvscsis: crq pre cooked: 0x%x, 0x%llx, 0x%llx\n",
-			format, length, vio_iu(iue)->srp.rsp.tag);
+	pr_debug("crq pre cooked: 0x%x, 0x%llx, 0x%llx\n",
+		 format, length, vio_iu(iue)->srp.rsp.tag);
 
 	crq_msg.valid = 0x80;
 	crq_msg.format = format;
@@ -1447,18 +1446,18 @@ static int send_iu(struct iu_entry *iue, u64 length, u8 format)
 	crq_msg.IU_length = cpu_to_be16(length);
 	crq_msg.IU_data_ptr = vio_iu(iue)->srp.rsp.tag;
 
-	pr_debug("ibmvscsis: send crq: 0x%x, 0x%llx, 0x%llx\n",
-			adapter->dma_dev->unit_address,
-			be64_to_cpu(crq_as_u64[0]),
-			be64_to_cpu(crq_as_u64[1]));
+	pr_debug("send crq: 0x%x, 0x%llx, 0x%llx\n",
+		 adapter->dma_dev->unit_address,
+		 be64_to_cpu(crq_as_u64[0]),
+		 be64_to_cpu(crq_as_u64[1]));
 
 	srp_iu_put(iue);
 
 	rc1 = h_send_crq(adapter, be64_to_cpu(crq_as_u64[0]),
-				be64_to_cpu(crq_as_u64[1]));
+			 be64_to_cpu(crq_as_u64[1]));
 
 	if (rc1) {
-		pr_err("ibmvscsis: %ld sending response\n", rc1);
+		pr_err("%ld sending response\n", rc1);
 		return rc1;
 	}
 	return rc;
@@ -1486,18 +1485,18 @@ static int send_adapter_info(struct iu_entry *iue,
 	info = dma_alloc_coherent(&adapter->dma_dev->dev, sizeof(*info),
 				  &data_token, GFP_KERNEL);
 	if (!info) {
-		pr_err("ibmvscsis: bad dma_alloc_coherent %p\n", target);
+		pr_err("bad dma_alloc_coherent %p\n", target);
 		mad->common.status = cpu_to_be16(VIOSRP_MAD_FAILED);
 		return 1;
 	}
 
 	/* Get remote info */
 	err = h_copy_rdma(sizeof(*info), adapter->riobn,
-				be64_to_cpu(remote_buffer),
-				adapter->liobn, data_token);
+			  be64_to_cpu(remote_buffer),
+			  adapter->liobn, data_token);
 
 	if (err == H_SUCCESS) {
-		pr_err("ibmvscsis: Client connect: %s (%d)\n",
+		pr_err("Client connect: %s (%d)\n",
 		       info->partition_name, info->partition_number);
 
 		if (adapter->client_data.partition_number == 0)
@@ -1511,8 +1510,8 @@ static int send_adapter_info(struct iu_entry *iue,
 		adapter->client_data.mad_version =
 						be32_to_cpu(info->mad_version);
 		adapter->client_data.os_type = be32_to_cpu(info->os_type);
-		pr_debug("ibmvscsis: adapterinfo client adapter %u\n",
-				adapter->client_data.os_type);
+		pr_debug("adapter info client adapter %u\n",
+			 adapter->client_data.os_type);
 
 		strcpy(info->srp_version, "16.a");
 		strncpy(info->partition_name, partition_name,
@@ -1523,7 +1522,7 @@ static int send_adapter_info(struct iu_entry *iue,
 		info->os_type = cpu_to_be32(2);
 		memset(&info->port_max_txu[0], 0, sizeof(info->port_max_txu));
 		info->port_max_txu[0] = cpu_to_be32(SCSI_MAX_SG_SEGMENTS *
-						PAGE_SIZE);
+						    PAGE_SIZE);
 
 		dma_rmb();
 		/* Send our info to remote */
@@ -1537,14 +1536,14 @@ static int send_adapter_info(struct iu_entry *iue,
 		case H_SOURCE_PARM:
 		case H_DEST_PARM:
 			if (connection_broken(adapter))
-				pr_debug("ibmvscsis: rdma connection broken\n");
+				pr_debug("rdma connection broken\n");
 		default:
-			pr_err("ibmvscsis: Error sending adapter info %d\n",
+			pr_err("Error sending adapter info %d\n",
 			       err);
 			return -EIO;
 		}
 	} else {
-		pr_err("ibmvscsis: Error sending adapter info %d\n", err);
+		pr_err("Error sending adapter info %d\n", err);
 		return 1;
 	}
 
@@ -1562,10 +1561,10 @@ static int process_mad_iu(struct iu_entry *iue)
 
 	switch (be32_to_cpu(iu->mad.empty_iu.common.type)) {
 	case VIOSRP_EMPTY_IU_TYPE:
-		pr_err("ibmvscsis: %s\n", "Unsupported EMPTY MAD IU");
+		pr_err("%s\n", "Unsupported EMPTY MAD IU");
 		break;
 	case VIOSRP_ERROR_LOG_TYPE:
-		pr_err("ibmvscsis: %s\n", "Unsupported ERROR LOG MAD IU");
+		pr_err("%s\n", "Unsupported ERROR LOG MAD IU");
 		iu->mad.error_log.common.status = 1;
 		send_iu(iue, sizeof(iu->mad.error_log),	VIOSRP_MAD_FORMAT);
 		break;
@@ -1581,7 +1580,7 @@ static int process_mad_iu(struct iu_entry *iue)
 		send_iu(iue, sizeof(*conf), VIOSRP_MAD_FORMAT);
 		break;
 	default:
-		pr_err("ibmvscsis: Unknown type %u\n", iu->srp.rsp.opcode);
+		pr_err("Unknown type %u\n", iu->srp.rsp.opcode);
 		iu->mad.empty_iu.common.status =
 					cpu_to_be16(VIOSRP_MAD_NOT_SUPPORTED);
 		send_iu(iue, sizeof(iu->mad), VIOSRP_MAD_FORMAT);
@@ -1622,18 +1621,17 @@ static void process_login(struct iu_entry *iue)
 
 	snprintf(name, sizeof(name), "%x", vdev->unit_address);
 
-	if (adapter->tport.enabled == false) {
+	if (!adapter->tport.enabled) {
 		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		pr_err("ibmvscsis: Rejected SRP_LOGIN_REQ because target %s has not yet been enabled",
+		pr_err("Rejected SRP_LOGIN_REQ because target %s has not yet been enabled",
 		       name);
 		goto reject;
 	}
 
 	se_tpg = ibmvscsis_make_nexus(&adapter->tport,
 				      &adapter->tport.tport_name[0]);
-	if (se_tpg == NULL) {
-		pr_debug("ibmvscsis: login make nexus fail se_tpg(%p)\n",
-						se_tpg);
+	if (!se_tpg) {
+		pr_debug("login make nexus fail se_tpg(%p)\n", se_tpg);
 		goto reject;
 	}
 
@@ -1641,14 +1639,14 @@ static void process_login(struct iu_entry *iue)
 
 	rsp->req_lim_delta = cpu_to_be32(INITIAL_SRP_LIMIT);
 
-	pr_debug("ibmvscsis: process_login, tag:%llu\n", tag);
+	pr_debug("process_login, tag:%llu\n", tag);
 
 	rsp->tag = tag;
 	rsp->max_it_iu_len = cpu_to_be32(sizeof(union srp_iu));
 	rsp->max_ti_iu_len = cpu_to_be32(sizeof(union srp_iu));
 	/* direct and indirect */
-	rsp->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT
-					| SRP_BUF_FORMAT_INDIRECT);
+	rsp->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
+				   SRP_BUF_FORMAT_INDIRECT);
 
 	send_iu(iue, sizeof(*rsp), VIOSRP_SRP_FORMAT);
 	return;
@@ -1656,8 +1654,8 @@ static void process_login(struct iu_entry *iue)
 reject:
 	rej->opcode = SRP_LOGIN_REJ;
 	rej->tag = tag;
-	rej->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT
-				   | SRP_BUF_FORMAT_INDIRECT);
+	rej->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
+				   SRP_BUF_FORMAT_INDIRECT);
 
 	send_iu(iue, sizeof(*rej), VIOSRP_SRP_FORMAT);
 }
@@ -1674,7 +1672,7 @@ static void process_tsk_mgmt(struct ibmvscsis_adapter *adapter,
 	int rc = 0;
 
 	rsp = &vio_iu(iue)->srp.rsp;
-	unpacked_lun = ibmvscsis_unpack_lun((uint8_t *)&srp_tsk->lun,
+	unpacked_lun = ibmvscsis_unpack_lun((u8 *)&srp_tsk->lun,
 					    sizeof(srp_tsk->lun));
 
 	switch (srp_tsk->tsk_mgmt_func) {
@@ -1696,36 +1694,30 @@ static void process_tsk_mgmt(struct ibmvscsis_adapter *adapter,
 		tcm_type = TMR_CLEAR_ACA;
 		break;
 	default:
-		pr_err("ibmvscsis: unknown task mgmt func %d\n",
-						srp_tsk->tsk_mgmt_func);
+		pr_err("unknown task mgmt func %d\n", srp_tsk->tsk_mgmt_func);
 		cmd->se_cmd.se_tmr_req->response =
 					TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
-		rc = -1;
-		break;
+		goto fail;
 	}
 
-	if (!rc) {
-		cmd->se_cmd.tag = be64_to_cpu(srp_tsk->tag);
-
-		pr_debug("ibmvscsis: calling submit_tmr, func %d\n",
-			 srp_tsk->tsk_mgmt_func);
-		rc = target_submit_tmr(&cmd->se_cmd,
-				       adapter->tport.se_sess, NULL,
-				       unpacked_lun, srp_tsk, tcm_type,
-				       GFP_KERNEL, tag_to_abort,
-				       TARGET_SCF_ACK_KREF);
-		if (rc != 0) {
-			pr_err("ibmvscsis: target_submit_tmr failed, rc %d\n",
-			       rc);
-			cmd->se_cmd.se_tmr_req->response =
-							TMR_FUNCTION_REJECTED;
-			goto fail;
-		}
+	cmd->se_cmd.tag = be64_to_cpu(srp_tsk->tag);
+
+	pr_debug("calling submit_tmr, func %d\n",
+		 srp_tsk->tsk_mgmt_func);
+	rc = target_submit_tmr(&cmd->se_cmd,
+			       adapter->tport.se_sess, NULL,
+			       unpacked_lun, srp_tsk, tcm_type,
+			       GFP_KERNEL, tag_to_abort,
+			       TARGET_SCF_ACK_KREF);
+	if (rc != 0) {
+		pr_err("target_submit_tmr failed, rc %d\n", rc);
+		cmd->se_cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
+		goto fail;
 	}
+
 fail:
 	if (rc)
 		transport_send_check_condition_and_sense(&cmd->se_cmd, 0, 0);
-
 }
 
 static bool connection_broken(struct ibmvscsis_adapter *adapter)
@@ -1737,7 +1729,8 @@ static bool connection_broken(struct ibmvscsis_adapter *adapter)
 
 	/* create a PING crq */
 	crq = (struct viosrp_crq *)&buffer;
-	buffer[0] = buffer[1] = 0;
+	buffer[0] = 0;
+	buffer[1] = 0;
 	crq->valid = 0x80;
 	crq->format = 6;
 	crq->status = 0xF5;
@@ -1746,8 +1739,7 @@ static bool connection_broken(struct ibmvscsis_adapter *adapter)
 				   cpu_to_be64(buffer[0]),
 				   cpu_to_be64(buffer[1]));
 
-	pr_debug("ibmvscsis (%s): connection_broken: rc %ld\n",
-			dev_name(&adapter->dma_dev->dev), h_return_code);
+	pr_debug("connection_broken: rc %ld\n", h_return_code);
 
 	if (h_return_code == H_CLOSED)
 		rc = true;
@@ -1759,7 +1751,7 @@ static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 			  struct srp_direct_buf *md, int nmd,
 			  enum dma_data_direction dir, unsigned int rest)
 {
-	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
 	struct srp_target *target = iue->target;
 	struct ibmvscsis_adapter *adapter = target->ldata;
 	dma_addr_t token;
@@ -1767,7 +1759,8 @@ static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 	unsigned int done = 0;
 	int i, sidx, soff;
 
-	sidx = soff = 0;
+	sidx = 0;
+	soff = 0;
 	token = sg_dma_address(sg + sidx);
 
 	for (i = 0; i < nmd && rest; i++) {
@@ -1788,7 +1781,8 @@ static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 						  adapter->liobn,
 						  token + soff,
 						  adapter->riobn,
-						  be64_to_cpu(md[i].va)+mdone);
+						  be64_to_cpu(md[i].va) +
+						  mdone);
 			switch (err) {
 			case H_SUCCESS:
 				break;
@@ -1796,10 +1790,10 @@ static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 			case H_SOURCE_PARM:
 			case H_DEST_PARM:
 				if (connection_broken(adapter))
-					pr_debug("ibmvscsis: rdma connection broken\n");
+					pr_debug("rdma connection broken\n");
 			default:
-				pr_err("ibmvscsis: rdma error %d %d %ld\n",
-					dir, slen, err);
+				pr_err("rdma error %d %d %ld\n",
+				       dir, slen, err);
 				return -EIO;
 			}
 
@@ -1814,8 +1808,8 @@ static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 				token = sg_dma_address(sg + sidx);
 
 				if (sidx > nsg) {
-					pr_err("ibmvscsis: out of sg %p %d %d\n",
-						iue, sidx, nsg);
+					pr_err("out of sg %p %d %d\n",
+					       iue, sidx, nsg);
 					return -EIO;
 				}
 			}
@@ -1833,8 +1827,6 @@ static int ibmvscsis_queuecommand(struct ibmvscsis_adapter *adapter,
 	struct ibmvscsis_cmnd *vsc;
 	int ret;
 
-	pr_debug("ibmvscsis: ibmvscsis_queuecommand\n");
-
 	vsc = kzalloc(sizeof(*vsc), GFP_KERNEL);
 	adapter->cmd = vsc;
 	sc = &vsc->sc;
@@ -1847,14 +1839,14 @@ static int ibmvscsis_queuecommand(struct ibmvscsis_adapter *adapter,
 	return ret;
 }
 
-static uint64_t ibmvscsis_unpack_lun(const uint8_t *lun, int len)
+static u64 ibmvscsis_unpack_lun(const u8 *lun, int len)
 {
-	uint64_t res = NO_SUCH_LUN;
+	u64 res = NO_SUCH_LUN;
 	int addressing_method;
 
 	if (unlikely(len < 2)) {
 		pr_err("Illegal LUN length %d, expected 2 bytes or more\n",
-			len);
+		       len);
 		goto out;
 	}
 
@@ -1888,7 +1880,7 @@ static uint64_t ibmvscsis_unpack_lun(const uint8_t *lun, int len)
 	case SCSI_LUN_ADDR_METHOD_EXTENDED_LUN:
 	default:
 		pr_err("Unimplemented LUN addressing method %u\n",
-			addressing_method);
+		       addressing_method);
 		break;
 	}
 
@@ -1907,7 +1899,7 @@ static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
 	int attr;
 	u64 data_len;
 	int ret;
-	uint64_t unpacked_lun;
+	u64 unpacked_lun;
 
 	switch (scmd->task_attr) {
 	case SRP_SIMPLE_TASK:
@@ -1923,24 +1915,23 @@ static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
 		attr = TCM_ACA_TAG;
 		break;
 	default:
-		pr_err("ibmvscsis: Task attribute %d not supported\n",
-		       scmd->task_attr);
+		pr_err("Task attribute %d not supported\n", scmd->task_attr);
 		attr = TCM_SIMPLE_TAG;
 	}
 
-	pr_debug("ibmvscsis: srp_data_length: %llx, srp_direction:%x\n",
-			srp_data_length(scmd, srp_cmd_direction(scmd)),
-			srp_cmd_direction(scmd));
+	pr_debug("srp_data_length: %llx, srp_direction:%x\n",
+		 srp_data_length(scmd, srp_cmd_direction(scmd)),
+		 srp_cmd_direction(scmd));
 	data_len = srp_data_length(scmd, srp_cmd_direction(scmd));
 
 	vsc->se_cmd.tag = scmd->tag;
 	se_cmd = &vsc->se_cmd;
 
-	pr_debug("ibmvscsis: size of lun:%lx, lun:%s\n", sizeof(scmd->lun),
-				&scmd->lun.scsi_lun[0]);
+	pr_debug("size of lun:%lx, lun:%s\n", sizeof(scmd->lun),
+		 &scmd->lun.scsi_lun[0]);
 
-	unpacked_lun = ibmvscsis_unpack_lun((uint8_t *)&scmd->lun,
-				sizeof(scmd->lun));
+	unpacked_lun = ibmvscsis_unpack_lun((u8 *)&scmd->lun,
+					    sizeof(scmd->lun));
 
 	ret = target_submit_cmd(se_cmd, adapter->tport.se_sess,
 				&scmd->cdb[0], &vsc->sense_buf[0], unpacked_lun,
@@ -1948,7 +1939,7 @@ static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
 				TARGET_SCF_ACK_KREF);
 	if (ret != 0) {
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		pr_debug("ibmvscsis: tcm_queuecommand fail submit_cmd\n");
+		pr_debug("tcm_queuecommand fail submit_cmd\n");
 		goto send_sense;
 	}
 	return 0;
@@ -1971,27 +1962,21 @@ static int __init ibmvscsis_init(void)
 {
 	int ret = -ENOMEM;
 
-	pr_info("IBMVSCSIS fabric module %s on %s/%s on "UTS_RELEASE"\n",
-		IBMVSCSIS_VERSION,
-		utsname()->sysname,
-		utsname()->machine);
-
 	ret = get_system_info();
 	if (ret) {
-		pr_err("ibmvscsis: ret %d from get_system_info\n", ret);
+		pr_err("ret %d from get_system_info\n", ret);
 		goto out;
 	}
 
 	ret = class_register(&ibmvscsis_class);
 	if (ret) {
-		pr_err("ibmvscsis failed class register\n");
+		pr_err("failed class register\n");
 		goto out;
 	}
 
 	ret = target_register_template(&ibmvscsis_ops);
 	if (ret) {
-		pr_err("ibmvscsis: ret %d from target_register_template\n",
-				ret);
+		pr_err("ret %d from target_register_template\n", ret);
 		goto unregister_class;
 	}
 
@@ -2001,7 +1986,7 @@ static int __init ibmvscsis_init(void)
 
 	ret = vio_register_driver(&ibmvscsis_driver);
 	if (ret) {
-		pr_err("ibmvscsis: ret %d from vio_register_driver\n", ret);
+		pr_err("ret %d from vio_register_driver\n", ret);
 		goto destroy_wq;
 	}
 
@@ -2019,7 +2004,7 @@ out:
 
 static void __exit ibmvscsis_exit(void)
 {
-	pr_info("ibmvscsis: Unregister IBM virtual SCSI driver\n");
+	pr_info("Unregister IBM virtual SCSI driver\n");
 	vio_unregister_driver(&ibmvscsis_driver);
 	destroy_workqueue(vtgtd);
 	target_unregister_template(&ibmvscsis_ops);
@@ -2029,5 +2014,6 @@ static void __exit ibmvscsis_exit(void)
 MODULE_DESCRIPTION("IBMVSCSIS fabric driver");
 MODULE_AUTHOR("Bryant G. Ly");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(IBMVSCSIS_VERSION);
 module_init(ibmvscsis_init);
 module_exit(ibmvscsis_exit);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.h b/drivers/scsi/ibmvscsi/ibmvscsis.h
index bcee92b..0637aeb 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsis.h
+++ b/drivers/scsi/ibmvscsi/ibmvscsis.h
@@ -25,27 +25,36 @@
 #ifndef __H_IBMVSCSIS
 #define __H_IBMVSCSIS
 
+#define SYS_ID_NAME_LEN		64
+#define PARTITION_NAMELEN	97
 #define IBMVSCSIS_NAMELEN       32
 
 #define SCSOLNT_RESP_SHIFT      1
 #define UCSOLNT_RESP_SHIFT      2
 
-#define SCSOLNT         (1 << SCSOLNT_RESP_SHIFT)
-#define UCSOLNT         (1 << UCSOLNT_RESP_SHIFT)
+#define SCSOLNT		BIT(SCSOLNT_RESP_SHIFT)
+#define UCSOLNT		BIT(UCSOLNT_RESP_SHIFT)
 
 #define INQ_DATA_OFFSET 8
 #define NO_SUCH_LUN ((u64)-1LL)
 
+struct crq_queue {
+	struct viosrp_crq *msgs;
+	int size, cur;
+	dma_addr_t msg_token;
+	spinlock_t lock;
+};
+
 struct client_info {
 #define SRP_VERSION "16.a"
 	char srp_version[8];
 	/* root node property ibm,partition-name */
-	char partition_name[96];
+	char partition_name[PARTITION_NAMELEN];
 	/* root node property ibm,partition-no */
-	uint32_t partition_number;
+	u32 partition_number;
 	/* initially 1 */
-	uint32_t mad_version;
-	uint32_t os_type;
+	u32 mad_version;
+	u32 os_type;
 };
 
 struct ibmvscsis_cmnd {
@@ -112,25 +121,6 @@ struct ibmvscsis_nacl {
 	struct se_node_acl se_node_acl;
 };
 
-struct inquiry_data {
-	u8 qual_type;
-	u8 rmb_reserve;
-	u8 version;
-	u8 aerc_naca_hisup_format;
-	u8 addl_len;
-	u8 sccs_reserved;
-	u8 bque_encserv_vs_multip_mchngr_reserved;
-	u8 reladr_reserved_linked_cmdqueue_vs;
-	char vendor[8];
-	char product[16];
-	char revision[4];
-	char vendor_specific[20];
-	char reserved1[2];
-	char version_descriptor[16];
-	char reserved2[22];
-	char unique[158];
-};
-
 enum srp_trans_event {
 	UNUSED_FORMAT = 0,
 	PARTNER_FAILED = 1,
diff --git a/drivers/scsi/ibmvscsi/libsrp.c b/drivers/scsi/ibmvscsi/libsrp.c
new file mode 100644
index 0000000..4bece8f
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/libsrp.c
@@ -0,0 +1,386 @@
+/*******************************************************************************
+ * SCSI RDMA Protocol lib functions
+ *
+ * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2016 Bryant G. Ly <bgly@us.ibm.com> IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ ***********************************************************************/
+
+#define pr_fmt(fmt)     KBUILD_MODNAME ": " fmt
+
+#include <linux/printk.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/kfifo.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/srp.h>
+#include <target/target_core_base.h>
+
+#include "libsrp.h"
+
+static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
+			     struct srp_buf **ring)
+{
+	int i;
+	struct iu_entry *iue;
+
+	q->pool = kcalloc(max, sizeof(struct iu_entry *), GFP_KERNEL);
+	if (!q->pool)
+		return -ENOMEM;
+	q->items = kcalloc(max, sizeof(struct iu_entry), GFP_KERNEL);
+	if (!q->items)
+		goto free_pool;
+
+	spin_lock_init(&q->lock);
+	kfifo_init(&q->queue, (void *)q->pool, max * sizeof(void *));
+
+	for (i = 0, iue = q->items; i < max; i++) {
+		kfifo_in(&q->queue, (void *)&iue, sizeof(void *));
+		iue->sbuf = ring[i];
+		iue++;
+	}
+	return 0;
+
+free_pool:
+	kfree(q->pool);
+	return -ENOMEM;
+}
+
+static void srp_iu_pool_free(struct srp_queue *q)
+{
+	kfree(q->items);
+	kfree(q->pool);
+}
+
+static struct srp_buf **srp_ring_alloc(struct device *dev,
+				       size_t max, size_t size)
+{
+	struct srp_buf **ring;
+	int i;
+
+	ring = kcalloc(max, sizeof(struct srp_buf *), GFP_KERNEL);
+	if (!ring)
+		return NULL;
+
+	for (i = 0; i < max; i++) {
+		ring[i] = kzalloc(sizeof(*ring[i]), GFP_KERNEL);
+		if (!ring[i])
+			goto out;
+		ring[i]->buf = dma_alloc_coherent(dev, size, &ring[i]->dma,
+						  GFP_KERNEL);
+		if (!ring[i]->buf)
+			goto out;
+	}
+	return ring;
+
+out:
+	for (i = 0; i < max && ring[i]; i++) {
+		if (ring[i]->buf) {
+			dma_free_coherent(dev, size, ring[i]->buf,
+					  ring[i]->dma);
+		}
+		kfree(ring[i]);
+	}
+	kfree(ring);
+
+	return NULL;
+}
+
+static void srp_ring_free(struct device *dev, struct srp_buf **ring,
+			  size_t max, size_t size)
+{
+	int i;
+
+	for (i = 0; i < max; i++) {
+		dma_free_coherent(dev, size, ring[i]->buf, ring[i]->dma);
+		kfree(ring[i]);
+	}
+	kfree(ring);
+}
+
+int srp_target_alloc(struct srp_target *target, struct device *dev,
+		     size_t nr, size_t iu_size)
+{
+	int err;
+
+	spin_lock_init(&target->lock);
+
+	target->dev = dev;
+
+	target->srp_iu_size = iu_size;
+	target->rx_ring_size = nr;
+	target->rx_ring = srp_ring_alloc(target->dev, nr, iu_size);
+	if (!target->rx_ring)
+		return -ENOMEM;
+	err = srp_iu_pool_alloc(&target->iu_queue, nr, target->rx_ring);
+	if (err)
+		goto free_ring;
+
+	dev_set_drvdata(target->dev, target);
+	return 0;
+
+free_ring:
+	srp_ring_free(target->dev, target->rx_ring, nr, iu_size);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(srp_target_alloc);
+
+void srp_target_free(struct srp_target *target)
+{
+	dev_set_drvdata(target->dev, NULL);
+	srp_ring_free(target->dev, target->rx_ring, target->rx_ring_size,
+		      target->srp_iu_size);
+	srp_iu_pool_free(&target->iu_queue);
+}
+EXPORT_SYMBOL_GPL(srp_target_free);
+
+struct iu_entry *srp_iu_get(struct srp_target *target)
+{
+	struct iu_entry *iue = NULL;
+
+	if (kfifo_out_locked(&target->iu_queue.queue, (void *)&iue,
+			     sizeof(void *),
+			     &target->iu_queue.lock) != sizeof(void *)) {
+		WARN_ONCE(1, "unexpected fifo state");
+		return NULL;
+	}
+	if (!iue)
+		return iue;
+	iue->target = target;
+	iue->flags = 0;
+	return iue;
+}
+EXPORT_SYMBOL_GPL(srp_iu_get);
+
+void srp_iu_put(struct iu_entry *iue)
+{
+	kfifo_in_locked(&iue->target->iu_queue.queue, (void *)&iue,
+			sizeof(void *), &iue->target->iu_queue.lock);
+}
+EXPORT_SYMBOL_GPL(srp_iu_put);
+
+static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
+			   enum dma_data_direction dir, srp_rdma_t rdma_io,
+			   int dma_map, int ext_desc)
+{
+	struct iu_entry *iue = NULL;
+	struct scatterlist *sg = NULL;
+	int err, nsg = 0, len;
+
+	if (dma_map) {
+		iue = (struct iu_entry *)sc->SCp.ptr;
+		sg = scsi_sglist(sc);
+		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
+				 DMA_BIDIRECTIONAL);
+		if (!nsg) {
+			pr_err("fail to map %p %d\n", iue, scsi_sg_count(sc));
+			return 0;
+		}
+		len = min(scsi_bufflen(sc), be32_to_cpu(md->len));
+	} else {
+		len = be32_to_cpu(md->len);
+	}
+
+	err = rdma_io(sc, sg, nsg, md, 1, dir, len);
+
+	if (dma_map)
+		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+
+	return err;
+}
+
+static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
+			     struct srp_indirect_buf *id,
+			     enum dma_data_direction dir, srp_rdma_t rdma_io,
+			     int dma_map, int ext_desc)
+{
+	struct iu_entry *iue = NULL;
+	struct srp_direct_buf *md = NULL;
+	struct scatterlist dummy, *sg = NULL;
+	dma_addr_t token = 0;
+	int err = 0;
+	int nmd, nsg = 0, len;
+
+	if (dma_map || ext_desc) {
+		iue = (struct iu_entry *)sc->SCp.ptr;
+		sg = scsi_sglist(sc);
+	}
+
+	nmd = be32_to_cpu(id->table_desc.len) / sizeof(struct srp_direct_buf);
+
+	if ((dir == DMA_FROM_DEVICE && nmd == cmd->data_in_desc_cnt) ||
+	    (dir == DMA_TO_DEVICE && nmd == cmd->data_out_desc_cnt)) {
+		md = &id->desc_list[0];
+		goto rdma;
+	}
+
+	if (ext_desc && dma_map) {
+		md = dma_alloc_coherent(iue->target->dev,
+					be32_to_cpu(id->table_desc.len),
+					&token, GFP_KERNEL);
+		if (!md) {
+			pr_err("Can't get dma memory %u\n",
+			       be32_to_cpu(id->table_desc.len));
+			return -ENOMEM;
+		}
+
+		sg_init_one(&dummy, md, be32_to_cpu(id->table_desc.len));
+		sg_dma_address(&dummy) = token;
+		sg_dma_len(&dummy) = be32_to_cpu(id->table_desc.len);
+		err = rdma_io(sc, &dummy, 1, &id->table_desc, 1, DMA_TO_DEVICE,
+			      be32_to_cpu(id->table_desc.len));
+		if (err) {
+			pr_err("Error copying indirect table %d\n", err);
+			goto free_mem;
+		}
+	} else {
+		pr_err("This command uses external indirect buffer\n");
+		return -EINVAL;
+	}
+
+rdma:
+	if (dma_map) {
+		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
+				 DMA_BIDIRECTIONAL);
+		if (!nsg) {
+			pr_err("fail to map %p %d\n", iue, scsi_sg_count(sc));
+			err = -EIO;
+			goto free_mem;
+		}
+		len = min(scsi_bufflen(sc), be32_to_cpu(id->len));
+	} else {
+		len = be32_to_cpu(id->len);
+	}
+
+	err = rdma_io(sc, sg, nsg, md, nmd, dir, len);
+
+	if (dma_map)
+		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+
+free_mem:
+	if (token && dma_map) {
+		dma_free_coherent(iue->target->dev,
+				  be32_to_cpu(id->table_desc.len), md, token);
+	}
+	return err;
+}
+
+static int data_out_desc_size(struct srp_cmd *cmd)
+{
+	int size = 0;
+	u8 fmt = cmd->buf_fmt >> 4;
+
+	switch (fmt) {
+	case SRP_NO_DATA_DESC:
+		break;
+	case SRP_DATA_DESC_DIRECT:
+		size = sizeof(struct srp_direct_buf);
+		break;
+	case SRP_DATA_DESC_INDIRECT:
+		size = sizeof(struct srp_indirect_buf) +
+			sizeof(struct srp_direct_buf) * cmd->data_out_desc_cnt;
+		break;
+	default:
+		pr_err("client error. Invalid data_out_format %x\n", fmt);
+		break;
+	}
+	return size;
+}
+
+/*
+ * TODO: this can be called multiple times for a single command if it
+ * has very long data.
+ */
+int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
+		      srp_rdma_t rdma_io, int dma_map, int ext_desc)
+{
+	struct srp_direct_buf *md;
+	struct srp_indirect_buf *id;
+	enum dma_data_direction dir;
+	int offset, err = 0;
+	u8 format;
+
+	offset = cmd->add_cdb_len & ~3;
+
+	dir = srp_cmd_direction(cmd);
+	if (dir == DMA_FROM_DEVICE)
+		offset += data_out_desc_size(cmd);
+
+	if (dir == DMA_TO_DEVICE)
+		format = cmd->buf_fmt >> 4;
+	else
+		format = cmd->buf_fmt & ((1U << 4) - 1);
+
+	switch (format) {
+	case SRP_NO_DATA_DESC:
+		break;
+	case SRP_DATA_DESC_DIRECT:
+		md = (struct srp_direct_buf *)(cmd->add_data + offset);
+		err = srp_direct_data(sc, md, dir, rdma_io, dma_map, ext_desc);
+		break;
+	case SRP_DATA_DESC_INDIRECT:
+		id = (struct srp_indirect_buf *)(cmd->add_data + offset);
+		err = srp_indirect_data(sc, cmd, id, dir, rdma_io, dma_map,
+					ext_desc);
+		break;
+	default:
+		pr_err("Unknown format %d %x\n", dir, format);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(srp_transfer_data);
+
+u64 srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
+{
+	struct srp_direct_buf *md;
+	struct srp_indirect_buf *id;
+	u64 len = 0;
+	unsigned offset = cmd->add_cdb_len & ~3;
+	u8 fmt;
+
+	if (dir == DMA_TO_DEVICE) {
+		fmt = cmd->buf_fmt >> 4;
+	} else {
+		fmt = cmd->buf_fmt & ((1U << 4) - 1);
+		offset += data_out_desc_size(cmd);
+	}
+
+	switch (fmt) {
+	case SRP_NO_DATA_DESC:
+		break;
+	case SRP_DATA_DESC_DIRECT:
+		md = (struct srp_direct_buf *)(cmd->add_data + offset);
+		len = be32_to_cpu(md->len);
+		break;
+	case SRP_DATA_DESC_INDIRECT:
+		id = (struct srp_indirect_buf *)(cmd->add_data + offset);
+		len = be32_to_cpu(id->len);
+		break;
+	default:
+		pr_err("invalid data format %x\n", fmt);
+		break;
+	}
+	return len;
+}
+EXPORT_SYMBOL_GPL(srp_data_length);
+
+MODULE_DESCRIPTION("SCSI RDMA Protocol lib functions");
+MODULE_AUTHOR("FUJITA Tomonori");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/ibmvscsi/libsrp.h b/drivers/scsi/ibmvscsi/libsrp.h
new file mode 100644
index 0000000..bf9e30b
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/libsrp.h
@@ -0,0 +1,91 @@
+#ifndef __LIBSRP_H__
+#define __LIBSRP_H__
+
+#include <linux/list.h>
+#include <linux/kfifo.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <scsi/srp.h>
+#include <target/target_core_base.h>
+
+enum srp_task_attributes {
+	SRP_SIMPLE_TASK = 0,
+	SRP_HEAD_TASK = 1,
+	SRP_ORDERED_TASK = 2,
+	SRP_ACA_TASK = 4
+};
+
+enum iue_flags {
+	V_DIOVER,
+	V_WRITE,
+	V_LINKED,
+	V_FLYING,
+};
+
+enum {
+	SRP_TASK_MANAGEMENT_FUNCTION_COMPLETE           = 0,
+	SRP_REQUEST_FIELDS_INVALID                      = 2,
+	SRP_TASK_MANAGEMENT_FUNCTION_NOT_SUPPORTED      = 4,
+	SRP_TASK_MANAGEMENT_FUNCTION_FAILED             = 5
+};
+
+struct srp_buf {
+	dma_addr_t dma;
+	void *buf;
+};
+
+struct srp_queue {
+	void *pool;
+	void *items;
+	struct kfifo queue;
+	spinlock_t lock;
+};
+
+struct srp_target {
+	struct Scsi_Host *shost;
+	struct se_device *tgt;
+	struct device *dev;
+
+	spinlock_t lock;
+	struct list_head cmd_queue;
+
+	size_t srp_iu_size;
+	struct srp_queue iu_queue;
+	size_t rx_ring_size;
+	struct srp_buf **rx_ring;
+
+	void *ldata;
+};
+
+struct iu_entry {
+	struct srp_target *target;
+
+	struct list_head ilist;
+	dma_addr_t remote_token;
+	unsigned long flags;
+
+	struct srp_buf *sbuf;
+};
+
+typedef int (srp_rdma_t)(struct scsi_cmnd *, struct scatterlist *, int,
+			 struct srp_direct_buf *, int,
+			 enum dma_data_direction, unsigned int);
+extern int srp_target_alloc(struct srp_target *, struct device *,
+			    size_t, size_t);
+extern void srp_target_free(struct srp_target *);
+extern struct iu_entry *srp_iu_get(struct srp_target *);
+extern void srp_iu_put(struct iu_entry *);
+extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *, srp_rdma_t,
+			     int, int);
+extern u64 srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir);
+static inline struct srp_target *host_to_srp_target(struct Scsi_Host *host)
+{
+	return (struct srp_target *)host->hostdata;
+}
+
+static inline int srp_cmd_direction(struct srp_cmd *cmd)
+{
+	return (cmd->buf_fmt >> 4) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+}
+
+#endif
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
deleted file mode 100644
index 0e32abd..0000000
--- a/drivers/scsi/libsrp.c
+++ /dev/null
@@ -1,387 +0,0 @@
-/*******************************************************************************
- * SCSI RDMA Protocol lib functions
- *
- * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
- * Copyright (C) 2016 Bryant G. Ly <bgly@us.ibm.com> IBM Corp.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- ***********************************************************************/
-
-#include <linux/printk.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/kfifo.h>
-#include <linux/scatterlist.h>
-#include <linux/dma-mapping.h>
-#include <linux/module.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/srp.h>
-#include <target/target_core_base.h>
-#include <scsi/libsrp.h>
-
-static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
-			     struct srp_buf **ring)
-{
-	int i;
-	struct iu_entry *iue;
-
-	q->pool = kcalloc(max, sizeof(struct iu_entry *), GFP_KERNEL);
-	if (!q->pool)
-		return -ENOMEM;
-	q->items = kcalloc(max, sizeof(struct iu_entry), GFP_KERNEL);
-	if (!q->items)
-		goto free_pool;
-
-	spin_lock_init(&q->lock);
-	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
-
-	for (i = 0, iue = q->items; i < max; i++) {
-		kfifo_in(&q->queue, (void *) &iue, sizeof(void *));
-		iue->sbuf = ring[i];
-		iue++;
-	}
-	return 0;
-
-free_pool:
-	kfree(q->pool);
-	return -ENOMEM;
-}
-
-static void srp_iu_pool_free(struct srp_queue *q)
-{
-	kfree(q->items);
-	kfree(q->pool);
-}
-
-static struct srp_buf **srp_ring_alloc(struct device *dev,
-				       size_t max, size_t size)
-{
-	int i;
-	struct srp_buf **ring;
-
-	ring = kcalloc(max, sizeof(struct srp_buf *), GFP_KERNEL);
-	if (!ring)
-		return NULL;
-
-	for (i = 0; i < max; i++) {
-		ring[i] = kzalloc(sizeof(struct srp_buf), GFP_KERNEL);
-		if (!ring[i])
-			goto out;
-		ring[i]->buf = dma_alloc_coherent(dev, size, &ring[i]->dma,
-						  GFP_KERNEL);
-		if (!ring[i]->buf)
-			goto out;
-	}
-	return ring;
-
-out:
-	for (i = 0; i < max && ring[i]; i++) {
-		if (ring[i]->buf) {
-			dma_free_coherent(dev, size, ring[i]->buf,
-						ring[i]->dma);
-		}
-		kfree(ring[i]);
-	}
-	kfree(ring);
-
-	return NULL;
-}
-
-static void srp_ring_free(struct device *dev, struct srp_buf **ring,
-			  size_t max, size_t size)
-{
-	int i;
-
-	for (i = 0; i < max; i++) {
-		dma_free_coherent(dev, size, ring[i]->buf, ring[i]->dma);
-		kfree(ring[i]);
-	}
-	kfree(ring);
-}
-
-int srp_target_alloc(struct srp_target *target, struct device *dev,
-		     size_t nr, size_t iu_size)
-{
-	int err;
-
-	spin_lock_init(&target->lock);
-
-	target->dev = dev;
-
-	target->srp_iu_size = iu_size;
-	target->rx_ring_size = nr;
-	target->rx_ring = srp_ring_alloc(target->dev, nr, iu_size);
-	if (!target->rx_ring)
-		return -ENOMEM;
-	err = srp_iu_pool_alloc(&target->iu_queue, nr, target->rx_ring);
-	if (err)
-		goto free_ring;
-
-	dev_set_drvdata(target->dev, target);
-	return 0;
-
-free_ring:
-	srp_ring_free(target->dev, target->rx_ring, nr, iu_size);
-	return -ENOMEM;
-}
-EXPORT_SYMBOL_GPL(srp_target_alloc);
-
-void srp_target_free(struct srp_target *target)
-{
-	dev_set_drvdata(target->dev, NULL);
-	srp_ring_free(target->dev, target->rx_ring, target->rx_ring_size,
-		      target->srp_iu_size);
-	srp_iu_pool_free(&target->iu_queue);
-}
-EXPORT_SYMBOL_GPL(srp_target_free);
-
-struct iu_entry *srp_iu_get(struct srp_target *target)
-{
-	struct iu_entry *iue = NULL;
-
-	if (kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
-				sizeof(void *),
-				&target->iu_queue.lock) != sizeof(void *)) {
-		WARN_ONCE(1, "unexpected fifo state");
-		return NULL;
-	}
-	if (!iue)
-		return iue;
-	iue->target = target;
-	iue->flags = 0;
-	return iue;
-}
-EXPORT_SYMBOL_GPL(srp_iu_get);
-
-void srp_iu_put(struct iu_entry *iue)
-{
-	kfifo_in_locked(&iue->target->iu_queue.queue, (void *) &iue,
-			sizeof(void *), &iue->target->iu_queue.lock);
-}
-EXPORT_SYMBOL_GPL(srp_iu_put);
-
-static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
-			   enum dma_data_direction dir, srp_rdma_t rdma_io,
-			   int dma_map, int ext_desc)
-{
-	struct iu_entry *iue = NULL;
-	struct scatterlist *sg = NULL;
-	int err, nsg = 0, len;
-
-	if (dma_map) {
-		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = scsi_sglist(sc);
-		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
-				 DMA_BIDIRECTIONAL);
-		if (!nsg) {
-			pr_err("libsrp: fail to map %p %d\n",
-				iue, scsi_sg_count(sc));
-			return 0;
-		}
-		len = min(scsi_bufflen(sc), be32_to_cpu(md->len));
-	} else
-		len = be32_to_cpu(md->len);
-
-	err = rdma_io(sc, sg, nsg, md, 1, dir, len);
-
-	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
-
-	return err;
-}
-
-static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
-			     struct srp_indirect_buf *id,
-			     enum dma_data_direction dir, srp_rdma_t rdma_io,
-			     int dma_map, int ext_desc)
-{
-	struct iu_entry *iue = NULL;
-	struct srp_direct_buf *md = NULL;
-	struct scatterlist dummy, *sg = NULL;
-	dma_addr_t token = 0;
-	int err = 0;
-	int nmd, nsg = 0, len;
-
-	if (dma_map || ext_desc) {
-		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = scsi_sglist(sc);
-	}
-
-	nmd = be32_to_cpu(id->table_desc.len) / sizeof(struct srp_direct_buf);
-
-	if ((dir == DMA_FROM_DEVICE && nmd == cmd->data_in_desc_cnt) ||
-	    (dir == DMA_TO_DEVICE && nmd == cmd->data_out_desc_cnt)) {
-		md = &id->desc_list[0];
-		goto rdma;
-	}
-
-	if (ext_desc && dma_map) {
-		md = dma_alloc_coherent(iue->target->dev,
-					be32_to_cpu(id->table_desc.len),
-					&token, GFP_KERNEL);
-		if (!md) {
-			pr_err("libsrp: Can't get dma memory %u\n",
-				be32_to_cpu(id->table_desc.len));
-			return -ENOMEM;
-		}
-
-		sg_init_one(&dummy, md, be32_to_cpu(id->table_desc.len));
-		sg_dma_address(&dummy) = token;
-		sg_dma_len(&dummy) = be32_to_cpu(id->table_desc.len);
-		err = rdma_io(sc, &dummy, 1, &id->table_desc, 1, DMA_TO_DEVICE,
-			      be32_to_cpu(id->table_desc.len));
-		if (err) {
-			pr_err("libsrp: Error copying indirect table %d\n",
-				err);
-			goto free_mem;
-		}
-	} else {
-		pr_err("libsrp: This command uses external indirect buffer\n");
-		return -EINVAL;
-	}
-
-rdma:
-	if (dma_map) {
-		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
-				 DMA_BIDIRECTIONAL);
-		if (!nsg) {
-			pr_err("libsrp: fail to map %p %d\n",
-				iue, scsi_sg_count(sc));
-			err = -EIO;
-			goto free_mem;
-		}
-		len = min(scsi_bufflen(sc), be32_to_cpu(id->len));
-	} else
-		len = be32_to_cpu(id->len);
-
-	err = rdma_io(sc, sg, nsg, md, nmd, dir, len);
-
-	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
-
-free_mem:
-	if (token && dma_map) {
-		dma_free_coherent(iue->target->dev,
-				  be32_to_cpu(id->table_desc.len), md, token);
-	}
-	return err;
-}
-
-static int data_out_desc_size(struct srp_cmd *cmd)
-{
-	int size = 0;
-	u8 fmt = cmd->buf_fmt >> 4;
-
-	switch (fmt) {
-	case SRP_NO_DATA_DESC:
-		break;
-	case SRP_DATA_DESC_DIRECT:
-		size = sizeof(struct srp_direct_buf);
-		break;
-	case SRP_DATA_DESC_INDIRECT:
-		size = sizeof(struct srp_indirect_buf) +
-			sizeof(struct srp_direct_buf) * cmd->data_out_desc_cnt;
-		break;
-	default:
-		pr_err("libsrp: client error. Invalid data_out_format %x\n",
-			fmt);
-		break;
-	}
-	return size;
-}
-
-/*
- * TODO: this can be called multiple times for a single command if it
- * has very long data.
- */
-int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
-		      srp_rdma_t rdma_io, int dma_map, int ext_desc)
-{
-	struct srp_direct_buf *md;
-	struct srp_indirect_buf *id;
-	enum dma_data_direction dir;
-	int offset, err = 0;
-	u8 format;
-
-	offset = cmd->add_cdb_len & ~3;
-
-	dir = srp_cmd_direction(cmd);
-	if (dir == DMA_FROM_DEVICE)
-		offset += data_out_desc_size(cmd);
-
-	if (dir == DMA_TO_DEVICE)
-		format = cmd->buf_fmt >> 4;
-	else
-		format = cmd->buf_fmt & ((1U << 4) - 1);
-
-	switch (format) {
-	case SRP_NO_DATA_DESC:
-		break;
-	case SRP_DATA_DESC_DIRECT:
-		md = (struct srp_direct_buf *)
-			(cmd->add_data + offset);
-		err = srp_direct_data(sc, md, dir, rdma_io, dma_map, ext_desc);
-		break;
-	case SRP_DATA_DESC_INDIRECT:
-		id = (struct srp_indirect_buf *)
-			(cmd->add_data + offset);
-		err = srp_indirect_data(sc, cmd, id, dir, rdma_io, dma_map,
-					ext_desc);
-		break;
-	default:
-		pr_err("libsrp: Unknown format %d %x\n", dir, format);
-		err = -EINVAL;
-	}
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(srp_transfer_data);
-
-u64 srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
-{
-	struct srp_direct_buf *md;
-	struct srp_indirect_buf *id;
-	u64 len = 0;
-	unsigned offset = cmd->add_cdb_len & ~3;
-	u8 fmt;
-
-	if (dir == DMA_TO_DEVICE)
-		fmt = cmd->buf_fmt >> 4;
-	else {
-		fmt = cmd->buf_fmt & ((1U << 4) - 1);
-		offset += data_out_desc_size(cmd);
-	}
-
-	switch (fmt) {
-	case SRP_NO_DATA_DESC:
-		break;
-	case SRP_DATA_DESC_DIRECT:
-		md = (struct srp_direct_buf *) (cmd->add_data + offset);
-		len = be32_to_cpu(md->len);
-		break;
-	case SRP_DATA_DESC_INDIRECT:
-		id = (struct srp_indirect_buf *) (cmd->add_data + offset);
-		len = be32_to_cpu(id->len);
-		break;
-	default:
-		pr_err("invalid data format %x\n", fmt);
-		break;
-	}
-	return len;
-}
-EXPORT_SYMBOL_GPL(srp_data_length);
-
-MODULE_DESCRIPTION("SCSI RDMA Protocol lib functions");
-MODULE_AUTHOR("FUJITA Tomonori");
-MODULE_LICENSE("GPL");
diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
deleted file mode 100644
index f9b2d8f..0000000
--- a/include/scsi/libsrp.h
+++ /dev/null
@@ -1,95 +0,0 @@
-#ifndef __LIBSRP_H__
-#define __LIBSRP_H__
-
-#include <linux/list.h>
-#include <linux/kfifo.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_host.h>
-#include <scsi/srp.h>
-#include <target/target_core_base.h>
-
-enum srp_task_attributes {
-	SRP_SIMPLE_TASK = 0,
-	SRP_HEAD_TASK = 1,
-	SRP_ORDERED_TASK = 2,
-	SRP_ACA_TASK = 4
-};
-
-enum iue_flags {
-	V_DIOVER,
-	V_WRITE,
-	V_LINKED,
-	V_FLYING,
-};
-
-enum {
-	SRP_TASK_MANAGEMENT_FUNCTION_COMPLETE           = 0,
-	SRP_REQUEST_FIELDS_INVALID                      = 2,
-	SRP_TASK_MANAGEMENT_FUNCTION_NOT_SUPPORTED      = 4,
-	SRP_TASK_MANAGEMENT_FUNCTION_FAILED             = 5
-};
-
-struct srp_buf {
-	dma_addr_t dma;
-	void *buf;
-};
-
-struct srp_queue {
-	void *pool;
-	void *items;
-	struct kfifo queue;
-	spinlock_t lock;
-};
-
-struct srp_target {
-	struct Scsi_Host *shost;
-	struct se_device *tgt;
-	struct device *dev;
-
-	spinlock_t lock;
-	struct list_head cmd_queue;
-
-	size_t srp_iu_size;
-	struct srp_queue iu_queue;
-	size_t rx_ring_size;
-	struct srp_buf **rx_ring;
-
-	void *ldata;
-};
-
-struct iu_entry {
-	struct srp_target *target;
-
-	struct list_head ilist;
-	dma_addr_t remote_token;
-	unsigned long flags;
-
-	struct srp_buf *sbuf;
-};
-
-typedef int (srp_rdma_t)(struct scsi_cmnd *, struct scatterlist *, int,
-			 struct srp_direct_buf *, int,
-			 enum dma_data_direction, unsigned int);
-extern int srp_target_alloc(struct srp_target *, struct device *,
-				size_t, size_t);
-extern void srp_target_free(struct srp_target *);
-
-extern struct iu_entry *srp_iu_get(struct srp_target *);
-extern void srp_iu_put(struct iu_entry *);
-
-extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *,
-			     srp_rdma_t, int, int);
-
-static inline struct srp_target *host_to_srp_target(struct Scsi_Host *host)
-{
-	return (struct srp_target *) host->hostdata;
-}
-
-static inline int srp_cmd_direction(struct srp_cmd *cmd)
-{
-	return (cmd->buf_fmt >> 4) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-}
-
-extern u64 srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir);
-
-#endif
-- 
2.5.4 (Apple Git-61)
