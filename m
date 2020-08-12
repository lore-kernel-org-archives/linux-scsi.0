Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90922C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 698982076C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHLUzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 16:55:04 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:31619 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgHLUzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Aug 2020 16:55:04 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 12 Aug 2020 13:54:59 -0700
Received: from petr-dev3.eng.vmware.com (petr-dev2.eng.vmware.com [10.20.78.5])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id E672CB2441;
        Wed, 12 Aug 2020 16:55:02 -0400 (EDT)
Received: by petr-dev3.eng.vmware.com (Postfix, from userid 1078)
        id E136BA00680; Wed, 12 Aug 2020 13:55:02 -0700 (PDT)
Date:   Wed, 12 Aug 2020 13:55:02 -0700
From:   Jim Gill <jgill@vmware.com>
To:     <pv-drivers@vmware.com>
CC:     <jgill@vmware.com>, <jejb@ibm.linux.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/3 for-next] pvscsi: Limit ring pages for swiotlb
Message-ID: <20200812205502.GA18382@petr-dev3.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Received-SPF: None (EX13-EDG-OU-002.vmware.com: jgill@vmware.com does not
 designate permitted sender hosts)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A large number of outstanding scsi commands can
 completely fill up the allowable DMA size. Typically this happens with
 SWIOTLB and SEV encryption active. While this is harmless for the scsi middle
 layer, it floods the kernel log with error messages and can cause other
 device drivers to error. Reduce the number of ring pages to 1 if we detect
 DMA size restrictions.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
[jgill@vmware.com: Forwarding patch on behalf of thellstrom]
Acked-by: jgill@vmware.com
---
 drivers/scsi/vmw_pvscsi.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 0573e94..fa2748f 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -28,6 +28,7 @@
 #include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/dmapool.h>
+#include <linux/mem_encrypt.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -45,6 +46,7 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(PVSCSI_DRIVER_VERSION_STRING);
 
 #define PVSCSI_DEFAULT_NUM_PAGES_PER_RING	8
+#define PVSCSI_RESTRICT_NUM_PAGES_PER_RING      1
 #define PVSCSI_DEFAULT_NUM_PAGES_MSG_RING	1
 #define PVSCSI_DEFAULT_QUEUE_DEPTH		254
 #define SGL_SIZE				PAGE_SIZE
@@ -1416,14 +1418,26 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	max_id = pvscsi_get_max_targets(adapter);
 	printk(KERN_INFO "vmw_pvscsi: max_id: %u\n", max_id);
 
-	if (pvscsi_ring_pages == 0)
-		/*
-		 * Set the right default value. Up to 16 it is 8, above it is
-		 * max.
-		 */
-		pvscsi_ring_pages = (max_id > 16) ?
-			PVSCSI_SETUP_RINGS_MAX_NUM_PAGES :
-			PVSCSI_DEFAULT_NUM_PAGES_PER_RING;
+	if (pvscsi_ring_pages == 0) {
+		struct sysinfo si;
+
+		si_meminfo(&si);
+		if (mem_encrypt_active())
+			/*
+			 * There are DMA size restrictions. Reduce the queue
+			 * depth to try to avoid exhausting DMA size and trigger
+			 * dma mapping errors.
+			 */
+			pvscsi_ring_pages = PVSCSI_RESTRICT_NUM_PAGES_PER_RING;
+		else
+			/*
+			 * Set the right default value. Up to 16 it is 8,
+			 * above it is max.
+			 */
+			pvscsi_ring_pages = (max_id > 16) ?
+				PVSCSI_SETUP_RINGS_MAX_NUM_PAGES :
+				PVSCSI_DEFAULT_NUM_PAGES_PER_RING;
+	}
 	printk(KERN_INFO
 	       "vmw_pvscsi: setting ring_pages to %d\n",
 	       pvscsi_ring_pages);
-- 
2.7.4

