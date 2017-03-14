From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 4/9] scsi_transport_iscsi: Use flush_work in iscsi_remove_session
Date: Tue, 14 Mar 2017 13:31:29 +0530
Message-ID: <1489478494-5432-5-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489478494-5432-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37847 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750904AbdCNICI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2017 04:02:08 -0400
Received: by mail-wm0-f48.google.com with SMTP id n11so57108208wma.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 01:02:07 -0700 (PDT)
In-Reply-To: <1489478494-5432-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

scsi_flush_work flushes workqueue for the Scsi_Host.
In iSCSI offload enabled host, this would wait for all other
sessions under the host.

Use flush_work for the session being removed instead.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 568c9f2..a424eae 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2158,7 +2158,6 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 
 void iscsi_remove_session(struct iscsi_cls_session *session)
 {
-	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	unsigned long flags;
 	int err;
 
@@ -2185,7 +2184,7 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 
 	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
 	/* flush running scans then delete devices */
-	scsi_flush_work(shost);
+	flush_work(&session->scan_work);
 	__iscsi_unbind_session(&session->unbind_work);
 
 	/* hw iscsi may not have removed all connections from session */
-- 
2.7.4
