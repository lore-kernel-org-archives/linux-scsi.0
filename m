From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 09/17] cxlflash: Support up to 4 ports
Date: Wed, 12 Apr 2017 14:14:41 -0500
Message-ID: <1492024481-55956-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32993 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753771AbdDLTPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:15:00 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ9AB2054370
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:00 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29sqnn77vw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:14:59 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 15:14:59 -0400
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Update the driver to allow for future cards with 4 ports.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c    | 78 ++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/cxlflash/sislite.h |  6 ++--
 2 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 64ad76b..568cd63 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1419,7 +1419,7 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	ssize_t vpd_size;
 	char vpd_data[CXLFLASH_VPD_LEN];
 	char tmp_buf[WWPN_BUF_LEN] = { 0 };
-	char *wwpn_vpd_tags[MAX_FC_PORTS] = { "V5", "V6" };
+	char *wwpn_vpd_tags[MAX_FC_PORTS] = { "V5", "V6", "V7", "V8" };
 
 	/* Get the VPD data from the device */
 	vpd_size = cxl_read_adapter_vpd(pdev, vpd_data, sizeof(vpd_data));
@@ -2175,6 +2175,40 @@ static ssize_t port1_show(struct device *dev,
 }
 
 /**
+ * port2_show() - queries and presents the current status of port 2
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port2_show(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
+
+	return cxlflash_show_port_status(2, cfg, buf);
+}
+
+/**
+ * port3_show() - queries and presents the current status of port 3
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port3_show(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
+
+	return cxlflash_show_port_status(3, cfg, buf);
+}
+
+/**
  * lun_mode_show() - presents the current LUN mode of the host
  * @dev:	Generic device associated with the host.
  * @attr:	Device attribute representing the LUN mode.
@@ -2327,6 +2361,40 @@ static ssize_t port1_lun_table_show(struct device *dev,
 }
 
 /**
+ * port2_lun_table_show() - presents the current LUN table of port 2
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port2_lun_table_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
+
+	return cxlflash_show_port_lun_table(2, cfg, buf);
+}
+
+/**
+ * port3_lun_table_show() - presents the current LUN table of port 3
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t port3_lun_table_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
+
+	return cxlflash_show_port_lun_table(3, cfg, buf);
+}
+
+/**
  * irqpoll_weight_show() - presents the current IRQ poll weight for the host
  * @dev:	Generic device associated with the host.
  * @attr:	Device attribute representing the IRQ poll weight.
@@ -2417,19 +2485,27 @@ static ssize_t mode_show(struct device *dev,
  */
 static DEVICE_ATTR_RO(port0);
 static DEVICE_ATTR_RO(port1);
+static DEVICE_ATTR_RO(port2);
+static DEVICE_ATTR_RO(port3);
 static DEVICE_ATTR_RW(lun_mode);
 static DEVICE_ATTR_RO(ioctl_version);
 static DEVICE_ATTR_RO(port0_lun_table);
 static DEVICE_ATTR_RO(port1_lun_table);
+static DEVICE_ATTR_RO(port2_lun_table);
+static DEVICE_ATTR_RO(port3_lun_table);
 static DEVICE_ATTR_RW(irqpoll_weight);
 
 static struct device_attribute *cxlflash_host_attrs[] = {
 	&dev_attr_port0,
 	&dev_attr_port1,
+	&dev_attr_port2,
+	&dev_attr_port3,
 	&dev_attr_lun_mode,
 	&dev_attr_ioctl_version,
 	&dev_attr_port0_lun_table,
 	&dev_attr_port1_lun_table,
+	&dev_attr_port2_lun_table,
+	&dev_attr_port3_lun_table,
 	&dev_attr_irqpoll_weight,
 	NULL
 };
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index 42d9c9e..0e52bbb 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -394,7 +394,7 @@ struct sisl_global_regs {
 };
 
 #define CXLFLASH_NUM_FC_PORTS_PER_BANK	2	/* fixed # of ports per bank */
-#define CXLFLASH_MAX_FC_BANKS		1	/* max # of banks supported */
+#define CXLFLASH_MAX_FC_BANKS		2	/* max # of banks supported */
 #define CXLFLASH_MAX_FC_PORTS	(CXLFLASH_NUM_FC_PORTS_PER_BANK *	\
 				 CXLFLASH_MAX_FC_BANKS)
 #define CXLFLASH_MAX_CONTEXT	512	/* number of contexts per AFU */
@@ -414,9 +414,9 @@ struct sisl_global_map {
 
 	char page1[SIZE_4K];	/* page 1 */
 
-	struct fc_port_bank bank[CXLFLASH_MAX_FC_BANKS]; /* pages 2 - 5 */
+	struct fc_port_bank bank[CXLFLASH_MAX_FC_BANKS]; /* pages 2 - 9 */
 
-	/* pages 6 - 15 are reserved */
+	/* pages 10 - 15 are reserved */
 
 };
 
-- 
2.1.0
