From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] osst: make all the buffer the same size
Date: Sun, 14 Dec 2008 00:55:17 +0900
Message-ID: <1229183718-1171-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229183718-1171-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40802 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYLMQMs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 11:12:48 -0500
In-Reply-To: <1229183718-1171-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This simiplifies the buffer management; all the buffers in osst_buffer
become the same size. This is necessary to use the block layer API (sg
driver was modified in the same way) since the block layer API takes
the same size page frames instead of scatter gatter.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/osst.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 0ea78d9..f733b93 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5286,11 +5286,6 @@ static int enlarge_buffer(struct osst_buffer *STbuffer, int need_dma)
 		struct page *page = alloc_pages(priority, (OS_FRAME_SIZE - got <= PAGE_SIZE) ? 0 : order);
 		STbuffer->sg[segs].offset = 0;
 		if (page == NULL) {
-			if (OS_FRAME_SIZE - got <= (max_segs - segs) * b_size / 2 && order) {
-				b_size /= 2;  /* Large enough for the rest of the buffers */
-				order--;
-				continue;
-			}
 			printk(KERN_WARNING "osst :W: Failed to enlarge buffer to %d bytes.\n",
 						OS_FRAME_SIZE);
 #if DEBUG
-- 
1.5.6.5

