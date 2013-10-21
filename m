From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/19] fcoe: Fix missing mutex_unlock in fcoe_sysfs_fcf_add
 error path
Date: Mon, 21 Oct 2013 11:02:06 -0700
Message-ID: <20131021180206.31563.93023.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49789 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3JUSCH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:02:07 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, Neil Horman <nhorman@tuxdriver.com>

From: Neil Horman <nhorman@tuxdriver.com>

In this pending patch:
http://patchwork.open-fcoe.org/patch/104/

Tomas Henzl noted that the error path when fcoe_fcf_device_add fails, was
missing a mutex_unlock call.

Not sure what staet the integration of the above patch is in, but if you could
either merge this with it, or apply it on top of what you already have, that
would be great.  Thanks!

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: thenzl@redhat.com
Reported-by: thenzl@redhat.com
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 75efdbc..2aba32f 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -203,6 +203,7 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
 		fcf_dev = fcoe_fcf_device_add(ctlr_dev, temp);
 		if (unlikely(!fcf_dev)) {
 			rc = -ENOMEM;
+			mutex_unlock(&ctlr_dev->lock);
 			goto out;
 		}
 

