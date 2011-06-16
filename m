From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
Subject: [PATCH 08/11] [SCSI] tcm_fc: use printk_ratelimited() instead of
 printk_ratelimit()
Date: Thu, 16 Jun 2011 14:13:48 +0200
Message-ID: <9fa37410d549c9e160ac75828f326f9a2b5b1e81.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40350 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756982Ab1FPMNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 08:13:50 -0400
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <jbottomley@parallels.com>, Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.>
Cc: christian.dietrich@informatik.uni-erlangen.de

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited()

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 drivers/target/tcm_fc/tfc_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 4c3c0ef..b1d6911 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -39,6 +39,7 @@
 #include <linux/configfs.h>
 #include <linux/ctype.h>
 #include <linux/hash.h>
+#include <linux/ratelimit.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -201,8 +202,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 		error = lport->tt.seq_send(lport, cmd->seq, fp);
 		if (error) {
 			/* XXX For now, initiator will retry */
-			if (printk_ratelimit())
-				printk(KERN_ERR "%s: Failed to send frame %p, "
+			printk_ratelimited(KERN_ERR "%s: Failed to send frame %p, "
 						"xid <0x%x>, remaining <0x%x>, "
 						"lso_max <0x%x>\n",
 						__func__, fp, ep->xid,
-- 
1.7.4.1

