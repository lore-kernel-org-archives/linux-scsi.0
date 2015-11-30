From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [RESEND] scsi: mvsas: fix misleading indentation
Date: Mon, 30 Nov 2015 14:32:17 +0000
Message-ID: <1448893937-5252-1-git-send-email-luisbg@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, JBottomley@odin.com, jthumshirn@suse.de, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Luis de Bethencourt <luisbg@osg.samsung.com>
List-Id: linux-scsi@vger.kernel.org

Fix a smatch warning:
drivers/scsi/mvsas/mv_sas.c:740 mvs_task_prep() warn: curly braces intended?

The code is correct, the indention is misleading. When the device is not
ready we want to return SAS_PHY_DOWN. But current indentation makes it
look like we only do so in the else branch of if (mvi_dev).

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---

Hi, 

This is a resend of a patch from October 19th [0]

Adding Andrew Morton to the CC list, as recommended at Korea Linux Forum.

Thanks,
Luis

[0] https://lkml.org/lkml/2015/10/19/775

 drivers/scsi/mvsas/mv_sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 9c78074..e712fe7 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -737,8 +737,8 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 			mv_dprintk("device %016llx not ready.\n",
 				SAS_ADDR(dev->sas_addr));
 
-			rc = SAS_PHY_DOWN;
-			return rc;
+		rc = SAS_PHY_DOWN;
+		return rc;
 	}
 	tei.port = dev->port->lldd_port;
 	if (tei.port && !tei.port->port_attached && !tmf) {
-- 
2.5.3
