From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v2] [SCSI] scsi_debug: Do not respond to certain commands with CHECK CONDITION when sense pending
Date: Fri, 15 Feb 2013 12:52:31 -0500
Message-ID: <1360950751-5136-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab3BORwd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 12:52:33 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1FHqXhQ020586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Feb 2013 12:52:33 -0500
Received: from emilne.csb (dhcp-185-251.bos.redhat.com [10.16.185.251])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1FHqWlQ025010
	for <linux-scsi@vger.kernel.org>; Fri, 15 Feb 2013 12:52:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

According to SPC, certain commands are not supposed to respond
with a CHECK CONDITION due to a pending UNIT ATTENTION.  This
was causing failures when re-scanning a scsi_debug target.  The
commands in this category are INQUIRY and REPORT LUNS.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8a6bf31..48fd5a7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4060,7 +4060,8 @@ write:
 		errsts = check_condition_result;
 		break;
 	}
-	if (!errsts && devip->sense_pending) {
+	if (!errsts && devip->sense_pending && (*cmd != INQUIRY) &&
+	    (*cmd != REPORT_LUNS)) {
 		devip->sense_pending = 0;
 		errsts = check_condition_result;
 	}
-- 
1.7.11.7

