From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/8] sg: remove b_malloc_len in sg_scatter_hold struct
Date: Tue,  2 Sep 2008 22:50:03 +0900
Message-ID: <1220363408-7134-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56055 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYIBNwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 09:52:46 -0400
In-Reply-To: <1220363408-7134-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

It's not used for anything useful after the block layer conversion.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2c30331..ccce31a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -116,7 +116,6 @@ typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
 	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
 	unsigned sglist_len; /* size of malloc'd scatter-gather list ++ */
 	unsigned bufflen;	/* Size of (aggregate) data buffer */
-	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
 	struct page **pages;
 	int page_order;
 	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
@@ -1986,7 +1985,6 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 			req_schp->pages = rsv_schp->pages;
 
 			req_schp->bufflen = size;
-			req_schp->b_malloc_len = rsv_schp->b_malloc_len;
 			req_schp->page_order = rsv_schp->page_order;
 			break;
 		} else
-- 
1.5.4.2

