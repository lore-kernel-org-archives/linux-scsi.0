From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/20] fcoe: initialize return value in fcoe_destroy
Date: Wed, 21 Oct 2009 16:27:44 -0700
Message-ID: <20091021232744.12986.45963.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbZJUX1n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:27:43 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
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
index 7c89887..8702c8d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1631,7 +1631,7 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 {
 	struct fcoe_interface *fcoe;
 	struct net_device *netdev;
-	int rc;
+	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
 #ifdef CONFIG_FCOE_MODULE

