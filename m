From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/12] fcoe: check netif operstate instead of IFF_UP & link
	state
Date: Fri, 09 Apr 2010 14:22:28 -0700
Message-ID: <20100409212228.1968.11974.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30193 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504Ab0DIVW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:22:28 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

Allow for dormant states while link configuration completes.
In the default link mode, this is equivalent to the old check.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0d8127e..d16dd12 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2148,8 +2148,7 @@ int fcoe_link_ok(struct fc_lport *lport)
 	struct net_device *netdev = port->fcoe->netdev;
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 
-	if ((netdev->flags & IFF_UP) && netif_carrier_ok(netdev) &&
-	    (!dev_ethtool_get_settings(netdev, &ecmd))) {
+	if (netif_oper_up(netdev) && !dev_ethtool_get_settings(netdev, &ecmd)) {
 		lport->link_supported_speeds &=
 			~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
 		if (ecmd.supported & (SUPPORTED_1000baseT_Half |

