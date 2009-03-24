From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/26] qla2xxx: Correct abort-semantics in qla2x00_abort_all_cmds().
Date: Tue, 24 Mar 2009 09:08:04 -0700
Message-ID: <1237910900-30817-11-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762298AbZCXQIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:32 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

As all commands queued on the physical HBA should be aborted and
returned to the upper-layers.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dad624e..0d586a4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1063,7 +1063,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 			continue;
 		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
 			sp = req->outstanding_cmds[cnt];
-			if (sp && sp->fcport->vha == vha) {
+			if (sp) {
 				req->outstanding_cmds[cnt] = NULL;
 				sp->cmd->result = res;
 				qla2x00_sp_compl(ha, sp);
-- 
1.6.2.rc0.55.g30aa4f

