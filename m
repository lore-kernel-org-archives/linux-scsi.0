From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add device_configure to the transport classes
Date: 05 Oct 2004 11:11:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096992666.1765.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:9910 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270283AbUJEQLH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 12:11:07 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i95GB6m27848
	for <linux-scsi@vger.kernel.org>; Tue, 5 Oct 2004 12:11:06 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The idea here is to have a callback that's invoked after inquiry is
complete so that the transport class can pick fields it's interested in
out of the inquiry data.  The hope would be to have some of those fields
that are currently scsi_device flags go away.

This is against the scsi-target-2.6 tree

James

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/05 11:05:24-05:00 jejb@pashleys.(none) 
#   add device_configure to the transport classes
#   
#   This allows attributes to be picked out of the INQUIRY fields and
#   placed into transport specific capability flags
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# include/scsi/scsi_transport_spi.h
#   2004/10/05 11:05:12-05:00 jejb@pashleys.(none) +17 -0
#   add device_configure to the transport classes
# 
# include/scsi/scsi_transport.h
#   2004/10/05 11:05:12-05:00 jejb@pashleys.(none) +1 -0
#   add device_configure to the transport classes
# 
# drivers/scsi/scsi_transport_spi.c
#   2004/10/05 11:05:12-05:00 jejb@pashleys.(none) +18 -0
#   add device_configure to the transport classes
# 
# drivers/scsi/scsi_scan.c
#   2004/10/05 11:05:12-05:00 jejb@pashleys.(none) +4 -1
#   add device_configure to the transport classes
# 
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2004-10-05 11:08:24 -05:00
+++ b/drivers/scsi/scsi_scan.c	2004-10-05 11:08:24 -05:00
@@ -613,7 +613,10 @@
 	if (*bflags & BLIST_NOT_LOCKABLE)
 		sdev->lockable = 0;
 
-	if(sdev->host->hostt->slave_configure)
+	if (sdev->host->transportt->device_configure)
+		sdev->host->transportt->device_configure(sdev);
+
+	if (sdev->host->hostt->slave_configure)
 		sdev->host->hostt->slave_configure(sdev);
 
 	/*
diff -Nru a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c	2004-10-05 11:08:24 -05:00
+++ b/drivers/scsi/scsi_transport_spi.c	2004-10-05 11:08:24 -05:00
@@ -150,6 +150,23 @@
 	return 0;
 }
 
+static int spi_configure_device(struct scsi_device *sdev)
+{
+	struct scsi_target *starget = sdev->sdev_target;
+
+	/* Populate the target capability fields with the values
+	 * gleaned from the device inquiry */
+
+	spi_support_sync(starget) = scsi_device_sync(sdev);
+	spi_support_wide(starget) = scsi_device_wide(sdev);
+	spi_support_dt(starget) = scsi_device_dt(sdev);
+	spi_support_dt_only(starget) = scsi_device_dt_only(sdev);
+	spi_support_ius(starget) = scsi_device_ius(sdev);
+	spi_support_qas(starget) = scsi_device_qas(sdev);
+
+	return 0;
+}
+
 static int spi_setup_transport_attrs(struct scsi_target *starget)
 {
 	spi_period(starget) = -1;	/* illegal value */
@@ -783,6 +800,7 @@
 	i->t.target_attrs = &i->attrs[0];
 	i->t.target_class = &spi_transport_class;
 	i->t.target_setup = &spi_setup_transport_attrs;
+	i->t.device_configure = &spi_configure_device;
 	i->t.target_size = sizeof(struct spi_transport_attrs);
 	i->t.host_attrs = &i->host_attrs[0];
 	i->t.host_class = &spi_host_class;
diff -Nru a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
--- a/include/scsi/scsi_transport.h	2004-10-05 11:08:24 -05:00
+++ b/include/scsi/scsi_transport.h	2004-10-05 11:08:24 -05:00
@@ -36,6 +36,7 @@
 
 	/* Constructor functions */
 	int (*device_setup)(struct scsi_device *);
+	int (*device_configure)(struct scsi_device *);
 	int (*target_setup)(struct scsi_target *);
 	int (*host_setup)(struct Scsi_Host *);
 
diff -Nru a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
--- a/include/scsi/scsi_transport_spi.h	2004-10-05 11:08:24 -05:00
+++ b/include/scsi/scsi_transport_spi.h	2004-10-05 11:08:24 -05:00
@@ -37,6 +37,13 @@
 	unsigned int pcomp_en:1;/* Precompensation enabled */
 	unsigned int initial_dv:1; /* DV done to this target yet  */
 	unsigned long flags;	/* flags field for drivers to use */
+	/* Device Properties fields */
+	unsigned int support_sync:1; /* synchronous support */
+	unsigned int support_wide:1; /* wide support */
+	unsigned int support_dt:1; /* allows DT phases */
+	unsigned int support_dt_only; /* disallows ST phases */
+	unsigned int support_ius; /* support Information Units */
+	unsigned int support_qas; /* supports quick arbitration and selection */
 	/* Private Fields */
 	unsigned int dv_pending:1; /* Internal flag */
 	struct semaphore dv_sem; /* semaphore to serialise dv */
@@ -65,8 +72,18 @@
 #define spi_rti(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->rti)
 #define spi_pcomp_en(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->pcomp_en)
 #define spi_initial_dv(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->initial_dv)
+
+#define spi_support_sync(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->support_sync)
+#define spi_support_wide(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->support_wide)
+#define spi_support_dt(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->support_dt)
+#define spi_support_dt_only(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->support_dt_only)
+#define spi_support_ius(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->support_ius)
+#define spi_support_qas(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->support_qas)
+
 #define spi_flags(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->flags)
 #define spi_signalling(h)	(((struct spi_host_attrs *)&(h)->shost_data)->signalling)
+
+
 
 /* The functions by which the transport class and the driver communicate */
 struct spi_function_template {

