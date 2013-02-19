From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/21] debris left by "[SCSI] libfcoe: Remove
 mutex_trylock/restart_syscall checks"
Date: Tue, 19 Feb 2013 11:31:59 -0800
Message-ID: <20130219193159.10192.73751.stgit@fritz>
References: <20130219193031.10192.33777.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:58462 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928Ab3BSTcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 14:32:18 -0500
In-Reply-To: <20130219193031.10192.33777.stgit@fritz>
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

