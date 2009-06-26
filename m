From: kxie@chelsio.com
Subject: [PATCH 2.6.30-rc] cxgb3i -- fixed connection error when vlan is
 enabled
Date: Fri, 26 Jun 2009 15:17:29 -0700
Message-ID: <200906262217.n5QMHTXg006358@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:3444 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbZFZWI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2009 18:08:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

[PATCH 2.6.30-rc] cxgb3i -- fixed connection error when vlan is enabled

From: Karen Xie <kxie@chelsio.com>

There is a bug when VLAN is configured on the cxgb3 interface, the iscsi
conn. would be denied with message "cxgb3i: NOT going through cxgbi device."

This patch added code to get the real egress net_device when vlan is configured.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_iscsi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index 04a4374..60013a4 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -13,6 +13,7 @@
 
 #include <linux/inet.h>
 #include <linux/crypto.h>
+#include <linux/if_vlan.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -183,6 +184,9 @@ static struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
 	struct cxgb3i_adapter *snic;
 	int i;
 
+	if (ndev->priv_flags & IFF_802_1Q_VLAN)
+		ndev = vlan_dev_real_dev(ndev);
+
 	read_lock(&cxgb3i_snic_rwlock);
 	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
 		for (i = 0; i < snic->hba_cnt; i++) {
