From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 06/15] aacraid: Added sysfs for driver version
Date: Thu, 16 Feb 2017 12:51:15 -0800
Message-ID: <20170216205124.20271-7-RaghavaAditya.Renukunta@microsemi.com>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0077.outbound.protection.outlook.com ([104.47.32.77]:63297
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755305AbdBQD2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 22:28:12 -0500
In-Reply-To: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

Added support to retrieve driver version from a new sysfs variable called
driver_version. It makes it easier for the user to figure out the driver
version that is currently running.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/linit.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index ab4f1e7..df02784 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1131,6 +1131,13 @@ static ssize_t aac_show_bios_version(struct device *device,
 	return len;
 }
 
+static ssize_t aac_show_driver_version(struct device *device,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", aac_driver_version);
+}
+
 static ssize_t aac_show_serial_number(struct device *device,
 			       struct device_attribute *attr, char *buf)
 {
@@ -1241,6 +1248,13 @@ static struct device_attribute aac_bios_version = {
 	},
 	.show = aac_show_bios_version,
 };
+static struct device_attribute aac_lld_version = {
+	.attr = {
+		.name = "driver_version",
+		.mode = 0444,
+	},
+	.show = aac_show_driver_version,
+};
 static struct device_attribute aac_serial_number = {
 	.attr = {
 		.name = "serial_number",
@@ -1278,6 +1292,7 @@ static struct device_attribute *aac_attrs[] = {
 	&aac_kernel_version,
 	&aac_monitor_version,
 	&aac_bios_version,
+	&aac_lld_version,
 	&aac_serial_number,
 	&aac_max_channel,
 	&aac_max_id,
-- 
2.7.4
