From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.27-rc3
Date: Tue, 19 Aug 2008 19:17:03 -0500
Message-ID: <1219191424.3256.68.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33967 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310AbYHTARI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 20:17:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is essentially a set of minor fixes with one or two notable
exceptions:  The DIF and USB problem is pretty major if you have one of
the devices.  The megaraid dbg_lvl world writeable is a potential DoS
and the megaraid pci posting flush fix could lead to a spurious
interrupt being registered.

The patch is available at:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The Short changelog is:

Andrew Vasquez (6):
      qla2xxx: Update version number to 8.02.01-k7.
      qla2xxx: Explicitly tear-down vports during PCI remove_one().
      qla2xxx: Reference proper ha during SBR handling.
      qla2xxx: Don't leak SG-DMA mappings while aborting commands.
      qla2xxx: Correct vport-state management issues during ISP-ABORT.
      qla2xxx: Correct synchronization of software/firmware fcport states.

Brian King (7):
      ibmvfc: Driver version 1.0.2
      ibmvfc: Add details to async event log
      ibmvfc: Sanitize response lengths
      ibmvfc: Fix for lost async events
      ibmvfc: Fixup host state during reinit
      ibmvfc: Fix another hang on module removal
      ibmvscsi: Fixup desired DMA value for shared memory partitions

Chandra Seetharaman (2):
      scsi_dh: Initialize lun_state in check_ownership()
      scsi_dh: Do not use scsilun in rdac hardware handler

Hugh Dickins (1):
      sd: fix USB devices incorrectly reporting DIF support

Joe Malicki (1):
      megaraid_sas: remove sysfs dbg_lvl world writeable permissions

Mike Hernandez (1):
      qla2xxx: Set npiv_supported flag for FCoE HBAs.

Yang, Bo (4):
      megaraid_sas: version and Documentation Update
      megaraid_sas: add new controllers (0x78 0x79)
      megaraid_sas: add the shutdown DCMD cmd to driver shutdown routine
      megaraid_sas: add readl to force PCI posting flush

The diffstat:

 Documentation/scsi/ChangeLog.megaraid_sas  |   23 +++++
 drivers/scsi/device_handler/scsi_dh_rdac.c |    3 
 drivers/scsi/ibmvscsi/ibmvfc.c             |   37 +++++----
 drivers/scsi/ibmvscsi/ibmvfc.h             |    4 
 drivers/scsi/ibmvscsi/ibmvscsi.c           |    2 
 drivers/scsi/megaraid/megaraid_sas.c       |  119 ++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h       |   10 +-
 drivers/scsi/qla2xxx/qla_attr.c            |   11 ++
 drivers/scsi/qla2xxx/qla_def.h             |    1 
 drivers/scsi/qla2xxx/qla_init.c            |    8 +
 drivers/scsi/qla2xxx/qla_isr.c             |   14 +--
 drivers/scsi/qla2xxx/qla_mbx.c             |    2 
 drivers/scsi/qla2xxx/qla_os.c              |   18 ++--
 drivers/scsi/qla2xxx/qla_version.h         |    2 
 include/scsi/scsi_device.h                 |    3 
 15 files changed, 214 insertions(+), 43 deletions(-)

And the entire diff below.

James

---

diff --git a/Documentation/scsi/ChangeLog.megaraid_sas b/Documentation/scsi/ChangeLog.megaraid_sas
index 716fcc1..c851ef4 100644
--- a/Documentation/scsi/ChangeLog.megaraid_sas
+++ b/Documentation/scsi/ChangeLog.megaraid_sas
@@ -1,3 +1,26 @@
+
+1 Release Date    : Thur.July. 24 11:41:51 PST 2008 -
+                       (emaild-id:megaraidlinux@lsi.com)
+                       Sumant Patro
+                       Bo Yang
+
+2 Current Version : 00.00.04.01
+3 Older Version   : 00.00.03.22
+
+1. Add the new controller (0078, 0079) support to the driver
+       Those controllers are LSI's next generatation(gen2) SAS controllers.
+
+1 Release Date    : Mon.June. 23 10:12:45 PST 2008 -
+                       (emaild-id:megaraidlinux@lsi.com)
+                       Sumant Patro
+                       Bo Yang
+
+2 Current Version : 00.00.03.22
+3 Older Version   : 00.00.03.20
+
+1. Add shutdown DCMD cmd to the shutdown routine to make FW shutdown proper.
+2. Unexpected interrupt occurs in HWR Linux driver, add the dumy readl pci flush will fix this issue.
+
 1 Release Date    : Mon. March 10 11:02:31 PDT 2008 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Sumant Patro
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b093a50..518da83 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -376,7 +376,7 @@ static int get_lun(struct scsi_device *sdev, struct rdac_dh_data *h)
 		if (inqp->page_id[0] != 'e' || inqp->page_id[1] != 'd' ||
 		    inqp->page_id[2] != 'i' || inqp->page_id[3] != 'd')
 			return SCSI_DH_NOSYS;
-		h->lun = scsilun_to_int((struct scsi_lun *)inqp->lun);
+		h->lun = inqp->lun[7]; /* Uses only the last byte */
 	}
 	return err;
 }
@@ -386,6 +386,7 @@ static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 	int err;
 	struct c9_inquiry *inqp;
 
+	h->lun_state = RDAC_LUN_UNOWNED;
 	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c9;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ae560bc..4e0b7c8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -556,11 +556,12 @@ static void ibmvfc_link_down(struct ibmvfc_host *vhost,
 /**
  * ibmvfc_init_host - Start host initialization
  * @vhost:		ibmvfc host struct
+ * @relogin:	is this a re-login?
  *
  * Return value:
  *	nothing
  **/
-static void ibmvfc_init_host(struct ibmvfc_host *vhost)
+static void ibmvfc_init_host(struct ibmvfc_host *vhost, int relogin)
 {
 	struct ibmvfc_target *tgt;
 
@@ -574,6 +575,11 @@ static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 	}
 
 	if (!ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING)) {
+		if (!relogin) {
+			memset(vhost->async_crq.msgs, 0, PAGE_SIZE);
+			vhost->async_crq.cur = 0;
+		}
+
 		list_for_each_entry(tgt, &vhost->targets, queue)
 			tgt->need_login = 1;
 		scsi_block_requests(vhost->host);
@@ -1059,9 +1065,10 @@ static void ibmvfc_get_starget_port_id(struct scsi_target *starget)
 static int ibmvfc_wait_while_resetting(struct ibmvfc_host *vhost)
 {
 	long timeout = wait_event_timeout(vhost->init_wait_q,
-					  (vhost->state == IBMVFC_ACTIVE ||
-					   vhost->state == IBMVFC_HOST_OFFLINE ||
-					   vhost->state == IBMVFC_LINK_DEAD),
+					  ((vhost->state == IBMVFC_ACTIVE ||
+					    vhost->state == IBMVFC_HOST_OFFLINE ||
+					    vhost->state == IBMVFC_LINK_DEAD) &&
+					   vhost->action == IBMVFC_HOST_ACTION_NONE),
 					  (init_timeout * HZ));
 
 	return timeout ? 0 : -EIO;
@@ -1450,8 +1457,8 @@ static void ibmvfc_scsi_done(struct ibmvfc_event *evt)
 	struct ibmvfc_cmd *vfc_cmd = &evt->xfer_iu->cmd;
 	struct ibmvfc_fcp_rsp *rsp = &vfc_cmd->rsp;
 	struct scsi_cmnd *cmnd = evt->cmnd;
-	int rsp_len = 0;
-	int sense_len = rsp->fcp_sense_len;
+	u32 rsp_len = 0;
+	u32 sense_len = rsp->fcp_sense_len;
 
 	if (cmnd) {
 		if (vfc_cmd->response_flags & IBMVFC_ADAPTER_RESID_VALID)
@@ -1468,7 +1475,7 @@ static void ibmvfc_scsi_done(struct ibmvfc_event *evt)
 				rsp_len = rsp->fcp_rsp_len;
 			if ((sense_len + rsp_len) > SCSI_SENSE_BUFFERSIZE)
 				sense_len = SCSI_SENSE_BUFFERSIZE - rsp_len;
-			if ((rsp->flags & FCP_SNS_LEN_VALID) && rsp->fcp_sense_len)
+			if ((rsp->flags & FCP_SNS_LEN_VALID) && rsp->fcp_sense_len && rsp_len <= 8)
 				memcpy(cmnd->sense_buffer, rsp->data.sense + rsp_len, sense_len);
 
 			ibmvfc_log_error(evt);
@@ -2077,17 +2084,18 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 {
 	const char *desc = ibmvfc_get_ae_desc(crq->event);
 
-	ibmvfc_log(vhost, 3, "%s event received\n", desc);
+	ibmvfc_log(vhost, 3, "%s event received. scsi_id: %lx, wwpn: %lx,"
+		   " node_name: %lx\n", desc, crq->scsi_id, crq->wwpn, crq->node_name);
 
 	switch (crq->event) {
 	case IBMVFC_AE_LINK_UP:
 	case IBMVFC_AE_RESUME:
 		vhost->events_to_log |= IBMVFC_AE_LINKUP;
-		ibmvfc_init_host(vhost);
+		ibmvfc_init_host(vhost, 1);
 		break;
 	case IBMVFC_AE_SCN_FABRIC:
 		vhost->events_to_log |= IBMVFC_AE_RSCN;
-		ibmvfc_init_host(vhost);
+		ibmvfc_init_host(vhost, 1);
 		break;
 	case IBMVFC_AE_SCN_NPORT:
 	case IBMVFC_AE_SCN_GROUP:
@@ -2133,13 +2141,13 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
 			/* Send back a response */
 			rc = ibmvfc_send_crq_init_complete(vhost);
 			if (rc == 0)
-				ibmvfc_init_host(vhost);
+				ibmvfc_init_host(vhost, 0);
 			else
 				dev_err(vhost->dev, "Unable to send init rsp. rc=%ld\n", rc);
 			break;
 		case IBMVFC_CRQ_INIT_COMPLETE:
 			dev_info(vhost->dev, "Partner initialization complete\n");
-			ibmvfc_init_host(vhost);
+			ibmvfc_init_host(vhost, 0);
 			break;
 		default:
 			dev_err(vhost->dev, "Unknown crq message type: %d\n", crq->format);
@@ -3357,8 +3365,6 @@ static void ibmvfc_npiv_login(struct ibmvfc_host *vhost)
 	mad->buffer.va = vhost->login_buf_dma;
 	mad->buffer.len = sizeof(*vhost->login_buf);
 
-	memset(vhost->async_crq.msgs, 0, PAGE_SIZE);
-	vhost->async_crq.cur = 0;
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
 
 	if (!ibmvfc_send_event(evt, vhost, default_timeout))
@@ -3601,8 +3607,9 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 			}
 		}
 
-		if (vhost->reinit) {
+		if (vhost->reinit && !ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING)) {
 			vhost->reinit = 0;
+			scsi_block_requests(vhost->host);
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
 		} else {
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 4bf6e37..fb3177a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.1"
-#define IBMVFC_DRIVER_DATE		"(July 11, 2008)"
+#define IBMVFC_DRIVER_VERSION		"1.0.2"
+#define IBMVFC_DRIVER_DATE		"(August 14, 2008)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	15
 #define IBMVFC_INIT_TIMEOUT		30
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 6b24b9c..7b1502c 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1636,7 +1636,7 @@ static unsigned long ibmvscsi_get_desired_dma(struct vio_dev *vdev)
 	unsigned long desired_io = max_requests * sizeof(union viosrp_iu);
 
 	/* add io space for sg data */
-	desired_io += (IBMVSCSI_MAX_SECTORS_DEFAULT *
+	desired_io += (IBMVSCSI_MAX_SECTORS_DEFAULT * 512 *
 	                     IBMVSCSI_CMDS_PER_LUN_DEFAULT);
 
 	return desired_io;
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index fc7ac15..97b7633 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.20-rc1
+ * Version     : v00.00.04.01-rc1
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
@@ -71,6 +71,10 @@ static struct pci_device_id megasas_pci_table[] = {
 	/* ppc IOP */
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078DE)},
 	/* ppc IOP */
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078GEN2)},
+	/* gen2*/
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS0079GEN2)},
+	/* gen2*/
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_VERDE_ZCR)},
 	/* xscale IOP, vega */
 	{PCI_DEVICE(PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DELL_PERC5)},
@@ -198,6 +202,9 @@ megasas_clear_intr_xscale(struct megasas_register_set __iomem * regs)
 	 */
 	writel(status, &regs->outbound_intr_status);
 
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_status);
+
 	return 0;
 }
 
@@ -293,6 +300,9 @@ megasas_clear_intr_ppc(struct megasas_register_set __iomem * regs)
 	 */
 	writel(status, &regs->outbound_doorbell_clear);
 
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_doorbell_clear);
+
 	return 0;
 }
 /**
@@ -318,6 +328,99 @@ static struct megasas_instance_template megasas_instance_template_ppc = {
 };
 
 /**
+*	The following functions are defined for gen2 (deviceid : 0x78 0x79)
+*	controllers
+*/
+
+/**
+ * megasas_enable_intr_gen2 -  Enables interrupts
+ * @regs:                      MFI register set
+ */
+static inline void
+megasas_enable_intr_gen2(struct megasas_register_set __iomem *regs)
+{
+	writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);
+
+	/* write ~0x00000005 (4 & 1) to the intr mask*/
+	writel(~MFI_GEN2_ENABLE_INTERRUPT_MASK, &(regs)->outbound_intr_mask);
+
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_mask);
+}
+
+/**
+ * megasas_disable_intr_gen2 - Disables interrupt
+ * @regs:                      MFI register set
+ */
+static inline void
+megasas_disable_intr_gen2(struct megasas_register_set __iomem *regs)
+{
+	u32 mask = 0xFFFFFFFF;
+	writel(mask, &regs->outbound_intr_mask);
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_mask);
+}
+
+/**
+ * megasas_read_fw_status_reg_gen2 - returns the current FW status value
+ * @regs:                      MFI register set
+ */
+static u32
+megasas_read_fw_status_reg_gen2(struct megasas_register_set __iomem *regs)
+{
+	return readl(&(regs)->outbound_scratch_pad);
+}
+
+/**
+ * megasas_clear_interrupt_gen2 -      Check & clear interrupt
+ * @regs:                              MFI register set
+ */
+static int
+megasas_clear_intr_gen2(struct megasas_register_set __iomem *regs)
+{
+	u32 status;
+	/*
+	 * Check if it is our interrupt
+	 */
+	status = readl(&regs->outbound_intr_status);
+
+	if (!(status & MFI_GEN2_ENABLE_INTERRUPT_MASK))
+		return 1;
+
+	/*
+	 * Clear the interrupt by writing back the same value
+	 */
+	writel(status, &regs->outbound_doorbell_clear);
+
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_status);
+
+	return 0;
+}
+/**
+ * megasas_fire_cmd_gen2 -     Sends command to the FW
+ * @frame_phys_addr :          Physical address of cmd
+ * @frame_count :              Number of frames for the command
+ * @regs :                     MFI register set
+ */
+static inline void
+megasas_fire_cmd_gen2(dma_addr_t frame_phys_addr, u32 frame_count,
+			struct megasas_register_set __iomem *regs)
+{
+	writel((frame_phys_addr | (frame_count<<1))|1,
+			&(regs)->inbound_queue_port);
+}
+
+static struct megasas_instance_template megasas_instance_template_gen2 = {
+
+	.fire_cmd = megasas_fire_cmd_gen2,
+	.enable_intr = megasas_enable_intr_gen2,
+	.disable_intr = megasas_disable_intr_gen2,
+	.clear_intr = megasas_clear_intr_gen2,
+	.read_fw_status_reg = megasas_read_fw_status_reg_gen2,
+};
+
+/**
 *	This is the end of set of functions & definitions
 * 	specific to ppc (deviceid : 0x60) controllers
 */
@@ -1976,7 +2079,12 @@ static int megasas_init_mfi(struct megasas_instance *instance)
 	/*
 	 * Map the message registers
 	 */
-	instance->base_addr = pci_resource_start(instance->pdev, 0);
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0079GEN2)) {
+		instance->base_addr = pci_resource_start(instance->pdev, 1);
+	} else {
+		instance->base_addr = pci_resource_start(instance->pdev, 0);
+	}
 
 	if (pci_request_regions(instance->pdev, "megasas: LSI")) {
 		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
@@ -1998,6 +2106,10 @@ static int megasas_init_mfi(struct megasas_instance *instance)
 		case PCI_DEVICE_ID_LSI_SAS1078DE:
 			instance->instancet = &megasas_instance_template_ppc;
 			break;
+		case PCI_DEVICE_ID_LSI_SAS1078GEN2:
+		case PCI_DEVICE_ID_LSI_SAS0079GEN2:
+			instance->instancet = &megasas_instance_template_gen2;
+			break;
 		case PCI_DEVICE_ID_LSI_SAS1064R:
 		case PCI_DEVICE_ID_DELL_PERC5:
 		default:
@@ -2857,6 +2969,7 @@ static void megasas_shutdown(struct pci_dev *pdev)
 {
 	struct megasas_instance *instance = pci_get_drvdata(pdev);
 	megasas_flush_cache(instance);
+	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 }
 
 /**
@@ -3292,7 +3405,7 @@ megasas_sysfs_set_dbg_lvl(struct device_driver *dd, const char *buf, size_t coun
 	return retval;
 }
 
-static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUGO, megasas_sysfs_show_dbg_lvl,
+static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUSR, megasas_sysfs_show_dbg_lvl,
 		megasas_sysfs_set_dbg_lvl);
 
 static ssize_t
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index b0c41e6..0d03324 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION			"00.00.03.20-rc1"
-#define MEGASAS_RELDATE			"March 10, 2008"
-#define MEGASAS_EXT_VERSION		"Mon. March 10 11:02:31 PDT 2008"
+#define MEGASAS_VERSION				"00.00.04.01"
+#define MEGASAS_RELDATE				"July 24, 2008"
+#define MEGASAS_EXT_VERSION			"Thu July 24 11:41:51 PST 2008"
 
 /*
  * Device IDs
@@ -28,6 +28,8 @@
 #define	PCI_DEVICE_ID_LSI_SAS1078R		0x0060
 #define	PCI_DEVICE_ID_LSI_SAS1078DE		0x007C
 #define	PCI_DEVICE_ID_LSI_VERDE_ZCR		0x0413
+#define	PCI_DEVICE_ID_LSI_SAS1078GEN2		0x0078
+#define	PCI_DEVICE_ID_LSI_SAS0079GEN2		0x0079
 
 /*
  * =====================================
@@ -580,6 +582,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_COMPLETION_TIMER_INTERVAL      (HZ/10)
 
 #define MFI_REPLY_1078_MESSAGE_INTERRUPT	0x80000000
+#define MFI_REPLY_GEN2_MESSAGE_INTERRUPT	0x00000001
+#define MFI_GEN2_ENABLE_INTERRUPT_MASK		(0x00000001 | 0x00000004)
 
 /*
 * register set for both 1068 and 1078 controllers
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a319a20..45e7dcb 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -993,6 +993,17 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 {
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 
+	/*
+	 * At this point all fcport's software-states are cleared.  Perform any
+	 * final cleanup of firmware resources (PCBs and XCBs).
+	 */
+	if (fcport->loop_id != FC_NO_LOOP_ID) {
+		fcport->ha->isp_ops->fabric_logout(fcport->ha, fcport->loop_id,
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa);
+		fcport->loop_id = FC_NO_LOOP_ID;
+	}
+
 	qla2x00_abort_fcport_cmds(fcport);
 	scsi_target_unblock(&rport->dev);
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6da31ba..94a720e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2237,6 +2237,7 @@ typedef struct scsi_qla_host {
 #define REGISTER_FDMI_NEEDED	26
 #define FCPORT_UPDATE_NEEDED	27
 #define VP_DPC_NEEDED		28	/* wake up for VP dpc handling */
+#define UNLOADING		29
 
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 601a6b2..ee89ddd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -976,8 +976,9 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 				    &ha->fw_attributes, &ha->fw_memory_size);
 				qla2x00_resize_request_q(ha);
 				ha->flags.npiv_supported = 0;
-				if ((IS_QLA24XX(ha) || IS_QLA25XX(ha)) &&
-				    (ha->fw_attributes & BIT_2)) {
+				if ((IS_QLA24XX(ha) || IS_QLA25XX(ha) ||
+				     IS_QLA84XX(ha)) &&
+					 (ha->fw_attributes & BIT_2)) {
 					ha->flags.npiv_supported = 1;
 					if ((!ha->max_npiv_vports) ||
 					    ((ha->max_npiv_vports + 1) %
@@ -3251,6 +3252,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 {
 	int rval;
 	uint8_t        status = 0;
+	scsi_qla_host_t *vha;
 
 	if (ha->flags.online) {
 		ha->flags.online = 0;
@@ -3265,6 +3267,8 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
 			qla2x00_mark_all_devices_lost(ha, 0);
+			list_for_each_entry(vha, &ha->vp_list, vp_list)
+			       qla2x00_mark_all_devices_lost(vha, 0);
 		} else {
 			if (!atomic_read(&ha->loop_down_timer))
 				atomic_set(&ha->loop_down_timer,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 874d802..45a3b93 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -879,11 +879,12 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
 	sp->request_sense_ptr += sense_len;
 	sp->request_sense_length -= sense_len;
 	if (sp->request_sense_length != 0)
-		sp->ha->status_srb = sp;
+		sp->fcport->ha->status_srb = sp;
 
 	DEBUG5(printk("%s(): Check condition Sense data, scsi(%ld:%d:%d:%d) "
-	    "cmd=%p pid=%ld\n", __func__, sp->ha->host_no, cp->device->channel,
-	    cp->device->id, cp->device->lun, cp, cp->serial_number));
+	    "cmd=%p pid=%ld\n", __func__, sp->fcport->ha->host_no,
+	    cp->device->channel, cp->device->id, cp->device->lun, cp,
+	    cp->serial_number));
 	if (sense_len)
 		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
 		    CMD_ACTUAL_SNSLEN(cp)));
@@ -1184,9 +1185,8 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		    atomic_read(&fcport->state)));
 
 		cp->result = DID_BUS_BUSY << 16;
-		if (atomic_read(&fcport->state) == FCS_ONLINE) {
-			qla2x00_mark_device_lost(ha, fcport, 1, 1);
-		}
+		if (atomic_read(&fcport->state) == FCS_ONLINE)
+			qla2x00_mark_device_lost(fcport->ha, fcport, 1, 1);
 		break;
 
 	case CS_RESET:
@@ -1229,7 +1229,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 
 		/* Check to see if logout occurred. */
 		if ((le16_to_cpu(sts->status_flags) & SF_LOGOUT_SENT))
-			qla2x00_mark_device_lost(ha, fcport, 1, 1);
+			qla2x00_mark_device_lost(fcport->ha, fcport, 1, 1);
 		break;
 
 	default:
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bc90d6b..813bc77 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2686,7 +2686,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 		set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
 		set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
 
-		wake_up_process(ha->dpc_thread);
+		qla2xxx_wake_dpc(ha);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7c8af7e..26afe44 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -780,7 +780,8 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha, unsigned int t,
 		sp = pha->outstanding_cmds[cnt];
 		if (!sp)
 			continue;
-		if (ha->vp_idx != sp->ha->vp_idx)
+
+		if (ha->vp_idx != sp->fcport->ha->vp_idx)
 			continue;
 		match = 0;
 		switch (type) {
@@ -1080,9 +1081,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *ha, int res)
 		sp = ha->outstanding_cmds[cnt];
 		if (sp) {
 			ha->outstanding_cmds[cnt] = NULL;
-			sp->flags = 0;
 			sp->cmd->result = res;
-			sp->cmd->host_scribble = (unsigned char *)NULL;
 			qla2x00_sp_compl(ha, sp);
 		}
 	}
@@ -1776,10 +1775,15 @@ probe_out:
 static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *ha, *vha, *temp;
 
 	ha = pci_get_drvdata(pdev);
 
+	list_for_each_entry_safe(vha, temp, &ha->vp_list, vp_list)
+		fc_vport_terminate(vha->fc_vport);
+
+	set_bit(UNLOADING, &ha->dpc_flags);
+
 	qla2x00_dfs_remove(ha);
 
 	qla84xx_put_chip(ha);
@@ -2451,8 +2455,10 @@ qla2x00_do_dpc(void *data)
 void
 qla2xxx_wake_dpc(scsi_qla_host_t *ha)
 {
-	if (ha->dpc_thread)
-		wake_up_process(ha->dpc_thread);
+	struct task_struct *t = ha->dpc_thread;
+
+	if (!test_bit(UNLOADING, &ha->dpc_flags) && t)
+		wake_up_process(t);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 676c390..4160e4c 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.02.01-k6"
+#define QLA2XXX_VERSION      "8.02.01-k7"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	2
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 291d56a..80b2e93 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
+#include <scsi/scsi.h>
 #include <asm/atomic.h>
 
 struct request_queue;
@@ -426,7 +427,7 @@ static inline int scsi_device_enclosure(struct scsi_device *sdev)
 
 static inline int scsi_device_protection(struct scsi_device *sdev)
 {
-	return sdev->inquiry[5] & (1<<0);
+	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
 #define MODULE_ALIAS_SCSI_DEVICE(type) \


