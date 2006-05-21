From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Serial Console capture
Date: Sun, 21 May 2006 12:07:44 -0500
Message-ID: <1148231265.17239.17.camel@mulgrave.il.steeleye.com>
References: <BAY112-F171BA6C2D4226546E27C7EA0A50@phx.gbl>
	 <1148225428.17239.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16820 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751432AbWEURHr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 May 2006 13:07:47 -0400
In-Reply-To: <1148225428.17239.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mun Hamlet <hamletmun@hotmail.com>
Cc: linux-scsi@vger.kernel.org

OK, try this ... I think it will correct for the Western Digital
problem.

James

diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 91d294c..5ba306c 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -233,6 +233,7 @@ typedef enum {
 	AHC_TARGETMODE	= 0x20000,	/* Has tested target mode support */
 	AHC_MULTIROLE	= 0x40000,	/* Space for two roles at a time */
 	AHC_REMOVABLE	= 0x80000,	/* Hot-Swap supported */
+	AHC_HVD		= 0x100000,	/* HVD rather than SE */
 	AHC_AIC7770_FE	= AHC_FENONE,
 	/*
 	 * The real 7850 does not support Ultra modes, but there are
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 2c80167..cb4269f 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2537,6 +2537,22 @@ static void ahc_linux_set_iu(struct scsi
 }
 #endif
 
+static void ahc_linux_get_signalling(struct Scsi_Host *shost)
+{
+	struct ahc_softc *ahc = *(struct ahc_softc **)shost->hostdata;
+	u8 mode = ahc_inb(ahc, SBLKCTL);
+
+	if (mode & ENAB40)
+		spi_signalling(shost) = SPI_SIGNAL_LVD;
+	else if (mode & ENAB20)
+		spi_signalling(shost) = 
+			ahc->features & AHC_HVD ?
+			SPI_SIGNAL_HVD :
+			SPI_SIGNAL_SE;
+	else
+		spi_signalling(shost) = SPI_SIGNAL_UNKNOWN;
+}
+
 static struct spi_function_template ahc_linux_transport_functions = {
 	.set_offset	= ahc_linux_set_offset,
 	.show_offset	= 1,
@@ -2552,6 +2568,7 @@ #if 0
 	.set_qas	= ahc_linux_set_qas,
 	.show_qas	= 1,
 #endif
+	.get_signalling	= ahc_linux_get_signalling,
 };
 
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index 3adecef..aee106b 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -144,16 +144,22 @@ static ahc_device_setup_t ahc_aic785X_se
 static ahc_device_setup_t ahc_aic7860_setup;
 static ahc_device_setup_t ahc_apa1480_setup;
 static ahc_device_setup_t ahc_aic7870_setup;
+static ahc_device_setup_t ahc_aic7870h_setup;
 static ahc_device_setup_t ahc_aha394X_setup;
+static ahc_device_setup_t ahc_aha394Xh_setup;
 static ahc_device_setup_t ahc_aha494X_setup;
+static ahc_device_setup_t ahc_aha494Xh_setup;
 static ahc_device_setup_t ahc_aha398X_setup;
 static ahc_device_setup_t ahc_aic7880_setup;
+static ahc_device_setup_t ahc_aic7880h_setup;
 static ahc_device_setup_t ahc_aha2940Pro_setup;
 static ahc_device_setup_t ahc_aha394XU_setup;
+static ahc_device_setup_t ahc_aha394XUh_setup;
 static ahc_device_setup_t ahc_aha398XU_setup;
 static ahc_device_setup_t ahc_aic7890_setup;
 static ahc_device_setup_t ahc_aic7892_setup;
 static ahc_device_setup_t ahc_aic7895_setup;
+static ahc_device_setup_t ahc_aic7895h_setup;
 static ahc_device_setup_t ahc_aic7896_setup;
 static ahc_device_setup_t ahc_aic7899_setup;
 static ahc_device_setup_t ahc_aha29160C_setup;
@@ -225,19 +231,19 @@ struct ahc_pci_identity ahc_pci_ident_ta
 		ID_AHA_2944,
 		ID_ALL_MASK,
 		"Adaptec 2944 SCSI adapter",
-		ahc_aic7870_setup
+		ahc_aic7870h_setup
 	},
 	{
 		ID_AHA_3944,
 		ID_ALL_MASK,
 		"Adaptec 3944 SCSI adapter",
-		ahc_aha394X_setup
+		ahc_aha394Xh_setup
 	},
 	{
 		ID_AHA_4944,
 		ID_ALL_MASK,
 		"Adaptec 4944 SCSI adapter",
-		ahc_aha494X_setup
+		ahc_aha494Xh_setup
 	},
 	/* aic7880 based controllers */
 	{
@@ -256,13 +262,13 @@ struct ahc_pci_identity ahc_pci_ident_ta
 		ID_AHA_2944U & ID_DEV_VENDOR_MASK,
 		ID_DEV_VENDOR_MASK,
 		"Adaptec 2944 Ultra SCSI adapter",
-		ahc_aic7880_setup
+		ahc_aic7880h_setup
 	},
 	{
 		ID_AHA_3944U & ID_DEV_VENDOR_MASK,
 		ID_DEV_VENDOR_MASK,
 		"Adaptec 3944 Ultra SCSI adapter",
-		ahc_aha394XU_setup
+		ahc_aha394XUh_setup
 	},
 	{
 		ID_AHA_398XU & ID_DEV_VENDOR_MASK,
@@ -278,7 +284,7 @@ struct ahc_pci_identity ahc_pci_ident_ta
 		ID_AHA_4944U & ID_DEV_VENDOR_MASK,
 		ID_DEV_VENDOR_MASK,
 		"Adaptec 4944 Ultra SCSI adapter",
-		ahc_aic7880_setup
+		ahc_aic7880h_setup
 	},
 	{
 		ID_AHA_2930U & ID_DEV_VENDOR_MASK,
@@ -414,7 +420,7 @@ struct ahc_pci_identity ahc_pci_ident_ta
 		ID_AHA_3944AU,
 		ID_ALL_MASK,
 		"Adaptec 3944A Ultra SCSI adapter",
-		ahc_aic7895_setup
+		ahc_aic7895h_setup
 	},
 	{
 		ID_AIC7895_ARO,
@@ -2121,6 +2127,16 @@ ahc_aic7870_setup(struct ahc_softc *ahc)
 }
 
 static int
+ahc_aic7870h_setup(struct ahc_softc *ahc)
+{
+	int error = ahc_aic7870_setup(ahc);
+
+	ahc->features |= AHC_HVD;
+
+	return error;
+}
+
+static int
 ahc_aha394X_setup(struct ahc_softc *ahc)
 {
 	int error;
@@ -2132,6 +2148,16 @@ ahc_aha394X_setup(struct ahc_softc *ahc)
 }
 
 static int
+ahc_aha394Xh_setup(struct ahc_softc *ahc)
+{
+	int error = ahc_aha394X_setup(ahc);
+
+	ahc->features |= AHC_HVD;
+
+	return error;
+}
+
+static int
 ahc_aha398X_setup(struct ahc_softc *ahc)
 {
 	int error;
@@ -2154,6 +2180,16 @@ ahc_aha494X_setup(struct ahc_softc *ahc)
 }
 
 static int
+ahc_aha494Xh_setup(struct ahc_softc *ahc)
+{
+	int error = ahc_aha494X_setup(ahc);
+
+	ahc->features |= AHC_HVD;
+
+	return error;
+}
+
+static int
 ahc_aic7880_setup(struct ahc_softc *ahc)
 {
 	ahc_dev_softc_t pci;
@@ -2175,6 +2211,17 @@ ahc_aic7880_setup(struct ahc_softc *ahc)
 }
 
 static int
+ahc_aic7880h_setup(struct ahc_softc *ahc)
+{
+	int error = ahc_aic7880_setup(ahc);
+
+	ahc->features |= AHC_HVD;
+
+	return error;
+}
+
+
+static int
 ahc_aha2940Pro_setup(struct ahc_softc *ahc)
 {
 
@@ -2194,6 +2241,16 @@ ahc_aha394XU_setup(struct ahc_softc *ahc
 }
 
 static int
+ahc_aha394XUh_setup(struct ahc_softc *ahc)
+{
+	int error = ahc_aha394XU_setup(ahc);
+
+	ahc->features |= AHC_HVD;
+
+	return error;
+}
+
+static int
 ahc_aha398XU_setup(struct ahc_softc *ahc)
 {
 	int error;
@@ -2292,6 +2349,16 @@ #endif
 }
 
 static int
+ahc_aic7895h_setup(struct ahc_softc *ahc)
+{
+	int error = ahc_aic7895_setup(ahc);
+
+	ahc->features |= AHC_HVD;
+
+	return error;
+}
+
+static int
 ahc_aic7896_setup(struct ahc_softc *ahc)
 {
 	ahc_dev_softc_t pci;
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 780aaed..e993b73 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -785,6 +785,7 @@ spi_dv_device_internal(struct scsi_devic
 {
 	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
 	struct scsi_target *starget = sdev->sdev_target;
+	struct Scsi_Host *shost = sdev->host;
 	int len = sdev->inquiry_len;
 	/* first set us up for narrow async */
 	DV_SET(offset, 0);
@@ -844,6 +845,14 @@ spi_dv_device_internal(struct scsi_devic
 		if (spi_min_period(starget) == 8)
 			DV_SET(pcomp_en, 1);
 	}
+	/* now that we've done all this, actually check the bus
+	 * signal type (if known).  Some devices are stupid on
+	 * a SE bus and still claim they can try LVD only settings */
+	if (i->f->get_signalling)
+		i->f->get_signalling(shost);
+	if (spi_signalling(shost) == SPI_SIGNAL_SE ||
+	    spi_signalling(shost) == SPI_SIGNAL_HVD)
+		DV_SET(dt, 0);
 	/* Do the read only INQUIRY tests */
 	spi_dv_retrain(sdev, buffer, buffer + sdev->inquiry_len,
 		       spi_dv_device_compare_inquiry);


