From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] Correct removal of procfs host enteries [2/2]
Date: Fri, 1 Aug 2003 13:11:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030801201149.GC3868@beaverton.ibm.com>
References: <20030801201020.GB3868@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:3069 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S270652AbTHAUH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2003 16:07:59 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e35.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h71K7wc8267580
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 16:07:58 -0400
Received: from dyn9-47-17-195 (DYN318028BLD.beaverton.ibm.com [9.47.17.91] (may be forged))
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h71K7vAp087324
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 14:07:57 -0600
Content-Disposition: inline
In-Reply-To: <20030801201020.GB3868@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This patch reduces the user of scsi_host present.

aic79xx_osm and aic7xxx_osm are 2.4 code. ioctl_probe has side effect of
needing present value.
EDESC


 drivers/scsi/NCR53c406a.c    |    5 +++--
 drivers/scsi/aacraid/linit.c |    1 -
 drivers/scsi/scsi_module.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/NCR53c406a.c~shost_present drivers/scsi/NCR53c406a.c
--- patched-scsi-misc-2.5/drivers/scsi/NCR53c406a.c~shost_present	Thu Jul 31 14:32:16 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/NCR53c406a.c	Thu Jul 31 14:32:16 2003
@@ -450,6 +450,7 @@ static __inline__ int NCR53c406a_pio_wri
 
 static int __init NCR53c406a_detect(Scsi_Host_Template * tpnt)
 {
+	int present = 0;
 	struct Scsi_Host *shpnt = NULL;
 #ifndef PORT_BASE
 	int i;
@@ -522,7 +523,7 @@ static int __init NCR53c406a_detect(Scsi
 
 	DEB(printk("NCR53c406a: using port_base 0x%x\n", port_base));
 
-	tpnt->present = 1;
+	present = 1;
 	tpnt->proc_name = "NCR53c406a";
 
 	shpnt = scsi_register(tpnt, 0);
@@ -576,7 +577,7 @@ static int __init NCR53c406a_detect(Scsi
 	sprintf(info_msg, "NCR53c406a at 0x%x, IRQ %d, %s PIO mode.", port_base, irq_level, fast_pio ? "fast" : "slow");
 #endif
 
-	return (tpnt->present);
+	return (present);
 
 #if USE_DMA
       err_free_irq:
diff -puN drivers/scsi/aacraid/linit.c~shost_present drivers/scsi/aacraid/linit.c
--- patched-scsi-misc-2.5/drivers/scsi/aacraid/linit.c~shost_present	Thu Jul 31 14:32:16 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/aacraid/linit.c	Thu Jul 31 14:32:16 2003
@@ -295,7 +295,6 @@ static int aac_detect(Scsi_Host_Template
 			printk(KERN_WARNING "aacraid: unable to register \"aac\" device.\n");
 	}
 
-	template->present = aac_count; /* # of cards of this type found */
 	return aac_count;
 }
 
diff -puN drivers/scsi/scsi_module.c~shost_present drivers/scsi/scsi_module.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_module.c~shost_present	Thu Jul 31 14:32:16 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_module.c	Thu Jul 31 14:32:16 2003
@@ -33,7 +33,7 @@ static int __init init_this_scsi_driver(
 	INIT_LIST_HEAD(&sht->legacy_hosts);
 
 	sht->detect(sht);
-	if (!sht->present)
+	if (list_empty(&sht->legacy_hosts))
 		return -ENODEV;
 
 	list_for_each_entry(shost, &sht->legacy_hosts, sht_legacy_list) {

_

