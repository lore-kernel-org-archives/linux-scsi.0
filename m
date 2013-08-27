From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 25/29] qla2xxx: Add a new interface to update versions.
Date: Tue, 27 Aug 2013 01:37:51 -0400
Message-ID: <1377581875-8574-26-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:16850 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931Ab3H0GGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:52 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63PaW019068
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:52 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1eg8v690wy-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:52 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

On any Adapter when we flash through FC/FCoE without card reset option it still
shows the Running FW version in Flashed FW version. This new interface will be
used by API to instruct the driver to update its cache versions.

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   14 +++++++++++++-
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 85aad4a..b1d32c4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -590,7 +590,7 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	int type;
 	uint32_t idc_control;
-
+	uint8_t *tmp_data = NULL;
 	if (off != 0)
 		return -EINVAL;
 
@@ -687,7 +687,19 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 		__qla83xx_set_idc_control(vha, idc_control);
 		qla83xx_idc_unlock(vha, 0);
 		break;
+	case 0x20261:
+		ql_dbg(ql_dbg_user, vha, 0x70e0,
+		    "Updating cache versions without reset ");
 
+		tmp_data = vmalloc(256);
+		if (!tmp_data) {
+			ql_log(ql_log_warn, vha, 0x70e1,
+			    "Unable to allocate memory for VPD information update.\n");
+			return -ENOMEM;
+		}
+		ha->isp_ops->get_flash_version(vha, tmp_data);
+		vfree(tmp_data);
+		break;
 	}
 	return count;
 }
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f192c52..f693b30 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -31,7 +31,7 @@
  * |                              |                    | 0x5040,0x5075  |
  * |                              |                    | 0x503d,0x5044  |
  * | Timer Routines               |       0x6012       |                |
- * | User Space Interactions      |       0x70dd       | 0x7018,0x702e, |
+ * | User Space Interactions      |       0x70e1       | 0x7018,0x702e, |
  * |                              |                    | 0x7020,0x7024, |
  * |                              |                    | 0x7039,0x7045, |
  * |                              |                    | 0x7073-0x7075, |
-- 
1.7.7

