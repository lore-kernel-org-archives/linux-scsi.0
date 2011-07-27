From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/10] libfc, fcoe: ignore rx frame with wrong xid info
Date: Wed, 27 Jul 2011 15:10:39 -0700
Message-ID: <20110727221039.23675.95425.stgit@localhost6.localdomain6>
References: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab1G0WKj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:10:39 -0400
In-Reply-To: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Drop the rx frame having xid with wrong cpu info
or received with xid  not matching to our xid.

Not dropping such frame is causing panic as
that causes accessing data struct beyond their
bounds.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c     |    4 ++++
 drivers/scsi/libfc/fc_exch.c |    4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index f7547fb..945df21 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1373,6 +1373,10 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 		} else
 			cpu = smp_processor_id();
 	}
+
+	if (cpu >= nr_cpu_ids)
+		goto err;
+
 	fps = &per_cpu(fcoe_percpu, cpu);
 	spin_lock_bh(&fps->fcoe_rx_list.lock);
 	if (unlikely(!fps->thread)) {
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 7baf223..01ff082 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -802,10 +802,8 @@ static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
 		pool = per_cpu_ptr(mp->pool, xid & fc_cpu_mask);
 		spin_lock_bh(&pool->lock);
 		ep = fc_exch_ptr_get(pool, (xid - mp->min_xid) >> fc_cpu_order);
-		if (ep) {
+		if (ep && ep->xid == xid)
 			fc_exch_hold(ep);
-			WARN_ON(ep->xid != xid);
-		}
 		spin_unlock_bh(&pool->lock);
 	}
 	return ep;

