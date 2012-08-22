From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 15/42] qla2xxx: Only enable link up on the correct interrupt event.
Date: Wed, 22 Aug 2012 14:21:09 -0400
Message-ID: <1345659696-3670-16-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:10860 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964984Ab2HVSiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:15 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e6a01e4..8f37531 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -843,8 +843,7 @@ skip_rio:
 		 * it.  Otherwise ignore it and Wait for RSCN to come in.
 		 */
 		atomic_set(&vha->loop_down_timer, 0);
-		if (atomic_read(&vha->loop_state) != LOOP_DOWN &&
-		    atomic_read(&vha->loop_state) != LOOP_DEAD) {
+		if (mb[1] != 0xffff || (mb[2] != 0x6 && mb[2] != 0x4)) {
 			ql_dbg(ql_dbg_async, vha, 0x5011,
 			    "Asynchronous PORT UPDATE ignored %04x/%04x/%04x.\n",
 			    mb[1], mb[2], mb[3]);
-- 
1.7.7

