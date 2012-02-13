From: vikas.chaudhary@qlogic.com
Subject: [PATCH 05/11] qla4xxx: Remove un-necessary print statment
Date: Mon, 13 Feb 2012 18:30:44 +0530
Message-ID: <1329138050-1042-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:61193
	"HELO magana.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1756607Ab2BMNJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:53 -0500
In-Reply-To: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

On ROM lock acquiring timeout failure, driver spews lot of warning
messages in a for loop, remove the unwanted warning message to reduce
kernel messages clutter.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 225e921..af8dcf6 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -860,11 +860,8 @@ qla4_8xxx_rom_lock(struct scsi_qla_host *ha)
 		done = qla4_8xxx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_LOCK));
 		if (done == 1)
 			break;
-		if (timeout >= qla4_8xxx_rom_lock_timeout) {
-			ql4_printk(KERN_WARNING, ha,
-			    "%s: Failed to acquire rom lock", __func__);
+		if (timeout >= qla4_8xxx_rom_lock_timeout)
 			return -1;
-		}
 
 		timeout++;
 
-- 
1.7.8.247.g10f4e

