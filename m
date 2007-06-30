From: "Anil K. Ravindranath" <anil_ravindranath@adaptec.com>
Subject: [PATCH] aic7xxx driver. Restrict DMA to 32bit for 29320LPE Adaptec
	SCSI controller
Date: Sat, 30 Jun 2007 05:45:51 -0700
Message-ID: <1183207551.14436.15.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:36271 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbXF3WFR (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Sat, 30 Jun 2007 18:05:17 -0400
Received: from aime2k302.adaptec.com (aime2k302.adaptec.com [10.25.8.48])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 92E661B6A7C
	for <Linux-scsi@vger.kernel.org>; Sat, 30 Jun 2007 15:05:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org
Cc: "Anil K. Ravindranath" <anil_ravindranath@adaptec.com>

Subject: [PATCH] aic7xxx driver. Restrict DMA to 32bit for 29320LPE
Adaptec SCSI controller

Contribution:

Anil Ravindranath <anil_ravindranath@adaptec.com>

Issue:

Data Bursts that cross from 32- to 64-Bit address space have incorrect
address for 29320LPE. This leads to potential data corruption.

Fix:

Restrict DMA to 32bit so that it does not cross 4GB boundary.

Change Log:

Restrict DMA to 32bit for 29320LPE so that it does not cross 4GB
boundary

Patch: apply to scsi-misc-2.6.git development tree

Signed off By:  Anil Ravindranath <anil_ravindranath@adaptec.com>

diff -urN a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c    2007-06-30
05:24:08.000000000 -0700
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c    2007-06-30
05:25:40.000000000 -0700
@@ -161,7 +161,10 @@
        }
        pci_set_master(pdev);

-       if (sizeof(dma_addr_t) > 4) {
+       /*
+        * Restrict DMA to 32bit for 29320LPE
+        */
+       if ((sizeof(dma_addr_t) > 4) && (entry->full_id !=
ID_AHA_29320LPE)) {
                const u64 required_mask = dma_get_required_mask(dev);

                if (required_mask > DMA_39BIT_MASK &&



diffstat output:

aic79xx_osm_pci.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

With regards,
  Anil
