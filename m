From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 4/4] aic7xxx: minor cleanups made possible by busyq removal change
Date: Sun, 29 May 2005 03:41:25 -0400
Message-ID: <20050529074125.GA26010@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlmail.prod.rxgsys.com ([69.61.70.25]:25225 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S261271AbVE2Hl3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 03:41:29 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by bastet.signetmail.com (RXG Elite Mail Server) with ESMTP id D6E6DA883F
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 02:20:42 -0400 (EDT)
Received: from bastet.signetmail.com ([127.0.0.1])
 by localhost (atlmail.prod.rxgsys.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30525-01 for <linux-scsi@vger.kernel.org>;
 Sun, 29 May 2005 02:20:40 -0400 (EDT)
Received: from havoc.gtf.org (havoc.gtf.org [63.115.148.101])
	by bastet.signetmail.com (RXG Elite Mail Server) with ESMTP id A7CADA8818
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 02:20:39 -0400 (EDT)
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id CA8401C1E97D
	for <linux-scsi@vger.kernel.org>; Sun, 29 May 2005 03:41:25 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j4T7fPaF026020
	for linux-scsi@vger.kernel.org; Sun, 29 May 2005 03:41:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



[note:  just for review...  do not apply, will be submitted later via git]

author Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 11:35:55 -0400
committer Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 11:35:55 -0400

[SCSI] aic7xxx: minor cleanups made possible by busyq removal change

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6819,7 +6819,6 @@ ahc_dump_card_state(struct ahc_softc *ah
 		printf("\n");
 	}
 
-	ahc_platform_dump_card_state(ahc);
 	printf("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n");
 	ahc_outb(ahc, SCBPTR, saved_scbptr);
 	if (paused == 0)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -876,8 +876,6 @@ struct scsi_host_template aic7xxx_driver
 	.slave_destroy		= ahc_linux_slave_destroy,
 };
 
-/**************************** Tasklet Handler *********************************/
-
 /******************************** Macros **************************************/
 #define BUILD_SCSIID(ahc, cmd)						    \
 	((((cmd)->device->id << TID_SHIFT) & TID)			    \
@@ -2620,11 +2618,6 @@ done:
 	return (retval);
 }
 
-void
-ahc_platform_dump_card_state(struct ahc_softc *ahc)
-{
-}
-
 static void ahc_linux_exit(void);
 
 static void ahc_linux_get_width(struct scsi_target *starget)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/aic7xxx_osm.h
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -320,7 +320,7 @@ struct ahc_cmd {
  * after a successfully completed inquiry command to the target when
  * that inquiry data indicates a lun is present.
  */
-TAILQ_HEAD(ahc_busyq, ahc_cmd);
+
 typedef enum {
 	AHC_DEV_FREEZE_TIL_EMPTY = 0x02, /* Freeze queue until active == 0 */
 	AHC_DEV_Q_BASIC		 = 0x10, /* Allow basic device queuing */
@@ -953,7 +953,6 @@ void	ahc_done(struct ahc_softc*, struct 
 void	ahc_send_async(struct ahc_softc *, char channel,
 		       u_int target, u_int lun, ac_code, void *);
 void	ahc_print_path(struct ahc_softc *, struct scb *);
-void	ahc_platform_dump_card_state(struct ahc_softc *ahc);
 
 #ifdef CONFIG_PCI
 #define AHC_PCI_CONFIG 1
