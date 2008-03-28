From: akpm@linux-foundation.org
Subject: [patch 14/17] drivers/scsi/hptiop.c: fix build warning
Date: Fri, 28 Mar 2008 14:48:41 -0700
Message-ID: <200803282148.m2SLmfAG012255@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757410AbYC1VtW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:49:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, linux@highpoint-tech.com

From: Andrew Morton <akpm@linux-foundation.org>

powerpc:

drivers/scsi/hptiop.c: In function 'iop_set_config_mv':
drivers/scsi/hptiop.c:395: warning: large integer implicitly truncated to unsigned type

This field is only 32-bit, so cpu_to_le64() seems wrong.

Cc: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hptiop.c~drivers-scsi-hptiopc-fix-build-warning drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~drivers-scsi-hptiopc-fix-build-warning
+++ a/drivers/scsi/hptiop.c
@@ -392,7 +392,7 @@ static int iop_set_config_mv(struct hpti
 	req->header.size =
 		cpu_to_le32(sizeof(struct hpt_iop_request_set_config));
 	req->header.result = cpu_to_le32(IOP_RESULT_PENDING);
-	req->header.context = cpu_to_le64(IOP_REQUEST_TYPE_SET_CONFIG<<5);
+	req->header.context = cpu_to_le32(IOP_REQUEST_TYPE_SET_CONFIG<<5);
 
 	if (iop_send_sync_request_mv(hba, 0, 20000)) {
 		dprintk("Set config send cmd failed\n");
_
