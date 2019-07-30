From: Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] scsi: 3w-sas: Fix unterminated strncpy
Date: Tue, 30 Jul 2019 16:40:47 +0800
Message-ID: <20190730084047.26482-1-hslester96@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Adam Radford <aradford@gmail.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
List-Id: linux-scsi@vger.kernel.org

strncpy(dest, src, strlen(src)) leads to unterminated
dest, which is dangerous.
Here driver_version's len is 32 and TW_DRIVER_VERSION
is shorter than 32.
Therefore strcpy is OK.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/scsi/3w-sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index dda6fa857709..96f529c613a6 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1328,7 +1328,7 @@ static int twl_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 		}
 
 		/* Load rest of compatibility struct */
-		strncpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION, strlen(TW_DRIVER_VERSION));
+		strcpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION);
 		tw_dev->tw_compat_info.driver_srl_high = TW_CURRENT_DRIVER_SRL;
 		tw_dev->tw_compat_info.driver_branch_high = TW_CURRENT_DRIVER_BRANCH;
 		tw_dev->tw_compat_info.driver_build_high = TW_CURRENT_DRIVER_BUILD;
-- 
2.20.1
