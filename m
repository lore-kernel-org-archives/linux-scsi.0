From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 03/17] qla2xxx: Use correct offset to req-q-out for reserve calculation
Date: Thu, 25 Sep 2014 06:14:45 -0400
Message-ID: <1411640099-7856-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Cc: <stable@vger.kernel.org>
Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 43f9177..2fe6da3 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1431,12 +1431,10 @@ static inline void qlt_unmap_sg(struct scsi_qla_host *vha,
 static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 	uint32_t req_cnt)
 {
-	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg = ha->iobase;
 	uint32_t cnt;
 
 	if (vha->req->cnt < (req_cnt + 2)) {
-		cnt = (uint16_t)RD_REG_DWORD(&reg->isp24.req_q_out);
+		cnt = (uint16_t)RD_REG_DWORD(vha->req->req_q_out);
 
 		ql_dbg(ql_dbg_tgt, vha, 0xe00a,
 		    "Request ring circled: cnt=%d, vha->->ring_index=%d, "
-- 
1.7.7
