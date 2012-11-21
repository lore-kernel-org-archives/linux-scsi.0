From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 2/5] qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.
Date: Wed, 21 Nov 2012 02:39:54 -0500
Message-ID: <1353483597-17206-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483597-17206-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:63123 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753312Ab2KUH6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:07 -0500
In-Reply-To: <1353483597-17206-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: David Jeffery <djeffery@redhat.com>

When the qla2xxx driver loses access to multiple, remote ports, there is a race
condition which can occur which will keep the request stuck on a scsi request
queue indefinitely.

This bad state occurred do to a race condition with how the FCPORT_UPDATE_NEEDED
bit is set in qla2x00_schedule_rport_del(), and how it is cleared in
qla2x00_do_dpc().  The problem port has its drport pointer set, but it has never
been processed by the driver to inform the fc transport that the port has been
lost.  qla2x00_schedule_rport_del() sets drport, and then sets the
FCPORT_UPDATE_NEEDED bit.  In qla2x00_do_dpc(), the port lists are walked and
any drport pointer is handled and the fc transport informed of the port loss,
then the FCPORT_UPDATE_NEEDED bit is cleared.  This leaves a race where the
dpc thread is processing one port removal, another port removal is marked
with a call to qla2x00_schedule_rport_del(), and the dpc thread clears the
bit for both removals, even though only the first removal was actually
handled.  Until another event occurs to set FCPORT_UPDATE_NEEDED, the later
port removal is never finished and qla2xxx stays in a bad state which causes
requests to become stuck on request queues.

This patch updates the driver to test and clear FCPORT_UPDATE_NEEDED
atomically.  This ensures the port state changes are processed and not lost.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d501bf5..a603967 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4505,9 +4505,9 @@ qla2x00_do_dpc(void *data)
 			    "ISP abort end.\n");
 		}
 
-		if (test_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags)) {
+		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED,
+		    &base_vha->dpc_flags)) {
 			qla2x00_update_fcports(base_vha);
-			clear_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		}
 
 		if (test_bit(SCR_PENDING, &base_vha->dpc_flags)) {
-- 
1.7.7

