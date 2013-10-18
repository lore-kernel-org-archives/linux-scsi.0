From: Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] drivers: scsi: lpfc_debugfs: Fix wrong assignment
Date: Fri, 18 Oct 2013 20:15:37 -0300
Message-ID: <1382138137-4088-1-git-send-email-felipensp@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On lpfc_debugfs_initialize function the dumpHostSlim member setup happens
when 'phba->sli_rev < LPFC_SLI_REV4' is true, however when it is false NULL
has been assigned to debug_dumpHBASlim instead of debug_dumpHostSlim.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 60084e6..b800cc9 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -4001,7 +4001,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				goto debug_failed;
 			}
 		} else
-			phba->debug_dumpHBASlim = NULL;
+			phba->debug_dumpHostSlim = NULL;

 		/* Setup dumpData */
 		snprintf(name, sizeof(name), "dumpData");
--
1.7.10.4
