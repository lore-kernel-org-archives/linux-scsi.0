From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] add device_configure to the transport classes
Date: Tue, 5 Oct 2004 19:10:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF2154D688.D97183DA-ONC1256F24.005BD3E3-C1256F24.005EE95C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:20711 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S269050AbUJERK1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 13:10:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>





James,

now that there is more and more stuff handed over to transport classes,
would it be feasible to put LUN there as well, as its form appears to be
transport specific as well? (e.g. 64 bit for FC while other transports
may be unable to convey 64 bit LUNs)

I see that this particular patch is not exactly what was needed to achieve
this, because at the time of the evaluation INQUIRY data the LUN has
already been adapted to the way LUNs are stored in scsi_device.

I am also not sure yet how this approach would go with REPORT_LUNS,
which returns 64 bit LUNs for all transports. But for everybody interested
in 64 bit LUNs, it would certainly clean things up.

Martin Peschke


James Bottomley <James.Bottomley@SteelEye.com>@vger.kernel.org on
05/10/2004 18:11:01

Sent by:    linux-scsi-owner@vger.kernel.org


To:    SCSI Mailing List <linux-scsi@vger.kernel.org>
cc:
Subject:    [PATCH] add device_configure to the transport classes


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
--- a/drivers/scsi/scsi_scan.c             2004-10-05 11:08:24 -05:00
+++ b/drivers/scsi/scsi_scan.c             2004-10-05 11:08:24 -05:00
@@ -613,7 +613,10 @@
             if (*bflags & BLIST_NOT_LOCKABLE)
                         sdev->lockable = 0;

-            if(sdev->host->hostt->slave_configure)
+            if (sdev->host->transportt->device_configure)
+                        sdev->host->transportt->device_configure(sdev);
+
+            if (sdev->host->hostt->slave_configure)
                         sdev->host->hostt->slave_configure(sdev);

             /*
diff -Nru a/drivers/scsi/scsi_transport_spi.c
b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c          2004-10-05 11:08:24 -05:00
+++ b/drivers/scsi/scsi_transport_spi.c          2004-10-05 11:08:24 -05:00
@@ -150,6 +150,23 @@
             return 0;
 }

+static int spi_configure_device(struct scsi_device *sdev)
+{
+            struct scsi_target *starget = sdev->sdev_target;
+
+            /* Populate the target capability fields with the values
+             * gleaned from the device inquiry */
+
+            spi_support_sync(starget) = scsi_device_sync(sdev);
+            spi_support_wide(starget) = scsi_device_wide(sdev);
+            spi_support_dt(starget) = scsi_device_dt(sdev);
+            spi_support_dt_only(starget) = scsi_device_dt_only(sdev);
+            spi_support_ius(starget) = scsi_device_ius(sdev);
+            spi_support_qas(starget) = scsi_device_qas(sdev);
+
+            return 0;
+}
+
 static int spi_setup_transport_attrs(struct scsi_target *starget)
 {
             spi_period(starget) = -1;           /* illegal value */
@@ -783,6 +800,7 @@
             i->t.target_attrs = &i->attrs[0];
             i->t.target_class = &spi_transport_class;
             i->t.target_setup = &spi_setup_transport_attrs;
+            i->t.device_configure = &spi_configure_device;
             i->t.target_size = sizeof(struct spi_transport_attrs);
             i->t.host_attrs = &i->host_attrs[0];
             i->t.host_class = &spi_host_class;
diff -Nru a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
--- a/include/scsi/scsi_transport.h        2004-10-05 11:08:24 -05:00
+++ b/include/scsi/scsi_transport.h        2004-10-05 11:08:24 -05:00
@@ -36,6 +36,7 @@

             /* Constructor functions */
             int (*device_setup)(struct scsi_device *);
+            int (*device_configure)(struct scsi_device *);
             int (*target_setup)(struct scsi_target *);
             int (*host_setup)(struct Scsi_Host *);

diff -Nru a/include/scsi/scsi_transport_spi.h
b/include/scsi/scsi_transport_spi.h
--- a/include/scsi/scsi_transport_spi.h          2004-10-05 11:08:24 -05:00
+++ b/include/scsi/scsi_transport_spi.h          2004-10-05 11:08:24 -05:00
@@ -37,6 +37,13 @@
             unsigned int pcomp_en:1;/* Precompensation enabled */
             unsigned int initial_dv:1; /* DV done to this target yet  */
             unsigned long flags;          /* flags field for drivers to
use */
+            /* Device Properties fields */
+            unsigned int support_sync:1; /* synchronous support */
+            unsigned int support_wide:1; /* wide support */
+            unsigned int support_dt:1; /* allows DT phases */
+            unsigned int support_dt_only; /* disallows ST phases */
+            unsigned int support_ius; /* support Information Units */
+            unsigned int support_qas; /* supports quick arbitration and
selection */
             /* Private Fields */
             unsigned int dv_pending:1; /* Internal flag */
             struct semaphore dv_sem; /* semaphore to serialise dv */
@@ -65,8 +72,18 @@
 #define spi_rti(x)            (((struct spi_transport_attrs
*)&(x)->starget_data)->rti)
 #define spi_pcomp_en(x)             (((struct spi_transport_attrs
*)&(x)->starget_data)->pcomp_en)
 #define spi_initial_dv(x)           (((struct spi_transport_attrs
*)&(x)->starget_data)->initial_dv)
+
+#define spi_support_sync(x)         (((struct spi_transport_attrs
*)&(x)->starget_data)->support_sync)
+#define spi_support_wide(x)         (((struct spi_transport_attrs
*)&(x)->starget_data)->support_wide)
+#define spi_support_dt(x)           (((struct spi_transport_attrs
*)&(x)->starget_data)->support_dt)
+#define spi_support_dt_only(x)            (((struct spi_transport_attrs
*)&(x)->starget_data)->support_dt_only)
+#define spi_support_ius(x)          (((struct spi_transport_attrs
*)&(x)->starget_data)->support_ius)
+#define spi_support_qas(x)          (((struct spi_transport_attrs
*)&(x)->starget_data)->support_qas)
+
 #define spi_flags(x)          (((struct spi_transport_attrs
*)&(x)->starget_data)->flags)
 #define spi_signalling(h)           (((struct spi_host_attrs
*)&(h)->shost_data)->signalling)
+
+

 /* The functions by which the transport class and the driver communicate
*/
 struct spi_function_template {

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



