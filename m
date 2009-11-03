From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 48/54] fcoe: Fix setting lport's WWNN/WWPN to use san mac
	address
Date: Tue, 03 Nov 2009 11:49:49 -0800
Message-ID: <20091103194949.4085.34820.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32331 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbZKCTto (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:49:44 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

We are still using netdev->dev_addr to generate lport's WWNN/WWPN even if the
LLD has support for NETDEV_HW_ADDR_T_SAN. Instead, we should just use the
fip->ctl_src_addr, which is the NETDEV_HW_ADDR_T_SAN if LLD supports it or it
is just the netdev->dev_addr if it does not.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c1fd756..fba7ba0 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -599,10 +599,10 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long)lport);
 
 	if (!lport->vport) {
-		wwnn = fcoe_wwn_from_mac(netdev->dev_addr, 1, 0);
+		wwnn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
 		fc_set_wwnn(lport, wwnn);
 		/* XXX - 3rd arg needs to be vlan id */
-		wwpn = fcoe_wwn_from_mac(netdev->dev_addr, 2, 0);
+		wwpn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 2, 0);
 		fc_set_wwpn(lport, wwpn);
 	}
 

