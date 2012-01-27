From: Dan Williams <dan.j.williams@intel.com>
Subject: [3.3-rc PATCH] isci: Fix NULL ptr dereference when no firmware is
 being loaded
Date: Fri, 27 Jan 2012 11:17:37 -0800
Message-ID: <20120127191643.27551.23976.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41822 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab2A0TRi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2012 14:17:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>, Dan Melnic <dan@seamicro.com>

From: Dave Jiang <dave.jiang@intel.com>

NULL orom ptr passed in for verification which caused page fault.
We will set a default version when we don't have orom struct.

Reported-by: Dan Melnic <dan@seamicro.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 for scsi-fixes / 3.3

 drivers/scsi/isci/host.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 1a65d65..418391b 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1848,9 +1848,11 @@ static enum sci_status sci_oem_parameters_set(struct isci_host *ihost)
 	if (state == SCIC_RESET ||
 	    state == SCIC_INITIALIZING ||
 	    state == SCIC_INITIALIZED) {
+		u8 oem_version = pci_info->orom ? pci_info->orom->hdr.version :
+			ISCI_ROM_VER_1_0;
 
 		if (sci_oem_parameters_validate(&ihost->oem_parameters,
-						pci_info->orom->hdr.version))
+						oem_version))
 			return SCI_FAILURE_INVALID_PARAMETER_VALUE;
 
 		return SCI_SUCCESS;

