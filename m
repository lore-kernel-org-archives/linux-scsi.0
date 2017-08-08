From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] hpsa: handle unsupported devices more gracefully
Date: Tue,  8 Aug 2017 10:35:15 +0200
Message-ID: <1502181315-102499-7-git-send-email-hare@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51917 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750849AbdHHIfU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 04:35:20 -0400
In-Reply-To: <1502181315-102499-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

Add a warning message if an unsupported device is found and the
hpsa_allow_any parameter is not set.
Also make the hpsa_allow_any parameter writeable once the hpsa
driver is loaded.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/scsi/hpsa.c | 43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 790958f..d523ec0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -82,10 +82,19 @@
 MODULE_VERSION(HPSA_DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-static int hpsa_allow_any;
-module_param(hpsa_allow_any, int, S_IRUGO|S_IWUSR);
+static bool hpsa_allow_any = false;
+static bool hpsa_claimed_unsupported = false;
+static int hpsa_set_hpsa_allow_any(const char *buffer,
+				   const struct kernel_param *kp);
+static struct kernel_param_ops hpsa_allow_any_ops = {
+	.set = hpsa_set_hpsa_allow_any,
+	.get = param_get_bool,
+};
+
+module_param_cb(hpsa_allow_any, &hpsa_allow_any_ops, &hpsa_allow_any,
+		S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(hpsa_allow_any,
-		"Allow hpsa driver to access unknown HP Smart Array hardware");
+		"Allow hpsa driver to access unsupported HP Smart Array hardware");
 static int hpsa_simple_mode;
 module_param(hpsa_simple_mode, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(hpsa_simple_mode,
@@ -7302,10 +7311,12 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id,
 		!hpsa_allow_any) {
 		dev_warn(&pdev->dev, "unrecognized board ID: "
 			"0x%08x, ignoring.\n", *board_id);
+		dev_warn(&pdev->dev, "This device may be enabled by loading the hpsa module with the hpsa_allow_any=1 option or by writing \"%s\" to /sys/bus/pci/drivers/hpsa/bind while the module is loaded. Please note that the driver is untested with this device and will result in an unsupported environment.\n", dev_name(&pdev->dev));
 			return -ENODEV;
 	}
 	if (supported)
 		*supported = false;
+	hpsa_claimed_unsupported = true;
 	return ARRAY_SIZE(products) - 1; /* generic unknown smart array */
 }
 
@@ -9622,5 +9633,31 @@ static void __attribute__((unused)) verify_offsets(void)
 #undef VERIFY_OFFSET
 }
 
+static int hpsa_set_hpsa_allow_any(const char *buffer,
+				   const struct kernel_param *kp)
+{
+	int ret;
+	struct kernel_param dummy_kp = *kp;
+	bool newval;
+
+	dummy_kp.arg = &newval;
+
+	ret = param_set_bool(buffer, &dummy_kp);
+	if (ret)
+		return ret;
+
+	if (hpsa_allow_any && !newval) {
+		if (hpsa_claimed_unsupported) {
+			pr_info("hpsa: can't disable hpsa_allow_any parameter. Devices already in use.\n");
+			return -EPERM;
+		} else
+			hpsa_allow_any = false;
+	} else if (!hpsa_allow_any && newval) {
+		pr_info("hpsa: allowing unsupported devices. If devices are claimed, this will result in an unsupported environment.\n");
+		hpsa_allow_any = true;
+	}
+	return 0;
+}
+
 module_init(hpsa_init);
 module_exit(hpsa_cleanup);
-- 
1.8.5.6
