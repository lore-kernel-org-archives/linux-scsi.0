From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 18/30] scsi: aacraid: Merge func to get container information
Date: Tue, 26 Dec 2017 20:34:39 -0800
Message-ID: <20171227043451.27813-19-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0064.outbound.protection.outlook.com ([104.47.37.64]:64326
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751822AbdL0EfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:16 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Merge aac_get_containers to setup target function, so that information
about all the present devices can be retrieved in one shot.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aachba.c  |  4 ++++
 drivers/scsi/aacraid/commsup.c | 34 +++++++++++++++-------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 67ca5af..c30f7da 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2021,6 +2021,10 @@ static int aac_setup_safw_targets(struct aac_dev *dev, int rescan)
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
