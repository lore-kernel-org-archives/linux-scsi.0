From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
Date: Mon, 19 Dec 2011 13:05:46 +0100
Message-ID: <1324296346-17876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab1LSMFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 07:05:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

scsi_dh_attach() should return a standard error number on error.

Reported-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index e3f2db2..dfc2334 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -74,7 +74,7 @@ static inline int scsi_dh_handler_exist(const char *name)
 }
 static inline int scsi_dh_attach(struct request_queue *req, const char *name)
 {
-	return SCSI_DH_NOSYS;
+	return -EINVAL;
 }
 static inline void scsi_dh_detach(struct request_queue *q)
 {
@@ -82,6 +82,6 @@ static inline void scsi_dh_detach(struct request_queue *q)
 }
 static inline int scsi_dh_set_params(struct request_queue *req, const char *params)
 {
-	return -SCSI_DH_NOSYS;
+	return -EINVAL;
 }
 #endif
