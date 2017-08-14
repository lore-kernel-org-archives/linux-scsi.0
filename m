From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 5/6] hpsa: handle unsupported devices more gracefully
Date: Mon, 14 Aug 2017 13:19:14 +0200
Message-ID: <1502709555-15837-6-git-send-email-hare@suse.de>
References: <1502709555-15837-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752859AbdHNLTX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Aug 2017 07:19:23 -0400
In-Reply-To: <1502709555-15837-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, Hannes Reinecke <hare@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

Add a warning message if an unsupported device is found and the
hpsa_allow_any parameter is not set.
Also make the hpsa_allow_any parameter writeable once the hpsa
driver is loaded.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c90a83d..7168cec 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -85,7 +85,7 @@
 static int hpsa_allow_any;
 module_param(hpsa_allow_any, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(hpsa_allow_any,
-		"Allow hpsa driver to access unknown HP Smart Array hardware");
+		"Allow hpsa driver to access unsupported HP Smart Array hardware");
 static int hpsa_simple_mode;
 module_param(hpsa_simple_mode, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(hpsa_simple_mode,
@@ -7314,6 +7314,7 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id,
 		!hpsa_allow_any) {
 		dev_warn(&pdev->dev, "unrecognized board ID: "
 			"0x%08x, ignoring.\n", *board_id);
+		dev_warn(&pdev->dev, "This device may be enabled by loading the hpsa module with the hpsa_allow_any=1 option or by writing \"%s\" to /sys/bus/pci/drivers/hpsa/bind while the module is loaded. Please note that the driver is untested with this device and will result in an unsupported environment.\n", dev_name(&pdev->dev));
 			return -ENODEV;
 	}
 	if (legacy_board)
-- 
1.8.5.6
