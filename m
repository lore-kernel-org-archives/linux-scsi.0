From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] attach aic7xxx to the spi transport class.
Date: Sun, 10 Apr 2005 13:58:27 -0500
Message-ID: <1113159507.6737.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:49366 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261584AbVDJS6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 14:58:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch is the beginning of the long process to see if we can make
this driver play better.

The first step is simply to attach it to the transport class so you can
view and set the transfer parameters.

Next, I intend to plug it into the generic domain validation routines
(thus killing the separate ahc dv thread)

Some time later will be killing the internal queueing, since really only
the DV state machine uses it and finally plumbing it into the generic
tag infrastructure.

If anyone has a 79xx card and wants to play too, this should be a simple
cut and paste, doing s/ahc_/ahd_/ in all my functions.  The 79xx will
also need QAS, IU and all the other ultra320 transport properties ...

James

===== drivers/scsi/aic7xxx/aic7xxx_osm.c 1.63 vs edited =====
--- 1.63/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-01-07 23:44:36 -06:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-04-10 13:36:07 -05:00
@@ -122,6 +122,10 @@
 #include "aic7xxx_osm.h"
 #include "aic7xxx_inline.h"
 #include <scsi/scsicam.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
+static struct scsi_transport_template *ahc_linux_transport_template = NULL;
 
 /*
  * Include aiclib.c as part of our
@@ -1728,6 +1732,8 @@
 	ahc_linux_start_dv(ahc);
 	ahc_unlock(ahc, &s);
 
+	host->transportt = ahc_linux_transport_template;
+
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	scsi_add_host(host, (ahc->dev_softc ? &ahc->dev_softc->dev : NULL)); /* XXX handle failure */
 	scsi_scan_host(host);
@@ -4990,13 +4996,169 @@
 
 static void ahc_linux_exit(void);
 
+static void ahc_linux_get_period(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_tmode_tstate *tstate;
+	struct ahc_initiator_tinfo *tinfo 
+		= ahc_fetch_transinfo(ahc,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_period(starget) = tinfo->curr.period;
+}
+
+static void ahc_linux_set_period(struct scsi_target *starget, int period)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_tmode_tstate *tstate;
+	struct ahc_initiator_tinfo *tinfo 
+		= ahc_fetch_transinfo(ahc,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	struct ahc_devinfo devinfo;
+	unsigned int ppr_options = tinfo->curr.ppr_options;
+	unsigned long flags;
+	struct ahc_syncrate *syncrate;
+
+	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
+	ahc_lock(ahc, &flags);
+	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->curr.offset,
+			 ppr_options, AHC_TRANS_GOAL, FALSE);
+	ahc_unlock(ahc, &flags);
+}
+
+static void ahc_linux_get_offset(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_tmode_tstate *tstate;
+	struct ahc_initiator_tinfo *tinfo 
+		= ahc_fetch_transinfo(ahc,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_offset(starget) = tinfo->curr.offset;
+}
+
+static void ahc_linux_set_offset(struct scsi_target *starget, int offset)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_tmode_tstate *tstate;
+	struct ahc_initiator_tinfo *tinfo 
+		= ahc_fetch_transinfo(ahc,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	struct ahc_devinfo devinfo;
+	unsigned int ppr_options = tinfo->curr.ppr_options;
+	unsigned int period = tinfo->curr.period;
+	unsigned long flags;
+	struct ahc_syncrate *syncrate;
+
+	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options, AHC_SYNCRATE_DT);
+	ahc_lock(ahc, &flags);
+	ahc_set_syncrate(ahc, &devinfo, syncrate, period, offset,
+			 ppr_options, AHC_TRANS_GOAL, FALSE);
+	ahc_unlock(ahc, &flags);
+}
+
+static void ahc_linux_get_width(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_tmode_tstate *tstate;
+	struct ahc_initiator_tinfo *tinfo 
+		= ahc_fetch_transinfo(ahc,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_width(starget) = tinfo->curr.width;
+}
+
+static void ahc_linux_set_width(struct scsi_target *starget, int width)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_devinfo devinfo;
+	unsigned long flags;
+
+	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	ahc_lock(ahc, &flags);
+	ahc_set_width(ahc, &devinfo, width, AHC_TRANS_GOAL, FALSE);
+	ahc_unlock(ahc, &flags);
+}
+
+static void ahc_linux_get_dt(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_tmode_tstate *tstate;
+	struct ahc_initiator_tinfo *tinfo 
+		= ahc_fetch_transinfo(ahc,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	spi_dt(starget) = tinfo->curr.ppr_options & MSG_EXT_PPR_DT_REQ;
+}
+
+static void ahc_linux_set_dt(struct scsi_target *starget, int dt)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ahc_softc *ahc = *((struct ahc_softc **)shost->hostdata);
+	struct ahc_tmode_tstate *tstate;
+	struct ahc_initiator_tinfo *tinfo 
+		= ahc_fetch_transinfo(ahc,
+				      starget->channel + 'A',
+				      shost->this_id, starget->id, &tstate);
+	struct ahc_devinfo devinfo;
+	unsigned int ppr_options = tinfo->curr.ppr_options
+		& ~MSG_EXT_PPR_DT_REQ;
+	unsigned int period = tinfo->curr.period;
+	unsigned long flags;
+	struct ahc_syncrate *syncrate;
+
+	ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
+			    starget->channel + 'A', ROLE_INITIATOR);
+	syncrate = ahc_find_syncrate(ahc, &period, &ppr_options,
+				     dt ? AHC_SYNCRATE_DT : AHC_SYNCRATE_ULTRA2);
+	ahc_lock(ahc, &flags);
+	ahc_set_syncrate(ahc, &devinfo, syncrate, period, tinfo->curr.offset,
+			 ppr_options, AHC_TRANS_GOAL, FALSE);
+	ahc_unlock(ahc, &flags);
+}
+
+static struct spi_function_template ahc_linux_transport_functions = {
+	.get_offset	= ahc_linux_get_offset,
+	.set_offset	= ahc_linux_set_offset,
+	.show_offset	= 1,
+	.get_period	= ahc_linux_get_period,
+	.set_period	= ahc_linux_set_period,
+	.show_period	= 1,
+	.get_width	= ahc_linux_get_width,
+	.set_width	= ahc_linux_set_width,
+	.show_width	= 1,
+	.get_dt		= ahc_linux_get_dt,
+	.set_dt		= ahc_linux_set_dt,
+	.show_dt	= 1,
+};
+
+
+
 static int __init
 ahc_linux_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	ahc_linux_transport_template = spi_attach_transport(&ahc_linux_transport_functions);
+	if (!ahc_linux_transport_template)
+		return -ENODEV;
 	int rc = ahc_linux_detect(&aic7xxx_driver_template);
 	if (rc)
 		return rc;
+	spi_release_transport(ahc_linux_transport_template);
 	ahc_linux_exit();
 	return -ENODEV;
 #else
@@ -5037,6 +5199,7 @@
 #endif
 	ahc_linux_pci_exit();
 	ahc_linux_eisa_exit();
+	spi_release_transport(ahc_linux_transport_template);
 }
 
 module_init(ahc_linux_init);


