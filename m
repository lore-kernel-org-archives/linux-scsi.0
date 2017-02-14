From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 14/16] aacraid: Save adapter fib log before an IOP reset
Date: Tue, 14 Feb 2017 12:44:44 -0800
Message-ID: <20170214204446.14808-15-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0083.outbound.protection.outlook.com ([104.47.34.83]:31968
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751664AbdBODWo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:44 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

Currently  the adapter firmware does not save outstanding I/O's log
information  when an IOP reset is triggered. This is problematic when
trying to root cause and debug issues.

Fixed by adding sync command to trigger I/O log file save in the adapter
firmware before issuing an IOP reset.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  |  4 ++++
 drivers/scsi/aacraid/aacraid.h |  6 ++++++
 drivers/scsi/aacraid/src.c     | 17 +++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 3ede50f..e3e93de 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -294,6 +294,10 @@ MODULE_PARM_DESC(aif_timeout, "The duration of time in seconds to wait for"
 	"deregistering them. This is typically adjusted for heavily burdened"
 	" systems.");
 
+int aac_fib_dump;
+module_param(aac_fib_dump, int, 0644);
+MODULE_PARM_DESC(aac_fib_dump, "Dump controller fibs prior to IOP_RESET 0=off, 1=on");
+
 int numacb = -1;
 module_param(numacb, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(numacb, "Request a limit to the number of adapter control"
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 9281e72..622fd69 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1444,6 +1444,10 @@ struct aac_supplement_adapter_info
 #define AAC_OPTION_VARIABLE_BLOCK_SIZE	cpu_to_le32(0x00040000)
 /* 240 simple volume support */
 #define AAC_OPTION_SUPPORTED_240_VOLUMES cpu_to_le32(0x10000000)
+/*
+ * Supports FIB dump sync command send prior to IOP_RESET
+ */
+#define AAC_OPTION_SUPPORTED3_IOP_RESET_FIB_DUMP	cpu_to_le32(0x00004000)
 #define AAC_SIS_VERSION_V3	3
 #define AAC_SIS_SLOT_UNKNOWN	0xFF
 
@@ -2483,6 +2487,7 @@ struct aac_hba_info {
 #define GET_DRIVER_BUFFER_PROPERTIES	0x00000023
 #define RCV_TEMP_READINGS		0x00000025
 #define GET_COMM_PREFERRED_SETTINGS	0x00000026
+#define IOP_RESET_FW_FIB_DUMP		0x00000034
 #define IOP_RESET			0x00001000
 #define IOP_RESET_ALWAYS		0x00001001
 #define RE_INIT_ADAPTER			0x000000ee
@@ -2686,4 +2691,5 @@ extern int aac_commit;
 extern int update_interval;
 extern int check_interval;
 extern int aac_check_reset;
+extern int aac_fib_dump;
 #endif
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 0990117..fa03cdc 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -679,10 +679,27 @@ void aac_set_intx_mode(struct aac_dev *dev)
 	}
 }
 
+static void aac_dump_fw_fib_iop_reset(struct aac_dev *dev)
+{
+	__le32 supported_options3;
+
+	if (!aac_fib_dump)
+		return;
+
+	supported_options3  = dev->supplement_adapter_info.supported_options3;
+	if (!(supported_options3 & AAC_OPTION_SUPPORTED3_IOP_RESET_FIB_DUMP))
+		return;
+
+	aac_adapter_sync_cmd(dev, IOP_RESET_FW_FIB_DUMP,
+			0, 0, 0,  0, 0, 0, NULL, NULL, NULL, NULL, NULL);
+}
+
 static void aac_send_iop_reset(struct aac_dev *dev, int bled)
 {
 	u32 var, reset_mask;
 
+	aac_dump_fw_fib_iop_reset(dev);
+
 	bled = aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
 				    0, 0, 0, 0, 0, 0, &var,
 				    &reset_mask, NULL, NULL, NULL);
-- 
2.7.4
