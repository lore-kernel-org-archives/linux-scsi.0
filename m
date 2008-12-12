From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 6/12]: Updates for target_core_hba.c
Date: Fri, 12 Dec 2008 01:32:44 -0800
Message-ID: <1229074364.4153.648.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758959AbYLLJdB@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From c5c8768f89ab4d419bff6f49edb59e7346a7cec7 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 00:53:17 -0800
Subject: [PATCH] [Target_Core_Mod]: Updates for target_core_hba.c

This patch makes Core HBA code use TRANSPORT_MAX_GLOBAL_HBAS and
se_check_devices_access().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_hba.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/lio-core/target_core_hba.c b/drivers/lio-core/target_core_hba.c
index 1f99d3e..d2515aa 100644
--- a/drivers/lio-core/target_core_hba.c
+++ b/drivers/lio-core/target_core_hba.c
@@ -72,9 +72,9 @@ extern se_hba_t *core_get_hba_from_id (u32 hba_id, int addhba)
 {
 	se_hba_t *hba;
 	
-	if (hba_id > (ISCSI_MAX_GLOBAL_HBAS-1)) {
-		TRACE_ERROR("iSCSI HBA_ID: %u exceeds ISCSI_MAX_GLOBAL_HBAS-1: %u\n",
-			hba_id, ISCSI_MAX_GLOBAL_HBAS-1);
+	if (hba_id > (TRANSPORT_MAX_GLOBAL_HBAS-1)) {
+		TRACE_ERROR("iSCSI HBA_ID: %u exceeds TRANSPORT_MAX_GLOBAL_HBAS-1: %u\n",
+			hba_id, TRANSPORT_MAX_GLOBAL_HBAS-1);
 		return(NULL);
 	}
 
@@ -94,7 +94,7 @@ extern se_hba_t *core_get_next_free_hba (void)
 	u32 i;
 
 	spin_lock(&se_global->hba_lock);     
-	for (i = 0; i < ISCSI_MAX_GLOBAL_HBAS; i++) {
+	for (i = 0; i < TRANSPORT_MAX_GLOBAL_HBAS; i++) {
 		hba = &se_global->hba_list[i];
 		if (hba->hba_status != HBA_STATUS_FREE)
 			continue;
@@ -182,7 +182,7 @@ extern int se_core_del_hba (
 	 * Do not allow the se_hba_t to be released if references exist to
 	 * from se_device_t->se_lun_t.
 	 */
-	if (iscsi_check_devices_access(hba) < 0) {
+	if (se_check_devices_access(hba) < 0) {
 		TRACE_ERROR("CORE_HBA[%u] - **ERROR** - Unable to release HBA"
 			" with active LUNs\n", hba->hba_id);
 		return(-EINVAL);
@@ -232,14 +232,14 @@ extern void iscsi_disable_all_hbas (void)
 	se_hba_t *hba;
 
 	spin_lock(&se_global->hba_lock);
-	for (i = 0; i < ISCSI_MAX_GLOBAL_HBAS; i++) {
+	for (i = 0; i < TRANSPORT_MAX_GLOBAL_HBAS; i++) {
 		hba = &se_global->hba_list[i];
 
 		if (!(hba->hba_status & HBA_STATUS_ACTIVE))
 			continue;
 
 		spin_unlock(&se_global->hba_lock);
-		iscsi_disable_devices_for_hba(hba);
+		se_disable_devices_for_hba(hba);
 		spin_lock(&se_global->hba_lock);
 	}
 	spin_unlock(&se_global->hba_lock);
@@ -259,7 +259,7 @@ extern void iscsi_hba_del_all_hbas (void)
 	se_hba_t *hba;
 
 	spin_lock(&se_global->hba_lock);
-	for (i = 0; i < ISCSI_MAX_GLOBAL_HBAS; i++) {
+	for (i = 0; i < TRANSPORT_MAX_GLOBAL_HBAS; i++) {
 		hba = &se_global->hba_list[i];
 	
 		if (!(hba->hba_status & HBA_STATUS_ACTIVE))
-- 
1.5.4.1
