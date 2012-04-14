From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH for 3.4] isci: fix oem parameter validation on single
 controller skus
Date: Fri, 13 Apr 2012 17:41:57 -0700
Message-ID: <20120414003835.8490.48501.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46936 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab2DNA0R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Apr 2012 20:26:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Dave Jiang <dave.jiang@intel.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org

OEM parameters [1] are parsed from the platform option-rom / efi
driver.  By default the driver was validating the parameters for the
dual-controller case, but in single-controller case only the first set
of parameters may be valid.

Limit the validation to the number of actual controllers detected
otherwise the driver may fail to parse the valid parameters leading to
driver-load or runtime failures.

[1] the platform specific set of phy address, configuration,and analog
    tuning values

[stable v3.0+]
Cc: <stable@vger.kernel.org>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 James,

 Since this is a one liner and no other isci regression fixes pending
 I'm just sending the patch and not creating a signed tag for it.

 --
 Dan

 drivers/scsi/isci/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 5137db5..bc6cf88 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -476,7 +476,7 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
 	if (!orom)
 		orom = isci_request_oprom(pdev);
 
-	for (i = 0; orom && i < ARRAY_SIZE(orom->ctrl); i++) {
+	for (i = 0; orom && i < num_controllers(pdev); i++) {
 		if (sci_oem_parameters_validate(&orom->ctrl[i],
 						orom->hdr.version)) {
 			dev_warn(&pdev->dev,

