From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [V2 PATCH 06/11] aacraid: 240 simple volume support
Date: Thu, 26 Mar 2015 10:41:27 -0400
Message-ID: <1427380892-1978-7-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37913 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbbCZOsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:48:02 -0400
In-Reply-To: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add 240 simple volume support

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c  |    5 +++++
 drivers/scsi/aacraid/aacraid.h |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 09027e9..9b3dd6e 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -462,6 +462,11 @@ int aac_get_containers(struct aac_dev *dev)
 	if (status >= 0) {
 		dresp = (struct aac_get_container_count_resp *)fib_data(fibptr);
 		maximum_num_containers = le32_to_cpu(dresp->ContainerSwitchEntries);
+		if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+		    AAC_OPTION_SUPPORTED_240_VOLUMES) {
+			maximum_num_containers =
+				le32_to_cpu(dresp->MaxSimpleVolumes);
+		}
 		aac_fib_complete(fibptr);
 	}
 	/* FIB should be freed only after getting the response from the F/W */
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 015c341..bf14ae0 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1016,6 +1016,8 @@ struct aac_supplement_adapter_info
 #define AAC_OPTION_DOORBELL_RESET	cpu_to_le32(0x00004000)
 /* 4KB sector size */
 #define AAC_OPTION_VARIABLE_BLOCK_SIZE	cpu_to_le32(0x00040000)
+/* 240 simple volume support */
+#define AAC_OPTION_SUPPORTED_240_VOLUMES cpu_to_le32(0x10000000)
 #define AAC_SIS_VERSION_V3	3
 #define AAC_SIS_SLOT_UNKNOWN	0xFF
 
@@ -1751,6 +1753,7 @@ struct aac_get_container_count_resp {
 	__le32		MaxContainers;
 	__le32		ContainerSwitchEntries;
 	__le32		MaxPartitions;
+	__le32		MaxSimpleVolumes;
 };
 
 
-- 
1.7.7.3

