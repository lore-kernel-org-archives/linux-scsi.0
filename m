From: Jeff Garzik <jgarzik@pobox.com>
Subject: [scsi hcil 5/9] split up __spi_scan_target()
Date: Mon, 24 Oct 2005 18:03:06 -0400
Message-ID: <20051024220306.GE10567@havoc.gtf.org>
References: <20051024220013.GA10070@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:49807 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751341AbVJXWDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:03:07 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id F02531C0A7BA
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:03:06 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OM367N010716
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:03:06 -0400
Content-Disposition: inline
In-Reply-To: <20051024220013.GA10070@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


commit 732f2c555a9778d44905e6dcbcab4caab9a29475
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Mon Oct 24 15:35:30 2005 -0400

    [SCSI] split up __spi_scan_target()
    
    Split up __spi_scan_target() into two logical pieces:
    * struct scsi_target scanning
    * SPI-specific scsi_target allocation
    
    This paves the way for an SPI-independent scsi_scan_target().

 drivers/scsi/scsi_scan.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0cbcbe7..205c89f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1306,23 +1306,11 @@ void scsi_rescan_device(struct device *d
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
-static void __spi_scan_target(struct device *parent, unsigned int channel,
-		unsigned int id, unsigned int lun, int rescan)
+static void __scsi_scan_target(struct scsi_target *starget, unsigned int lun,
+			       int rescan)
 {
-	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
 	int res;
-	struct scsi_target *starget;
-
-	if (shost->this_id == id)
-		/*
-		 * Don't scan the host adapter
-		 */
-		return;
-
-	starget = scsi_alloc_target(parent, channel, id);
-	if (!starget)
-		return;
 
 	get_device(&starget->dev);
 	if (lun != SCAN_WILD_CARD) {
@@ -1356,6 +1344,23 @@ static void __spi_scan_target(struct dev
 	put_device(&starget->dev);
 }
 
+static void __spi_scan_target(struct device *parent, unsigned int channel,
+		unsigned int id, unsigned int lun, int rescan)
+{
+	struct Scsi_Host *shost = dev_to_shost(parent);
+	struct scsi_target *starget;
+
+	if (shost->this_id == id)
+		/*
+		 * Don't scan the host adapter
+		 */
+		return;
+
+	starget = scsi_alloc_target(parent, channel, id);
+	if (starget)
+		__scsi_scan_target(starget, lun, rescan);
+}
+
 /**
  * spi_scan_target - scan a target id, possibly including all LUNs on the
  *     target.
