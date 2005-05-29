From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/4] aic7xxx/aic79xx: call scsi_set_device()
Date: Sun, 29 May 2005 03:40:29 -0400
Message-ID: <20050529074029.GA25962@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlmail.prod.rxgsys.com ([69.61.70.25]:22921 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S261265AbVE2Hkf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 03:40:35 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by bastet.signetmail.com (RXG Elite Mail Server) with ESMTP id BBD7DA883F
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 02:19:47 -0400 (EDT)
Received: from bastet.signetmail.com ([127.0.0.1])
 by localhost (atlmail.prod.rxgsys.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30283-07 for <linux-scsi@vger.kernel.org>;
 Sun, 29 May 2005 02:19:44 -0400 (EDT)
Received: from havoc.gtf.org (havoc.gtf.org [63.115.148.101])
	by bastet.signetmail.com (RXG Elite Mail Server) with ESMTP id 69A50A8818
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 02:19:43 -0400 (EDT)
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 78CB61C1E97D
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 03:40:29 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j4T7eTQe025968
	for linux-scsi@vger.kernel.org; Sun, 29 May 2005 03:40:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



[note:  just for review...  do not apply, will be submitted later via git]

author Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 06:47:07 -0400
committer Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 06:47:07 -0400

[SCSI] aic7xxx/aic79xx: call scsi_set_device()

The 2.4.x version correctly called scsi_set_pci_device(), but the
author missed the corresponding 2.6.x scsi_set_device() change.

This requires moving the definition of pci_dev_to_dev() from
include/linux/libata.h to include/linux/pci.h.

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2022,6 +2022,8 @@ ahd_linux_register_host(struct ahd_softc
 	host->unique_id = ahd->unit;
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	scsi_set_pci_device(host, ahd->dev_softc);
+#else
+	scsi_set_device(host, pci_dev_to_dev(ahd->dev_softc));
 #endif
 	ahd_linux_setup_user_rd_strm_settings(ahd);
 	ahd_linux_initialize_scsi_bus(ahd);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1196,6 +1196,7 @@ ahc_linux_register_host(struct ahc_softc
 		ahc_set_name(ahc, new_name);
 	}
 	host->unique_id = ahc->unit;
+	scsi_set_device(host, pci_dev_to_dev(ahc->dev_softc));
 	ahc_linux_initialize_scsi_bus(ahc);
 	ahc_intr_enable(ahc, TRUE);
 	ahc_unlock(ahc, &s);
diff --git a/include/linux/libata.h b/include/linux/libata.h
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -69,12 +69,6 @@
 /* defines only for the constants which don't work well as enums */
 #define ATA_TAG_POISON		0xfafbfcfdU
 
-/* move to PCI layer? */
-static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
-{
-	return &pdev->dev;
-}
-
 enum {
 	/* various global constants */
 	LIBATA_MAX_PRD		= ATA_MAX_PRD / 2,
diff --git a/include/linux/pci.h b/include/linux/pci.h
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -573,6 +573,11 @@ struct pci_dev {
 #define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
 #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
 
+static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
+{
+	return &pdev->dev;
+}
+
 /*
  *  For PCI devices, the region numbers are assigned this way:
  *
