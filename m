From: willy@parisc-linux.org (Matthew Wilcox)
Subject: [PATCH] [2/5] Improve 53c700 /proc/interrupt output
Date: Fri, 18 Mar 2005 20:56:26 -0700 (MST)
Message-ID: <20050319035626.97A54496108@palinux.hppa>
Received: from palinux.external.hp.com ([192.25.206.14]:49555 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S262389AbVCSD41
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2005 22:56:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Improve 53c700 /proc/interrupt output

Request the IRQ in the name of the chip rather than the bus address.

Signed-off-by: Matthew Wilcox <willy@parisc-linux.org>

diff -urpNX dontdiff linus-2.6/drivers/scsi/53c700.c parisc-2.6/drivers/scsi/53c700.c
--- linus-2.6/drivers/scsi/53c700.c	2005-03-18 06:21:10.744516094 -0700
+++ parisc-2.6/drivers/scsi/53c700.c	2005-03-18 06:02:57.000000000 -0700
@@ -304,6 +304,7 @@ NCR_700_detect(struct scsi_host_template
 	__u8 *memory;
 	__u32 *script;
 	struct Scsi_Host *host;
+	const char *chipname;
 	static int banner = 0;
 	int j;
 
@@ -408,15 +409,15 @@ NCR_700_detect(struct scsi_host_template
 		printk(KERN_NOTICE "53c700: Version " NCR_700_VERSION " By James.Bottomley@HansenPartnership.com\n");
 		banner = 1;
 	}
+	chipname = hostdata->chip710 ? "53c710" : \
+		   (hostdata->fast ? "53c700-66" : "53c700");
 	printk(KERN_NOTICE "scsi%d: %s rev %d %s\n", host->host_no,
-	       hostdata->chip710 ? "53c710" : 
-	       (hostdata->fast ? "53c700-66" : "53c700"),
-	       hostdata->rev, hostdata->differential ?
-	       "(Differential)" : "");
+			chipname, hostdata->rev,
+			hostdata->differential ?  "(Differential)" : "");
 	/* reset the chip */
 	NCR_700_chip_reset(host);
 
-	if (request_irq(irq, NCR_700_intr, SA_SHIRQ, dev->bus_id, host)) {
+	if (request_irq(irq, NCR_700_intr, SA_SHIRQ, chipname, host)) {
 		dev_printk(KERN_ERR, dev, "53c700: irq %lu request failed\n ",
 			   irq);
 		goto out_put_host;
