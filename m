From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  06/14] qla2xxx: Do not crash system for sp ref count zero
Date: Tue, 4 Aug 2015 13:37:56 -0400
Message-ID: <1438709884-623-7-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:24314 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768AbbHDSX6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:58 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Hiral Patel <hiral.patel@qlogic.com>

Aovid crashing the system in the scenario where firmware
just completes the command and it can not find the command
during abort mailbox processing. This scenario can lead to
sp reference counter being zero. Instead of crashing the
system, use WARN_ON to print warning in log file.

Signed-off-by: Hiral Patel <hiral.patel@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8a5cac8..070f2a1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -656,7 +656,7 @@ qla2x00_sp_compl(void *data, void *ptr, int res)
 		    "SP reference-count to ZERO -- sp=%p cmd=%p.\n",
 		    sp, GET_CMD_SP(sp));
 		if (ql2xextended_error_logging & ql_dbg_io)
-			BUG();
+			WARN_ON(atomic_read(&sp->ref_count) == 0);
 		return;
 	}
 	if (!atomic_dec_and_test(&sp->ref_count))
-- 
1.7.7

