From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 22/30] scsi: aacraid: Merge adapter setup with resolve luns
Date: Tue, 26 Dec 2017 20:34:43 -0800
Message-ID: <20171227043451.27813-23-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0040.outbound.protection.outlook.com ([104.47.32.40]:19154
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751814AbdL0EfU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:20 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

The device hotplug events are processed only after retrieving the updated
lun information from the fw. Does not make sense to keep them separate.

Merge both the hotplug handling and safw adapter setup code into single
function.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/commsup.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 5b7a4f5..34155b1 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1934,11 +1934,18 @@ static int aac_is_safw_device_exposed(struct aac_dev *dev, int bus, int target)
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
 
@@ -1953,6 +1960,8 @@ static void aac_resolve_luns(struct aac_dev *dev)
 								is_exposed)
 			aac_remove_safw_device(dev, bus, target);
 	}
+out:
+	return rcode;
 }
 
 /**
@@ -1988,9 +1997,7 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
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
