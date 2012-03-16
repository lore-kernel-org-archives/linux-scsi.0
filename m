From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] qla_target: Convert to qlini_mode='enabled' by default
Date: Fri, 16 Mar 2012 22:40:52 +0000
Message-ID: <1331937652-21243-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39832 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945935Ab2CPWuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2012 18:50:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: target-devel <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>, Joern Engel <joern@logfs.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch for lio-core/target-pending changes the qlini_mode
module parameter in qla_target.c to by default enable initiator mode
operation in qla2xxx.ko LLD.  This means that target mode cannot not
be enabled with tcm_qla2xxx.ko code unless qlini_mode='disabled' is
explictly set at modprobe qla2xxx time.

It also changes struct qla_tgt setup from qla2x00_probe_one() to now
be skipped in initiator mode, and will set the following bit at runtime
if necessary in qla_tgt_add_target():

+       if (!(base_vha->host->hostt->supported_mode & MODE_TARGET))
+               base_vha->host->hostt->supported_mode |= MODE_TARGET;
+

in order for tcm_qla2xxx_make_lport() -> qla_tgt_lport_register()
to pickup MODE_TARGET when walking qla_tgt_glist for a matching
entry during /sys/kernel/config/target/qla2xxx/$LPORT_WWPN/ ->
scsi_qla_host registration.

Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: James Bottomley <JBottomley@Parallels.com
Cc: Christoph Hellwig <hch@lst.de>
Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_os.c     |    2 +-
 drivers/scsi/qla2xxx/qla_target.c |   17 ++++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f6c86a9..9759682 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -263,7 +263,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla2x00_host_attrs,
 
-	.supported_mode		= MODE_INITIATOR | MODE_TARGET,
+	.supported_mode		= MODE_INITIATOR,
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 72b2fc4..cbbb627 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -43,15 +43,15 @@
 #include "qla_def.h"
 #include "qla_target.h"
 
-static char *qlini_mode = QLA2XXX_INI_MODE_STR_DISABLED;
+static char *qlini_mode = QLA2XXX_INI_MODE_STR_ENABLED;
 module_param(qlini_mode, charp, S_IRUGO);
 MODULE_PARM_DESC(qlini_mode,
 	"Determines when initiator mode will be enabled. Possible values: "
 	"\"exclusive\" - initiator mode will be enabled on load, "
 	"disabled on enabling target mode and then on disabling target mode "
 	"enabled back; "
-	"\"disabled\" (default) - initiator mode will never be enabled; "
-	"\"enabled\" - initiator mode will always stay enabled.");
+	"\"disabled\" - initiator mode will never be enabled; "
+	"\"enabled\" (default) - initiator mode will always stay enabled.");
 
 static int ql2x_ini_mode = QLA2XXX_INI_MODE_EXCLUSIVE;
 
@@ -4113,6 +4113,9 @@ int qla_tgt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 {
 	struct qla_tgt *tgt;
 
+	if (ql2x_ini_mode == QLA2XXX_INI_MODE_ENABLED)
+		return 0;
+
 	ql_dbg(ql_dbg_tgt, base_vha, 0xe036, "Registering target for host %ld(%p)",
 			base_vha->host_no, ha);
 
@@ -4124,6 +4127,9 @@ int qla_tgt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 		return -ENOMEM;
 	}
 
+	if (!(base_vha->host->hostt->supported_mode & MODE_TARGET))
+		base_vha->host->hostt->supported_mode |= MODE_TARGET;
+
 	tgt->ha = ha;
 	tgt->vha = base_vha;
 	init_waitqueue_head(&tgt->waitQ);
@@ -4160,11 +4166,8 @@ int qla_tgt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 /* Must be called under tgt_host_action_mutex */
 int qla_tgt_remove_target(struct qla_hw_data *ha, struct scsi_qla_host *vha)
 {
-	if (!ha->qla_tgt) {
-		printk(KERN_ERR "qla_target(%d): Can't remove "
-			"existing target", vha->vp_idx);
+	if (!ha->qla_tgt)
 		return 0;
-	}
 
 	mutex_lock(&qla_tgt_mutex);
 	list_del(&ha->qla_tgt->tgt_list_entry);
-- 
1.7.2.5

