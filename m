From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 7/9] isci: dynamic interrupt coalescing
Date: Fri, 29 Jul 2011 17:17:10 -0700
Message-ID: <20110730001710.28430.2274.stgit@localhost6.localdomain6>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24098 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1G3ARL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 20:17:11 -0400
In-Reply-To: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org

Hardware allows both an outstanding number commands and a timeout value
(whichever occurs first) as a gate to the next interrupt generation.  This
scheme at completion time looks at the remaining number of outstanding tasks
and sets the timeout to maximize small transaction operation.  If transactions
are large (take more than a few 10s of microseconds to complete) then
performance is not interrupt processing bound, so the small timeouts this
scheme generates are overridden by the time it takes for a completion to
arrive.

Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c |   10 +++++++++-
 drivers/scsi/isci/host.h |    3 +++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 26072f1..2328f98 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1091,6 +1091,7 @@ static void isci_host_completion_routine(unsigned long data)
 	struct isci_request *request;
 	struct isci_request *next_request;
 	struct sas_task     *task;
+	u16 active;
 
 	INIT_LIST_HEAD(&completed_request_list);
 	INIT_LIST_HEAD(&errored_request_list);
@@ -1181,6 +1182,13 @@ static void isci_host_completion_routine(unsigned long data)
 		}
 	}
 
+	/* the coalesence timeout doubles at each encoding step, so
+	 * update it based on the ilog2 value of the outstanding requests
+	 */
+	active = isci_tci_active(ihost);
+	writel(SMU_ICC_GEN_VAL(NUMBER, active) |
+	       SMU_ICC_GEN_VAL(TIMER, ISCI_COALESCE_BASE + ilog2(active)),
+	       &ihost->smu_registers->interrupt_coalesce_control);
 }
 
 /**
@@ -1471,7 +1479,7 @@ static void sci_controller_ready_state_enter(struct sci_base_state_machine *sm)
 	struct isci_host *ihost = container_of(sm, typeof(*ihost), sm);
 
 	/* set the default interrupt coalescence number and timeout value. */
-	sci_controller_set_interrupt_coalescence(ihost, 0x10, 250);
+	sci_controller_set_interrupt_coalescence(ihost, 0, 0);
 }
 
 static void sci_controller_ready_state_exit(struct sci_base_state_machine *sm)
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 062101a..9f33831 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -369,6 +369,9 @@ static inline struct isci_host *dev_to_ihost(struct domain_device *dev)
 #define ISCI_TAG_SEQ(tag) (((tag) >> 12) & (SCI_MAX_SEQ-1))
 #define ISCI_TAG_TCI(tag) ((tag) & (SCI_MAX_IO_REQUESTS-1))
 
+/* interrupt coalescing baseline: 9 == 3 to 5us interrupt delay per command */
+#define ISCI_COALESCE_BASE 9
+
 /* expander attached sata devices require 3 rnc slots */
 static inline int sci_remote_device_node_count(struct isci_remote_device *idev)
 {

