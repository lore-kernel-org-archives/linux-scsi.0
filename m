From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 06/13] qla4xxx: Prevent other port reinitialization during
 remove_adapter
Date: Sun, 13 Mar 2011 22:24:25 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B150C@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:16497
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192Ab1CNFYe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:24:34 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Higgins <karen.higgins@qlogic.com>

remove ha flag AF_HBA_GOING_AWAY and added flag AF_HA_REMOVAL
to mark the other ISP-4xxx port to indicate that the driver is
being removed, so that the other port will not re-initialize
while in the process of removing the ha due to driver unload
or hba hotplug.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    3 +-
 drivers/scsi/qla4xxx/ql4_isr.c |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c  |   62 +++++++++++++++++++++++++++++++--------
 4 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 7aa60ee..b5fb245 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -358,6 +358,7 @@ struct isp_operations {
  * Linux Host Adapter structure
  */
 struct scsi_qla_host {
+       struct klist_node node;
        /* Linux adapter configuration data */
        unsigned long flags;

@@ -371,7 +372,7 @@ struct scsi_qla_host {
 #define AF_LINK_UP                     8 /* 0x00000100 */
 #define AF_IRQ_ATTACHED                        10 /* 0x00000400 */
 #define AF_DISABLE_ACB_COMPLETE                11 /* 0x00000800 */
-#define AF_HBA_GOING_AWAY              12 /* 0x00001000 */
+#define AF_HA_REMOVAL                  12 /* 0x00001000 */
 #define AF_INTx_ENABLED                        15 /* 0x00008000 */
 #define AF_MSI_ENABLED                 16 /* 0x00010000 */
 #define AF_MSIX_ENABLED                        17 /* 0x00020000 */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 2ef1a98..2f40ac7 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -801,7 +801,7 @@ irqreturn_t qla4xxx_intr_handler(int irq, void *dev_id)
                               &ha->reg->ctrl_status);
                        readl(&ha->reg->ctrl_status);

-                       if (!test_bit(AF_HBA_GOING_AWAY, &ha->flags))
+                       if (!test_bit(AF_HA_REMOVAL, &ha->flags))
                                set_bit(DPC_RESET_HA_INTR, &ha->dpc_flags);

                        break;
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 379df2b..199fa64 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -151,7 +151,7 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
        if (test_bit(AF_IRQ_ATTACHED, &ha->flags) &&
            test_bit(AF_INTERRUPTS_ON, &ha->flags) &&
            test_bit(AF_ONLINE, &ha->flags) &&
-           !test_bit(AF_HBA_GOING_AWAY, &ha->flags)) {
+           !test_bit(AF_HA_REMOVAL, &ha->flags)) {
                /* Do not poll for completion. Use completion queue */
                set_bit(AF_MBOX_COMMAND_NOPOLL, &ha->flags);
                wait_for_completion_timeout(&ha->mbx_intr_comp, MBOX_TOV * HZ);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6068f80..59c5552 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -27,6 +27,11 @@ static char qla4xxx_version_str[40];
 static struct kmem_cache *srb_cachep;

 /*
+ * List of host adapters
+ */
+static struct klist qla4xxx_hostlist;
+
+/*
  * Module parameter information and variables
  */
 int ql4xdontresethba = 0;
@@ -749,12 +754,6 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
        if (!pci_channel_offline(ha->pdev))
                pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);

-       if (test_bit(AF_HBA_GOING_AWAY, &ha->flags)) {
-               DEBUG2(ql4_printk(KERN_INFO, ha, "%s exited. HBA GOING AWAY\n",
-                   __func__));
-               return;
-       }
-
        if (is_qla8022(ha)) {
                qla4_8xxx_watchdog(ha);
        }
@@ -1063,7 +1062,6 @@ void qla4xxx_dead_adapter_cleanup(struct scsi_qla_host *ha)

        /* Disable the board */
        ql4_printk(KERN_INFO, ha, "Disabling the board\n");
-       set_bit(AF_HBA_GOING_AWAY, &ha->flags);

        qla4xxx_abort_active_cmds(ha, DID_NO_CONNECT << 16);
        qla4xxx_mark_all_devices_missing(ha);
@@ -1255,11 +1253,6 @@ static void qla4xxx_do_dpc(struct work_struct *work)
                goto do_dpc_exit;
        }

-       /* HBA is in the process of being permanently disabled.
-        * Don't process anything */
-       if (test_bit(AF_HBA_GOING_AWAY, &ha->flags))
-               return;
-
        if (is_qla8022(ha)) {
                if (test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags)) {
                        qla4_8xxx_idc_lock(ha);
@@ -1808,6 +1801,10 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
               ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
               ha->patch_number, ha->build_number);
        scsi_scan_host(host);
+
+       /* Insert new entry into the list of adapters. */
+       klist_add_tail(&ha->node, &qla4xxx_hostlist);
+
        return 0;

 probe_failed:
@@ -1824,6 +1821,41 @@ probe_disable_device:
 }

 /**
+ * qla4xxx_prevent_other_port_reinit - Mark the other ISP-4xxx port to indicate
+ * that the driver is being removed, so that the other port will not
+ * re-initialize while in the process of removing the ha due to driver unload
+ * or hba hotplug.
+ * @ha: pointer to adapter structure
+ **/
+static void qla4xxx_prevent_other_port_reinit(struct scsi_qla_host *ha)
+{
+       struct scsi_qla_host *ha_listp;
+       struct klist_iter i;
+       struct klist_node *n;
+
+       klist_iter_init(&qla4xxx_hostlist, &i);
+       while ((n = klist_next(&i)) != NULL) {
+               ha_listp = container_of(n, struct scsi_qla_host, node);
+               if (ha == ha_listp)
+                       continue;
+
+               if ((pci_domain_nr(ha->pdev->bus) ==
+                   pci_domain_nr(ha_listp->pdev->bus)) &&
+                   (ha->pdev->bus->number ==
+                   ha_listp->pdev->bus->number) &&
+                   (PCI_SLOT(ha->pdev->devfn) ==
+                   PCI_SLOT(ha_listp->pdev->devfn))) {
+
+                       set_bit(AF_HA_REMOVAL, &ha_listp->flags);
+                       DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Prevent %s "
+                           "reinit\n", __func__,
+                           dev_name(&ha_listp->pdev->dev)));
+               }
+       }
+       klist_iter_exit(&i);
+}
+
+/**
  * qla4xxx_remove_adapter - calback function to remove adapter.
  * @pci_dev: PCI device pointer
  **/
@@ -1833,7 +1865,10 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)

        ha = pci_get_drvdata(pdev);

-       set_bit(AF_HBA_GOING_AWAY, &ha->flags);
+       if (!is_qla8022(ha))
+               qla4xxx_prevent_other_port_reinit(ha);
+
+       klist_remove(&ha->node);

        /* remove devs from iscsi_sessions to scsi_devices */
        qla4xxx_free_ddb_list(ha);
@@ -2546,6 +2581,7 @@ static int __init qla4xxx_module_init(void)
 {
        int ret;

+       klist_init(&qla4xxx_hostlist, NULL, NULL);
        /* Allocate cache for SRBs. */
        srb_cachep = kmem_cache_create("qla4xxx_srbs", sizeof(struct srb), 0,
                                       SLAB_HWCACHE_ALIGN, NULL);
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

