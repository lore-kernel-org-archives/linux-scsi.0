From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: fnic: Remove set but not used variable 'vdev'
Date: Fri, 25 Jan 2019 10:00:14 +0800
Message-ID: <20190125020014.11184-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/fnic/vnic_wq.c: In function 'vnic_wq_alloc_bufs':
drivers/scsi/fnic/vnic_wq.c:50:19: warning:
 variable 'vdev' set but not used [-Wunused-but-set-variable]

drivers/scsi/fnic/vnic_rq.c: In function 'vnic_rq_alloc_bufs':
drivers/scsi/fnic/vnic_rq.c:30:19: warning:
 variable 'vdev' set but not used [-Wunused-but-set-variable]

It never used since introduction

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/fnic/vnic_rq.c | 3 ---
 drivers/scsi/fnic/vnic_wq.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_rq.c b/drivers/scsi/fnic/vnic_rq.c
index 74d2f2c..6a35b1b 100644
--- a/drivers/scsi/fnic/vnic_rq.c
+++ b/drivers/scsi/fnic/vnic_rq.c
@@ -27,12 +27,9 @@
 static int vnic_rq_alloc_bufs(struct vnic_rq *rq)
 {
 	struct vnic_rq_buf *buf;
-	struct vnic_dev *vdev;
 	unsigned int i, j, count = rq->ring.desc_count;
 	unsigned int blks = VNIC_RQ_BUF_BLKS_NEEDED(count);
 
-	vdev = rq->vdev;
-
 	for (i = 0; i < blks; i++) {
 		rq->bufs[i] = kzalloc(VNIC_RQ_BUF_BLK_SZ, GFP_ATOMIC);
 		if (!rq->bufs[i]) {
diff --git a/drivers/scsi/fnic/vnic_wq.c b/drivers/scsi/fnic/vnic_wq.c
index 74cfc56..015af2c 100644
--- a/drivers/scsi/fnic/vnic_wq.c
+++ b/drivers/scsi/fnic/vnic_wq.c
@@ -47,12 +47,9 @@ int vnic_wq_alloc_ring(struct vnic_dev *vdev, struct vnic_wq *wq,
 static int vnic_wq_alloc_bufs(struct vnic_wq *wq)
 {
 	struct vnic_wq_buf *buf;
-	struct vnic_dev *vdev;
 	unsigned int i, j, count = wq->ring.desc_count;
 	unsigned int blks = VNIC_WQ_BUF_BLKS_NEEDED(count);
 
-	vdev = wq->vdev;
-
 	for (i = 0; i < blks; i++) {
 		wq->bufs[i] = kzalloc(VNIC_WQ_BUF_BLK_SZ, GFP_ATOMIC);
 		if (!wq->bufs[i]) {
-- 
2.7.0
