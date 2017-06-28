From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH] qla2xxx: Fix compile warning
Date: Wed, 28 Jun 2017 15:00:26 -0700
Message-ID: <20170628220026.5706-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0067.outbound.protection.outlook.com ([104.47.32.67]:20485
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751566AbdF1WAn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 18:00:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Fixes following warning

drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2x00_start_nvme_mq':
include/uapi/linux/byteorder/big_endian.h:32:26: warning: large integer
implicitly truncated to unsigned type [-Woverflow]
 #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 1da8fa8f641d..14e25e32e622 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -441,7 +441,7 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
 				req->ring_ptr++;
 			}
 			cont_pkt = (cont_a64_entry_t *)req->ring_ptr;
-			cont_pkt->entry_type = cpu_to_le32(CONTINUE_A64_TYPE);
+			cont_pkt->entry_type = CONTINUE_A64_TYPE;
 
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
-- 
2.13.1.452.g97e2ff464
