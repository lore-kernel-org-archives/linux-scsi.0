From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-scsi-for-next] tcm_qla2xxx: Set correct protection flags when DIF/DIX is enabled
Date: Fri, 23 May 2014 02:04:23 +0000
Message-ID: <1400810663-24731-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

With the advent of per session protection flags in v3.15-rc1 code,
a target fabric driver supporting T10 PI needs to declare it's own
protection capabilities at transport_init_session() time.

This patch updates tcm_qla2xxx_check_initiator_node_acl() to extract
the T10 PI capabilities using scsi_qla_host_t->flags.difdix_supported,
and sets TARGET_PROT_ALL (all forms of PASS + INSERT + STRIP operations
supported by HW fabric offloads) when available.

Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 896cb23..8c10438 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1501,7 +1501,8 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	struct qla_tgt_sess *sess = qla_tgt_sess;
 	unsigned char port_name[36];
 	unsigned long flags;
-
+	int prot_flags = (vha->flags.difdix_supported) ? TARGET_PROT_ALL :
+							 TARGET_PROT_NORMAL;
 	lport = vha->vha_tgt.target_lport_ptr;
 	if (!lport) {
 		pr_err("Unable to locate struct tcm_qla2xxx_lport\n");
@@ -1518,7 +1519,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	}
 	se_tpg = &tpg->se_tpg;
 
-	se_sess = transport_init_session(TARGET_PROT_NORMAL);
+	se_sess = transport_init_session(prot_flags);
 	if (IS_ERR(se_sess)) {
 		pr_err("Unable to initialize struct se_session\n");
 		return PTR_ERR(se_sess);
-- 
1.7.10.4
