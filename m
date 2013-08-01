From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v4 07/10] scsi: Clear expecting_cc_ua on successful commands
Date: Thu,  1 Aug 2013 16:57:36 -0400
Message-ID: <1375390659-12495-8-git-send-email-emilne@redhat.com>
References: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3HAU5q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 16:57:46 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r71KvkUw005110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:46 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvgvg031004
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:46 -0400
In-Reply-To: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

If a device does not report a unit attention as expected,
clear the expecting_cc_ua flag so that we will not suppress
a future unit attention condition that is *not* expected.
INQUIRY and REPORT LUNS commands should not do this, however,
because they do not report pending unit attention conditions.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_error.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d0f71e5..96707a6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1540,6 +1540,13 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 */
 		return ADD_TO_MLQUEUE;
 	case GOOD:
+		/*
+		 * Reset expecting_cc_ua for all commands except INQUIRY and
+		 * REPORT LUNS, because if we didn't get a UA on this command
+		 * as expected, then we don't want to suppress a subsequent one.
+		 */
+		if (scmd->cmnd[0] != INQUIRY && scmd->cmnd[0] != REPORT_LUNS)
+			scmd->device->expecting_cc_ua = 0;
 		scsi_handle_queue_ramp_up(scmd->device);
 	case COMMAND_TERMINATED:
 		return SUCCESS;
-- 
1.7.11.7

