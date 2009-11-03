From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 46/54] fcoe: Fix checking san mac address
Date: Tue, 03 Nov 2009 11:49:38 -0800
Message-ID: <20091103194938.4085.42925.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60187 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbZKCTtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:49:33 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

This was fixed before in 7a7f0c7 but it's introduced again recently.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 343900a..2274fcd 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -275,7 +275,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	rcu_read_lock();
 	for_each_dev_addr(netdev, ha) {
 		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
-		    (is_valid_ether_addr(fip->ctl_src_addr))) {
+		    (is_valid_ether_addr(ha->addr))) {
 			memcpy(fip->ctl_src_addr, ha->addr, ETH_ALEN);
 			fip->spma = 1;
 			break;

