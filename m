From: akpm@osdl.org
Subject: [patch 02/30] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_match_scb() static
Date: Mon, 04 Dec 2006 15:18:21 -0800
Message-ID: <200612042319.kB4NJUMH008730@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57383 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967797AbWLDXWt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:22:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de, hare@suse.de

From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx.h      |    3 ---
 drivers/scsi/aic7xxx/aic79xx_core.c |    5 ++++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static drivers/scsi/aic7xxx/aic79xx.h
--- a/drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static
+++ a/drivers/scsi/aic7xxx/aic79xx.h
@@ -1337,9 +1337,6 @@ int	ahd_pci_test_register_access(struct 
 /************************** SCB and SCB queue management **********************/
 void		ahd_qinfifo_requeue_tail(struct ahd_softc *ahd,
 					 struct scb *scb);
-int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
-			      int target, char channel, int lun,
-			      u_int tag, role_t role);
 
 /****************************** Initialization ********************************/
 struct ahd_softc	*ahd_alloc(void *platform_arg, char *name);
diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -262,6 +262,9 @@ static void		ahd_update_coalescing_value
 						     u_int mincmds);
 static int		ahd_verify_vpd_cksum(struct vpd_config *vpd);
 static int		ahd_wait_seeprom(struct ahd_softc *ahd);
+static int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
+				      int target, char channel, int lun,
+				      u_int tag, role_t role);
 
 /******************************** Private Inlines *****************************/
 
@@ -7256,7 +7259,7 @@ ahd_busy_tcl(struct ahd_softc *ahd, u_in
 }
 
 /************************** SCB and SCB queue management **********************/
-int
+static int
 ahd_match_scb(struct ahd_softc *ahd, struct scb *scb, int target,
 	      char channel, int lun, u_int tag, role_t role)
 {
_
