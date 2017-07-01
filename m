From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2] qla2xxx: Fix NVMe entry_type for iocb packet on BE system
Date: Fri, 30 Jun 2017 19:32:53 -0700
Message-ID: <20170701023253.8362-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0043.outbound.protection.outlook.com ([104.47.40.43]:47216
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751581AbdGACc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 22:32:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

This patch fixes incorrect assignment for entry_type field for Continuation
Type iocb packet on BE system. This was caught by -Woverflow warning on BE
system compilation.

For Continuation Type iocb driver needs to write complete 32 bit value to
initialize other field members in stucture to 0.

Following warning is seen on BE system compile: 

drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2x00_start_nvme_mq':
include/uapi/linux/byteorder/big_endian.h:32:26: warning: large integer
implicitly truncated to unsigned type [-Woverflow]
 #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>

---
Changes from v1 --> v2

o Modified commit message and description to clarify issue 
  in qla2xxx NVMe initiator code on BE system.

---
 drivers/scsi/qla2xxx/qla_nvme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 1da8fa8f641d..367cf8613b15 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -441,7 +441,8 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
 				req->ring_ptr++;
 			}
 			cont_pkt = (cont_a64_entry_t *)req->ring_ptr;
-			cont_pkt->entry_type = cpu_to_le32(CONTINUE_A64_TYPE);
+			*((uint32_t *)(&cont_pkt->entry_type)) =
+			    cpu_to_le32(CONTINUE_A64_TYPE);
 
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
-- 
2.11.0
