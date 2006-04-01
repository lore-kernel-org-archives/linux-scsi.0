From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [CMT 08/16] qla4xxx: driver review ql4_inline.h
Date: Sat, 01 Apr 2006 12:29:46 -0600
Message-ID: <200604011829.k31ITkFi025532@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:35994 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S932078AbWDAS35 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 13:29:57 -0500
In-reply-to: 200604010418.k314Iqam008288@falcon30.maxeymade.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Missing some kerneldoc and levels on printks.

++doug
--
diff --git a/drivers/scsi/qla4xxx/ql4_inline.h b/drivers/scsi/qla4xxx/ql4_inline.h
new file mode 100644
index 0000000..bd4dd42
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_inline.h
@@ -0,0 +1,86 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+/*
+ *
+ * qla4xxx_lookup_ddb_by_fw_index
+ *      This routine locates a device handle given the firmware device
+ *      database index.  If device doesn't exist, returns NULL.
+ *
+ * Input:
+ *      ha - Pointer to host adapter structure.
+ *      fw_ddb_index - Firmware's device database index
+ *
+ * Returns:
+ *      Pointer to the corresponding internal device database structure
+ */

-ENEEDSKERNELDOC

+static inline ddb_entry_t *
+qla4xxx_lookup_ddb_by_fw_index(scsi_qla_host_t *ha, uint32_t fw_ddb_index)
+{
+        ddb_entry_t *ddb_entry = NULL;
+
+        if ((fw_ddb_index < MAX_DDB_ENTRIES) &&
+            (ha->fw_ddb_index_map[fw_ddb_index] !=
+                (ddb_entry_t *) INVALID_ENTRY)) {
+                ddb_entry = ha->fw_ddb_index_map[fw_ddb_index];
+        }
+
+        DEBUG3(printk("scsi%d: %s: index [%d], ddb_entry = %p\n",
+            ha->host_no, __func__, fw_ddb_index, ddb_entry));

-EPRINTKMISSINGLEVEL

+
+        return ddb_entry;
+}
+
+static inline void
+__qla4xxx_enable_intrs(scsi_qla_host_t *ha)
+{
+	if (IS_QLA4022(ha)) {
+		WRT_REG_DWORD(&ha->reg->u1.isp4022.intr_mask,
+		    SET_RMASK(IMR_SCSI_INTR_ENABLE));
+		PCI_POSTING(&ha->reg->u1.isp4022.intr_mask);
+	} else {
+		WRT_REG_DWORD(&ha->reg->ctrl_status,
+		    SET_RMASK(CSR_SCSI_INTR_ENABLE));
+		PCI_POSTING(&ha->reg->ctrl_status);
+	}
+	set_bit(AF_INTERRUPTS_ON, &ha->flags);
+}
+
+static inline void
+__qla4xxx_disable_intrs(scsi_qla_host_t *ha)
+{
+	if (IS_QLA4022(ha)) {
+		WRT_REG_DWORD(&ha->reg->u1.isp4022.intr_mask,
+		    CLR_RMASK(IMR_SCSI_INTR_ENABLE));
+		PCI_POSTING(&ha->reg->u1.isp4022.intr_mask);
+	} else {
+		WRT_REG_DWORD(&ha->reg->ctrl_status,
+		    CLR_RMASK(CSR_SCSI_INTR_ENABLE));
+		PCI_POSTING(&ha->reg->ctrl_status);
+	}
+	clear_bit(AF_INTERRUPTS_ON, &ha->flags);
+}
+
+static inline void
+qla4xxx_enable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	__qla4xxx_enable_intrs(ha);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+static inline void
+qla4xxx_disable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	__qla4xxx_disable_intrs(ha);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
