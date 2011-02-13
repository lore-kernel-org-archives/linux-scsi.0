From: Fubo Chen <fubo.chen@gmail.com>
Subject: target: Check LUN numbers
Date: Sun, 13 Feb 2011 09:24:37 +0100
Message-ID: <AANLkTimQktk0e2dLiHB=YQNC1tUS1HYgnD3MF76it2Sq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53998 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1BMIYi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2011 03:24:38 -0500
Received: by iwn9 with SMTP id 9so3815764iwn.19
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2011 00:24:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>

Check LUN before reading from device_list[] array.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
---
 drivers/target/target_core_device.c |   13 +++++++++++++
 1 file changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_device.c
b/drivers/target/target_core_device.c
index 27d4858..ba16ad9 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -67,6 +67,13 @@ int transport_get_lun_for_cmd(

 	BUG_ON(!se_sess);
 	BUG_ON(!SE_NODE_ACL(se_sess));
+
+	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
+		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
+		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		return -EINVAL;
+	}
+
 	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 	deve = se_cmd->se_deve =
 			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
@@ -186,6 +193,12 @@ int transport_get_lun_for_tmr(
 	struct se_session *se_sess = SE_SESS(se_cmd);
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;

+	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
+		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
+		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		return -EINVAL;
+	}
+
 	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 	deve = se_cmd->se_deve =
 			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
-- 
1.7.1
