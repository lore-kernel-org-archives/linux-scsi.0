From: Dan Williams <dan.j.williams@intel.com>
Subject: [3.2-rc PATCH 5/8] isci: performance-fix,
 shorten default "no outbound task" timeout
Date: Fri, 16 Dec 2011 16:53:36 -0800
Message-ID: <20111217005336.14133.5851.stgit@localhost6.localdomain6>
References: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39861 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab1LQAxh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 19:53:37 -0500
In-Reply-To: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marcin Tomczak <marcin.tomczak@intel.com>

From: Marcin Tomczak <marcin.tomczak@intel.com>

>From Richard Boyd:
"No task timeout timer reduced from 20 to 2 This timer controls how
long the SCU hardware will hold open the TX side of the connection
before sending a DONE.  The timer allows the hardware to attempt to
optimize the DONE/CLOSE behavior to allow for new COMMAND IU to be
posted.  In practice closing the connection quicker is better."

Signed-off-by: Marcin Tomczak <marcin.tomczak@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c |    2 +-
 drivers/scsi/isci/init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 3374f1b..ecaa7bb 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1697,7 +1697,7 @@ static void sci_controller_set_default_config_parameters(struct isci_host *ihost
 	ihost->user_parameters.ssp_inactivity_timeout = 5;
 	ihost->user_parameters.stp_max_occupancy_timeout = 5;
 	ihost->user_parameters.ssp_max_occupancy_timeout = 20;
-	ihost->user_parameters.no_outbound_task_timeout = 20;
+	ihost->user_parameters.no_outbound_task_timeout = 2;
 }
 
 static void controller_timeout(unsigned long data)
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 1047108..3c4ddad 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -94,7 +94,7 @@ MODULE_DEVICE_TABLE(pci, isci_id_table);
 
 /* linux isci specific settings */
 
-unsigned char no_outbound_task_to = 20;
+unsigned char no_outbound_task_to = 2;
 module_param(no_outbound_task_to, byte, 0);
 MODULE_PARM_DESC(no_outbound_task_to, "No Outbound Task Timeout (1us incr)");
 

