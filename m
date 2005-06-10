From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: remove ahc_find_softc
Date: Sat, 11 Jun 2005 00:14:30 +0200
Message-ID: <20050610221430.GB8706@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:57779 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261279AbVFJWOc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 18:14:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

there's absolutely no reason not to trust the driver private data


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx.h	2005-06-03 16:52:52.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx.h	2005-06-03 16:52:59.000000000 +0200
@@ -1199,7 +1199,6 @@
 int			 ahc_suspend(struct ahc_softc *ahc); 
 int			 ahc_resume(struct ahc_softc *ahc);
 void			 ahc_softc_insert(struct ahc_softc *);
-struct ahc_softc	*ahc_find_softc(struct ahc_softc *ahc);
 void			 ahc_set_unit(struct ahc_softc *, int);
 void			 ahc_set_name(struct ahc_softc *, char *);
 void			 ahc_alloc_scbs(struct ahc_softc *ahc);
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-03 16:51:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-03 16:52:59.000000000 +0200
@@ -140,27 +140,17 @@
 static void
 ahc_linux_pci_dev_remove(struct pci_dev *pdev)
 {
-	struct ahc_softc *ahc;
-	u_long l;
+	struct ahc_softc *ahc = pci_get_drvdata(pdev);
+	u_long s;
 
-	/*
-	 * We should be able to just perform
-	 * the free directly, but check our
-	 * list for extra sanity.
-	 */
-	ahc_list_lock(&l);
-	ahc = ahc_find_softc((struct ahc_softc *)pci_get_drvdata(pdev));
-	if (ahc != NULL) {
-		u_long s;
-
-		TAILQ_REMOVE(&ahc_tailq, ahc, links);
-		ahc_list_unlock(&l);
-		ahc_lock(ahc, &s);
-		ahc_intr_enable(ahc, FALSE);
-		ahc_unlock(ahc, &s);
-		ahc_free(ahc);
-	} else
-		ahc_list_unlock(&l);
+	ahc_list_lock(&s);
+	TAILQ_REMOVE(&ahc_tailq, ahc, links);
+	ahc_list_unlock(&s);
+
+	ahc_lock(ahc, &s);
+	ahc_intr_enable(ahc, FALSE);
+	ahc_unlock(ahc, &s);
+	ahc_free(ahc);
 }
 
 static int
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_core.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_core.c	2005-06-03 16:51:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_core.c	2005-06-03 16:53:00.000000000 +0200
@@ -3934,22 +3934,6 @@
 	ahc->init_level++;
 }
 
-/*
- * Verify that the passed in softc pointer is for a
- * controller that is still configured.
- */
-struct ahc_softc *
-ahc_find_softc(struct ahc_softc *ahc)
-{
-	struct ahc_softc *list_ahc;
-
-	TAILQ_FOREACH(list_ahc, &ahc_tailq, links) {
-		if (list_ahc == ahc)
-			return (ahc);
-	}
-	return (NULL);
-}
-
 void
 ahc_set_unit(struct ahc_softc *ahc, int unit)
 {
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_proc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_proc.c	2005-06-03 16:51:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_proc.c	2005-06-03 16:53:00.000000000 +0200
@@ -297,20 +297,13 @@
 ahc_linux_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		    off_t offset, int length, int inout)
 {
-	struct	ahc_softc *ahc;
+	struct	ahc_softc *ahc = *(struct ahc_softc **)shost->hostdata;
 	struct	info_str info;
 	char	ahc_info[256];
-	u_long	s;
 	u_int	max_targ;
 	u_int	i;
 	int	retval;
 
-	retval = -EINVAL;
-	ahc_list_lock(&s);
-	ahc = ahc_find_softc(*(struct ahc_softc **)shost->hostdata);
-	if (ahc == NULL)
-		goto done;
-
 	 /* Has data been written to the file? */ 
 	if (inout == TRUE) {
 		retval = ahc_proc_write_seeprom(ahc, buffer, length);
@@ -372,6 +365,5 @@
 	}
 	retval = info.pos > info.offset ? info.pos - info.offset : 0;
 done:
-	ahc_list_unlock(&s);
 	return (retval);
 }
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7770_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7770_osm.c	2005-06-03 16:52:00.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7770_osm.c	2005-06-03 16:53:54.000000000 +0200
@@ -190,25 +190,13 @@
 static int
 aic7770_eisa_dev_remove(struct device *dev)
 {
-	struct ahc_softc *ahc;
-	u_long l;
+	struct ahc_softc *ahc = dev_get_drvata(dev);
+	u_long s;
 
-	/*
-	 * We should be able to just perform
-	 * the free directly, but check our
-	 * list for extra sanity.
-	 */
-	ahc_list_lock(&l);
-	ahc = ahc_find_softc((struct ahc_softc *)dev->driver_data);
-	if (ahc != NULL) {
-		u_long s;
-
-		ahc_lock(ahc, &s);
-		ahc_intr_enable(ahc, FALSE);
-		ahc_unlock(ahc, &s);
-		ahc_free(ahc);
-	}
-	ahc_list_unlock(&l);
+	ahc_lock(ahc, &s);
+	ahc_intr_enable(ahc, FALSE);
+	ahc_unlock(ahc, &s);
+	ahc_free(ahc);
 
 	return (0);
 }
