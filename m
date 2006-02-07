From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] unused show_spi_transport_period_helper parameter
Date: Tue, 7 Feb 2006 08:01:02 -0700
Message-ID: <20060207150102.GB1601@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40832 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S965111AbWBGPBD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 10:01:03 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


show_spi_transport_period_helper() doesn't need the class_device parameter

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.24
diff -u -p -r1.24 scsi_transport_spi.c
--- ./drivers/scsi/scsi_transport_spi.c	17 Jan 2006 14:51:49 -0000	1.24
+++ ./drivers/scsi/scsi_transport_spi.c	7 Feb 2006 13:11:26 -0000
@@ -401,8 +401,7 @@ static int period_to_str(char *buf, int 
 }
 
 static ssize_t
-show_spi_transport_period_helper(struct class_device *cdev, char *buf,
-				 int period)
+show_spi_transport_period_helper(char *buf, int period)
 {
 	int len = period_to_str(buf, period);
 	buf[len++] = '\n';
@@ -459,7 +458,7 @@ show_spi_transport_period(struct class_d
 	if (i->f->get_period)
 		i->f->get_period(starget);
 
-	return show_spi_transport_period_helper(cdev, buf, tp->period);
+	return show_spi_transport_period_helper(buf, tp->period);
 }
 
 static ssize_t
@@ -494,7 +493,7 @@ show_spi_transport_min_period(struct cla
 	struct spi_transport_attrs *tp =
 		(struct spi_transport_attrs *)&starget->starget_data;
 
-	return show_spi_transport_period_helper(cdev, buf, tp->min_period);
+	return show_spi_transport_period_helper(buf, tp->min_period);
 }
 
 static ssize_t
