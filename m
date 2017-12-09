From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 6/9] lpfc: Fix issues connecting with nvme initiator
Date: Fri,  8 Dec 2017 17:18:08 -0800
Message-ID: <20171209011811.23421-7-jsmart2021@gmail.com>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:46814 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbdLIBS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2017 20:18:29 -0500
Received: by mail-qk0-f195.google.com with SMTP id b184so1024065qkc.13
        for <linux-scsi@vger.kernel.org>; Fri, 08 Dec 2017 17:18:29 -0800 (PST)
In-Reply-To: <20171209011811.23421-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

In the lpfc discovery engine, when as a nvme target, where the
driver was performing mailbox io with the adapter for port login
when a NVME PRLI is received from the host. Rather than queue and
eventually get back to sending a response after the mailbox traffic,
the driver rejected the io with an error response.

Turns out this particular initiator didn't like the rejection values
(unable to process command/command in progress) so it never attempted
a retry of the PRLI. Thus the host never established nvme connectivity
with the lpfc target.

By changing the rejection values (to Logical Busy/nothing more), the
initiator accepted the response and would retry the PRLI, resulting in
nvme connectivity.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 283382ac0456..d841aa42f607 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1603,8 +1603,8 @@ lpfc_rcv_prli_reglogin_issue(struct lpfc_vport *vport,
 			 * rpi registration does complete.
 			 */
 			memset(&stat, 0, sizeof(struct ls_rjt));
-			stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
-			stat.un.b.lsRjtRsnCodeExp = LSEXP_CMD_IN_PROGRESS;
+			stat.un.b.lsRjtRsnCode = LSRJT_LOGICAL_BSY;
+			stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 			lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
 					    ndlp, NULL);
 			return ndlp->nlp_state;
-- 
2.13.1
