From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] scsi: fix potential NULL pointer dereference.
Date: Tue, 25 Mar 2014 13:58:53 +0100
Message-ID: <1395752333-12185-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaCYM7L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2014 08:59:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, m.lombardi85@gmail.com

The scsi_get_command() function returns NULL if
it fails to allocate the scsi_cmnd structure.
If this happens, a NULL pointer will be dereferenced.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/scsi_error.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 78b004d..4021849 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2289,6 +2289,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 		return FAILED;
 
 	scmd = scsi_get_command(dev, GFP_KERNEL);
+	if (!scmd)
+		return FAILED;
+
 	blk_rq_init(NULL, &req);
 	scmd->request = &req;
 
-- 
Maurizio Lombardi

