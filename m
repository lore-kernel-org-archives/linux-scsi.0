From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 06/13] qla4xxx: Prevent other port reinitialization during
 remove_adapter
Date: Wed, 16 Mar 2011 05:29:34 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8722659E4D2@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:28577
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872Ab1CPM3o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2011 08:29:44 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Higgins <karen.higgins@qlogic.com>

remove ha flag AF_HBA_GOING_AWAY and added flag AF_HA_REMOVAL
to mark the other ISP-4xxx port to indicate that the driver is
being removed, so that the other port will not re-initialize
while in the process of removing the ha due to driver unload
or hba hotplug.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    5 +++-
 drivers/scsi/qla4xxx/ql4_isr.c |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c  |   51 +++++++++++++++++++++++++++++----------
 4 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 7aa60ee..c1f8d1b 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -53,6 +53,9 @@
 #define PCI_DEVICE_ID_QLOGIC_ISP8022   0x8022
 #endif

+#define ISP4XXX_PCI_FN_1       0x1
+#define ISP4XXX_PCI_FN_2       0x3
+
 #define QLA_SUCCESS                    0
 #define QLA_ERROR                      1

@@ -371,7 +374,7 @@ struct scsi_qla_host {
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
index 6068f80..3ab4618 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -749,12 +749,6 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
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
@@ -1063,7 +1057,6 @@ void qla4xxx_dead_adapter_cleanup(struct scsi_qla_host *ha)

        /* Disable the board */
        ql4_printk(KERN_INFO, ha, "Disabling the board\n");
-       set_bit(AF_HBA_GOING_AWAY, &ha->flags);

        qla4xxx_abort_active_cmds(ha, DID_NO_CONNECT << 16);
        qla4xxx_mark_all_devices_missing(ha);
@@ -1255,11 +1248,6 @@ static void qla4xxx_do_dpc(struct work_struct *work)
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
@@ -1824,6 +1812,42 @@ probe_disable_device:
 }

 /**
+ * qla4xxx_prevent_other_port_reinit - prevent other port from re-initialize
+ * @ha: pointer to adapter structure
+ *
+ * Mark the other ISP-4xxx port to indicate that the driver is being removed,
+ * so that the other port will not re-initialize while in the process of
+ * removing the ha due to driver unload or hba hotplug.
+ **/
+static void qla4xxx_prevent_other_port_reinit(struct scsi_qla_host *ha)
+{
+       struct scsi_qla_host *other_ha = NULL;
+       struct pci_dev *other_pdev = NULL;
+       int fn = ISP4XXX_PCI_FN_2;
+
+       /*iscsi function numbers for ISP4xxx is 1 and 3*/
+       if (PCI_FUNC(ha->pdev->devfn) & BIT_1)
+               fn = ISP4XXX_PCI_FN_1;
+
+       other_pdev =
+               pci_get_domain_bus_and_slot(pci_domain_nr(ha->pdev->bus),
+               ha->pdev->bus->number, PCI_DEVFN(PCI_SLOT(ha->pdev->devfn),
+               fn));
+
+       /* Get other_ha if other_pdev state is enable*/
+       if (atomic_read(&other_pdev->enable_cnt)) {
+               other_ha = pci_get_drvdata(other_pdev);
+               if (other_ha) {
+                       set_bit(AF_HA_REMOVAL, &other_ha->flags);
+                       DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Prevent %s "
+                           "reinit\n", __func__,
+                           dev_name(&other_ha->pdev->dev)));
+                       pci_dev_put(other_pdev);
+               }
+       }
+}
+
+/**
  * qla4xxx_remove_adapter - calback function to remove adapter.
  * @pci_dev: PCI device pointer
  **/
@@ -1833,7 +1857,8 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)

        ha = pci_get_drvdata(pdev);

-       set_bit(AF_HBA_GOING_AWAY, &ha->flags);
+       if (!is_qla8022(ha))
+               qla4xxx_prevent_other_port_reinit(ha);

        /* remove devs from iscsi_sessions to scsi_devices */
        qla4xxx_free_ddb_list(ha);
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

