From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 21/22] libfc: Remove page flags check for sglist
Date: Wed, 29 Jul 2009 17:05:40 -0700
Message-ID: <20090730000539.24658.92983.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532AbZG3AFj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:39 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

I don't believe this check is needed any more in the current kernel, which,
if I understand correctly, is for compound page where only the first page
is supposed to get ref-counted.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 2069edf..7d5ffcb 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -507,33 +507,6 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 	f_ctl = FC_FC_REL_OFF;
 	WARN_ON(!seq);
 
-	/*
-	 * If a get_page()/put_page() will fail, don't use sg lists
-	 * in the fc_frame structure.
-	 *
-	 * The put_page() may be long after the I/O has completed
-	 * in the case of FCoE, since the network driver does it
-	 * via free_skb().  See the test in free_pages_check().
-	 *
-	 * Test this case with 'dd </dev/zero >/dev/st0 bs=64k'.
-	 */
-	if (using_sg) {
-		for (sg = scsi_sglist(sc); sg; sg = sg_next(sg)) {
-			if (page_count(sg_page(sg)) == 0 ||
-			    (sg_page(sg)->flags & (1 << PG_lru |
-						   1 << PG_private |
-						   1 << PG_locked |
-						   1 << PG_active |
-						   1 << PG_slab |
-						   1 << PG_swapcache |
-						   1 << PG_writeback |
-						   1 << PG_reserved |
-						   1 << PG_buddy))) {
-				using_sg = 0;
-				break;
-			}
-		}
-	}
 	sg = scsi_sglist(sc);
 
 	while (remaining > 0 && sg) {

