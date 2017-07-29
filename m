From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 1/4] aic7xxx: remove empty function
Date: Sat, 29 Jul 2017 03:01:56 +0200
Message-ID: <b7c348511384a5766cbd975b382e7d114959cdfc.1501288712.git.mirq-linux@rere.qmqm.pl>
References: <cover.1501288712.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([91.227.64.183]:60650 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753038AbdG2BB6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 21:01:58 -0400
In-Reply-To: <cover.1501288712.git.mirq-linux@rere.qmqm.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

ahc_platform_dump_card_state() does nothing. Remove it.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 1 -
 drivers/scsi/aic7xxx/aic7xxx_osm.c  | 5 -----
 drivers/scsi/aic7xxx/aic7xxx_osm.h  | 1 -
 3 files changed, 7 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 64ab9eaec428..381846164003 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -7340,7 +7340,6 @@ ahc_dump_card_state(struct ahc_softc *ahc)
 		printk("\n");
 	}
 
-	ahc_platform_dump_card_state(ahc);
 	printk("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n");
 	ahc_outb(ahc, SCBPTR, saved_scbptr);
 	if (paused == 0)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index fc6a83188c1e..acd687f4554e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2329,11 +2329,6 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 	return (retval);
 }
 
-void
-ahc_platform_dump_card_state(struct ahc_softc *ahc)
-{
-}
-
 static void ahc_linux_set_width(struct scsi_target *starget, int width)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/aic7xxx_osm.h
index 54c702864103..f8489078f003 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -688,7 +688,6 @@ void	ahc_done(struct ahc_softc*, struct scb*);
 void	ahc_send_async(struct ahc_softc *, char channel,
 		       u_int target, u_int lun, ac_code);
 void	ahc_print_path(struct ahc_softc *, struct scb *);
-void	ahc_platform_dump_card_state(struct ahc_softc *ahc);
 
 #ifdef CONFIG_PCI
 #define AHC_PCI_CONFIG 1
-- 
2.11.0
