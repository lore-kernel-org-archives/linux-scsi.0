From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/14] qla2xxx: Set correct cabling state during initialization.
Date: Mon, 29 Jan 2007 10:22:23 -0800
Message-ID: <1170094951389-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbXA2SWp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:45 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Previous work to add asynchronous-scsi-scanning support
(d19044c32baadeb80e135027124a9e845c6f057c) caused peculiar
semantic changes when no cabling was attached to the HBA
whereby unneeded and intrusive 'error-handling' would take
place due to the initial link state being unset.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cef24f3..5c9ce61 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -65,7 +65,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 	ha->flags.reset_active = 0;
 	atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&ha->loop_state, LOOP_DOWN);
-	ha->device_flags = 0;
+	ha->device_flags = DFLG_NO_CABLE;
 	ha->dpc_flags = 0;
 	ha->flags.management_server_logged_in = 0;
 	ha->marker_needed = 0;
-- 
1.5.0.rc2.gdbaa0

