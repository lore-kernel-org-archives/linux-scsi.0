From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] hptiop: fix sense_buffer
Date: Sun, 27 Jan 2008 10:22:26 +0900
Message-ID: <20080127102207D.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:52896 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYA0BWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 20:22:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux@highpoint-tech.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Sorry, there was another place that I overlooked in the sense buffer
conversion.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] hptiop: fix sense_buffer access bug

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/hptiop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index e7b2f35..890f44f 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -573,7 +573,7 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 		scsi_set_resid(scp,
 			scsi_bufflen(scp) - le32_to_cpu(req->dataxfer_length));
 		scp->result = SAM_STAT_CHECK_CONDITION;
-		memcpy(&scp->sense_buffer, &req->sg_list,
+		memcpy(scp->sense_buffer, &req->sg_list,
 				min_t(size_t, SCSI_SENSE_BUFFERSIZE,
 					le32_to_cpu(req->dataxfer_length)));
 		break;
-- 
1.5.3.4

