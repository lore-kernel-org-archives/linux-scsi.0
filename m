From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ibmvscsi: Add endian conversions to sysfs attribute show functions
Date: Wed,  3 Feb 2016 17:28:34 -0600
Message-ID: <1454542114-1797-7-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:50772 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933399AbcBCX3W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 18:29:22 -0500
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Wed, 3 Feb 2016 16:29:20 -0700
In-Reply-To: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, hare@suse.de, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

The values returned by the show functions for the host os_type,
mad_version, and partition_number attributes get their values
directly from the madapter_info struct whose associated fields are
__be32 typed. Added endian conversion to ensure these values are
sane on LE platforms.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index a2b8db1..3621ac5 100644
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

