From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: libcxgbi: in case of vlan pass 0 as ifindex to find route
Date: Tue, 10 Oct 2017 19:25:30 +0530
Message-ID: <1507643730-5236-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:62654 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932100AbdJJNzp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 09:55:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

In case of vlan pass 0 as ifindex to find route instead of
passing real_dev ifindex, if we pass real_dev ifindex
then ip_route_output_ports() and ip6_route_output() will
check for route through real_dev not through vlan interface.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 512c8f1..8503ac9 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2556,7 +2556,10 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 			goto err_out;
 		}
 
-		ifindex = hba->ndev->ifindex;
+		rtnl_lock();
+		if (!vlan_uses_dev(hba->ndev))
+			ifindex = hba->ndev->ifindex;
+		rtnl_unlock();
 	}
 
 	if (dst_addr->sa_family == AF_INET) {
-- 
2.0.2
