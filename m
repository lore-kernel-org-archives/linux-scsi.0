From: vignesh babu <vignesh.babu@wipro.com>
Subject: [kj] is_power_of_2 in scsi
Date: Mon, 13 Aug 2007 18:25:29 +0530
Message-ID: <1187009729.7273.9.camel@merlin.linuxcoe.com>
Reply-To: vigneshbabu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:58603 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S972353AbXHMM4E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2007 08:56:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, davem@davemloft.net, open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org, Kernel Janitors List <kernel-janitors@lists.osdl.org>

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 77b06a9..908f342 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -14,6 +14,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/irqreturn.h>
+#include <linux/log2.h>
 
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -1126,7 +1127,7 @@ static int esp_reconnect(struct esp *esp)
 		if (!(bits & esp->scsi_id_mask))
 			goto do_reset;
 		bits &= ~esp->scsi_id_mask;
-		if (!bits || (bits & (bits - 1)))
+		if (!is_power_of_2(bits))
 			goto do_reset;
 
 		target = ffs(bits) - 1;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5606d1e..ffa6cc1 100644
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
@@ -1366,7 +1367,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		qdepth = ISCSI_DEF_CMD_PER_LUN;
 	}
 
-	if (cmds_max < 2 || (cmds_max & (cmds_max - 1)) ||
+	if (!is_power_of_2(cmds_max) ||
 	    cmds_max >= ISCSI_MGMT_ITT_OFFSET) {
 		if (cmds_max != 0)
 			printk(KERN_ERR "iscsi: invalid can_queue of %d. "

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

