From: Usha Ketineni <usha.k.ketineni@intel.com>
Subject: [PATCH] fcoe: fix reset of fip selection time.
Date: Mon, 29 Feb 2016 03:36:52 -0800
Message-ID: <20160229113652.2680.73280.stgit@ukketine.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6152 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbcB2S1J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 13:27:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: fcoe-devel@open-fcoe.org

Do not reset fip selection time for every advertisement
in fcoe_ctlr_recv_adv() but set it only once for the first
validated FCF. Otherwise FCF selection won't happen when the
advertisements consistently arrive with sub FCOE_CTLR_START_DELAY
periodicity.

Tested-by: Narendra K <narendra_k@dell.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Acked-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Usha Ketineni <usha.k.ketineni@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index d68d572..0c85ef6 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1079,7 +1079,8 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	 * If this is the first validated FCF, note the time and
 	 * set a timer to trigger selection.
 	 */
-	if (mtu_valid && !fip->sel_fcf && fcoe_ctlr_fcf_usable(fcf)) {
+	if (mtu_valid && !fip->sel_fcf && !fip->sel_time &&
+	    fcoe_ctlr_fcf_usable(fcf)) {
 		fip->sel_time = jiffies +
 			msecs_to_jiffies(FCOE_CTLR_START_DELAY);
 		if (!timer_pending(&fip->timer) ||

