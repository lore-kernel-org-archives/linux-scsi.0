From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  12/14] qla2xxx: Fix missing device login retries.
Date: Tue, 4 Aug 2015 13:38:02 -0400
Message-ID: <1438709884-623-13-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:63082 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbbHDSXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:47 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

On certain conditions, login failures will just invoke
qla2x00_mark_device_lost() with the intend to do login again;
but if login_retry has been set already, that would fail to set the
relogin needed flag which is required to wakeup the DPC to retry.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 94d7a6d..aca6577 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3264,9 +3264,10 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 	if (!do_login)
 		return;
 
+	set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+
 	if (fcport->login_retry == 0) {
 		fcport->login_retry = vha->hw->login_retry_count;
-		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 
 		ql_dbg(ql_dbg_disc, vha, 0x2067,
 		    "Port login retry %8phN, id = 0x%04x retry cnt=%d.\n",
-- 
1.7.7

