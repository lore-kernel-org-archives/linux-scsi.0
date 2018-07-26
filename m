From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] qedi: Fix a potential buffer overflow
Date: Thu, 26 Jul 2018 14:10:37 -0700
Message-ID: <20180726211037.6257-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, QLogic-Storage-Upstream@cavium.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tell snprintf() to store at most 255 characters in the output buffer
instead of 256. This patch avoids that smatch reports the following
warning:

drivers/scsi/qedi/qedi_main.c:891: qedi_get_boot_tgt_info() error: snprintf() is printing too much 256 vs 255

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: <QLogic-Storage-Upstream@cavium.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 682f3ce31014..ea62180d9ec8 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -888,7 +888,7 @@ static void qedi_get_boot_tgt_info(struct nvm_iscsi_block *block,
 	ipv6_en = !!(block->generic.ctrl_flags &
 		     NVM_ISCSI_CFG_GEN_IPV6_ENABLED);
 
-	snprintf(tgt->iscsi_name, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
+	snprintf(tgt->iscsi_name, sizeof(tgt->iscsi_name), "%s\n",
 		 block->target[index].target_name.byte);
 
 	tgt->ipv6_en = ipv6_en;
-- 
2.18.0
