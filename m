From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/11] fcoe: don't export functions that are internal to fcoe
Date: Tue, 21 Apr 2009 16:27:30 -0700
Message-ID: <20090421232730.8165.39880.stgit@fritz>
References: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4760 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZDUX1b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:27:31 -0400
In-Reply-To: <20090421232647.8165.46673.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

These probably never should have been exported.
If they were needed outside of the fcoe module, they
would have been moved to libfcoe.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 13a0a6f..7bd0e82 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -884,7 +884,6 @@ err2:
 	kfree_skb(skb);
 	return -1;
 }
-EXPORT_SYMBOL_GPL(fcoe_rcv);
 
 /**
  * fcoe_start_io() - pass to netdev to start xmit for fcoe
@@ -1123,7 +1122,6 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fcoe_xmit);
 
 /**
  * fcoe_percpu_receive_thread() - recv thread per cpu
@@ -1652,7 +1650,6 @@ int fcoe_link_ok(struct fc_lport *lp)
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(fcoe_link_ok);
 
 /**
  * fcoe_percpu_clean() - Clear the pending skbs for an lport
@@ -1684,7 +1681,6 @@ void fcoe_percpu_clean(struct fc_lport *lp)
 		spin_unlock_bh(&pp->fcoe_rx_list.lock);
 	}
 }
-EXPORT_SYMBOL_GPL(fcoe_percpu_clean);
 
 /**
  * fcoe_clean_pending_queue() - Dequeue a skb and free it
@@ -1705,7 +1701,6 @@ void fcoe_clean_pending_queue(struct fc_lport *lp)
 	}
 	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
 }
-EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
 
 /**
  * fcoe_reset() - Resets the fcoe
@@ -1719,7 +1714,6 @@ int fcoe_reset(struct Scsi_Host *shost)
 	fc_lport_reset(lport);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fcoe_reset);
 
 /**
  * fcoe_hostlist_lookup_softc() - find the corresponding lport by a given device
@@ -1757,7 +1751,6 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 
 	return (fc) ? fc->ctlr.lp : NULL;
 }
-EXPORT_SYMBOL_GPL(fcoe_hostlist_lookup);
 
 /**
  * fcoe_hostlist_add() - Add a lport to lports list
@@ -1778,7 +1771,6 @@ int fcoe_hostlist_add(const struct fc_lport *lp)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fcoe_hostlist_add);
 
 /**
  * fcoe_hostlist_remove() - remove a lport from lports list
@@ -1798,7 +1790,6 @@ int fcoe_hostlist_remove(const struct fc_lport *lp)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fcoe_hostlist_remove);
 
 /**
  * fcoe_init() - fcoe module loading initialization

