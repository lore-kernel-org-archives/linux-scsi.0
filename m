From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 15/19] tcmu: simplify dbi thresh handling
Date: Sun, 29 Oct 2017 22:44:35 -0500
Message-ID: <1509335079-5276-16-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbdJ3DpE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Oct 2017 23:45:04 -0400
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

We do not really save a lot by trying to increase thresh
a multiple of the existing value. This just simplifies the
code by increasing it to whatever is needed for the command
being executed.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 68668a8..0630657 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -79,7 +79,6 @@
 #define DATA_BLOCK_SIZE PAGE_SIZE
 #define DATA_BLOCK_BITS (256 * 1024)
 #define DATA_SIZE (DATA_BLOCK_BITS * DATA_BLOCK_SIZE)
-#define DATA_BLOCK_INIT_BITS 128
 
 /* The total size of the ring is 8M + 256K * PAGE_SIZE */
 #define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
@@ -699,7 +698,6 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	if ((space * DATA_BLOCK_SIZE) < data_needed) {
 		unsigned long blocks_left = DATA_BLOCK_BITS - udev->dbi_thresh +
 						space;
-		unsigned long grow;
 
 		if (blocks_left < blocks_needed) {
 			pr_debug("no data space: only %lu available, but ask for %zu\n",
@@ -708,23 +706,9 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 			return false;
 		}
 
-		/* Try to expand the thresh */
-		if (!udev->dbi_thresh) {
-			/* From idle state */
-			uint32_t init_thresh = DATA_BLOCK_INIT_BITS;
-
-			udev->dbi_thresh = max(blocks_needed, init_thresh);
-		} else {
-			/*
-			 * Grow the data area by max(blocks needed,
-			 * dbi_thresh / 2), but limited to the max
-			 * DATA_BLOCK_BITS size.
-			 */
-			grow = max(blocks_needed, udev->dbi_thresh / 2);
-			udev->dbi_thresh += grow;
-			if (udev->dbi_thresh > DATA_BLOCK_BITS)
-				udev->dbi_thresh = DATA_BLOCK_BITS;
-		}
+		udev->dbi_thresh += blocks_needed;
+		if (udev->dbi_thresh > DATA_BLOCK_BITS)
+			udev->dbi_thresh = DATA_BLOCK_BITS;
 	}
 
 	return tcmu_get_empty_blocks(udev, cmd);
-- 
1.8.3.1
