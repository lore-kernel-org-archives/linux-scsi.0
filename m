From: P Karthik Jayanth <karthik@chelsio.com>
Subject: [PATCH] [SCSI] csiostor: Don't ignore the newly alloced lnode.
Date: Mon, 22 Sep 2014 21:36:44 +0530
Message-ID: <1411402004-29625-1-git-send-email-karthik@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:40861
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751070AbaIVQJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2014 12:09:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, hch@infradead.org, P Karthik Jayanth <karthik@chelsio.com>

In case of multiple FCFs, the newly allocated lnode by csio_lnode_alloc()
is completely ignored during link up event. Fix it.

Signed-off-by: P Karthik Jayanth <karthik@chelsio.com>
---
 drivers/scsi/csiostor/csio_lnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index ffe9be0..d956f97 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -873,7 +873,7 @@ csio_handle_link_up(struct csio_hw *hw, uint8_t portid, uint32_t fcfi,
 		if (ln->vnp_flowid != CSIO_INVALID_IDX) {
 			/* New VN-Port */
 			spin_unlock_irq(&hw->lock);
-			csio_lnode_alloc(hw);
+			ln = csio_lnode_alloc(hw);
 			spin_lock_irq(&hw->lock);
 			if (!ln) {
 				csio_err(hw,
-- 
2.0.2

