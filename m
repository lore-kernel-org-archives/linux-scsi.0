From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/5] qla4xxx: Break the loop if the sendtargets list was empty
Date: Fri, 16 Dec 2011 01:58:57 -0800
Message-ID: <1324029539-26021-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:42373
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756127Ab1LPKNY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 05:13:24 -0500
In-Reply-To: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

JIRA Key: UPSISCSI-205

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 1221349..aa0fed8 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4242,6 +4242,9 @@ void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset)
 
 	wtime = jiffies + (HZ * tmo);
 	do {
+		if (list_empty(&list_st))
+			break;
+
 		qla4xxx_remove_failed_ddb(ha, &list_st);
 		schedule_timeout_uninterruptible(HZ / 10);
 	} while (time_after(wtime, jiffies));
-- 
1.7.1


