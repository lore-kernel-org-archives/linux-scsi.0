From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] qla2xxx: Add missing call to qlt_fc_port_deleted()
Date: Wed,  9 May 2012 10:51:01 -0700
Message-ID: <1336585861-23603-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:54329 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758476Ab2EIRvK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 13:51:10 -0400
Received: by dalf4 with SMTP id f4so687787dal.29
        for <linux-scsi@vger.kernel.org>; Wed, 09 May 2012 10:51:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Arun Easi <arun.easi@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

qla2x00_schedule_rport_del() calls fc_remote_port_delete(), which
starts a timer to tear down an rport structure.  We need a call to
qlt_fc_port_deleted() here.  Otherwise, if the FC transport timer
expires and tears down the rport, the initiator will be logged out and
the target code's notion of what sessions it has will get out of sync
with the rest of the driver and the firmware.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 11d41c7..a43ebce 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2879,8 +2879,10 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
 		spin_unlock_irqrestore(vha->host->host_lock, flags);
 		set_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		qla2xxx_wake_dpc(base_vha);
-	} else
+	} else {
 		fc_remote_port_delete(rport);
+		qlt_fc_port_deleted(vha, fcport);
+	}
 }
 
 /*
-- 
1.7.9.5

