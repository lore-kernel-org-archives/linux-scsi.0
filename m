From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/MIB 10/12]: Update SCSI MIBs
Date: Fri, 12 Dec 2008 01:35:34 -0800
Message-ID: <1229074534.4153.659.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:39859 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759078AbYLLJfh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:35:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

>From 11596ef31b485e778260d1f3e2e455add22ab11a Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 01:00:54 -0800
Subject: [PATCH] [Target_Core_Mod/MIB]: Update SCSI MIBs

This patch updates SCSI MIB (RFC 4455) for Target_Core_Mod to use
struct target_core_fabric_ops (using TPG_TFO macro).

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_mib.c |   51 ++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/lio-core/target_core_mib.c b/drivers/lio-core/target_core_mib.c
index ff82f93..8b31a03 100644
--- a/drivers/lio-core/target_core_mib.c
+++ b/drivers/lio-core/target_core_mib.c
@@ -39,15 +39,10 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
-#include "iscsi_protocol.h"
-#include <iscsi_debug_opcodes.h>
-#include "iscsi_target_core.h"
 #include <target_core_base.h>
 #include <iscsi_target_error.h>
-#include "iscsi_target_device.h"
 #include "target_core_hba.h"
 #include "target_core_transport.h"
-#include "iscsi_target_util.h"
 
 #include "target_core_mib.h"
 
@@ -94,7 +89,7 @@ static int scsi_inst_seq_show(struct seq_file *seq, void *v)
 	seq_puts(seq, "inst sw_indx\n");
 
 	spin_lock(&se_global->hba_lock);
-	for (i = 0; i < ISCSI_MAX_GLOBAL_HBAS; i++) {
+	for (i = 0; i < TRANSPORT_MAX_GLOBAL_HBAS; i++) {
 		hba = &se_global->hba_list[i];
 
 		if (!(hba->hba_status & HBA_STATUS_ACTIVE))
@@ -105,7 +100,7 @@ static int scsi_inst_seq_show(struct seq_file *seq, void *v)
 
 		seq_printf(seq, "%u %u\n", hba->hba_index, SCSI_INST_SW_INDEX);
 		seq_printf(seq, "plugin: %s version: %s\n", hba->transport->name,
-				PYX_ISCSI_VERSION);
+				TARGET_CORE_VERSION);
 	}
 	spin_unlock(&se_global->hba_lock);
 
@@ -147,7 +142,7 @@ static void *locate_hba_start(
 	seq->private = (void *)tpg_iter;
 
 	spin_lock(&se_global->hba_lock);
-	for (i = 0; i < ISCSI_MAX_GLOBAL_HBAS; i++) {
+	for (i = 0; i < TRANSPORT_MAX_GLOBAL_HBAS; i++) {
 		hba = &se_global->hba_list[i];
 
 		if (!(hba->hba_status & HBA_STATUS_ACTIVE))
@@ -204,7 +199,7 @@ static void *locate_hba_next(
 	atomic_dec(&hba->dev_mib_access_count);
 	iterp->ti_ptr = NULL;
 
-	for (i = (iterp->ti_offset + 1); i < ISCSI_MAX_GLOBAL_HBAS; i++) {
+	for (i = (iterp->ti_offset + 1); i < TRANSPORT_MAX_GLOBAL_HBAS; i++) {
 		hba = &se_global->hba_list[i];
 
 		if (!(hba->hba_status & HBA_STATUS_ACTIVE))
@@ -431,7 +426,9 @@ static int scsi_transport_seq_show(struct seq_file *seq, void *v)
 	se_device_t *dev;
 	table_iter_t *iterp = (table_iter_t *)seq->private;
 	se_port_t *se, *se_tmp;
+	se_portal_group_t *tpg;
 	t10_wwn_t *wwn;
+	char buf[64];
 
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "inst device indx dev_name\n");
@@ -447,11 +444,15 @@ static int scsi_transport_seq_show(struct seq_file *seq, void *v)
 
 		spin_lock(&dev->se_port_lock);
 		list_for_each_entry_safe(se, se_tmp, &dev->dev_sep_list, sep_list) {
+			tpg = se->sep_tpg;
+			sprintf(buf, "scsiTransport%s",
+					TPG_TFO(tpg)->get_fabric_name());
+
 			seq_printf(seq, "%u %s %u %s+%s\n",
 				hba->hba_index, /* scsiTransportIndex */
-				"scsiTransportISCSI",  /* scsiTransportType */
-				se->sep_tpg->tpg_tiqn->tiqn_index, /* scsiTransportPointer */
-				se->sep_tpg->tpg_tiqn->tiqn,
+				buf,  /* scsiTransportType */
+				TPG_TFO(tpg)->tpg_get_inst_index(tpg),
+				TPG_TFO(tpg)->tpg_get_wwn(tpg),
 				(strlen(wwn->unit_serial)) ?
 				wwn->unit_serial : wwn->vendor);	 /* scsiTransportDevName */
 		}
@@ -524,19 +525,19 @@ static int scsi_tgt_dev_seq_show(struct seq_file *seq, void *v)
 	spin_lock(&hba->device_lock);
 	if ((dev = (se_device_t *)iterp->ti_ptr)) {
 		switch (dev->dev_status) {
-		case ISCSI_DEVICE_ACTIVATED:
+		case TRANSPORT_DEVICE_ACTIVATED:
 			strcpy(status, "activated");
 			break;
-		case ISCSI_DEVICE_DEACTIVATED:
+		case TRANSPORT_DEVICE_DEACTIVATED:
 			strcpy(status, "deactivated");
 			non_accessible_lus = 1;
 			break;
-		case ISCSI_DEVICE_SHUTDOWN:
+		case TRANSPORT_DEVICE_SHUTDOWN:
 			strcpy(status, "shutdown");
 			non_accessible_lus = 1;
 			break;
-		case ISCSI_DEVICE_OFFLINE_ACTIVATED:
-		case ISCSI_DEVICE_OFFLINE_DEACTIVATED:
+		case TRANSPORT_DEVICE_OFFLINE_ACTIVATED:
+		case TRANSPORT_DEVICE_OFFLINE_DEACTIVATED:
 			strcpy(status, "offline");
 			non_accessible_lus = 1;
 			break;
@@ -600,9 +601,11 @@ static int scsi_tgt_port_seq_show(struct seq_file *seq, void *v)
 	se_hba_t *hba;
 	se_device_t *dev;
 	se_port_t *sep, *sep_tmp;
+	se_portal_group_t *tpg;
 	table_iter_t *iterp = (table_iter_t *)seq->private;
 	u32 rx_mbytes, tx_mbytes;
 	unsigned long long num_cmds;
+	char buf[64];
 
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "inst device indx name port_index in_cmds write_mbytes"
@@ -617,12 +620,16 @@ static int scsi_tgt_port_seq_show(struct seq_file *seq, void *v)
 	if ((dev = (se_device_t *)iterp->ti_ptr)) {
 		spin_lock(&dev->se_port_lock);
 		list_for_each_entry_safe(sep, sep_tmp, &dev->dev_sep_list, sep_list) {
+			tpg = sep->sep_tpg;
+			sprintf(buf, "%sPort#", TPG_TFO(tpg)->get_fabric_name());
+
 			seq_printf(seq, "%u %u %u %s%d %s%s%d ", 
 			     hba->hba_index,
 			     dev->dev_index,
 			     sep->sep_index,
-			     "iSCSIPort#", sep->sep_index, 
-			     sep->sep_tpg->tpg_tiqn->tiqn, "+t+", sep->sep_tpg->tpgt);
+			     buf, sep->sep_index, 
+			     TPG_TFO(tpg)->tpg_get_wwn(tpg), "+t+",
+			     TPG_TFO(tpg)->tpg_get_tag(tpg));
 
 			spin_lock(&sep->sep_lun->lun_sep_lock);
 			num_cmds = sep->sep_stats.cmd_pdus;
@@ -841,7 +848,7 @@ static int scsi_lu_seq_show(struct seq_file *seq, void *v)
                                 dev->dev_index, SCSI_LU_INDEX,
 				(unsigned long long)0, /* scsiLuDefaultLun */
 				(strlen(dev->t10_wwn.unit_serial)) ?
-				(char *)&dev->t10_wwn.unit_serial[0] : NONE); /* scsiLuWwnName */
+				(char *)&dev->t10_wwn.unit_serial[0] : "None"); /* scsiLuWwnName */
 
 		memcpy(&str[0], (void *)&dev->t10_wwn, 28);
 
@@ -868,7 +875,7 @@ static int scsi_lu_seq_show(struct seq_file *seq, void *v)
 
 		seq_printf(seq," %u %s %s %llu %u %u %u %u %u %u\n",
 			   dev->dev_obj_api->get_device_type((void *)dev), /* scsiLuPeripheralType */
-			   (dev->dev_status == ISCSI_DEVICE_ACTIVATED)?
+			   (dev->dev_status == TRANSPORT_DEVICE_ACTIVATED)?
 			   	"available":"notavailable", /* scsiLuStatus */
 			   "exposed", 	/* scsiLuState */
 			   (unsigned long long)dev->num_cmds,
@@ -1053,7 +1060,7 @@ u32 scsi_get_new_index(scsi_index_t type)
 {
 	u32 new_index;
 
-	if ((type < 0) || (type >= INDEX_TYPE_MAX)) {
+	if ((type < 0) || (type >= SCSI_INDEX_TYPE_MAX)) {
 		printk("Invalid index type %d\n", type);
 		return(-1);
 	}
-- 
1.5.4.1



