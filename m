From: Ashutosh Naik <ashutosh.naik@gmail.com>
Subject: [PATCH] scsi/arm/ecoscsi.c Handle scsi_add_host failure
Date: Tue, 10 Jan 2006 18:11:24 +0530
Message-ID: <81083a450601100441s7675d584jd10db5a8e6ccaf58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_124_2415053.1136896884096"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.197]:30180 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750810AbWAJMlZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 07:41:25 -0500
Received: by zproxy.gmail.com with SMTP id 14so4506085nzn
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 04:41:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk

------=_Part_124_2415053.1136896884096
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Add scsi_add_host() failure handling for ecoscsi driver.

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>

------=_Part_124_2415053.1136896884096
Content-Type: text/plain; name=ecoscsi.txt; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="ecoscsi.txt"

diff -Naurp linux-2.6.15-git5-vanilla/drivers/scsi/arm/ecoscsi.c linux-2.6.15-git5/drivers/scsi/arm/ecoscsi.c
--- linux-2.6.15-git5-vanilla/drivers/scsi/arm/ecoscsi.c	2006-01-03 08:51:10.000000000 +0530
+++ linux-2.6.15-git5/drivers/scsi/arm/ecoscsi.c	2006-01-10 17:59:21.000000000 +0530
@@ -203,7 +203,13 @@ static int __init ecoscsi_init(void)
 	NCR5380_print_options(host);
 	printk("\n");
 
-	scsi_add_host(host, NULL); /* XXX handle failure */
+	retval = scsi_add_host(host, NULL);
+	if (retval) {
+		printk(KERN_WARNING "ecoscsi: scsi_add_host failed\n");
+		scsi_host_put(host);
+		return retval;
+	}
+
 	scsi_scan_host(host);
 	return 0;
 

------=_Part_124_2415053.1136896884096--
