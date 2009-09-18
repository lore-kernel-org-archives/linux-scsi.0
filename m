From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/24] fcoe: initialize return value in fcoe_destroy
Date: Fri, 18 Sep 2009 15:50:11 -0700
Message-ID: <20090918225011.5928.65375.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20713 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758043AbZIRWuI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:50:08 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>

From: Mike Christie <michaelc@cs.wisc.edu>

When doing echo ethX > /sys..../destroy I am getting
errors when the tear down succeeds. It looks like the
reason for this is because the rc var is not getting set
when the destruction works. This just sets it to zero.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 49d46a8..0a3affd 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1804,7 +1804,7 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 {
 	struct fcoe_interface *fcoe;
 	struct net_device *netdev;
-	int rc;
+	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
 #ifdef CONFIG_FCOE_MODULE

