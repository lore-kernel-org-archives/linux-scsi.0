From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/22] fcoe: Fix validation of mac address when checking for
	spma support
Date: Wed, 29 Jul 2009 17:03:50 -0700
Message-ID: <20090730000350.24658.42303.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41968 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245AbZG3ADu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:03:50 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Fix this bug of validating the wrong mac address while checking for SAN MAC
address support from LLD as we should check ha->addr not ctlr.ctl_src_addr.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0a5609b..b7dfc6e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -329,7 +329,7 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	rcu_read_lock();
 	for_each_dev_addr(netdev, ha) {
 		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
-		    (is_valid_ether_addr(fc->ctlr.ctl_src_addr))) {
+		    (is_valid_ether_addr(ha->addr))) {
 			memcpy(fc->ctlr.ctl_src_addr, ha->addr, ETH_ALEN);
 			fc->ctlr.spma = 1;
 			break;

