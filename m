From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH 7/7] mvsas: use to_delayed_work
Date: Fri,  1 Jan 2016 22:59:12 +0800
Message-ID: <adad7d1f36f74a55626bc1590007089a44415993.1451659910.git.geliangtang@163.com>
References: <643e31066f3378b9521dd9cd8c569ccfcf185d61.1451659910.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <643e31066f3378b9521dd9cd8c569ccfcf185d61.1451659910.git.geliangtang@163.com>
In-Reply-To: <643e31066f3378b9521dd9cd8c569ccfcf185d61.1451659910.git.geliangtang@163.com>
References: <643e31066f3378b9521dd9cd8c569ccfcf185d61.1451659910.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: Geliang Tang <geliangtang@163.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use to_delayed_work() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/scsi/mvsas/mv_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index e712fe7..78bf557 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1887,7 +1887,7 @@ static void mvs_phy_disconnected(struct mvs_phy *phy)
 
 static void mvs_work_queue(struct work_struct *work)
 {
-	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(work);
 	struct mvs_wq *mwq = container_of(dw, struct mvs_wq, work_q);
 	struct mvs_info *mvi = mwq->mvi;
 	unsigned long flags;
-- 
2.5.0
