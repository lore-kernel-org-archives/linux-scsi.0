From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: megaraid: Fix possible null-pointer dereferences in megasas_complete_cmd()
Date: Mon, 29 Jul 2019 10:54:45 +0800
Message-ID: <20190729025445.18312-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

In megasas_complete_cmd(), there is an if statement on line 3411 to
check whether cmd->scmd is NULL:
    if (cmd->scmd)

When cmd->scmd is NULL, it is used at some places, such as on line 3286:
    cmd->scmd->result = alt_status << 16;
on line 3295:
    cmd->scmd->scsi_done(cmd->scmd);
on line 3343:
    cmd->scmd->scsi_done(cmd->scmd);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, cmd->scmd is checked before being used.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b2339d04a700..181c4d9cd707 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3440,6 +3440,9 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	case MFI_CMD_LD_READ:
 	case MFI_CMD_LD_WRITE:
 
+		if (!cmd->scmd)
+			break;
+
 		if (alt_status) {
 			cmd->scmd->result = alt_status << 16;
 			exception = 1;
-- 
2.17.0
