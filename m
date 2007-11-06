From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] SCSI: Use is_power_of_2() macro for simplicity.
Date: Tue, 6 Nov 2007 10:20:46 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711061019450.9041@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:41537 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbXKFPW2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 10:22:28 -0500
Received: from [99.236.101.138] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1IpQG3-00073M-Rq
	for linux-scsi@vger.kernel.org; Tue, 06 Nov 2007 10:22:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

 drivers/scsi/NCR53C9x.c  |    3 ++-
 drivers/scsi/esp_scsi.c  |    3 ++-
 drivers/scsi/iscsi_tcp.c |    3 ++-
 drivers/scsi/libiscsi.c  |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 5b0efc9..2823f7d 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -33,6 +33,7 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/init.h>
+#include <linux/log2.h>

 #include "scsi.h"
 #include <scsi/scsi_host.h>
@@ -1656,7 +1657,7 @@ static inline int reconnect_target(struct NCR_ESP *esp, struct ESP_regs *eregs)
 	if(!(it & me))
 		return -1;
 	it &= ~me;
-	if(it & (it - 1))
+	if(!is_power_of_2(it))
 		return -1;
 	while(!(it & 1))
 		targ++, it >>= 1;
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 4ed3a52..83c454d 100644
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
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4bcf916..40a7fcc 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
+#include <linux/log2.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -2076,7 +2077,7 @@ iscsi_conn_set_param(struct iscsi_cls_conn *cls_conn, enum iscsi_param param,
 			break;
 		iscsi_r2tpool_free(session);
 		iscsi_set_param(cls_conn, param, buf, buflen);
-		if (session->max_r2t & (session->max_r2t - 1))
+		if (!is_power_of_2(session->max_r2t))
 			session->max_r2t = roundup_pow_of_two(session->max_r2t);
 		if (iscsi_r2tpool_alloc(session))
 			return -ENOMEM;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index efceed4..daf8a4b 100644
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
@@ -1390,7 +1391,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		qdepth = ISCSI_DEF_CMD_PER_LUN;
 	}

-	if (cmds_max < 2 || (cmds_max & (cmds_max - 1)) ||
+	if (cmds_max < 2 || !is_power_of_2(cmds_max) ||
 	    cmds_max >= ISCSI_MGMT_ITT_OFFSET) {
 		if (cmds_max != 0)
 			printk(KERN_ERR "iscsi: invalid can_queue of %d. "
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
