From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [V2 PATCH 5/8] bnx2fc: Remove network bonding checking
Date: Thu, 17 Mar 2011 17:13:32 -0700
Message-ID: <1300407212.644.408.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4803 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab1CRANl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 20:13:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Nithin Sujir <nsujir@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>Nithin Sujir <nsujir@broadcom.com>

From: Michael Chan <mchan@broadcom.com>

bnx2fc only operates on bnx2x hardware devices and not master bonding
devices, so there is no need to check for bonding.  Even if the bnx2x
device is "enslaved" into a bonding device, FCoE is unaffected as it
has its own MAC address and queues.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 90cd632..0eec4e0 100644
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
1.7.0.6




