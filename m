From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/scsi/lpfc/lpfc_init.c: remove unnecessary casting
Date: Tue, 27 May 2014 19:49:18 +0200
Message-ID: <1401212958-7710-1-git-send-email-fabf@skynet.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:12760 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbaE0RtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 13:49:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

Fix coccicheck warning:
"WARNING: casting value returned by k[cmz]alloc to (struct lpfc_sli_ring *) is useless."

Cc: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/lpfc/lpfc_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 635eeb3..50f2a1f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4743,9 +4743,9 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
-			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
+		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
+					 sizeof(struct lpfc_sli_ring),
+					 GFP_KERNEL);
 	if (!phba->sli.ring)
 		return -ENOMEM;
 
-- 
1.8.4.5

