From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 04/10] scsi_transport_iscsi: Use flush_work in iscsi_remove_session
Date: Thu, 16 Mar 2017 08:54:39 +0530
Message-ID: <1489634685-4975-5-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:36745 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdCPD0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 23:26:01 -0400
Received: by mail-wr0-f180.google.com with SMTP id u108so23110829wrb.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 20:25:25 -0700 (PDT)
In-Reply-To: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
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
