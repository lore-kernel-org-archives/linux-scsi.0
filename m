From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] scsi: qla2xxx: remove incorrect byte swap
Date: Fri, 30 Jun 2017 18:10:39 +0200
Message-ID: <20170630161056.30630-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:60857 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751792AbdF3QLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2017 12:11:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Himanshu Madhani <himanshu.madhani@cavium.com>, Darren Trapp <darren.trapp@cavium.com>, Giridhar Malavali <giridhar.malavali@cavium.com>, Duane Grigsby <duane.grigsby@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

cont_pkt->entry_type is an 8-bit field, so doing a 32-bit byteswap
on it will store incorrect data:

drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2x00_start_nvme_mq':
include/uapi/linux/byteorder/big_endian.h:32:26: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
drivers/scsi/qla2xxx/qla_nvme.c:444:27: note: in expansion of macro 'cpu_to_le32'
    cont_pkt->entry_type = cpu_to_le32(CONTINUE_A64_TYPE);

This removes the erroneous cpu_to_le32().

Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and transport registration")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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
2.9.0
