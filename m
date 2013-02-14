From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] [SCSI] scsi_debug: Do not respond to INQUIRY commands with CHECK CONDITION when sense pending
Date: Thu, 14 Feb 2013 11:36:34 -0500
Message-ID: <1360859795-30448-2-git-send-email-emilne@redhat.com>
References: <1360859795-30448-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839Ab3BNQgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2013 11:36:38 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1EGactU006915
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2013 11:36:38 -0500
Received: from emilne.csb (dhcp-185-251.bos.redhat.com [10.16.185.251])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1EGabxZ000379
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2013 11:36:37 -0500
In-Reply-To: <1360859795-30448-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

According to SPC, INQUIRY commands are not supposed to respond
with a CHECK CONDITION due to a pending UNIT ATTENTION.  This
was causing failures when re-scanning a scsi_debug target.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8a6bf31..68f13be 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4060,7 +4060,7 @@ write:
 		errsts = check_condition_result;
 		break;
 	}
-	if (!errsts && devip->sense_pending) {
+	if (!errsts && devip->sense_pending && (*cmd != INQUIRY)) {
 		devip->sense_pending = 0;
 		errsts = check_condition_result;
 	}
-- 
1.7.11.7

