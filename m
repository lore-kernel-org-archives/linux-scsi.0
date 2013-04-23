From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] cciss: bug fix to prevent cciss from loading in kdump crash kernel
Date: Tue, 23 Apr 2013 12:25:39 -0500
Message-ID: <20130423172539.GA11255@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

PATCH 1/1

By default the cciss driver supports all "older" HP Smart Array controllers
and hpsa supports all controllers starting with the G6 family. There are
module parameters that allow a user to override those defaults and use hpsa
for any HP Smart Array controller.
If the user does override the default behavior and uses hpsa for older
controllers it is possible that cciss may try to load in a kdump crash
kernel. This may happen if cciss is loaded first from the kdump initrd
image. If cciss does load rather than hpsa and reset_devices is true we
immediately call cciss_hard_reset_controller. This will result in a kernel
panic and the core file cannot be created.
This patch prevents cciss from trying to load in this scenario.

Tested with 3.9.0-rc7.

From: Mike <mike.miller@hp.com>
Signed-off-by: Mike Miller <mike.miller@hp.com>

---
 drivers/block/cciss.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1c1b8e5..06c8dba 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4960,6 +4960,16 @@ static int cciss_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ctlr_info_t *h;
 	unsigned long flags;
 
+	/*
+	 * By default the cciss driver is used for all older HP Smart Array
+	 * controllers. There are module paramaters that allow a user to
+	 * override this behavior and instead use the hpsa SCSI driver. If
+	 * this is the case cciss may be loaded first from the kdump initrd
+	 * image and cause a kernel panic. So if reset_devices is true and
+	 * cciss_allow_hpsa is set just bail.
+	 */
+	if ((reset_devices) && (cciss_allow_hpsa == 1))
+		return -ENODEV;
 	rc = cciss_init_reset_devices(pdev);
 	if (rc) {
 		if (rc != -ENOTSUPP)
