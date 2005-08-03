From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add missing hold_mcs parameter to the spi transport class
Date: Wed, 03 Aug 2005 15:43:52 -0500
Message-ID: <1123101833.5019.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:47034 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262443AbVHCUnz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2005 16:43:55 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j73KhrA03567
	for <linux-scsi@vger.kernel.org>; Wed, 3 Aug 2005 16:43:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This parameter is important only to people who take the time to tune the
margin control settings, otherwise it's completely irrelevant.  However,
just in case anyone should want to do this, it's appropriate to include
the parameter.

I don't do anything with it in DV by design, so the parameter will come
up as off by default, so if anyone actually wants to play with the
margin control settings they'll have to enable it under the
spi_transport class first.

I also updated the transfer settings display to report all of the PPR
settings instead of only DT, IU and QAS

James

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -35,7 +35,7 @@
 
 #define SPI_PRINTK(x, l, f, a...)	dev_printk(l, &(x)->dev, f , ##a)
 
-#define SPI_NUM_ATTRS 13	/* increase this if you add attributes */
+#define SPI_NUM_ATTRS 14	/* increase this if you add attributes */
 #define SPI_OTHER_ATTRS 1	/* Increase this if you add "always
 				 * on" attributes */
 #define SPI_HOST_ATTRS	1
@@ -235,6 +235,7 @@ static int spi_setup_transport_attrs(str
 	spi_rd_strm(starget) = 0;
 	spi_rti(starget) = 0;
 	spi_pcomp_en(starget) = 0;
+	spi_hold_mcs(starget) = 0;
 	spi_dv_pending(starget) = 0;
 	spi_initial_dv(starget) = 0;
 	init_MUTEX(&spi_dv_sem(starget));
@@ -351,6 +352,7 @@ spi_transport_rd_attr(wr_flow, "%d\n");
 spi_transport_rd_attr(rd_strm, "%d\n");
 spi_transport_rd_attr(rti, "%d\n");
 spi_transport_rd_attr(pcomp_en, "%d\n");
+spi_transport_rd_attr(hold_mcs, "%d\n");
 
 /* we only care about the first child device so we return 1 */
 static int child_iter(struct device *dev, void *data)
@@ -1014,10 +1016,17 @@ void spi_display_xfer_agreement(struct s
 		sprint_frac(tmp, picosec, 1000);
 
 		dev_info(&starget->dev,
-			"%s %sSCSI %d.%d MB/s %s%s%s (%s ns, offset %d)\n",
-			scsi, tp->width ? "WIDE " : "", kb100/10, kb100 % 10,
-			tp->dt ? "DT" : "ST", tp->iu ? " IU" : "",
-			tp->qas  ? " QAS" : "", tmp, tp->offset);
+			 "%s %sSCSI %d.%d MB/s %s%s%s%s%s%s%s%s (%s ns, offset %d)\n",
+			 scsi, tp->width ? "WIDE " : "", kb100/10, kb100 % 10,
+			 tp->dt ? "DT" : "ST",
+			 tp->iu ? " IU" : "",
+			 tp->qas  ? " QAS" : "",
+			 tp->rd_strm ? " RDSTRM" : "",
+			 tp->rti ? " RTI" : "",
+			 tp->wr_flow ? " WRFLOW" : "",
+			 tp->pcomp_en ? " PCOMP" : "",
+			 tp->hold_mcs ? " HMCS" : "",
+			 tmp, tp->offset);
 	} else {
 		dev_info(&starget->dev, "%sasynchronous.\n",
 				tp->width ? "wide " : "");
@@ -1140,6 +1149,7 @@ spi_attach_transport(struct spi_function
 	SETUP_ATTRIBUTE(rd_strm);
 	SETUP_ATTRIBUTE(rti);
 	SETUP_ATTRIBUTE(pcomp_en);
+	SETUP_ATTRIBUTE(hold_mcs);
 
 	/* if you add an attribute but forget to increase SPI_NUM_ATTRS
 	 * this bug will trigger */
diff --git a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
--- a/include/scsi/scsi_transport_spi.h
+++ b/include/scsi/scsi_transport_spi.h
@@ -39,6 +39,7 @@ struct spi_transport_attrs {
 	unsigned int rd_strm:1;	/* Read streaming enabled */
 	unsigned int rti:1;	/* Retain Training Information */
 	unsigned int pcomp_en:1;/* Precompensation enabled */
+	unsigned int hold_mcs:1;/* Hold Margin Control Settings */
 	unsigned int initial_dv:1; /* DV done to this target yet  */
 	unsigned long flags;	/* flags field for drivers to use */
 	/* Device Properties fields */
@@ -78,6 +79,7 @@ struct spi_host_attrs {
 #define spi_rd_strm(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->rd_strm)
 #define spi_rti(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->rti)
 #define spi_pcomp_en(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->pcomp_en)
+#define spi_hold_mcs(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->hold_mcs)
 #define spi_initial_dv(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->initial_dv)
 
 #define spi_support_sync(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->support_sync)
@@ -114,6 +116,8 @@ struct spi_function_template {
 	void	(*set_rti)(struct scsi_target *, int);
 	void	(*get_pcomp_en)(struct scsi_target *);
 	void	(*set_pcomp_en)(struct scsi_target *, int);
+	void	(*get_hold_mcs)(struct scsi_target *);
+	void	(*set_hold_mcs)(struct scsi_target *, int);
 	void	(*get_signalling)(struct Scsi_Host *);
 	void	(*set_signalling)(struct Scsi_Host *, enum spi_signal_type);
 	/* The driver sets these to tell the transport class it
@@ -130,6 +134,7 @@ struct spi_function_template {
 	unsigned long	show_rd_strm:1;
 	unsigned long	show_rti:1;
 	unsigned long	show_pcomp_en:1;
+	unsigned long	show_hold_mcs:1;
 };
 
 struct scsi_transport_template *spi_attach_transport(struct spi_function_template *);


