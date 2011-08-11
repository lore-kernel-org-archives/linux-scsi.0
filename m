From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] libcxgbi: Fix some build warnings missed during cleanup of a previous patch
Date: Thu, 11 Aug 2011 06:47:24 -0400
Message-ID: <1313059644-25087-1-git-send-email-nhorman@tuxdriver.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50560 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1HKKrr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 06:47:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Divy Le Ray <divy@chelsio.com>, Steve Wise <swise@chelsio.com>, Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <JBottomley@parallels.com>

I recently submitted this:
http://marc.info/?l=linux-scsi&m=131228153521094&w=2

Patch to fix an oops in the cxgb3i iscsi driver.  I did what I thought was some
minor cleanup after testing and prior to submission.  Of course that bit me, and
and a result I introduced some build warnings that really don't need to be
there.  This patch corrects them.  Apologies for the noise

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Divy Le Ray <divy@chelsio.com>
CC: Steve Wise <swise@chelsio.com>
CC: Karen Xie <kxie@chelsio.com>
CC: Mike Christie <michaelc@cs.wisc.edu>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index eb5625d..0890728 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -475,7 +475,7 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 	struct sockaddr_in *daddr = (struct sockaddr_in *)dst_addr;
 	struct dst_entry *dst;
 	struct net_device *ndev;
-	struct cxgbi_device *cdev;
+	struct cxgbi_device *cdev = NULL;
 	struct rtable *rt = NULL;
 	struct flowi4 fl4;
 	struct cxgbi_sock *csk = NULL;
@@ -2499,7 +2499,7 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 	return ep;
 
 release_conn:
-	cdev_put(&csk->cdev);
+	cdev_put(csk->cdev);
 	cxgbi_sock_put(csk);
 	cxgbi_sock_closed(csk);
 err_out:
-- 
1.7.6

