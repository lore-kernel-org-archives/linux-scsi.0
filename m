From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] more SPI transport attribute updates
Date: 12 Mar 2004 15:55:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079124933.1878.26.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:65437 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262521AbUCLUzg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 15:55:36 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i2CKtZa31278
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2004 15:55:35 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This does three things

- Fix the signedness of the bit attributes (otherwise they show up as -1
when on, not 1)
- Make the period adjust to the closest value rather than ignoring
values it doesn't understand.
- Add a visibility field to attributes, so drivers can get rid of
attributes they're never going to care about

James

===== drivers/scsi/scsi_transport_spi.c 1.3 vs edited =====
--- 1.3/drivers/scsi/scsi_transport_spi.c	Sun Mar  7 16:35:17 2004
+++ edited/drivers/scsi/scsi_transport_spi.c	Fri Mar 12 14:40:53 2004
@@ -204,39 +204,26 @@
 	}
 
 	if(period == -1) {
-		 int val = simple_strtoul(buf, NULL, 0);
+		int val = simple_strtoul(buf, NULL, 0);
 
-		 
-		 if(val >= (SPI_STATIC_PPR + 1)*4)
-			  period = val/4;
 
+		/* Should probably check limits here, but this
+		 * gets reasonably close to OK for most things */
+		period = val/4;
 	}
 
-	if(period == -1 || period > 0xff)
-		 return -EINVAL;
+	if(period > 0xff)
+		period = 0xff;
 
 	i->f->set_period(sdev, period);
 
 	return count;
 }
 	
-
-	
-		 
-
-
 static CLASS_DEVICE_ATTR(period, S_IRUGO | S_IWUSR, 
 			 show_spi_transport_period,
 			 store_spi_transport_period);
 
-
-struct scsi_transport_template spi_transport_template = {
-	.class = &spi_transport_class,
-	.setup = &spi_setup_transport_attrs,
-	.cleanup = NULL,
-	.size = sizeof(struct spi_transport_attrs) - sizeof(unsigned long),
-};
-
 #define SETUP_ATTRIBUTE(field)						\
 	i->private_attrs[count] = class_device_attr_##field;		\
 	if(!i->f->set_##field) {					\
@@ -244,7 +231,8 @@
 		i->private_attrs[count].store = NULL;			\
 	}								\
 	i->attrs[count] = &i->private_attrs[count];			\
-	count++
+	if(i->f->show_##field)						\
+		count++
 
 struct scsi_transport_template *
 spi_attach_transport(struct spi_function_template *ft)
@@ -277,7 +265,7 @@
 
 	/* if you add an attribute but forget to increase SPI_NUM_ATTRS
 	 * this bug will trigger */
-	BUG_ON(count != SPI_NUM_ATTRS);
+	BUG_ON(count > SPI_NUM_ATTRS);
 
 	i->attrs[count] = NULL;
 
===== include/scsi/scsi_transport_spi.h 1.3 vs edited =====
--- 1.3/include/scsi/scsi_transport_spi.h	Sun Mar  7 16:35:17 2004
+++ edited/include/scsi/scsi_transport_spi.h	Fri Mar 12 14:41:12 2004
@@ -27,14 +27,14 @@
 struct spi_transport_attrs {
 	int period;		/* value in the PPR/SDTR command */
 	int offset;
-	int width:1;		/* 0 - narrow, 1 - wide */
-	int iu:1;		/* Information Units enabled */
-	int dt:1;		/* DT clocking enabled */
-	int qas:1;		/* Quick Arbitration and Selection enabled */
-	int wr_flow:1;		/* Write Flow control enabled */
-	int rd_strm:1;		/* Read streaming enabled */
-	int rti:1;		/* Retain Training Information */
-	int pcomp_en:1;		/* Precompensation enabled */
+	unsigned int width:1;	/* 0 - narrow, 1 - wide */
+	unsigned int iu:1;	/* Information Units enabled */
+	unsigned int dt:1;	/* DT clocking enabled */
+	unsigned int qas:1;	/* Quick Arbitration and Selection enabled */
+	unsigned int wr_flow:1;	/* Write Flow control enabled */
+	unsigned int rd_strm:1;	/* Read streaming enabled */
+	unsigned int rti:1;	/* Retain Training Information */
+	unsigned int pcomp_en:1;/* Precompensation enabled */
 };
 
 /* accessor functions */
@@ -71,6 +71,20 @@
 	void	(*set_rti)(struct scsi_device *, int);
 	void	(*get_pcomp_en)(struct scsi_device *);
 	void	(*set_pcomp_en)(struct scsi_device *, int);
+	/* The driver sets these to tell the transport class it
+	 * wants the attributes displayed in sysfs.  If the show_ flag
+	 * is not set, the attribute will be private to the transport
+	 * class */
+	unsigned long	show_period:1;
+	unsigned long	show_offset:1;
+	unsigned long	show_width:1;
+	unsigned long	show_iu:1;
+	unsigned long	show_dt:1;
+	unsigned long	show_qas:1;
+	unsigned long	show_wr_flow:1;
+	unsigned long	show_rd_strm:1;
+	unsigned long	show_rti:1;
+	unsigned long	show_pcomp_en:1;
 };
 
 struct scsi_transport_template *spi_attach_transport(struct spi_function_template *);

