From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 22/29] scsi: aacraid: Merge adapter setup with resolve luns
Date: Thu, 21 Dec 2017 09:34:13 -0800
Message-ID: <20171221173420.8213-23-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0043.outbound.protection.outlook.com ([104.47.36.43]:60032
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754621AbdLURew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:52 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

The device hotplug events are processed only after retrieving the updated
lun information from the fw. Does not make sense to keep them separate.

Merge both the hotplug handling and safw adapter setup code into single
function.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 2cd880f..f781076 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1938,11 +1938,18 @@ static int aac_is_safw_device_exposed(struct aac_dev *dev, int bus, int target)
 	return is_exposed;
 }
 
-static void aac_resolve_luns(struct aac_dev *dev)
+static int aac_update_safw_host_devices(struct aac_dev *dev, int rescan)
 {
 	int i;
-	int bus, target;
+	int bus;
+	int target;
 	int is_exposed = 0;
+	int rcode = 0;
+
+	rcode = aac_setup_safw_adapter(dev, rescan);
+	if (unlikely(rcode < 0)) {
+		goto out;
+	}
 
 	for (i = 0; i < AAC_BUS_TARGET_LOOP; i++) {
 
@@ -1957,6 +1964,8 @@ static void aac_resolve_luns(struct aac_dev *dev)
 								is_exposed)
 			aac_remove_safw_device(dev, bus, target);
 	}
+out:
+	return rcode;
 }
 
 /**
@@ -1992,9 +2001,7 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 	case SA_AIF_LDEV_CHANGE:
 	case SA_AIF_BPCFG_CHANGE:
 
-		aac_setup_safw_adapter(dev, AAC_RESCAN);
-
-		aac_resolve_luns(dev);
+		aac_update_safw_host_devices(dev, AAC_RESCAN);
 		break;
 
 	case SA_AIF_BPSTAT_CHANGE:
-- 
2.9.4
