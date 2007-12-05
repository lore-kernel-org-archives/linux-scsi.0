From: michaelc@cs.wisc.edu
Subject: [PATCH 22/23] libiscsi: use is_power_of_2
Date: Tue,  4 Dec 2007 18:42:36 -0600
Message-ID: <11968153894148-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
 <11968153753743-git-send-email-michaelc@cs.wisc.edu>
 <11968153751098-git-send-email-michaelc@cs.wisc.edu>
 <1196815376111-git-send-email-michaelc@cs.wisc.edu>
 <1196815377131-git-send-email-michaelc@cs.wisc.edu>
 <11968153781126-git-send-email-michaelc@cs.wisc.edu>
 <1196815378769-git-send-email-michaelc@cs.wisc.edu>
 <11968153791438-git-send-email-michaelc@cs.wisc.edu>
 <11968153801823-git-send-email-michaelc@cs.wisc.edu>
 <11968153812001-git-send-email-michaelc@cs.wisc.edu>
 <1196815382808-git-send-email-michaelc@cs.wisc.edu>
 <11968153831244-git-send-email-michaelc@cs.wisc.edu>
 <11968153842186-git-send-email-michaelc@cs.wisc.edu>
 <11968153853971-git-send-email-michaelc@cs.wisc.edu>
 <1196815386656-git-send-email-michaelc@cs.wisc.edu>
 <11968153873372-git-send-email-michaelc@cs.wisc.edu>
 <11968153871693-git-send-email-michaelc@cs.wisc.edu>
 <11968153883385-git-send-email-michaelc@cs.wisc.edu>
 <1196815389832-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXLEAnP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:15 -0500
In-Reply-To: <1196815389832-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, vignesh babu <vignesh.babu@wipro.com>

From: Mike Christie <michaelc@cs.wisc.edu>

Patch from vignesh babu <vignesh.babu@wipro.com>:

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6573223..553168a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <linux/kfifo.h>
 #include <linux/delay.h>
+#include <linux/log2.h>
 #include <asm/unaligned.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
@@ -1700,7 +1701,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		qdepth = ISCSI_DEF_CMD_PER_LUN;
 	}
 
-	if (cmds_max < 2 || (cmds_max & (cmds_max - 1)) ||
+	if (!is_power_of_2(cmds_max) ||
 	    cmds_max >= ISCSI_MGMT_ITT_OFFSET) {
 		if (cmds_max != 0)
 			printk(KERN_ERR "iscsi: invalid can_queue of %d. "
-- 
1.5.1.2

