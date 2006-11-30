From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: aic79xx - wrong max memory at driver init
Date: Thu, 30 Nov 2006 12:07:47 +0100
Message-ID: <456EBB83.9010300@ext.bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090204000606060008050409"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:12772 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S933585AbWK3LH6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Nov 2006 06:07:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: xb <xavier.bru@bull.net>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090204000606060008050409
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

Hello Hannes,

Aic79xx driver for Adaptec 39320 supports 64-bit addressing, but the
initialization code of the driver is wrong: it tests the available
memory size instead of testing the maximum available memory address.
This is necessary to support servers that provides 1 Terabyte of
physical memory space addressing.

Attached is the suggested patch (made against 2.6.17, but 2.6.19 is
still using the available memory size instead of using the max memory
address) to solve this issue.

regards

--
Fred

--------------090204000606060008050409
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="aic-TBytes.patch"
Content-Disposition: inline;
 filename="aic-TBytes.patch"

Signed-off-by: xavier.bru@bull.net
Signed-off-by: frederic.temporelli@bull.net

--- linux/drivers/scsi/aic7xxx/aic79xx_osm.c    2006-08-23 23:16:33.000000000 +0200
+++ linux-new/drivers/scsi/aic7xxx/aic79xx_osm.c        2006-09-14 16:44:24.000000000 +0200
@@ -62,6 +62,7 @@

 #include <linux/mm.h>          /* For fetching system memory size */

+extern unsigned long blk_max_pfn;
 static struct scsi_transport_template *ahd_linux_transport_template = NULL;

 #include <linux/init.h>                /* __setup */
@@ -1175,10 +1176,9 @@ ahd_linux_register_host(struct ahd_softc
 uint64_t
 ahd_linux_get_memsize(void)
 {
-       struct sysinfo si;
-
-       si_meminfo(&si);
-       return ((uint64_t)si.totalram << PAGE_SHIFT);
+       /* Need to take in account the max physical address in case
+        * of discontiguous memory. */
+       return ((uint64_t)blk_max_pfn << PAGE_SHIFT);
 }

 /*


--------------090204000606060008050409--
