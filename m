From: Mike Miller <mike.miller@hp.com>
Subject: [Patch 1/1] cciss: bug fix, prevent cciss from loading in kdump kernel
Date: Mon, 15 Apr 2013 12:59:06 -0500
Message-ID: <20130415175906.GA16955@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Patch 1/1

If hpsa is selected as the Smart Array driver cciss may try to load in the
kdump kernel. When this happens kdump fails and a core file cannot be created.
This patch prevents cciss from trying to load in this scenario. This effects
primarily older Smart Array controllers.

From: Mike Miller <mike.miller@hp.com>
Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/block/cciss.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1c1b8e5..a6c0973 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4960,6 +4960,12 @@ static int cciss_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ctlr_info_t *h;
 	unsigned long flags;
 
+	/*
+	 * if this is the kdump kernel and the user has set the flags to
+	 * use hpsa rather than cciss just bail
+	 */
+	if ((reset_devices) && (cciss_allow_hpsa == 1))
+		return -ENODEV;
 	rc = cciss_init_reset_devices(pdev);
 	if (rc) {
 		if (rc != -ENOTSUPP)
