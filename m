From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH v2 3/7] ibmvscsi: Replace magic values in set_adpater_info() with defines
Date: Wed, 10 Feb 2016 19:32:24 -0600
Message-ID: <1455154348-3226-4-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, jthumshirn@suse.de, manoj@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Add defines for mad version and mad os_type, and replace the magic
numbers in set_adapter_info() accordingly.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 8 ++++----
 drivers/scsi/ibmvscsi/viosrp.h   | 3 +++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index c888ea1..4b09a9b 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -283,8 +283,8 @@ static void set_adapter_info(struct ibmvscsi_host_data *hostdata)
 	hostdata->madapter_info.partition_number =
 					cpu_to_be32(partition_number);
 
-	hostdata->madapter_info.mad_version = cpu_to_be32(1);
-	hostdata->madapter_info.os_type = cpu_to_be32(2);
+	hostdata->madapter_info.mad_version = cpu_to_be32(SRP_MAD_VERSION_1);
+	hostdata->madapter_info.os_type = cpu_to_be32(SRP_MAD_OS_LINUX);
 }
 
 /**
@@ -1398,7 +1398,7 @@ static void adapter_info_rsp(struct srp_event_struct *evt_struct)
 			hostdata->host->max_sectors = 
 				be32_to_cpu(hostdata->madapter_info.port_max_txu[0]) >> 9;
 		
-		if (be32_to_cpu(hostdata->madapter_info.os_type) == 3 &&
+		if (be32_to_cpu(hostdata->madapter_info.os_type) == SRP_MAD_OS_AIX &&
 		    strcmp(hostdata->madapter_info.srp_version, "1.6a") <= 0) {
 			dev_err(hostdata->dev, "host (Ver. %s) doesn't support large transfers\n",
 				hostdata->madapter_info.srp_version);
@@ -1407,7 +1407,7 @@ static void adapter_info_rsp(struct srp_event_struct *evt_struct)
 			hostdata->host->sg_tablesize = MAX_INDIRECT_BUFS;
 		}
 
-		if (be32_to_cpu(hostdata->madapter_info.os_type) == 3) {
+		if (be32_to_cpu(hostdata->madapter_info.os_type) == SRP_MAD_OS_AIX) {
 			enable_fast_fail(hostdata);
 			return;
 		}
diff --git a/drivers/scsi/ibmvscsi/viosrp.h b/drivers/scsi/ibmvscsi/viosrp.h
index 3d20851..d0f689b 100644
--- a/drivers/scsi/ibmvscsi/viosrp.h
+++ b/drivers/scsi/ibmvscsi/viosrp.h
@@ -221,7 +221,10 @@ struct mad_adapter_info_data {
 	char srp_version[8];
 	char partition_name[96];
 	__be32 partition_number;
+#define SRP_MAD_VERSION_1 1
 	__be32 mad_version;
+#define SRP_MAD_OS_LINUX 2
+#define SRP_MAD_OS_AIX 3
 	__be32 os_type;
 	__be32 port_max_txu[8];	/* per-port maximum transfer */
 };
-- 
2.5.0
