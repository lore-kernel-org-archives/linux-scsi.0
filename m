From: madhu.iyengar@qlogic.com
Subject: [PATCH 04/10] qla2xxx: Return proper fabric name based on device state.
Date: Fri,  3 Sep 2010 15:20:51 -0700
Message-ID: <1283552457-4497-5-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39324 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753417Ab0ICW05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:57 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 114bc5a..a8689bf 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1676,14 +1676,14 @@ static void
 qla2x00_get_host_fabric_name(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *vha = shost_priv(shost);
-	u64 node_name;
+	uint8_t node_name[WWN_SIZE] = { 0xFF, 0xFF, 0xFF, 0xFF, \
+		0xFF, 0xFF, 0xFF, 0xFF};
+	u64 fabric_name = wwn_to_u64(node_name);
 
 	if (vha->device_flags & SWITCH_FOUND)
-		node_name = wwn_to_u64(vha->fabric_node_name);
-	else
-		node_name = wwn_to_u64(vha->node_name);
+		fabric_name = wwn_to_u64(vha->fabric_node_name);
 
-	fc_host_fabric_name(shost) = node_name;
+	fc_host_fabric_name(shost) = fabric_name;
 }
 
 static void
-- 
1.6.0.2

