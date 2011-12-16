From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/5] qla4xxx: Fixed BFS with sendtargets as boot index.
Date: Fri, 16 Dec 2011 01:58:58 -0800
Message-ID: <1324029539-26021-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:35485
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291Ab1LPKNF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 05:13:05 -0500
In-Reply-To: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

If ql4xdisablesysfsboot = 0 and sendtargets entry as boot index then
driver does export sendtarget entries in sysfs but iscsistart does not
do discovery. So in this case let driver do the discovery and
login to the targets.

JIRA Key: UPSISCSI-196

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index aa0fed8..6f9b84d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3980,9 +3980,6 @@ static void qla4xxx_build_st_list(struct scsi_qla_host *ha,
 		if (ret == QLA_ERROR)
 			break;
 
-		if (qla4xxx_verify_boot_idx(ha, idx) != QLA_SUCCESS)
-			goto continue_next_st;
-
 		/* Check if ST, add to the list_st */
 		if (strlen((char *) fw_ddb_entry->iscsi_name) != 0)
 			goto continue_next_st;
-- 
1.7.1


