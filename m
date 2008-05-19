From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/3] qla2xxx: Correct handling of AENs postings for vports.
Date: Mon, 19 May 2008 14:25:40 -0700
Message-ID: <1211232341-44818-2-git-send-email-andrew.vasquez@qlogic.com>
References: <20080519212418.GH42403@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52429 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760231AbYESVZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 17:25:44 -0400
In-Reply-To: <20080519212418.GH42403@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

Initialize all proper structure members in order to support
work-list vport processing.  This code also properly acquires the
correct (physical hardware_lock) lock during work submission.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    1 +
 drivers/scsi/qla2xxx/qla_os.c  |   14 ++++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index fc55429..62a3ad6 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -406,6 +406,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	INIT_LIST_HEAD(&vha->list);
 	INIT_LIST_HEAD(&vha->fcports);
 	INIT_LIST_HEAD(&vha->vp_fcports);
+	INIT_LIST_HEAD(&vha->work_list);
 
 	vha->dpc_flags = 0L;
 	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 817f62f..48eaa3b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2157,13 +2157,14 @@ static int
 qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
 {
 	unsigned long flags;
+	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	if (!locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock_irqsave(&pha->hardware_lock, flags);
 	list_add_tail(&e->list, &ha->work_list);
 	qla2xxx_wake_dpc(ha);
 	if (!locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(&pha->hardware_lock, flags);
 	return QLA_SUCCESS;
 }
 
@@ -2203,12 +2204,13 @@ static void
 qla2x00_do_work(struct scsi_qla_host *ha)
 {
 	struct qla_work_evt *e;
+	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irq(&pha->hardware_lock);
 	while (!list_empty(&ha->work_list)) {
 		e = list_entry(ha->work_list.next, struct qla_work_evt, list);
 		list_del_init(&e->list);
-		spin_unlock_irq(&ha->hardware_lock);
+		spin_unlock_irq(&pha->hardware_lock);
 
 		switch (e->type) {
 		case QLA_EVT_AEN:
@@ -2222,9 +2224,9 @@ qla2x00_do_work(struct scsi_qla_host *ha)
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
-		spin_lock_irq(&ha->hardware_lock);
+		spin_lock_irq(&pha->hardware_lock);
 	}
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irq(&pha->hardware_lock);
 }
 
 /**************************************************************************
-- 
1.5.5.1.316.g377d9

