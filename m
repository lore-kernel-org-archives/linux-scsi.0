From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 5/5] isci: improvements in driver unloading routine
Date: Fri, 10 Feb 2012 01:18:54 -0800
Message-ID: <20120210091854.26719.90584.stgit@dwillia2-linux.jf.intel.com>
References: <20120210091814.26719.75603.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758622Ab2BJJD7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 04:03:59 -0500
In-Reply-To: <20120210091814.26719.75603.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrzej Jakowski <andrzej.jakowski@intel.com>

From: Andrzej Jakowski <andrzej.jakowski@intel.com>

This patch fixes scenario where driver removal should be possible
only when driver is in READY state. Also it removes redundant
invocation of routine disabling SCU interrupts - this method is
called somewhere else in driver deinitialization path.

Signed-off-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index c3fe39b..7c7de43 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -60,6 +60,7 @@
 #include <linux/efi.h>
 #include <asm/string.h>
 #include <scsi/scsi_host.h>
+#include "host.h"
 #include "isci.h"
 #include "task.h"
 #include "probe_roms.h"
@@ -553,9 +554,9 @@ static void __devexit isci_pci_remove(struct pci_dev *pdev)
 	int i;
 
 	for_each_isci_host(i, ihost, pdev) {
+		wait_for_start(ihost);
 		isci_unregister(ihost);
 		isci_host_deinit(ihost);
-		sci_controller_disable_interrupts(ihost);
 	}
 }
 

