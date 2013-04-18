From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] cciss: add cciss_allow_hpsa module parameter
Date: Thu, 18 Apr 2013 13:49:37 -0500
Message-ID: <20130418184937.GA31252@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Add the cciss_allow_hpsa modules parameter. This allows users to use the hpsa
driver instead of cciss for older controllers.
Tested with 3.9.0-rc7 in combination with the bug fix submitted Tuesday. My
apologies for not testing that patch with the correct kernel.

From: Mike <mike.miller@hp.com>
Signed-off-by: Mike Miller <mike.miller@hp.com>

---
 drivers/block/cciss.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a6c0973..081d1a8 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -75,6 +75,12 @@ module_param(cciss_simple_mode, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(cciss_simple_mode,
 	"Use 'simple mode' rather than 'performant mode'");
 
+static int cciss_allow_hpsa;
+module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(cciss_allow_hpsa,
+	"Prevent cciss driver from accessing hardware known to be "
+	" supported by the hpsa driver");
+
 static DEFINE_MUTEX(cciss_mutex);
 static struct proc_dir_entry *proc_cciss;
 
@@ -4116,9 +4122,13 @@ static int cciss_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
 			subsystem_vendor_id;
 
-	for (i = 0; i < ARRAY_SIZE(products); i++)
+	for (i = 0; i < ARRAY_SIZE(products); i++) {
+		/* Stand aside for hpsa driver on request */
+		if (cciss_allow_hpsa)
+			return -ENODEV;
 		if (*board_id == products[i].board_id)
 			return i;
+	}
 	dev_warn(&pdev->dev, "unrecognized board ID: 0x%08x, ignoring.\n",
 		*board_id);
 	return -ENODEV;
