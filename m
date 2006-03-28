From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg: fix leak when dio setup fails
Date: Tue, 28 Mar 2006 14:48:22 -0500
Message-ID: <44299306.4080709@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040407090706040205020208"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:27825 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1751313AbWC1Tso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 14:48:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: lgeek@frontiernet.net

This is a multi-part message in MIME format.
--------------040407090706040205020208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Further to this thread started by Bryan Holty:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114306885116728&w=2

Here is the reworked patch again. This time it has been
tested with a program provided by Bryan. The patch is
against lk 2.6.16 .

Changelog:
  - when the sg driver is unable to setup direct IO,
    free that scatter gather list prior to falling
    back to indirect IO

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


--------------040407090706040205020208
Content-Type: text/x-patch;
 name="sg2616dio_lk.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg2616dio_lk.diff"

--- linux/drivers/scsi/sg.c	2006-03-20 10:08:49.000000000 -0500
+++ linux/drivers/scsi/sg.c2616dio_lk	2006-03-22 18:26:23.000000000 -0500
@@ -1834,8 +1834,10 @@
 	res = st_map_user_pages(schp->buffer, mx_sc_elems,
 				(unsigned long)hp->dxferp, dxfer_len, 
 				(SG_DXFER_TO_DEV == hp->dxfer_direction) ? 1 : 0);
-	if (res <= 0)
+	if (res <= 0) {
+		sg_remove_scat(schp);
 		return 1;
+	}
 	schp->k_use_sg = res;
 	schp->dio_in_use = 1;
 	hp->info |= SG_INFO_DIRECT_IO;

--------------040407090706040205020208--
