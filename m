From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 16/42] qla2xxx: Fix for continuous rescan attempts in arbitrated loop topology.
Date: Wed, 22 Aug 2012 14:21:10 -0400
Message-ID: <1345659696-3670-17-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:48005 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964983Ab2HVSiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:15 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Stale information in the temporary fcport created in
qla2x00_configure_local_loop() causes qla2x00_get_port_database() call
to fail. This reschedules scan, which gets stuck continuously in the
rescheduling-of-scan loop due to the failure.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 96fc04f..5fcc0b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2826,6 +2826,8 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		if (loop_id > LAST_LOCAL_LOOP_ID)
 			continue;
 
+		memset(new_fcport, 0, sizeof(fc_port_t));
+
 		/* Fill in member data. */
 		new_fcport->d_id.b.domain = domain;
 		new_fcport->d_id.b.area = area;
-- 
1.7.7

