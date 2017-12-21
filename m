From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 18/29] scsi: aacraid: Merge func to get container information
Date: Thu, 21 Dec 2017 09:34:09 -0800
Message-ID: <20171221173420.8213-19-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0073.outbound.protection.outlook.com ([104.47.40.73]:50048
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754187AbdLURer (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:47 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Merge aac_get_containers to setup target function, so that information
about all the present devices can be retrieved in one shot.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  |  4 ++++
 drivers/scsi/aacraid/commsup.c | 34 +++++++++++++++-------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 01cb825..7f6036c 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2032,6 +2032,10 @@ static int aac_setup_safw_targets(struct aac_dev *dev, int rescan)
 {
 	int rcode = 0;
 
+	rcode = aac_get_containers(dev);
+	if (unlikely(rcode < 0))
+		goto out;
+
 	rcode = aac_get_safw_ciss_luns(dev, rescan);
 	if (unlikely(rcode < 0))
 		goto out;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index f3077b3..9625eb0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1949,26 +1949,22 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 
 		aac_resolve_luns(dev);
 
-		if (events == SA_AIF_LDEV_CHANGE ||
-		    events == SA_AIF_BPCFG_CHANGE) {
-			aac_get_containers(dev);
-			for (container = 0; container <
+		for (container = 0; container <
 			dev->maximum_num_containers; ++container) {
-				sdev = scsi_device_lookup(dev->scsi_host_ptr,
-						CONTAINER_CHANNEL,
-						container, 0);
-				if (dev->fsa_dev[container].valid && !sdev) {
-					scsi_add_device(dev->scsi_host_ptr,
-						CONTAINER_CHANNEL,
-						container, 0);
-				} else if (!dev->fsa_dev[container].valid &&
-					sdev) {
-					scsi_remove_device(sdev);
-					scsi_device_put(sdev);
-				} else if (sdev) {
-					scsi_rescan_device(&sdev->sdev_gendev);
-					scsi_device_put(sdev);
-				}
+			sdev = scsi_device_lookup(dev->scsi_host_ptr,
+					CONTAINER_CHANNEL,
+					container, 0);
+			if (dev->fsa_dev[container].valid && !sdev) {
+				scsi_add_device(dev->scsi_host_ptr,
+					CONTAINER_CHANNEL,
+					container, 0);
+			} else if (!dev->fsa_dev[container].valid &&
+				sdev) {
+				scsi_remove_device(sdev);
+				scsi_device_put(sdev);
+			} else if (sdev) {
+				scsi_rescan_device(&sdev->sdev_gendev);
+				scsi_device_put(sdev);
 			}
 		}
 		break;
-- 
2.9.4
