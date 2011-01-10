From: kxie@chelsio.com
Subject: [PATCH] cxgb3i: fixed connection problem with iscsi private ip
Date: Mon, 10 Jan 2011 15:15:26 -0800
Message-ID: <201101102315.p0ANFQ8u015283@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:27086 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1AJXPg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jan 2011 18:15:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, davem@davemloft.net, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

[PATCH] cxgb3i: fixed connection problem with iscsi private ip

From: Karen Xie <kxie@chelsio.com>

fixed the connection problem when the private iscsi ipv4 address is provisioned on the interface.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.h |   18 ++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.h
index 5f5e339..bed14db 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.h
@@ -24,10 +24,20 @@
 
 extern cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS];
 
-#define cxgb3i_get_private_ipv4addr(ndev) \
-	(((struct port_info *)(netdev_priv(ndev)))->iscsi_ipv4addr)
-#define cxgb3i_set_private_ipv4addr(ndev, addr) \
-	(((struct port_info *)(netdev_priv(ndev)))->iscsi_ipv4addr) = addr
+static inline unsigned int cxgb3i_get_private_ipv4addr(struct net_device *ndev)
+{
+	return ((struct port_info *)(netdev_priv(ndev)))->iscsi_ipv4addr;
+}
+
+static inline void cxgb3i_set_private_ipv4addr(struct net_device *ndev,
+					unsigned int addr)
+{
+	struct port_info *pi =  (struct port_info *)netdev_priv(ndev);
+
+	pi->iscsic.flags = addr ? 1 : 0;
+	pi->iscsi_ipv4addr = addr;
+	if (addr)
+		memcpy(pi->iscsic.mac_addr, ndev->dev_addr, ETH_ALEN);
+}
 
 struct cpl_iscsi_hdr_norss {
 	union opcode_tid ot;
