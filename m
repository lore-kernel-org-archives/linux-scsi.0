From: Denis Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 3/4] aic7xxx: remove excessive inlining
Date: Sun, 13 Aug 2006 15:05:49 +0200
Message-ID: <200608131505.49995.vda.linux@googlemail.com>
References: <200608131457.21951.vda.linux@googlemail.com> <200608131502.10664.vda.linux@googlemail.com> <200608131503.07987.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tOy3E9ALqzrmxIZ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:47811 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751235AbWHMNF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 09:05:57 -0400
Received: by nf-out-0910.google.com with SMTP id a4so1426713nfc
        for <linux-scsi@vger.kernel.org>; Sun, 13 Aug 2006 06:05:56 -0700 (PDT)
In-Reply-To: <200608131503.07987.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

--Boundary-00=_tOy3E9ALqzrmxIZ
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 13 August 2006 15:03, Denis Vlasenko wrote:
> On Sunday 13 August 2006 15:02, Denis Vlasenko wrote:
> > Basically, patches deinline some functions, mainly those
> > which perform port I/O.
> 
> ahd_suspend/resume are not used. #ifdef them out.

I forgot to attach the file. :(
--
vda

--Boundary-00=_tOy3E9ALqzrmxIZ
Content-Type: text/x-diff;
  charset="koi8-r";
  name="3.UNUSED.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="3.UNUSED.diff"

diff -urpN -U4 linux-2.6.17.8.aic2/drivers/scsi/aic7xxx/aic79xx_core.c linux-2.6.17.8.aic3/drivers/scsi/aic7xxx/aic79xx_core.c
--- linux-2.6.17.8.aic2/drivers/scsi/aic7xxx/aic79xx_core.c	2006-08-13 12:01:38.000000000 +0200
+++ linux-2.6.17.8.aic3/drivers/scsi/aic7xxx/aic79xx_core.c	2006-08-13 12:01:42.000000000 +0200
@@ -7681,8 +7681,9 @@ ahd_pause_and_flushwork(struct ahd_softc
 
 	ahd->flags &= ~AHD_ALL_INTERRUPTS;
 }
 
+#ifdef UNUSED
 int
 ahd_suspend(struct ahd_softc *ahd)
 {
 
@@ -7704,16 +7705,17 @@ ahd_resume(struct ahd_softc *ahd)
 	ahd_intr_enable(ahd, TRUE); 
 	ahd_restart(ahd);
 	return (0);
 }
+#endif
 
 /************************** Busy Target Table *********************************/
 /*
  * Set SCBPTR to the SCB that contains the busy
  * table entry for TCL.  Return the offset into
  * the SCB that contains the entry for TCL.
  * saved_scbid is dereferenced and set to the
- * scbid that should be restored once manipualtion
+ * scbid that should be restored once manipulation
  * of the TCL entry is complete.
  */
 static u_int
 ahd_index_busy_tcl(struct ahd_softc *ahd, u_int *saved_scbid, u_int tcl)

--Boundary-00=_tOy3E9ALqzrmxIZ--
