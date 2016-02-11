From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH v2 6/7] ibmvscsi: Add endian conversions to sysfs attribute show functions
Date: Wed, 10 Feb 2016 19:32:27 -0600
Message-ID: <1455154348-3226-7-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, jthumshirn@suse.de, manoj@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The values returned by the show functions for the host os_type,
mad_version, and partition_number attributes get their values
directly from the madapter_info struct whose associated fields are
__be32 typed. Added endian conversion to ensure these values are
sane on LE platforms.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index e8d4af5..6025481 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1983,7 +1983,7 @@ static ssize_t show_host_partition_number(struct device *dev,
 	int len;
 
 	len = snprintf(buf, PAGE_SIZE, "%d\n",
-		       hostdata->madapter_info.partition_number);
+		       be32_to_cpu(hostdata->madapter_info.partition_number));
 	return len;
 }
 
@@ -2003,7 +2003,7 @@ static ssize_t show_host_mad_version(struct device *dev,
 	int len;
 
 	len = snprintf(buf, PAGE_SIZE, "%d\n",
-		       hostdata->madapter_info.mad_version);
+		       be32_to_cpu(hostdata->madapter_info.mad_version));
 	return len;
 }
 
@@ -2022,7 +2022,8 @@ static ssize_t show_host_os_type(struct device *dev,
 	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%d\n", hostdata->madapter_info.os_type);
+	len = snprintf(buf, PAGE_SIZE, "%d\n",
+		       be32_to_cpu(hostdata->madapter_info.os_type));
 	return len;
 }
 
-- 
2.5.0
