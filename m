From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] fcoe: remove a stray unlock
Date: Thu, 29 Mar 2012 21:53:26 +0300
Message-ID: <20120329185326.GD21812@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:17283 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650Ab2C2SyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2012 14:54:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Vasu Dev <vasu.dev@intel.com>

We moved the locking in dd060e74fb "[SCSI] fcoe: remove frame dropping
code from fcoe_percpu_clean" but this unlock was missed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 335e851..c2d8a8c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2274,10 +2274,9 @@ static void fcoe_percpu_clean(struct fc_lport *lport)
 			continue;
 
 		skb = dev_alloc_skb(0);
-		if (!skb) {
-			spin_unlock_bh(&pp->fcoe_rx_list.lock);
+		if (!skb)
 			continue;
-		}
+
 		skb->destructor = fcoe_percpu_flush_done;
 
 		spin_lock_bh(&pp->fcoe_rx_list.lock);
