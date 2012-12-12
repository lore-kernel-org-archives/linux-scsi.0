From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/16] debris left by "[SCSI] libfcoe: Remove
 mutex_trylock/restart_syscall checks"
Date: Wed, 12 Dec 2012 15:23:30 -0800
Message-ID: <20121212232330.13084.19801.stgit@fritz>
References: <20121212232203.13084.3630.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1909 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2LLXXa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 18:23:30 -0500
In-Reply-To: <20121212232203.13084.3630.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>

From: Al Viro <viro@ZenIV.linux.org.uk>

	AFAICS, the situation for fcoe_transport_disable() seems to be
the same as for fcoe_transport_enable().  IOW, shouldn't it have
restart_syscall() removed as well?  I don't see any in-tree ->disable()
instances that could return -ERESTARTSYS, anyway...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index dd1aeb4..f3a5a53 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -962,11 +962,7 @@ out_putdev:
 	dev_put(netdev);
 out_nodev:
 	mutex_unlock(&ft_mutex);
-
-	if (rc == -ERESTARTSYS)
-		return restart_syscall();
-	else
-		return rc;
+	return rc;
 }
 
 /**

