From: mchristi@redhat.com
Subject: [PATCH 2/2] target: fix max discard sectors calculation
Date: Mon, 16 May 2016 13:46:50 -0500
Message-ID: <1463424410-17196-3-git-send-email-mchristi@redhat.com>
References: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbcEPSqy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2016 14:46:54 -0400
In-Reply-To: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com
Cc: Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

max_discard_sectors and block_size are 32 bits, so we can
overflow when trying to convert between the linux block
layer max discard sectors and the LIO value.

This fixes a regression caused by this patch:

commit 8a9ebe717a133ba7bc90b06047f43cc6b8bcb8b3
Author: Mike Christie <mchristi@redhat.com>
Date:   Mon Jan 18 14:09:27 2016 -0600

    target: Fix WRITE_SAME/DISCARD conversion to linux 512b sectors

where you will get smaller and extra discards due to the max size
being shortened.


Signed-off-by: Mike Christie <mchristi@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/target/target_core_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index a4046ca..3f9f304 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -826,8 +826,8 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 	if (!blk_queue_discard(q))
 		return false;
 
-	attrib->max_unmap_lba_count = (q->limits.max_discard_sectors << 9) /
-								block_size;
+	attrib->max_unmap_lba_count =
+			((u64)q->limits.max_discard_sectors << 9) / block_size;
 	/*
 	 * Currently hardcoded to 1 in Linux/SCSI code..
 	 */
-- 
2.7.2

