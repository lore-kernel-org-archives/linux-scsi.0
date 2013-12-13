From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 02/32] target: Don't keep looping in report_luns if too big
Date: Fri, 13 Dec 2013 15:58:50 -0800
Message-ID: <1386979160-6928-3-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab3LMX72 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:28 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

All further loops will still fail the conditional so just bail right
away.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_spc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 021c3f4..8f52974 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1162,7 +1162,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		 */
 		lun_count++;
 		if ((offset + 8) > cmd->data_length)
-			continue;
+			break;
 
 		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
 		offset += 8;
-- 
1.7.1

