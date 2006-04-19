From: akpm@osdl.org
Subject: [patch 12/17] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_match_scb() static
Date: Tue, 18 Apr 2006 21:09:19 -0700
Message-ID: <200604190410.k3J4A1CI008242@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:8142 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750797AbWDSENP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 00:13:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx.h      |    3 ---
 drivers/scsi/aic7xxx/aic79xx_core.c |    5 ++++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static drivers/scsi/aic7xxx/aic79xx_core.c
--- devel/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static	2006-04-14 23:41:42.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_core.c	2006-04-14 23:41:42.000000000 -0700
@@ -262,6 +262,9 @@ static void		ahd_update_coalescing_value
 						     u_int mincmds);
 static int		ahd_verify_vpd_cksum(struct vpd_config *vpd);
 static int		ahd_wait_seeprom(struct ahd_softc *ahd);
+static int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
+				      int target, char channel, int lun,
+				      u_int tag, role_t role);
 
 /******************************** Private Inlines *****************************/
 
@@ -7213,7 +7216,7 @@ ahd_busy_tcl(struct ahd_softc *ahd, u_in
 }
 
 /************************** SCB and SCB queue management **********************/
-int
+static int
 ahd_match_scb(struct ahd_softc *ahd, struct scb *scb, int target,
 	      char channel, int lun, u_int tag, role_t role)
 {
diff -puN drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static drivers/scsi/aic7xxx/aic79xx.h
--- devel/drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static	2006-04-14 23:41:42.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx.h	2006-04-14 23:41:42.000000000 -0700
@@ -1347,9 +1347,6 @@ int	ahd_pci_test_register_access(struct 
 /************************** SCB and SCB queue management **********************/
 void		ahd_qinfifo_requeue_tail(struct ahd_softc *ahd,
 					 struct scb *scb);
-int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
-			      int target, char channel, int lun,
-			      u_int tag, role_t role);
 
 /****************************** Initialization ********************************/
 struct ahd_softc	*ahd_alloc(void *platform_arg, char *name);
_
