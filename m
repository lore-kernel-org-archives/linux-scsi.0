From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 47/54] fcoe: Fix getting san mac for VLAN interface
Date: Tue, 03 Nov 2009 11:49:43 -0800
Message-ID: <20091103194943.4085.88732.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60187 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbZKCTti (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:49:38 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Make sure we are get the SAN MAC address from the real netdev if the input
netdev is a VLAN device.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 2274fcd..c1fd756 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -249,6 +249,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 {
 	struct fcoe_ctlr *fip = &fcoe->ctlr;
 	struct netdev_hw_addr *ha;
+	struct net_device *real_dev;
 	u8 flogi_maddr[ETH_ALEN];
 	const struct net_device_ops *ops;
 
@@ -272,8 +273,10 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 
 	/* look for SAN MAC address, if multiple SAN MACs exist, only
 	 * use the first one for SPMA */
+	real_dev = (netdev->priv_flags & IFF_802_1Q_VLAN) ?
+		vlan_dev_real_dev(netdev) : netdev;
 	rcu_read_lock();
-	for_each_dev_addr(netdev, ha) {
+	for_each_dev_addr(real_dev, ha) {
 		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
 		    (is_valid_ether_addr(ha->addr))) {
 			memcpy(fip->ctl_src_addr, ha->addr, ETH_ALEN);

