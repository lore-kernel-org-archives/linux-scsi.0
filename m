From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/12] libfcoe: Don't KERN_ERR on netdev notification
Date: Fri, 10 Feb 2012 17:17:59 -0800
Message-ID: <20120211011759.7668.77814.stgit@localhost6.localdomain6>
References: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64623 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab2BKBSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 20:18:00 -0500
In-Reply-To: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

This is more of a debug statement. As a KERN_ERR we generate
log entries anytime any netdev goes up or down, so when booting
there are notification log entries for all system interfaces
including 'lo'. This is too much. Let's just log when necessary.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index bd97b22..0897be0 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -620,8 +620,8 @@ static int libfcoe_device_notification(struct notifier_block *notifier,
 
 	switch (event) {
 	case NETDEV_UNREGISTER:
-		printk(KERN_ERR "libfcoe_device_notification: NETDEV_UNREGISTER %s\n",
-				netdev->name);
+		LIBFCOE_TRANSPORT_DBG("NETDEV_UNREGISTER %s\n",
+				      netdev->name);
 		fcoe_del_netdev_mapping(netdev);
 		break;
 	}

