From: michaelc@cs.wisc.edu
Subject: [PATCH 22/24] libiscsi: use is_power_of_2
Date: Thu, 13 Dec 2007 12:43:41 -0600
Message-ID: <11975714543562-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
 <11975714333916-git-send-email-michaelc@cs.wisc.edu>
 <11975714342353-git-send-email-michaelc@cs.wisc.edu>
 <1197571435692-git-send-email-michaelc@cs.wisc.edu>
 <119757143673-git-send-email-michaelc@cs.wisc.edu>
 <11975714363904-git-send-email-michaelc@cs.wisc.edu>
 <11975714372848-git-send-email-michaelc@cs.wisc.edu>
 <11975714382641-git-send-email-michaelc@cs.wisc.edu>
 <11975714404116-git-send-email-michaelc@cs.wisc.edu>
 <11975714413336-git-send-email-michaelc@cs.wisc.edu>
 <1197571442630-git-send-email-michaelc@cs.wisc.edu>
 <11975714441250-git-send-email-michaelc@cs.wisc.edu>
 <1197571445685-git-send-email-michaelc@cs.wisc.edu>
 <1197571447387-git-send-email-michaelc@cs.wisc.edu>
 <1197571448857-git-send-email-michaelc@cs.wisc.edu>
 <11975714503562-git-send-email-michaelc@cs.wisc.edu>
 <1197571451503-git-send-email-michaelc@cs.wisc.edu>
 <1197571453148-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760067AbXLMSoT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:19 -0500
In-Reply-To: <1197571453148-git-send-email-michaelc@cs.wisc.edu>
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

