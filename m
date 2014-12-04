From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 1/4] scsi_debug: Fixed missing "break;" in SDEBUG_UA_CAPACITY_CHANGED case
Date: Thu,  4 Dec 2014 11:49:25 -0500
Message-ID: <1417711768-24167-2-git-send-email-emilne@redhat.com>
References: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbaLDQtb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 11:49:31 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnVLx020599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:31 -0500
Received: from emilne.csb ([10.18.25.104])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnUgD011313
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:31 -0500
In-Reply-To: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This eliminates a superfluous log message when the capacity is changed:

  "check_readiness: unexpected unit attention code=3"

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aa4b6b8..397cc10 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -817,6 +817,7 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 					UA_CHANGED_ASC, CAPACITY_CHANGED_ASCQ);
 			if (debug)
 				cp = "capacity data changed";
+			break;
 		default:
 			pr_warn("%s: unexpected unit attention code=%d\n",
 				__func__, k);
-- 
1.7.11.7

