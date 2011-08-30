From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/8] bnx2fc: Reset max receive frame size during link up
Date: Tue, 30 Aug 2011 15:54:47 -0700
Message-ID: <1314744894-24710-2-git-send-email-bprakash@broadcom.com>
References: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3851 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab1H3WzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 18:55:09 -0400
In-Reply-To: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, nsujir@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

If the max receive frame size is changed during link down, the driver uses the
same value after linkup unless it is reset to default.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 24e7071..6387067 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -863,6 +863,8 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 		bnx2fc_link_speed_update(lport);
 
 		if (link_possible && !bnx2fc_link_ok(lport)) {
+			/* Reset max recv frame size to default */
+			fc_set_mfs(lport, BNX2FC_MFS);
 			printk(KERN_ERR "indicate_netevent: ctlr_link_up\n");
 			fcoe_ctlr_link_up(&interface->ctlr);
 		} else if (fcoe_ctlr_link_down(&interface->ctlr)) {
-- 
1.7.0.6


