Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F836C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 110592082F
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgAQHKj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:10:39 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:35597 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgAQHKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 02:10:39 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: BZEOFrILSy91CecMMRVhKJnzQMA6EG/KHiKrgNnL0Cd9w4IUmz1xpQNKuNuVkYr1JdHIUc/Y1R
 GLT4DoZ/nfl27FfGI3g1RkfoXytmDckOe1eQatc815MgGzSq3tQ6MWJtu65VCry91atmx/GV9v
 fDLUkKAYFh2AHgVZx/lbsXkldYQQubyVzZnBrvmgSd9NKzREaY4L2rThs01HGpsJ4K2HXxoIjj
 HsywuUCWBcg+KhL1rZ137B+C8q/rPRPct5FigDme0rIKiQrTvI7ukkKTAXFNV9E8U3QB7ftQHn
 LzU=
X-IronPort-AV: E=Sophos;i="5.70,329,1574146800"; 
   d="scan'208";a="63598492"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 00:10:38 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 16 Jan
 2020 23:10:37 -0800
Received: from localhost (10.41.130.51) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 16 Jan
 2020 23:10:36 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 05/13] pm80xx : Support for char device.
Date:   Fri, 17 Jan 2020 12:49:15 +0530
Message-ID: <20200117071923.7445-6-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200117071923.7445-1-deepak.ukey@microchip.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Deepak Ukey <Deepak.Ukey@microchip.com>

Added the support to register the char device for pm80xx module so that
management utility fetch the different information from driver with the
help of IOCTL. Also added the IOCTL functionality to get driver info so
that management utility can fetch the information about driver like
driver name, driver major number, driver minor number and build number.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  | 148 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |  33 +++++++++
 drivers/scsi/pm8001/pm8001_init.c |   5 ++
 drivers/scsi/pm8001/pm8001_sas.h  |   6 ++
 4 files changed, 192 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 7c6be2ec110d..69458b318a20 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include "pm8001_sas.h"
 #include "pm8001_ctl.h"
+int pm80xx_major = -1;
 
 /* scsi host attributes */
 
@@ -845,3 +846,150 @@ struct device_attribute *pm8001_host_attrs[] = {
 	NULL,
 };
 
+/*
+ * pm8001_open - open the configuration file
+ * @inode: inode being opened
+ * @file: file handle attached
+ *
+ * Called when the configuration device is opened. Does the needed
+ * set up on the handle and then returns
+ *
+ */
+static int pm8001_open(struct inode *inode, struct file *file)
+{
+	struct pm8001_hba_info *pm8001_ha;
+	unsigned int minor_number = iminor(inode);
+	int err = -ENODEV;
+
+	list_for_each_entry(pm8001_ha, &hba_list, list) {
+		if (pm8001_ha->id == minor_number) {
+			file->private_data = pm8001_ha;
+			err = 0;
+			break;
+		}
+	}
+
+	return err;
+}
+
+/**
+ * pm8001_close - close the configuration file
+ * @inode: inode being opened
+ * @file: file handle attached
+ *
+ * Called when the configuration device is closed. Does the needed
+ * set up on the handle and then returns
+ *
+ */
+static int pm8001_close(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static long pm8001_info_ioctl(struct pm8001_hba_info *pm8001_ha,
+					unsigned long arg)
+{
+	u32 ret = 0;
+	struct ioctl_info_buffer info_buf;
+
+	strcpy(info_buf.information.sz_name, DRV_NAME);
+
+	info_buf.information.usmajor_revision = DRV_MAJOR;
+	info_buf.information.usminor_revision = DRV_MINOR;
+	info_buf.information.usbuild_revision = DRV_BUILD;
+	if (pm8001_ha->chip_id == chip_8001) {
+		info_buf.information.maxoutstandingIO =
+			pm8001_ha->main_cfg_tbl.pm8001_tbl.max_out_io;
+		info_buf.information.maxdevices =
+			(pm8001_ha->main_cfg_tbl.pm8001_tbl.max_sgl >> 16) &
+			0xFFFF;
+	} else {
+		info_buf.information.maxoutstandingIO =
+			pm8001_ha->main_cfg_tbl.pm80xx_tbl.max_out_io;
+		info_buf.information.maxdevices =
+			(pm8001_ha->main_cfg_tbl.pm80xx_tbl.max_sgl >> 16) &
+			0xFFFF;
+	}
+	info_buf.header.return_code = ADPT_IOCTL_CALL_SUCCESS;
+
+	if (copy_to_user((void *)arg, (void *)&info_buf,
+				sizeof(struct ioctl_info_buffer))) {
+		ret = ADPT_IOCTL_CALL_FAILED;
+	}
+	return ret;
+}
+
+/**
+ *	pm8001_ioctl - pm8001 configuration request
+ *	@inode: inode of device
+ *	@file: file handle
+ *	@cmd: ioctl command code
+ *	@arg: argument
+ *
+ *	Handles a configuration ioctl.
+ *
+ */
+static long pm8001_ioctl(struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	u32 ret = -EACCES;
+	struct pm8001_hba_info *pm8001_ha;
+	struct ioctl_header header;
+
+	pm8001_ha = file->private_data;
+
+	switch (cmd) {
+	case ADPT_IOCTL_INFO:
+		ret = pm8001_info_ioctl(pm8001_ha, arg);
+		break;
+	default:
+		ret = ADPT_IOCTL_CALL_INVALID_CODE;
+	}
+
+	if (ret == 0)
+		return ret;
+	header.return_code = ret;
+	ret = -EACCES;
+	if (copy_to_user((void *)arg, (void *)&header,
+				sizeof(struct ioctl_header))) {
+		PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("copy_to_user failed\n"));
+	}
+	return ret;
+}
+
+static const struct file_operations pm8001_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pm8001_open,
+	.release	= pm8001_close,
+	.unlocked_ioctl	= pm8001_ioctl,
+};
+
+/**
+ * pm8001_setup_chrdev - register char device
+ * Return value:
+ * 0 in case of success, otherwise non-zero value
+ */
+int pm8001_setup_chrdev(void)
+{
+	pm80xx_major = register_chrdev(0, DRV_NAME, &pm8001_fops);
+	if (pm80xx_major < 0) {
+		pr_warn("pm8001: unable to register %s  device.\n",
+				DRV_NAME);
+		return pm80xx_major;
+	}
+	return 0;
+}
+
+/**
+ * pm8001_release_chrdev - unregisters per-adapter management interface
+ * Return value:
+ * none
+ */
+void pm8001_release_chrdev(void)
+{
+	if (pm80xx_major > -1) {
+		unregister_chrdev(pm80xx_major, DRV_NAME);
+		pm80xx_major = -1;
+	}
+}
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
index d0d43a250b9e..f0f8b1deae27 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -59,5 +59,38 @@
 #define SYSFS_OFFSET                    1024
 #define PM80XX_IB_OB_QUEUE_SIZE         (32 * 1024)
 #define PM8001_IB_OB_QUEUE_SIZE         (16 * 1024)
+
+#define ADPT_IOCTL_CALL_SUCCESS		0x00
+#define ADPT_IOCTL_CALL_FAILED		0x01
+#define ADPT_IOCTL_CALL_INVALID_CODE	0x03
+
+struct ioctl_header {
+	u32 io_controller_num;
+	u32 length;
+	u32 return_code;
+	u32 timeout;
+	u16 direction;
+};
+
+struct ioctl_drv_info {
+	u8	sz_name[64];
+	u16	usmajor_revision;
+	u16	usminor_revision;
+	u16	usbuild_revision;
+	u16	reserved0;
+	u32	maxdevices;
+	u32	maxoutstandingIO;
+	u32	reserved[16];
+};
+
+struct ioctl_info_buffer {
+	struct ioctl_header	header;
+	struct ioctl_drv_info	information;
+};
+
+#define ADPT_IOCTL_INFO _IOR(ADPT_MAGIC_NUMBER, 0, struct ioctl_info_buffer *)
+
+#define ADPT_MAGIC_NUMBER	'm'
+
 #endif /* PM8001_CTL_H_INCLUDED */
 
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 775517f9b39d..25e74f1dbd0c 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1421,6 +1421,9 @@ static int __init pm8001_init(void)
 	pm8001_stt = sas_domain_attach_transport(&pm8001_transport_ops);
 	if (!pm8001_stt)
 		goto err_wq;
+	rc = pm8001_setup_chrdev();
+	if (rc)
+		goto err_ctl;
 	rc = pci_register_driver(&pm8001_pci_driver);
 	if (rc)
 		goto err_tp;
@@ -1428,6 +1431,8 @@ static int __init pm8001_init(void)
 
 err_tp:
 	sas_release_transport(pm8001_stt);
+err_ctl:
+	pm8001_release_chrdev();
 err_wq:
 	destroy_workqueue(pm8001_wq);
 err:
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 93438c8f67da..479aac34d7cc 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -59,6 +59,9 @@
 
 #define DRV_NAME		"pm80xx"
 #define DRV_VERSION		"0.1.39"
+#define DRV_MAJOR		1
+#define DRV_MINOR		3
+#define DRV_BUILD		0
 #define PM8001_FAIL_LOGGING	0x01 /* Error message logging */
 #define PM8001_INIT_LOGGING	0x02 /* driver init logging */
 #define PM8001_DISC_LOGGING	0x04 /* discovery layer logging */
@@ -745,6 +748,9 @@ ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
 /* ctl shared API */
 extern struct device_attribute *pm8001_host_attrs[];
 
+int pm8001_setup_chrdev(void);
+void pm8001_release_chrdev(void);
+
 static inline void
 pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
 			struct sas_task *task, struct pm8001_ccb_info *ccb,
-- 
2.16.3

