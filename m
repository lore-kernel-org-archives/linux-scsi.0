From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/3] target: Generate failure for XCOPY I/O with non-zero scsi_status
Date: Thu, 24 Oct 2013 07:30:58 +0000
Message-ID: <1382599859-13204-3-git-send-email-nab@daterainc.com>
References: <1382599859-13204-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1382599859-13204-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing non-zero se_cmd->scsi_status check required
for local XCOPY I/O within target_xcopy_issue_pt_cmd() to signal an
exception case failure.

This will trigger the generation of SAM_STAT_CHECK_CONDITION status
from within target_xcopy_do_work() process context code.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 5edcd2b..0e41143f 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -679,7 +679,8 @@ static int target_xcopy_issue_pt_cmd(struct xcopy_pt_cmd *xpt_cmd)
 
 	pr_debug("target_xcopy_issue_pt_cmd(): SCSI status: 0x%02x\n",
 			se_cmd->scsi_status);
-	return 0;
+
+	return (se_cmd->scsi_status) ? -EINVAL : 0;
 }
 
 static int target_xcopy_read_source(
-- 
1.7.2.5
