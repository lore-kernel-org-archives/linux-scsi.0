From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/3] lpfc: fix misleading indentation
Date: Mon, 14 Mar 2016 15:29:44 +0100
Message-ID: <1457965789-3373916-3-git-send-email-arnd@arndb.de>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:61907 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864AbcCNOap (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 10:30:45 -0400
In-Reply-To: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Sebastian Herbszt <herbszt@gmx.de>

gcc-6 complains about the indentation of the lpfc_destroy_vport_work_array()
call in lpfc_online(), which clearly doesn't look right:

drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_online':
drivers/scsi/lpfc/lpfc_init.c:2880:3: warning: statement is indented as if it were guarded by... [-Wmisleading-indentation]
   lpfc_destroy_vport_work_array(phba, vports);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/lpfc/lpfc_init.c:2863:2: note: ...this 'if' clause, but it is not
  if (vports != NULL)
  ^~

Looking at the patch that introduced this code, it's clear that the
behavior is correct and the indentation is wrong.

This fixes the indentation and adds curly braces around the previous
if() block for clarity, as that is most likely what caused the code
to be misindented in the first place.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 549e55cd2a1b ("[SCSI] lpfc 8.2.2 : Fix locking around HBA's port_list")
---
 drivers/scsi/lpfc/lpfc_init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a544366a367e..f57d02c3b6cf 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2860,7 +2860,7 @@ lpfc_online(struct lpfc_hba *phba)
 	}
 
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
+	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			struct Scsi_Host *shost;
 			shost = lpfc_shost_from_vport(vports[i]);
@@ -2877,7 +2877,8 @@ lpfc_online(struct lpfc_hba *phba)
 			}
 			spin_unlock_irq(shost->host_lock);
 		}
-		lpfc_destroy_vport_work_array(phba, vports);
+	}
+	lpfc_destroy_vport_work_array(phba, vports);
 
 	lpfc_unblock_mgmt_io(phba);
 	return 0;
-- 
2.7.0

