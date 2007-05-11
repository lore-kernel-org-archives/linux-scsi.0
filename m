From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] tgt: fix a rdma indirect transfer error bug
Date: Fri, 11 May 2007 19:10:45 +0900
Message-ID: <20070511191045W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:43951 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbXEKKLT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 06:11:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This sets sg_dma_len to a proper value.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/libsrp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 5631c19..732446e 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -254,6 +254,7 @@ static int srp_indirect_data(struct scsi
 
 		sg_init_one(&dummy, md, id->table_desc.len);
 		sg_dma_address(&dummy) = token;
+		sg_dma_len(&dummy) = id->table_desc.len;
 		err = rdma_io(sc, &dummy, 1, &id->table_desc, 1, DMA_TO_DEVICE,
 			      id->table_desc.len);
 		if (err) {
-- 
1.4.3.2

