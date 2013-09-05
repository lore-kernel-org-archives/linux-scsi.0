From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/16] libfc: Micro-optimize fc_setup_exch_mgr()
Date: Thu, 05 Sep 2013 12:12:50 -0700
Message-ID: <20130905191250.15235.69875.stgit@fritz>
References: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab3IETMv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:12:51 -0400
In-Reply-To: <20130905191218.15235.85917.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

Convert a loop into an ilog2() call. Although this code is not performance
sensitive this conversion makes this code easier to read.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index cb2b900..d0be52a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/export.h>
+#include <linux/log2.h>
 
 #include <scsi/fc/fc_fc2.h>
 
@@ -2530,13 +2531,8 @@ int fc_setup_exch_mgr(void)
 	 * cpu on which exchange originated by simple bitwise
 	 * AND operation between fc_cpu_mask and exchange id.
 	 */
-	fc_cpu_mask = 1;
-	fc_cpu_order = 0;
-	while (fc_cpu_mask < nr_cpu_ids) {
-		fc_cpu_mask <<= 1;
-		fc_cpu_order++;
-	}
-	fc_cpu_mask--;
+	fc_cpu_order = ilog2(roundup_pow_of_two(nr_cpu_ids));
+	fc_cpu_mask = (1 << fc_cpu_order) - 1;
 
 	fc_exch_workqueue = create_singlethread_workqueue("fc_exch_workqueue");
 	if (!fc_exch_workqueue)

