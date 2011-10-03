From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/4] bnx2fc: call ctlr_link_up only when the interface
 is enabled
Date: Mon, 3 Oct 2011 16:45:00 -0700
Message-ID: <1317685503-22622-2-git-send-email-bprakash@broadcom.com>
References: <1317685503-22622-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1273 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1JCXpT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 19:45:19 -0400
In-Reply-To: <1317685503-22622-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org

Link may not be up when the driver receives ulp_start event, and hence
fcoe_ctlr_link_up is not called. Call fcoe_ctlr_link_up during
indicate_netevent only when the interface is enabled. (It has to be called when
enabled because that is an indication that the vlan discovery is completed).

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 7e6ce7b..d2bbb80 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -870,6 +870,8 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 			 * enable to avoid sending discovery solicitation
 			 * on a stale vlan
 			 */
+			if (interface->enabled)
+				fcoe_ctlr_link_up(&interface->ctlr);
 		} else if (fcoe_ctlr_link_down(&interface->ctlr)) {
 			mutex_lock(&lport->lp_mutex);
 			list_for_each_entry(vport, &lport->vports, list)
-- 
1.7.0.6


