From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] scsi: fnic: Use eth_broadcast_addr instead of memset
Date: Sat, 30 Dec 2017 21:28:31 +0530
Message-ID: <1514649511-7605-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use eth_broadcasr_addr Networking API instead of memset to assign the
broadcast address to the given address array.

0-day tested with no failures.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 242e2ee..e51dc72 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -276,7 +276,7 @@ int fnic_flogi_reg_handler(struct fnic *fnic, u32 fc_id)
 	}
 
 	if (fnic->ctlr.map_dest) {
-		memset(gw_mac, 0xff, ETH_ALEN);
+		eth_broadcast_addr(gw_mac);
 		format = FCPIO_FLOGI_REG_DEF_DEST;
 	} else {
 		memcpy(gw_mac, fnic->ctlr.dest_addr, ETH_ALEN);
-- 
2.7.4
