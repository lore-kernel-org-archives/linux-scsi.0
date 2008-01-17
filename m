From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] atp870u: don't zero out sense_buffer in queuecommand
Date: Thu, 17 Jan 2008 20:07:17 +0900
Message-ID: <20080117200717Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:63925 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYAQLHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 06:07:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

LLDs don't need to zero out scsi_cmnd::sense_buffer in queuecommand
since scsi-ml does. This is a preparation of the future changes to
allocate the sense_buffer only when necessary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/atp870u.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index db6de5e..fb27f2c 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -613,7 +613,6 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 	struct Scsi_Host *host;
 
 	c = scmd_channel(req_p);
-	req_p->sense_buffer[0]=0;
 	scsi_set_resid(req_p, 0);
 	if (scmd_channel(req_p) > 1) {
 		req_p->result = 0x00040000;
-- 
1.5.3.4

