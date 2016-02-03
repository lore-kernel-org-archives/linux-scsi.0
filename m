From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ibmvscsi: Replace magic values in set_adpater_info() with defines
Date: Wed,  3 Feb 2016 17:28:31 -0600
Message-ID: <1454542114-1797-4-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, hare@suse.de, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Add defines for mad version and mad os_type, and replace the magic
numbers in set_adapter_info() accordingly.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ++--
 drivers/scsi/ibmvscsi/viosrp.h   | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 176260d..7e51615 100644
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
diff --git a/drivers/scsi/ibmvscsi/viosrp.h b/drivers/scsi/ibmvscsi/viosrp.h
index 17f2de0..da9bb29 100644
--- a/drivers/scsi/ibmvscsi/viosrp.h
+++ b/drivers/scsi/ibmvscsi/viosrp.h
@@ -38,6 +38,8 @@
 #define SRP_VERSION "16.a"
 #define SRP_MAX_IU_LEN	256
 #define SRP_MAX_LOC_LEN 32
+#define SRP_MAD_VERSION_1 1
+#define SRP_MAD_OS_LINUX 2
 
 union srp_iu {
 	struct srp_login_req login_req;
-- 
2.5.0
