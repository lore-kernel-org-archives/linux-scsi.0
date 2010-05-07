From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/10] fcoe: fixes wrong error exit in fcoe_create
Date: Fri, 07 May 2010 15:18:19 -0700
Message-ID: <20100507221819.14971.81679.stgit@localhost.localdomain>
References: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44774 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0EGWSV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:18:21 -0400
In-Reply-To: <20100507221804.14971.11739.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

fcoe_create exits using out_nodev label when module is not
yet LIVE but this exit path unlocks the rtnl_lock though
rtnl lock was not held in this case.

So this patch replaces out_nodev with out_nomod to exit
w/o unlocking rtnl_lock.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index aba839e..7022a16 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2056,7 +2056,7 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	 */
 	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
 		rc = -ENODEV;
-		goto out_nodev;
+		goto out_nomod;
 	}
 #endif
 

