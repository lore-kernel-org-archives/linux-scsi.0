From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: libcxgbi: return error if interface is not up
Date: Fri,  9 Dec 2016 14:40:07 +0530
Message-ID: <1481274607-19236-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:61352 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932362AbcLIJKY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2016 04:10:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

Do not post hw active open cmd if IFF_UP is not set
or link is down on the interface, return -ENETDOWN
in this case.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 9f4fde9..9167bcd 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -642,6 +642,12 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 			n->dev->name, ndev->name, mtu);
 	}
 
+	if (!(ndev->flags & IFF_UP) || !netif_carrier_ok(ndev)) {
+		pr_info("%s interface not up.\n", ndev->name);
+		err = -ENETDOWN;
+		goto rel_neigh;
+	}
+
 	cdev = cxgbi_device_find_by_netdev(ndev, &port);
 	if (!cdev) {
 		pr_info("dst %pI4, %s, NOT cxgbi device.\n",
@@ -736,6 +742,12 @@ static struct cxgbi_sock *cxgbi_check_route6(struct sockaddr *dst_addr)
 	}
 	ndev = n->dev;
 
+	if (!(ndev->flags & IFF_UP) || !netif_carrier_ok(ndev)) {
+		pr_info("%s interface not up.\n", ndev->name);
+		err = -ENETDOWN;
+		goto rel_rt;
+	}
+
 	if (ipv6_addr_is_multicast(&daddr6->sin6_addr)) {
 		pr_info("multi-cast route %pI6 port %u, dev %s.\n",
 			daddr6->sin6_addr.s6_addr,
-- 
2.0.2

