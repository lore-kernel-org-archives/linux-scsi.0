From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_match_scb() static
Date: Sat, 18 Mar 2006 19:45:12 +0100
Message-ID: <20060318184512.GE14608@stusta.de>
References: <20060318044056.350a2931.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45839 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1750797AbWCRSpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 13:45:13 -0500
Content-Disposition: inline
In-Reply-To: <20060318044056.350a2931.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Mar 18, 2006 at 04:40:56AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.16-rc6-mm1:
>...
>  git-scsi-misc.patch
>...
>  git trees.

ahd_match_scb() can now become static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/aic7xxx/aic79xx.h      |    3 ---
 drivers/scsi/aic7xxx/aic79xx_core.c |    5 ++++-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.16-rc6-mm2-full/drivers/scsi/aic7xxx/aic79xx.h.old	2006-03-18 18:33:30.000000000 +0100
+++ linux-2.6.16-rc6-mm2-full/drivers/scsi/aic7xxx/aic79xx.h	2006-03-18 18:33:38.000000000 +0100
@@ -1347,9 +1347,6 @@
 /************************** SCB and SCB queue management **********************/
 void		ahd_qinfifo_requeue_tail(struct ahd_softc *ahd,
 					 struct scb *scb);
-int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
-			      int target, char channel, int lun,
-			      u_int tag, role_t role);
 
 /****************************** Initialization ********************************/
 struct ahd_softc	*ahd_alloc(void *platform_arg, char *name);
--- linux-2.6.16-rc6-mm2-full/drivers/scsi/aic7xxx/aic79xx_core.c.old	2006-03-18 18:33:45.000000000 +0100
+++ linux-2.6.16-rc6-mm2-full/drivers/scsi/aic7xxx/aic79xx_core.c	2006-03-18 18:36:31.000000000 +0100
@@ -263,6 +263,9 @@
 						     u_int mincmds);
 static int		ahd_verify_vpd_cksum(struct vpd_config *vpd);
 static int		ahd_wait_seeprom(struct ahd_softc *ahd);
+static int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
+				      int target, char channel, int lun,
+				      u_int tag, role_t role);
 
 /******************************** Private Inlines *****************************/
 
@@ -7236,7 +7239,7 @@
 }
 
 /************************** SCB and SCB queue management **********************/
-int
+static int
 ahd_match_scb(struct ahd_softc *ahd, struct scb *scb, int target,
 	      char channel, int lun, u_int tag, role_t role)
 {

