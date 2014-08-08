From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 3/5] be2iscsi: Fix updating the boot enteries in sysfs
Date: Fri,  8 Aug 2014 01:00:00 -0400
Message-ID: <1407474003-26220-3-git-send-email-jkallickal@emulex.com>
References: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38602 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaHHFAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 01:00:18 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so6553978pad.22
        for <linux-scsi@vger.kernel.org>; Thu, 07 Aug 2014 22:00:17 -0700 (PDT)
In-Reply-To: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 During port async event driver should check if there is any boot target
 configured on the adapter. Update sysfs enteries with the boot target
 parameters.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 38 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/be2iscsi/be_cmds.h |  8 ++++++++
 drivers/scsi/be2iscsi/be_main.c | 17 +++++++++++++++++
 drivers/scsi/be2iscsi/be_main.h |  1 +
 4 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index ea4477f..80d97f3 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -275,6 +275,19 @@ bool is_link_state_evt(u32 trailer)
 		  ASYNC_EVENT_CODE_LINK_STATE);
 }
 
+static bool is_iscsi_evt(u32 trailer)
+{
+	return ((trailer >> ASYNC_TRAILER_EVENT_CODE_SHIFT) &
+		  ASYNC_TRAILER_EVENT_CODE_MASK) ==
+		  ASYNC_EVENT_CODE_ISCSI;
+}
+
+static int iscsi_evt_type(u32 trailer)
+{
+	return (trailer >> ASYNC_TRAILER_EVENT_TYPE_SHIFT) &
+		 ASYNC_TRAILER_EVENT_TYPE_MASK;
+}
+
 static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
 {
 	if (compl->flags != 0) {
@@ -438,7 +451,7 @@ void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 	} else if ((evt->port_link_status & ASYNC_EVENT_LINK_UP) ||
 		    ((evt->port_link_status & ASYNC_EVENT_LOGICAL) &&
 		     (evt->port_fault == BEISCSI_PHY_LINK_FAULT_NONE))) {
-		phba->state = BE_ADAPTER_LINK_UP;
+		phba->state = BE_ADAPTER_LINK_UP | BE_ADAPTER_CHECK_BOOT;
 
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
@@ -461,7 +474,28 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
 				/* Interpret compl as a async link evt */
 				beiscsi_async_link_state_process(phba,
 				   (struct be_async_event_link_state *) compl);
-			else
+			else if (is_iscsi_evt(compl->flags)) {
+				switch (iscsi_evt_type(compl->flags)) {
+				case ASYNC_EVENT_NEW_ISCSI_TGT_DISC:
+				case ASYNC_EVENT_NEW_ISCSI_CONN:
+				case ASYNC_EVENT_NEW_TCP_CONN:
+					phba->state |= BE_ADAPTER_CHECK_BOOT;
+					beiscsi_log(phba, KERN_ERR,
+						    BEISCSI_LOG_CONFIG |
+						    BEISCSI_LOG_MBOX,
+						    "BC_%d : Async iscsi Event,"
+						    " flags handled = 0x%08x\n",
+						    compl->flags);
+					break;
+				default:
+					beiscsi_log(phba, KERN_ERR,
+						    BEISCSI_LOG_CONFIG |
+						    BEISCSI_LOG_MBOX,
+						    "BC_%d : Unsupported Async"
+						    " Event, flags = 0x%08x\n",
+						    compl->flags);
+				}
+			} else
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_CONFIG |
 					    BEISCSI_LOG_MBOX,
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index ccda0b6..9889743 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -118,6 +118,14 @@ struct be_mcc_compl {
 #define ASYNC_TRAILER_EVENT_CODE_SHIFT	8	/* bits 8 - 15 */
 #define ASYNC_TRAILER_EVENT_CODE_MASK	0xFF
 #define ASYNC_EVENT_CODE_LINK_STATE	0x1
+#define ASYNC_EVENT_CODE_ISCSI		0x4
+
+#define ASYNC_TRAILER_EVENT_TYPE_SHIFT	16	/* bits 16 - 23 */
+#define ASYNC_TRAILER_EVENT_TYPE_MASK	0xF
+#define ASYNC_EVENT_NEW_ISCSI_TGT_DISC	0x4
+#define ASYNC_EVENT_NEW_ISCSI_CONN	0x5
+#define ASYNC_EVENT_NEW_TCP_CONN	0x7
+
 struct be_async_event_trailer {
 	u32 code;
 };
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d6465ed..8f9f625 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4379,6 +4379,10 @@ static int beiscsi_setup_boot_info(struct beiscsi_hba *phba)
 {
 	struct iscsi_boot_kobj *boot_kobj;
 
+	/* it has been created previously */
+	if (phba->boot_kset)
+		return 0;
+
 	/* get boot info using mgmt cmd */
 	if (beiscsi_get_boot_info(phba))
 		/* Try to see if we can carry on without this */
@@ -5337,6 +5341,14 @@ static void be_eqd_update(struct beiscsi_hba *phba)
 	}
 }
 
+static void be_check_boot_session(struct beiscsi_hba *phba)
+{
+	if (beiscsi_setup_boot_info(phba))
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : Could not set up "
+			    "iSCSI boot info on async event.\n");
+}
+
 /*
  * beiscsi_hw_health_check()- Check adapter health
  * @work: work item to check HW health
@@ -5352,6 +5364,11 @@ beiscsi_hw_health_check(struct work_struct *work)
 
 	be_eqd_update(phba);
 
+	if (phba->state & BE_ADAPTER_CHECK_BOOT) {
+		phba->state &= ~BE_ADAPTER_CHECK_BOOT;
+		be_check_boot_session(phba);
+	}
+
 	beiscsi_ue_detect(phba);
 
 	schedule_delayed_work(&phba->beiscsi_hw_check_task,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 0ca9d2d..1e3428a 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -104,6 +104,7 @@
 #define BE_ADAPTER_LINK_DOWN	0x002
 #define BE_ADAPTER_PCI_ERR	0x004
 #define BE_ADAPTER_STATE_SHUTDOWN	0x008
+#define BE_ADAPTER_CHECK_BOOT	0x010
 
 
 #define BEISCSI_CLEAN_UNLOAD	0x01
-- 
1.8.5.3

