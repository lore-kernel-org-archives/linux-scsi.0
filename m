From: akpm@linux-foundation.org
Subject: [patch 19/30] drivers/scsi/bvme6000_scsi.c: kmalloc + memset conversion to kzalloc
Date: Fri, 10 Aug 2007 14:50:46 -0700
Message-ID: <200708102150.l7ALokoc011375@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbXHJV7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:59:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/bvme6000_scsi.c | 3330 -> 3253 (-77 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bvme6000_scsi.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/bvme6000_scsi.c~drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc drivers/scsi/bvme6000_scsi.c
--- a/drivers/scsi/bvme6000_scsi.c~drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/scsi/bvme6000_scsi.c
@@ -36,19 +36,18 @@ static struct platform_device *bvme6000_
 static __devinit int
 bvme6000_probe(struct device *dev)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
 
 	if (!MACH_IS_BVME6000)
 		goto out;
 
-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (!hostdata) {
 		printk(KERN_ERR "bvme6000-scsi: "
 				"Failed to allocate host data\n");
 		goto out;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
 
 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)BVME_NCR53C710_BASE;
_
