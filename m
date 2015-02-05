From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] SCSI-aic7...: Delete unnecessary checks before the function
 call "kfree"
Date: Thu, 05 Feb 2015 22:27:51 +0100
Message-ID: <54D3E057.9030600@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E. J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 5 Feb 2015 22:23:48 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 10172a3..98a5ed1 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2200,8 +2200,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u_int scsi_id, char channel, int force)
 	if (channel == 'B')
 		scsi_id += 8;
 	tstate = ahc->enabled_targets[scsi_id];
-	if (tstate != NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahc->enabled_targets[scsi_id] = NULL;
 }
 #endif
@@ -4482,8 +4481,7 @@ ahc_set_unit(struct ahc_softc *ahc, int unit)
 void
 ahc_set_name(struct ahc_softc *ahc, char *name)
 {
-	if (ahc->name != NULL)
-		kfree(ahc->name);
+	kfree(ahc->name);
 	ahc->name = name;
 }
 
@@ -4550,10 +4548,8 @@ ahc_free(struct ahc_softc *ahc)
 		kfree(ahc->black_hole);
 	}
 #endif
-	if (ahc->name != NULL)
-		kfree(ahc->name);
-	if (ahc->seep_config != NULL)
-		kfree(ahc->seep_config);
+	kfree(ahc->name);
+	kfree(ahc->seep_config);
 #ifndef __FreeBSD__
 	kfree(ahc);
 #endif
@@ -4958,8 +4954,7 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 	case 0:
 		break;
 	}
-	if (scb_data->scbarray != NULL)
-		kfree(scb_data->scbarray);
+	kfree(scb_data->scbarray);
 }
 
 static void
-- 
2.2.2
