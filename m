From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [oops] rmmod aic7xyz (2.6.14-rc3 and 2.6.13)
Date: Sun, 02 Oct 2005 09:30:12 -0500
Message-ID: <1128263413.4810.4.camel@mulgrave>
References: <20051001221746.54d26f43.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:29400 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751096AbVJBOai (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Oct 2005 10:30:38 -0400
In-Reply-To: <20051001221746.54d26f43.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-10-01 at 22:17 -0700, Randy.Dunlap wrote:
> trivial to reproduce:
> 
> modprobe aic7xxx
> mount -t ext3 -o data=writeback /dev/sda4 /media/zip
> ls -l /media/zip
> umount /media/zip
> rmmod aic7xxx ---> oops

Heh, this is a big mea culpa.  Ages ago I set up my test systems to have
write back caches.  Of course, since then I've needed drives with more
sophisticated features.  Unfortunately, my sources tend to be enterprise
vendors who'd rather have a hole in their heads than ship drives with
write back caches.  The result being I've slowly migrated back to a
configuration with all write through caches without noticing.  It's
actually been so long it took me a while to work out how to convert them
to having a write back cache.

Anyway, I don't see your panic, but I do see a sequencer error because
the driver is switching off interrupts before calling scsi_remove_host
().

Try the attached (which fixes the problem for me).

James

diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/aic7770_osm.c
--- a/drivers/scsi/aic7xxx/aic7770_osm.c
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c
@@ -112,6 +112,9 @@ aic7770_remove(struct device *dev)
 	struct ahc_softc *ahc = dev_get_drvdata(dev);
 	u_long s;
 
+	if (ahc->platform_data && ahc->platform_data->host)
+			scsi_remove_host(ahc->platform_data->host);
+
 	ahc_lock(ahc, &s);
 	ahc_intr_enable(ahc, FALSE);
 	ahc_unlock(ahc, &s);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1209,11 +1209,6 @@ ahc_platform_free(struct ahc_softc *ahc)
 	int i, j;
 
 	if (ahc->platform_data != NULL) {
-		if (ahc->platform_data->host != NULL) {
-			scsi_remove_host(ahc->platform_data->host);
-			scsi_host_put(ahc->platform_data->host);
-		}
-
 		/* destroy all of the device and target objects */
 		for (i = 0; i < AHC_NUM_TARGETS; i++) {
 			starget = ahc->platform_data->starget[i];
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -143,6 +143,9 @@ ahc_linux_pci_dev_remove(struct pci_dev 
 	struct ahc_softc *ahc = pci_get_drvdata(pdev);
 	u_long s;
 
+	if (ahc->platform_data && ahc->platform_data->host)
+			scsi_remove_host(ahc->platform_data->host);
+
 	ahc_lock(ahc, &s);
 	ahc_intr_enable(ahc, FALSE);
 	ahc_unlock(ahc, &s);


