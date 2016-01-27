From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2 10/11] qla2xxx: Set relogin flag when we fail to queue login requests.
Date: Wed, 27 Jan 2016 12:03:37 -0500
Message-ID: <1453914218-380-11-git-send-email-himanshu.madhani@qlogic.com>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:14139 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933876AbcA0Rqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 12:46:35 -0500
In-Reply-To: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If we fail to queue an srb for an async login we should set the
relogin flag so it will be retried as the reason for the queuing
failure was most likely transient.  Failure to do this can lead to
failed paths as login is never retried if the relogin flag is not
set.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8001c89..184b6b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -157,8 +157,12 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
 		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
 	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
+	if (rval != QLA_SUCCESS) {
+		fcport->flags &= ~FCF_ASYNC_SENT;
+		fcport->flags |= FCF_LOGIN_NEEDED;
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		goto done_free_sp;
+	}
 
 	ql_dbg(ql_dbg_disc, vha, 0x2072,
 	    "Async-login - hdl=%x, loopid=%x portid=%02x%02x%02x "
-- 
1.7.7

