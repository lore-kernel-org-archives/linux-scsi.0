From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: aic79xx: Unregister pci before failing module_init
Date: Sat, 1 May 2004 21:21:12 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040501112112.GA4677@gondor.apana.org.au>
References: <200404270501.i3R51h207741@mail.osdl.org> <20040501110425.GA29776@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from arnor.apana.org.au ([203.14.152.115]:17164 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S261624AbUEALVb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 May 2004 07:21:31 -0400
Content-Disposition: inline
In-Reply-To: <20040501110425.GA29776@gondor.apana.org.au>
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, gibbs@scsiguy.com, linux-scsi@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi:

I forgot to fix aic79xx's init code when no. devices found == 0.
Here is the same fix that was applied to aic7xxx.

Cheers,
-- 
Debian GNU/Linux 3.0 is out! ( http://www.debian.org/ )
Email:  Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=p

Index: drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
RCS file: /home/gondolin/herbert/src/CVS/debian/kernel-source-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c,v
retrieving revision 1.1.1.14
diff -u -r1.1.1.14 aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c	11 Mar 2004 02:55:28 -0000	1.1.1.14
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c	1 May 2004 11:15:23 -0000
@@ -906,9 +906,9 @@
 	 */
 	ahd_list_lockinit();
 
-#ifdef CONFIG_PCI
-	ahd_linux_pci_init();
-#endif
+	found = ahd_linux_pci_init();
+	if (found)
+		goto pci_err;
 
 	/*
 	 * Register with the SCSI layer all
@@ -924,6 +924,13 @@
 	spin_lock_irq(&io_request_lock);
 #endif
 	aic79xx_detect_complete++;
+
+	if (!found) {
+		found = -ENODEV;
+		ahd_linux_pci_exit();
+	}
+
+pci_err:
 	return (found);
 }
 
@@ -5077,7 +5084,7 @@
 ahd_linux_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-       return (ahd_linux_detect(&aic79xx_driver_template) ? 0 : -ENODEV);
+	return ahd_linux_detect(&aic79xx_driver_template);
 #else
 	scsi_register_module(MODULE_SCSI_HA, &aic79xx_driver_template);
 	if (aic79xx_driver_template.present == 0) {

--azLHFNyN32YCQGCU--
