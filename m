From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] lpfc : add module parameter that allows adapter instances
	to avoid attachment
Date: Thu, 26 Mar 2009 15:55:00 -0400
Message-ID: <1238097300.27023.2.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59983 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZCZTzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 15:55:07 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n2QJt4qZ023160
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 12:55:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch adds a module parameter that supplies a text string containing a
list of PCI <bus>:<slot>.<func> values to identify adapter instances that
should *not* be attached to by the driver.

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |   21 ++++++++++++++++++++
 lpfc_crtn.h |    1 
 lpfc_init.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-01-05 11:50:39.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-03-26 13:57:34.000000000 -0400
@@ -1451,6 +1451,26 @@ lpfc_##attr##_store(struct device *dev, 
 		return -EINVAL;\
 }
 
+/*
+# lpfc_exclude_hba: This parameter contain a list of PCI slots with lpfc HBAs
+# 	which need to be excluded from attachment by the driver.
+#  String Syntax: <bus>:<slot>.<func>[|<bus>:<slot>.<func>...]
+*/
+char *lpfc_exclude_hba;
+module_param(lpfc_exclude_hba, charp, S_IRUGO);
+MODULE_PARM_DESC(lpfc_exclude_hba, "list of lpfc HBA PCI locations"
+	" to be excluded from attachment:  '<bus>:<slot>.<func>' separated by"
+	" | character");
+static ssize_t
+lpfc_exclude_hba_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+		(lpfc_exclude_hba == NULL) ? "" : lpfc_exclude_hba);
+}
+
+static DEVICE_ATTR(lpfc_exclude_hba, S_IRUGO, lpfc_exclude_hba_show,
+		NULL);
 
 #define LPFC_ATTR(name, defval, minval, maxval, desc) \
 static int lpfc_##name = defval;\
@@ -2939,6 +2959,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_max_scsicmpl_time,
 	&dev_attr_lpfc_stat_data_ctrl,
 	&dev_attr_lpfc_prot_sg_seg_cnt,
+	&dev_attr_lpfc_exclude_hba,
 	NULL,
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2009-03-26 13:41:47.000000000 -0400
@@ -264,6 +264,7 @@ extern struct fc_function_template lpfc_
 extern struct fc_function_template lpfc_vport_transport_functions;
 extern int lpfc_sli_mode;
 extern int lpfc_enable_npiv;
+extern char *lpfc_exclude_hba;
 
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
 int  lpfc_vport_symbolic_port_name(struct lpfc_vport *, char *,	size_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-01-05 11:50:39.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-03-26 13:51:01.000000000 -0400
@@ -33,6 +33,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
+#include <linux/ctype.h>
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
@@ -54,6 +55,7 @@ spinlock_t _dump_buf_lock;
 static int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 static int lpfc_post_rcv_buf(struct lpfc_hba *);
+static uint32_t lpfc_is_excluded_hba(struct pci_dev *pdev);
 
 static struct scsi_transport_template *lpfc_transport_template = NULL;
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
@@ -2607,6 +2609,17 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	struct lpfc_adapter_event_header adapter_event;
 
+	/*
+	 * Check if FC controller is excluded from binding to lpfc driver.
+	 */
+	if (lpfc_is_excluded_hba(pdev)) {
+		dev_printk(KERN_ERR, &pdev->dev, "%s: controller %02x:%02x.%x"
+			" is excluded from binding.\n",
+			LPFC_DRIVER_NAME, pdev->bus->number,
+			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+		return -EPERM;
+	}
+
 	if (pci_enable_device_mem(pdev))
 		goto out;
 	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
@@ -3471,6 +3484,54 @@ lpfc_init(void)
 	return error;
 }
 
+/*
+ * lpfc_is_excluded_hba - Check if the PCI device is excluded by user.
+ * @pdev: pointer to pci device.
+ *
+ * Return 1 if the pci device is excluded by the lpfc_exclude_hba
+ * parameter else return 0.
+ */
+static uint32_t
+lpfc_is_excluded_hba(struct pci_dev *pdev)
+{
+	u_int	bus, slot, func;
+	char	*cp, pci_buf[9];
+	char	*conf_p = lpfc_exclude_hba;
+
+	if (!conf_p)
+		return 0;
+
+	while (*conf_p) {
+		if (*conf_p == '|' || isspace((int)*conf_p)) {
+			conf_p++;
+			continue;
+		}
+		cp = pci_buf;
+
+		do {
+			*cp = *conf_p;
+			cp++;
+			conf_p++;
+			if (!(*conf_p) || (*conf_p == '-') || (*conf_p == '|')
+				|| isspace((int)*conf_p))
+				break;
+		} while (cp < pci_buf + sizeof(pci_buf));
+
+		*cp = '\0';
+
+		if (sscanf(pci_buf, "%x:%x.%x", &bus, &slot, &func) != 3 ||
+			(bus | slot | func) > 0xff)
+			continue;
+
+		if ((u_char)bus == pdev->bus->number &&
+		    (u_char)slot == PCI_SLOT(pdev->devfn) &&
+		    (u_char)func == PCI_FUNC(pdev->devfn)) {
+			return 1;
+		}
+	}
+	return 0;
+}
+
 /**
  * lpfc_exit: lpfc module removal routine.
  *


