From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/2] destroy scsi_bidi_sdb_cache in scsi_exit_queue
Date: Fri, 25 Jan 2008 23:25:13 +0900
Message-ID: <20080125232220M.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60719 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYAYOZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 09:25:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

This patchset is against the scsi-bidi tree.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] destroy scsi_bidi_sdb_cache in scsi_exit_queue

Needs to call kmem_cache_destroy for scsi_bidi_sdb_cache in
scsi_exit_queue.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e1c7eeb..7bfec7e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1712,6 +1712,7 @@ void scsi_exit_queue(void)
 	int i;
 
 	kmem_cache_destroy(scsi_io_context_cache);
+	kmem_cache_destroy(scsi_bidi_sdb_cache);
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-- 
1.5.3.4

