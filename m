From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] iscsi class: Fix freeing of skb in get host error path
Date: Sun,  3 Aug 2014 18:37:52 -0500
Message-ID: <1407109072-3351-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41904 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaHCXiC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Aug 2014 19:38:02 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s73NbvME023063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 3 Aug 2014 18:38:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

If get_host_stats failes we are using kfree to free the
skb. We should be using kfree_skb.

This patch was made over Christoph's scsi-queue drivers-for-3.17 branch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 534d3fb..67d43e3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3468,7 +3468,7 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 
 		err = transport->get_host_stats(shost, buf, host_stats_size);
 		if (err) {
-			kfree(skbhost_stats);
+			kfree_skb(skbhost_stats);
 			goto exit_host_stats;
 		}
 
-- 
1.7.1

