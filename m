From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/8] qla4xxx: Use the correct request queue.
Date: Fri, 30 Jul 2010 14:26:08 +0530
Message-ID: <20100730085608.GA12282@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:8544
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755762Ab0G3I7b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 04:59:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, ravi.anand@qlogic.com, michaelc@cs.wisc.edu

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_iocb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index f89973d..4ef9ba1 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -19,7 +19,7 @@ qla4xxx_space_in_req_ring(struct scsi_qla_host *ha, uint16_t req_cnt)
 
 	/* Calculate number of free request entries. */
 	if ((req_cnt + 2) >= ha->req_q_count) {
-		cnt = (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
+		cnt = (uint16_t) ha->isp_ops->rd_shdw_req_q_out(ha);
 		if (ha->request_in < cnt)
 			ha->req_q_count = cnt - ha->request_in;
 		else
-- 
1.6.6

