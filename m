From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] imm: check parport_claim
Date: Wed, 24 Feb 2016 16:27:11 +0530
Message-ID: <1456311431-18521-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

parport_claim() can fail and we should be checking if we were able to
claim the port.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/scsi/imm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index f8b88fa..9164ce12 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -77,9 +77,10 @@ static void imm_wakeup(void *ref)
 
 	spin_lock_irqsave(&arbitration_lock, flags);
 	if (dev->wanted) {
-		parport_claim(dev->dev);
-		got_it(dev);
-		dev->wanted = 0;
+		if (parport_claim(dev->dev) == 0) {
+			got_it(dev);
+			dev->wanted = 0;
+		}
 	}
 	spin_unlock_irqrestore(&arbitration_lock, flags);
 }
-- 
1.9.1
