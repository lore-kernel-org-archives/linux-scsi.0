From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 08/10] qla2xxx: Reduce exess wait during chip reset
Date: Fri, 23 Dec 2016 18:06:12 -0800
Message-ID: <1482545174-811-9-git-send-email-himanshu.madhani@cavium.com>
References: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Soft reset and Risc reset should take 100uS to complete.
This change pad the timeout up to 400uS, which should be
plenty.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 632d5f3..7b6317c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1191,7 +1191,7 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 
 	/* Wait for soft-reset to complete. */
 	RD_REG_DWORD(&reg->ctrl_status);
-	for (cnt = 0; cnt < 6000000; cnt++) {
+	for (cnt = 0; cnt < 60; cnt++) {
 		barrier();
 		if ((RD_REG_DWORD(&reg->ctrl_status) &
 		    CSRX_ISP_SOFT_RESET) == 0)
@@ -1234,7 +1234,7 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	RD_REG_DWORD(&reg->hccr);
 
 	RD_REG_WORD(&reg->mailbox0);
-	for (cnt = 6000000; RD_REG_WORD(&reg->mailbox0) != 0 &&
+	for (cnt = 60; RD_REG_WORD(&reg->mailbox0) != 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		barrier();
 		if (cnt)
-- 
1.8.3.1
