From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 12/14] qla2xxx: Correct fc_host port_state display.
Date: Fri, 18 Nov 2011 09:02:20 -0800
Message-ID: <1321635742-16426-13-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:44426
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758119Ab1KRRP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:57 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Add more fine grain parsing of vha->loop_state to export a more accurate
fc_host port_state.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ac326c4..7acd442 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1762,12 +1762,31 @@ qla2x00_get_host_port_state(struct Scsi_Host *shost)
 	scsi_qla_host_t *vha = shost_priv(shost);
 	struct scsi_qla_host *base_vha = pci_get_drvdata(vha->hw->pdev);
 
-	if (!base_vha->flags.online)
+	if (!base_vha->flags.online) {
 		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
-	else if (atomic_read(&base_vha->loop_state) == LOOP_TIMEOUT)
-		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
-	else
+		return;
+	}
+
+        switch (atomic_read(&base_vha->loop_state)) {
+        case LOOP_UPDATE:
+		fc_host_port_state(shost) = FC_PORTSTATE_DIAGNOSTICS;
+		break;
+        case LOOP_DOWN:
+		if(test_bit(LOOP_RESYNC_NEEDED, &base_vha->dpc_flags))
+			fc_host_port_state(shost) = FC_PORTSTATE_DIAGNOSTICS;
+		else
+			fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
+		break;
+        case LOOP_DEAD:
+		fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
+		break;
+        case LOOP_READY:
 		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+		break;
+        default:
+		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
+		break;
+	}
 }
 
 static int
-- 
1.6.0.2


