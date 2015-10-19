From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] scsi: mvsas: fix misleading indentation
Date: Mon, 19 Oct 2015 21:36:40 +0100
Message-ID: <1445287000-1370-1-git-send-email-luisbg@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, hare@suse.de, tj@kernel.org, dan.j.williams@intel.com, Luis de Bethencourt <luisbg@osg.samsung.com>
List-Id: linux-scsi@vger.kernel.org

Fix a smatch warning:
drivers/scsi/mvsas/mv_sas.c:740 mvs_task_prep() warn: curly braces intended?

The code is correct, the indention is misleading. When the device is not
ready we want to return SAS_PHY_DOWN. But current indentation makes it
look like we only do so in the else branch of if (mvi_dev).

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hi,

The aim of this patch is to improve code readability, and at the same time
silence the smatch warning.

Thanks for the review,
Luis

 drivers/scsi/mvsas/mv_sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 454536c..b1c5dec 100644
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
2.5.1
