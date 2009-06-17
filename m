From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] scsi_transport_spi: Blacklist Ultrium-3 tape for
 IU transfers
Date: Wed, 17 Jun 2009 19:05:05 +0000
Message-ID: <1245265505.8585.99.camel@mulgrave.site>
References: <1245265244.8585.94.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35972 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbZFQTFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 15:05:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 5983D8EE10E
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 12:05:08 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3u4cGMfPEEhe for <linux-scsi@vger.kernel.org>;
	Wed, 17 Jun 2009 12:05:08 -0700 (PDT)
Received: from [192.168.10.224] (newmulgrave.ext.hansenpartnership.com [192.168.10.224])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 02A988EE0F1
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 12:05:07 -0700 (PDT)
In-Reply-To: <1245265244.8585.94.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

There have been several bug reports which identified the Ultrium-3
tape as just hanging up on the bus during certain types of IU
transfer.  The identified culpret is type 0x02 (MULTIPLE COMMAND)
transfers.  The only way to prevent this tape wedging is to prevent it
from using IU transfers at all.  So this patch uses the exported
blacklist matching technology to recognise the drive and force it not
to use IU transfers.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_priv.h          |    1 +
 drivers/scsi/scsi_transport_spi.c |   40 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b4e49cd..00264aa 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -43,6 +43,7 @@ static inline void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 /* list of keys for the lists */
 enum {
 	SCSI_DEVINFO_GLOBAL = 0,
+	SCSI_DEVINFO_SPI,
 };
 
 extern int scsi_get_device_flags(struct scsi_device *sdev,
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 00cfb40..c25bd9a 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -46,6 +46,22 @@
 #define DV_RETRIES	3	/* should only need at most 
 				 * two cc/ua clears */
 
+/* Our blacklist flags */
+enum {
+	SPI_BLIST_NOIUS = 0x1,
+};
+
+/* blacklist table, modelled on scsi_devinfo.c */
+static struct {
+	char *vendor;
+	char *model;
+	unsigned flags;
+} spi_static_device_list[] __initdata = {
+	{"HP", "Ultrium 3-SCSI", SPI_BLIST_NOIUS },
+	{"IBM", "ULTRIUM-TD3", SPI_BLIST_NOIUS },
+	{NULL, NULL, 0}
+};
+
 /* Private data accessors (keep these out of the header file) */
 #define spi_dv_in_progress(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_in_progress)
 #define spi_dv_mutex(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_mutex)
@@ -207,6 +223,9 @@ static int spi_device_configure(struct transport_container *tc,
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_target *starget = sdev->sdev_target;
+	unsigned bflags = scsi_get_device_flags_keyed(sdev, &sdev->inquiry[8],
+						      &sdev->inquiry[16],
+						      SCSI_DEVINFO_SPI);
 
 	/* Populate the target capability fields with the values
 	 * gleaned from the device inquiry */
@@ -216,6 +235,10 @@ static int spi_device_configure(struct transport_container *tc,
 	spi_support_dt(starget) = scsi_device_dt(sdev);
 	spi_support_dt_only(starget) = scsi_device_dt_only(sdev);
 	spi_support_ius(starget) = scsi_device_ius(sdev);
+	if (bflags & SPI_BLIST_NOIUS) {
+		dev_info(dev, "Information Units disabled by blacklist\n");
+		spi_support_ius(starget) = 0;
+	}
 	spi_support_qas(starget) = scsi_device_qas(sdev);
 
 	return 0;
@@ -1524,7 +1547,21 @@ EXPORT_SYMBOL(spi_release_transport);
 
 static __init int spi_transport_init(void)
 {
-	int error = transport_class_register(&spi_transport_class);
+	int error = scsi_dev_info_add_list(SCSI_DEVINFO_SPI,
+					   "SCSI Parallel Transport Class");
+	if (!error) {
+		int i;
+
+		for (i = 0; spi_static_device_list[i].vendor; i++)
+			scsi_dev_info_list_add_keyed(1,	/* compatible */
+						     spi_static_device_list[i].vendor,
+						     spi_static_device_list[i].model,
+						     NULL,
+						     spi_static_device_list[i].flags,
+						     SCSI_DEVINFO_SPI);
+	}
+
+	error = transport_class_register(&spi_transport_class);
 	if (error)
 		return error;
 	error = anon_transport_class_register(&spi_device_class);
@@ -1536,6 +1573,7 @@ static void __exit spi_transport_exit(void)
 	transport_class_unregister(&spi_transport_class);
 	anon_transport_class_unregister(&spi_device_class);
 	transport_class_unregister(&spi_host_class);
+	scsi_dev_info_remove_list(SCSI_DEVINFO_SPI);
 }
 
 MODULE_AUTHOR("Martin Hicks");
-- 
1.6.2.4



