From: thomas schorpp <thomas.schorpp@googlemail.com>
Subject: [PATCH]aic7xxx: Take the LED out of diagnostic mode on PM resume,
 too.
Date: Fri, 03 Oct 2008 23:45:29 +0200
Message-ID: <48E69279.2000507@gmail.com>
Reply-To: thomas.schorpp@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020306090600020306080309"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:57698 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbYJCVpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2008 17:45:35 -0400
Received: by ug-out-1314.google.com with SMTP id k3so1343539ugf.37
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2008 14:45:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020306090600020306080309
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Take the Diag/Activity-LED of the HBA out of diagnostic mode on PM resume after successful PM resume from standby and HBA restart, 
it remained always on before. If something fails before complete recovery, it should remain on, since it is a diagnostics LED, 
reason for the used higher layer for the clear. 

Signed-off-by: thomas.schorpp@gmail.com




--------------020306090600020306080309
Content-Type: text/x-diff;
 name="aic7xxx_PM_fixled.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx_PM_fixled.patch"

--- drivers/scsi/aic7xxx/aic7xxx_core.c	2008-10-03 13:53:39.000000000 +0200
+++ drivers/scsi/aic7xxx/aic7xxx_core.c	2008-10-03 14:26:04.000000000 +0200
@@ -814,6 +814,7 @@
 static void
 ahc_restart(struct ahc_softc *ahc)
 {
+	uint8_t	sblkctl;
 
 	ahc_pause(ahc);
 
@@ -868,6 +869,12 @@
 	ahc_outb(ahc, SEQADDR0, 0);
 	ahc_outb(ahc, SEQADDR1, 0);
 
+	/*
+	 * Take the LED out of diagnostic mode on PM resume, too
+	 */
+	sblkctl = ahc_inb(ahc, SBLKCTL);
+	ahc_outb(ahc, SBLKCTL, (sblkctl & ~(DIAGLEDEN|DIAGLEDON)));
+
 	ahc_unpause(ahc);
 }
 

--------------020306090600020306080309--
