From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] Add full complement of SPI transport attributes
Date: 05 Mar 2004 19:33:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078533190.2122.60.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:28643 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261501AbUCFAdX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Mar 2004 19:33:23 -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch does two things:

1. Add all the other ppr type transport attributes to the spi class
2. make period settable as the ppr/sdtr period, but display in ns for
the user.

James

===== drivers/scsi/scsi_transport_spi.c 1.1 vs edited =====
--- 1.1/drivers/scsi/scsi_transport_spi.c	Thu Mar  4 17:29:03 2004
+++ edited/drivers/scsi/scsi_transport_spi.c	Fri Mar  5 18:43:30 2004
@@ -43,9 +43,16 @@
 
 static int spi_setup_transport_attrs(struct scsi_device *sdev)
 {
-	/* FIXME: should callback into the driver to get these values */
-	spi_period(sdev) = -1;
-	spi_offset(sdev) = -1;
+	spi_period(sdev) = -1;	/* illegal value */
+	spi_offset(sdev) = 0;	/* async */
+	spi_width(sdev) = 0;	/* narrow */
+	spi_iu(sdev) = 0;	/* no IU */
+	spi_dt(sdev) = 0;	/* ST */
+	spi_qas(sdev) = 0;
+	spi_wr_flow(sdev) = 0;
+	spi_rd_strm(sdev) = 0;
+	spi_rti(sdev) = 0;
+	spi_pcomp_en(sdev) = 0;
 
 	return 0;
 }
@@ -71,12 +78,78 @@
 static CLASS_DEVICE_ATTR( field, S_IRUGO, show_spi_transport_##field, NULL)
 
 /* The Parallel SCSI Tranport Attributes: */
-spi_transport_rd_attr(period, "%d\n");
 spi_transport_rd_attr(offset, "%d\n");
+spi_transport_rd_attr(width, "%d\n");
+spi_transport_rd_attr(iu, "%d\n");
+spi_transport_rd_attr(dt, "%d\n");
+spi_transport_rd_attr(qas, "%d\n");
+spi_transport_rd_attr(wr_flow, "%d\n");
+spi_transport_rd_attr(rd_strm, "%d\n");
+spi_transport_rd_attr(rti, "%d\n");
+spi_transport_rd_attr(pcomp_en, "%d\n");
+
+/* Translate the period into ns according to the current spec
+ * for SDTR/PPR messages */
+static ssize_t show_spi_transport_period(struct class_device *cdev, char *buf)
+
+{
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+	struct spi_transport_attrs *tp;
+	char *str;
+
+	tp = (struct spi_transport_attrs *)&sdev->transport_data;
+
+	switch(tp->period) {
+	case 0x00 ... 0x06:
+		str =  "reserved";
+		break;
+
+	case 0x07:
+		str = "3.125";
+		break;
+
+	case 0x08:
+		str = "6.25";
+		break;
+
+	case 0x09:
+		str = "12.5";
+		break;
+
+	case 0x0a:
+		str = "25";
+		break;
+
+	case 0x0b:
+		str = "30.3";
+		break;
+
+	case 0x0c:
+		str = "50";
+
+	case 0x0d ... 0xff:
+		return sprintf(buf, "%d\n", tp->period * 4);
+
+	default:
+		str = "unknown";
+	}
+	return sprintf(buf, "%s\n", str);
+}
+
+static CLASS_DEVICE_ATTR(period, S_IRUGO, show_spi_transport_period, NULL);
+
 
 struct class_device_attribute *spi_transport_attrs[] = {
 	&class_device_attr_period,
 	&class_device_attr_offset,
+	&class_device_attr_width,
+	&class_device_attr_iu,
+	&class_device_attr_dt,
+	&class_device_attr_qas,
+	&class_device_attr_wr_flow,
+	&class_device_attr_rd_strm,
+	&class_device_attr_rti,
+	&class_device_attr_pcomp_en,
 	NULL
 };
 
===== include/scsi/scsi_transport_spi.h 1.1 vs edited =====
--- 1.1/include/scsi/scsi_transport_spi.h	Thu Mar  4 17:29:05 2004
+++ edited/include/scsi/scsi_transport_spi.h	Fri Mar  5 18:17:53 2004
@@ -25,14 +25,29 @@
 struct scsi_transport_template;
 
 struct spi_transport_attrs {
-	int period;
+	int period;		/* value in the PPR/SDTR command */
 	int offset;
+	int width:1;		/* 0 - narrow, 1 - wide */
+	int iu:1;		/* Information Units enabled */
+	int dt:1;		/* DT clocking enabled */
+	int qas:1;		/* Quick Arbitration and Selection enabled */
+	int wr_flow:1;		/* Write Flow control enabled */
+	int rd_strm:1;		/* Read streaming enabled */
+	int rti:1;		/* Retain Training Information */
+	int pcomp_en:1;		/* Precompensation enabled */
 };
 
 /* accessor functions */
 #define spi_period(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->period)
 #define spi_offset(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->offset)
-
+#define spi_width(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->width)
+#define spi_iu(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->iu)
+#define spi_dt(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->dt)
+#define spi_qas(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->qas)
+#define spi_wr_flow(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->wr_flow)
+#define spi_rd_strm(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->rd_strm)
+#define spi_rti(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->rti)
+#define spi_pcomp_en(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->pcomp_en)
 extern struct scsi_transport_template spi_transport_template;
 
 #endif /* SCSI_TRANSPORT_SPI_H */

