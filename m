From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 05/19] qla2xxx: No fcport FC-4 type assignment in GA_NXT response.
Date: Wed, 21 Nov 2012 02:40:30 -0500
Message-ID: <1353483644-17262-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:13988 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753169Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index f4e4bd7..c51929c 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -218,6 +218,9 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 		memcpy(fcport->port_name, ct_rsp->rsp.ga_nxt.port_name,
 		    WWN_SIZE);
 
+		fcport->fc4_type = (ct_rsp->rsp.ga_nxt.fc4_types[2] & BIT_0) ?
+		    FC4_TYPE_FCP_SCSI : FC4_TYPE_OTHER;
+
 		if (ct_rsp->rsp.ga_nxt.port_type != NS_N_PORT_TYPE &&
 		    ct_rsp->rsp.ga_nxt.port_type != NS_NL_PORT_TYPE)
 			fcport->d_id.b.domain = 0xf0;
-- 
1.7.7

