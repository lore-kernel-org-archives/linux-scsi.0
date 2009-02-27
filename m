From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 17/24] fcoe: Use setup_timer() and mod_timer()
Date: Fri, 27 Feb 2009 10:56:00 -0800
Message-ID: <20090227185600.25509.43824.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6236 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735AbZB0S4C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:56:02 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Use helper functions for watchdog timer setup.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 02f044a..7887f2a 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1435,11 +1435,9 @@ static int __init fcoe_init(void)
 	 */
 	fcoe_dev_setup();
 
-	init_timer(&fcoe_timer);
-	fcoe_timer.data = 0;
-	fcoe_timer.function = fcoe_watchdog;
-	fcoe_timer.expires = (jiffies + (10 * HZ));
-	add_timer(&fcoe_timer);
+	setup_timer(&fcoe_timer, fcoe_watchdog, 0);
+
+	mod_timer(&fcoe_timer, jiffies + (10 * HZ));
 
 	/* initiatlize the fcoe transport */
 	fcoe_transport_init();

