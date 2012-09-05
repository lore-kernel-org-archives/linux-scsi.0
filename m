From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH] isci: Fix interrupt coalescing assumption of active TCs
Date: Wed, 05 Sep 2012 16:35:44 -0700
Message-ID: <20120905233543.5774.73174.stgit@djiang5-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6290 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759937Ab2IEXfu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Sep 2012 19:35:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, dan@seamicro.com, richard.g.boyd@intel.com

We always assign a dummy task context to a port in order to address a
silicon issue. We have 4 ports per controller. So when idle, there are always
exactly 4 TCs "active". The adaptive interrupt coalescing code uses number of
active TCs to figure out the coalescing values. However, we never hit "0" TCs
because of the 4 dummy TCs. Putting in fix so that we calculate this correctly.

Reported-by: Dan Melnic <dan@seamicro.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

 drivers/scsi/isci/host.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index b425ed5..bbe9fa5 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1120,10 +1120,16 @@ void isci_host_completion_routine(unsigned long data)
 	sci_controller_completion_handler(ihost);
 	spin_unlock_irq(&ihost->scic_lock);
 
-	/* the coalesence timeout doubles at each encoding step, so
+	/*
+	 * we subtract SCI_MAX_PORTS to account for the number of dummy TCs
+	 * issued for hardware issue workaround
+	 */
+	active = isci_tci_active(ihost) - SCI_MAX_PORTS;
+
+	/*
+	 * the coalesence timeout doubles at each encoding step, so
 	 * update it based on the ilog2 value of the outstanding requests
 	 */
-	active = isci_tci_active(ihost);
 	writel(SMU_ICC_GEN_VAL(NUMBER, active) |
 	       SMU_ICC_GEN_VAL(TIMER, ISCI_COALESCE_BASE + ilog2(active)),
 	       &ihost->smu_registers->interrupt_coalesce_control);

