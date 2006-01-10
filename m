From: Ashutosh Naik <ashutosh.naik@gmail.com>
Subject: [PATCH] scsi/aha1740.c Handle scsi_add_host failure
Date: Tue, 10 Jan 2006 17:51:15 +0530
Message-ID: <81083a450601100421t5f8fcc4am2c0ec666feccc4ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_92_15703604.1136895675020"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.207]:7144 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750751AbWAJMVP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 07:21:15 -0500
Received: by zproxy.gmail.com with SMTP id 14so4501169nzn
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 04:21:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>

------=_Part_92_15703604.1136895675020
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Add scsi_add_host() failure handling for Adaptec aha1740 driver.

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>

------=_Part_92_15703604.1136895675020
Content-Type: text/plain; name=aha1740.txt; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="aha1740.txt"

diff -Naurp linux-2.6.15-git5-vanilla/drivers/scsi/aha1740.c linux-2.6.15-git5/drivers/scsi/aha1740.c
--- linux-2.6.15-git5-vanilla/drivers/scsi/aha1740.c	2006-01-03 08:51:10.000000000 +0530
+++ linux-2.6.15-git5/drivers/scsi/aha1740.c	2006-01-10 16:22:13.000000000 +0530
@@ -587,7 +587,7 @@ static struct scsi_host_template aha1740
 
 static int aha1740_probe (struct device *dev)
 {
-	int slotbase;
+	int slotbase, retval;
 	unsigned int irq_level, irq_type, translation;
 	struct Scsi_Host *shpnt;
 	struct aha1740_hostdata *host;
@@ -642,7 +642,13 @@ static int aha1740_probe (struct device 
 	}
 
 	eisa_set_drvdata (edev, shpnt);
-	scsi_add_host (shpnt, dev); /* XXX handle failure */
+	retval = scsi_add_host (shpnt, dev);
+	if (retval) {
+		printk(KERN_WARNING "aha1740: scsi_add_host failed\n");
+		scsi_host_put (shpnt);
+		return retval;
+	}
+		
 	scsi_scan_host (shpnt);
 	return 0;
 

------=_Part_92_15703604.1136895675020--
