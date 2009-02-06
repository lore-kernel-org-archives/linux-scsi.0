From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/17] fcoe: Use setup_timer() and mod_timer()
Date: Fri, 06 Feb 2009 10:57:09 -0800
Message-ID: <20090206185709.26188.7990.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21060 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZBFS5R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:57:17 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Use helper functions for watchdog timer setup.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 5dae859..3072428 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1437,11 +1437,9 @@ static int __init fcoe_init(void)
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

