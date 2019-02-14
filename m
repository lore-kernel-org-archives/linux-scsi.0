From: Zhiwei Jiang <qq282012236@gmail.com>
Subject: [PATCH] scsi: target: move spin_lock_bh to spin_lock in tasklet
Date: Thu, 14 Feb 2019 22:06:51 +0800
Message-ID: <20190214140651.65514-1-qq282012236@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qq282012236@gmail.com
Cc: mikecyr@linux.ibm.com, jejb@linux.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

as you are already in a tasklet, it is unnecessary to call
spin_lock_bh, because softirq already disable BH.

Signed-off-by: Zhiwei Jiang <qq282012236@gmail.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index cc9cae469c4b..29e7c51fcc4b 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3346,7 +3346,7 @@ static void ibmvscsis_handle_crq(unsigned long data)
 	bool ack = true;
 	volatile u8 valid;
 
-	spin_lock_bh(&vscsi->intr_lock);
+	spin_lock(&vscsi->intr_lock);
 
 	dev_dbg(&vscsi->dev, "got interrupt\n");
 
@@ -3360,7 +3360,7 @@ static void ibmvscsis_handle_crq(unsigned long data)
 
 		dev_dbg(&vscsi->dev, "handle_crq, don't process: flags 0x%x, state 0x%hx\n",
 			vscsi->flags, vscsi->state);
-		spin_unlock_bh(&vscsi->intr_lock);
+		spin_unlock(&vscsi->intr_lock);
 		return;
 	}
 
@@ -3437,7 +3437,7 @@ static void ibmvscsis_handle_crq(unsigned long data)
 		(int)list_empty(&vscsi->schedule_q), vscsi->flags,
 		vscsi->state);
 
-	spin_unlock_bh(&vscsi->intr_lock);
+	spin_unlock(&vscsi->intr_lock);
 }
 
 static int ibmvscsis_probe(struct vio_dev *vdev,
-- 
2.19.0
