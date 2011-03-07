From: "Michael Chan" <mchan@broadcom.com>
Subject: [PATCH 5/6] [SCSI] bnx2fc: Remove network bonding checking
Date: Mon, 7 Mar 2011 15:42:28 -0800
Message-ID: <1299541349-2438-5-git-send-email-mchan@broadcom.com>
References: <1299541349-2438-1-git-send-email-mchan@broadcom.com>
 <1299541349-2438-2-git-send-email-mchan@broadcom.com>
 <1299541349-2438-3-git-send-email-mchan@broadcom.com>
 <1299541349-2438-4-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4213 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab1CHAgm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 19:36:42 -0500
In-Reply-To: <1299541349-2438-4-git-send-email-mchan@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, michaelc@cs.wisc.edu, bprakash@broadcom.com, nsujir@broadcom.com, Michael Chan <mchan@broadcom.com>

bnx2fc only operates on bnx2x hardware devices and not master bonding
devices, so there is no need to check for bonding.  Even if the bnx2x
device is "enslaved" into a bonding device, FCoE is unaffected as it
has its own MAC address and queues.

Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index a626920..b3afaf2 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1095,13 +1095,6 @@ static int bnx2fc_netdev_setup(struct bnx2fc_hba *hba)
 	struct netdev_hw_addr *ha;
 	int sel_san_mac = 0;
 
-	/* Do not support for bonding device */
-	if ((netdev->priv_flags & IFF_MASTER_ALB) ||
-			(netdev->priv_flags & IFF_SLAVE_INACTIVE) ||
-			(netdev->priv_flags & IFF_MASTER_8023AD)) {
-		return -EOPNOTSUPP;
-	}
-
 	/* setup Source MAC Address */
 	rcu_read_lock();
 	for_each_dev_addr(physdev, ha) {
-- 
1.6.4.GIT


