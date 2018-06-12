From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH] scsi: bnx2i: add error handling for ioremap_nocache
Date: Tue, 12 Jun 2018 11:13:00 +0800
Message-ID: <1528773180-37120-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When ioremap_nocache fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling ioremap_nocache.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 8f03a86..e9e669a 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2727,6 +2727,8 @@ int bnx2i_map_ep_dbell_regs(struct bnx2i_endpoint *ep)
 					      BNX2X_DOORBELL_PCI_BAR);
 		reg_off = (1 << BNX2X_DB_SHIFT) * (cid_num & 0x1FFFF);
 		ep->qp.ctx_base = ioremap_nocache(reg_base + reg_off, 4);
+		if (!ep->qp.ctx_base)
+			return -ENOMEM;
 		goto arm_cq;
 	}
 
-- 
2.7.4
