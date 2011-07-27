From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/10] libfc: release exchg cache
Date: Wed, 27 Jul 2011 15:10:34 -0700
Message-ID: <20110727221034.23675.81378.stgit@localhost6.localdomain6>
References: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50071 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab1G0WKf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:10:35 -0400
In-Reply-To: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>, Vasu Dev <vasu.dev@intel.com>

From: Hillf Danton <dhillf@gmail.com>

If fail to create workqueue, the newly created cache for exchg has to be
released.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index f5a0665..7baf223 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2465,8 +2465,11 @@ int fc_setup_exch_mgr(void)
 
 	fc_exch_workqueue = create_singlethread_workqueue("fc_exch_workqueue");
 	if (!fc_exch_workqueue)
-		return -ENOMEM;
+		goto err;
 	return 0;
+err:
+	kmem_cache_destroy(fc_em_cachep);
+	return -ENOMEM;
 }
 
 /**

