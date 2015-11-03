From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH v2 2/5] ipr: Don't set NO_ULEN_CHK bit when resource is a vset.
Date: Tue,  3 Nov 2015 16:26:07 -0200
Message-ID: <1446575170-18656-2-git-send-email-krisman@linux.vnet.ibm.com>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:43876 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbbKCS02 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2015 13:26:28 -0500
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Tue, 3 Nov 2015 16:26:27 -0200
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 482B3352007B
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2015 13:25:14 -0500 (EST)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA3IQsWN3301614
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 16:26:54 -0200
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
	by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA3IQNT9021828
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 16:26:24 -0200
In-Reply-To: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

According to the IPR specification, Inhibit Underlength Checking bit
must be disabled when issuing commands to vsets.  Enabling it in this
case might cause SCSI commands to fail with an Illegal Request, so make
sure we keep this bit cleared when resource is a vset.

Changes since v1:
	- Put gsci exclusive stuff in a separate block.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 238efab..6849b7f 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6363,15 +6363,19 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	ipr_cmd->scsi_cmd = scsi_cmd;
 	ipr_cmd->done = ipr_scsi_eh_done;
 
-	if (ipr_is_gscsi(res) || ipr_is_vset_device(res)) {
+	if (ipr_is_gscsi(res)) {
 		if (scsi_cmd->underflow == 0)
 			ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
 
-		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
-		if (ipr_is_gscsi(res) && res->reset_occurred) {
+		if (res->reset_occurred) {
 			res->reset_occurred = 0;
 			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_DELAY_AFTER_RST;
 		}
+	}
+
+	if (ipr_is_gscsi(res) || ipr_is_vset_device(res)) {
+		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
+
 		ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_ALIGNED_BFR;
 		if (scsi_cmd->flags & SCMD_TAGGED)
 			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_SIMPLE_TASK;
-- 
2.1.0

