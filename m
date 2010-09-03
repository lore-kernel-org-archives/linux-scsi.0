From: madhu.iyengar@qlogic.com
Subject: [PATCH 6/7] qla2xxx: Check for empty slot in request queue before posting Command type 6 request.
Date: Fri,  3 Sep 2010 14:57:05 -0700
Message-ID: <1283551026-3886-7-git-send-email-madhu.iyengar@qlogic.com>
References: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42967 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757641Ab0ICWDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:03:07 -0400
In-Reply-To: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nkmi@yahoo.com

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

For ISP82xx, the check for empty slot in request queue before posting command type 6
request was missing. This could lead to request queue entry corruptions causing
IO timeouts.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index ad290dc..0a71cc7 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2672,6 +2672,19 @@ qla82xx_start_scsi(srb_t *sp)
 sufficient_dsds:
 		req_cnt = 1;
 
+		if (req->cnt < (req_cnt + 2)) {
+			cnt = (uint16_t)RD_REG_DWORD_RELAXED(
+				&reg->req_q_out[0]);
+			if (req->ring_index < cnt)
+				req->cnt = cnt - req->ring_index;
+			else
+				req->cnt = req->length -
+					(req->ring_index - cnt);
+		}
+
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
+
 		ctx = sp->ctx = mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
 		if (!sp->ctx) {
 			DEBUG(printk(KERN_INFO
-- 
1.6.0.2

