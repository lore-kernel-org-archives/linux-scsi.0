From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC] scsi host sysfs support again [1/4]
Date: Mon, 5 May 2003 01:34:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505083445.GC8416@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:60390 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262041AbTEEITx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 04:19:53 -0400
Content-Disposition: inline
In-Reply-To: <20030505083315.GB8416@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>


-andmike
--
Michael Anderson
andmike@us.ibm.com

DESC
This patch removes the shost_devclass device class support that was
previously added, but incomplete.
EDESC


 drivers/acorn/scsi/acornscsi.c |    1 -
 drivers/acorn/scsi/arxescsi.c  |    1 -
 drivers/acorn/scsi/cumana_1.c  |    1 -
 drivers/acorn/scsi/cumana_2.c  |    1 -
 drivers/acorn/scsi/eesox.c     |    1 -
 drivers/acorn/scsi/oak.c       |    1 -
 drivers/acorn/scsi/powertec.c  |    1 -
 drivers/scsi/scsi_sysfs.c      |   23 -----------------------
 8 files changed, 30 deletions(-)

diff -puN drivers/acorn/scsi/acornscsi.c~shost-devclass-clean drivers/acorn/scsi/acornscsi.c
--- sysfs-scsi-misc-2.5/drivers/acorn/scsi/acornscsi.c~shost-devclass-clean	Thu May  1 17:59:24 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/acorn/scsi/acornscsi.c	Thu May  1 17:59:24 2003
@@ -3110,7 +3110,6 @@ static struct ecard_driver acornscsi_dri
 	.remove		= __devexit_p(acornscsi_remove),
 	.id_table	= acornscsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "acornscsi",
 	},
 };
diff -puN drivers/acorn/scsi/arxescsi.c~shost-devclass-clean drivers/acorn/scsi/arxescsi.c
--- sysfs-scsi-misc-2.5/drivers/acorn/scsi/arxescsi.c~shost-devclass-clean	Thu May  1 17:59:24 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/acorn/scsi/arxescsi.c	Thu May  1 17:59:24 2003
@@ -397,7 +397,6 @@ static struct ecard_driver arxescsi_driv
 	.remove		= __devexit_p(arxescsi_remove),
 	.id_table	= arxescsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "arxescsi",
 	},
 };
diff -puN drivers/acorn/scsi/cumana_1.c~shost-devclass-clean drivers/acorn/scsi/cumana_1.c
--- sysfs-scsi-misc-2.5/drivers/acorn/scsi/cumana_1.c~shost-devclass-clean	Thu May  1 17:59:24 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/acorn/scsi/cumana_1.c	Thu May  1 17:59:24 2003
@@ -334,7 +334,6 @@ static struct ecard_driver cumanascsi1_d
 	.remove		= __devexit_p(cumanascsi1_remove),
 	.id_table	= cumanascsi1_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "cumanascsi1",
 	},
 };
diff -puN drivers/acorn/scsi/cumana_2.c~shost-devclass-clean drivers/acorn/scsi/cumana_2.c
--- sysfs-scsi-misc-2.5/drivers/acorn/scsi/cumana_2.c~shost-devclass-clean	Thu May  1 17:59:24 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/acorn/scsi/cumana_2.c	Thu May  1 17:59:24 2003
@@ -572,7 +572,6 @@ static struct ecard_driver cumanascsi2_d
 	.remove		= __devexit_p(cumanascsi2_remove),
 	.id_table	= cumanascsi2_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "cumanascsi2",
 	},
 };
diff -puN drivers/acorn/scsi/eesox.c~shost-devclass-clean drivers/acorn/scsi/eesox.c
--- sysfs-scsi-misc-2.5/drivers/acorn/scsi/eesox.c~shost-devclass-clean	Thu May  1 17:59:24 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/acorn/scsi/eesox.c	Thu May  1 17:59:24 2003
@@ -679,7 +679,6 @@ static struct ecard_driver eesoxscsi_dri
 	.remove		= __devexit_p(eesoxscsi_remove),
 	.id_table	= eesoxscsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "eesoxscsi",
 	},
 };
diff -puN drivers/acorn/scsi/oak.c~shost-devclass-clean drivers/acorn/scsi/oak.c
--- sysfs-scsi-misc-2.5/drivers/acorn/scsi/oak.c~shost-devclass-clean	Thu May  1 17:59:24 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/acorn/scsi/oak.c	Thu May  1 17:59:24 2003
@@ -192,7 +192,6 @@ static struct ecard_driver oakscsi_drive
 	.remove		= __devexit_p(oakscsi_remove),
 	.id_table	= oakscsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "oakscsi",
 	},
 };
diff -puN drivers/acorn/scsi/powertec.c~shost-devclass-clean drivers/acorn/scsi/powertec.c
--- sysfs-scsi-misc-2.5/drivers/acorn/scsi/powertec.c~shost-devclass-clean	Thu May  1 17:59:24 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/acorn/scsi/powertec.c	Thu May  1 17:59:24 2003
@@ -475,7 +475,6 @@ static struct ecard_driver powertecscsi_
 	.remove		= __devexit_p(powertecscsi_remove),
 	.id_table	= powertecscsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "powertecscsi",
 	},
 };
diff -puN drivers/scsi/scsi_sysfs.c~shost-devclass-clean drivers/scsi/scsi_sysfs.c
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi_sysfs.c~shost-devclass-clean	Thu May  1 17:59:24 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi_sysfs.c	Thu May  1 17:59:24 2003
@@ -53,29 +53,6 @@ static struct device_attribute *const sh
 	&dev_attr_unchecked_isa_dma,
 };
 
-/**
- * scsi_host_class_name_show - copy out the SCSI host name
- * @dev:		device to check
- * @page:		copy data into this area
- * @count:		number of bytes to copy
- * @off:		start at this offset in page
- * Return:
- *     number of bytes written into page.
- **/
-static ssize_t scsi_host_class_name_show(struct device *dev, char *page)
-{
-	struct Scsi_Host *shost;
-
-	shost = to_scsi_host(dev);
-
-	if (!shost)
-		return 0;
-	
-	return snprintf(page, 20, "scsi%d\n", shost->host_no);
-}
-
-DEVICE_ATTR(class_name, S_IRUGO, scsi_host_class_name_show, NULL);
-
 struct class shost_class = {
 	.name		= "scsi-host",
 };

_

