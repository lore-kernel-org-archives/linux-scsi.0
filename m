From: akpm@osdl.org
Subject: [patch 2/3] support swsusp for aic7xxx
Date: Mon, 26 Apr 2004 22:01:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404270501.i3R51c207731@mail.osdl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:57001 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263557AbUD0FBl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 01:01:41 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: gibbs@scsiguy.com, linux-scsi@vger.kernel.org, akpm@osdl.org, pavel@ucw.cz


From: Pavel Machek <pavel@ucw.cz>

Marks threads as needed for suspend.
DESC
aic79xx_osm.c build fix
EDESC

drivers/scsi/aic7xxx/aic79xx_osm.c: In function `ahd_linux_dv_thread':
drivers/scsi/aic7xxx/aic79xx_osm.c:2594: `PF_IOTHREAD' undeclared (first use in this function)



---

 25-akpm/drivers/scsi/aic7xxx/aic79xx_osm.c |    1 +
 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~aic7xxx-swsusp-support drivers/scsi/aic7xxx/aic79xx_osm.c
--- 25/drivers/scsi/aic7xxx/aic79xx_osm.c~aic7xxx-swsusp-support	2004-04-25 23:09:37.428392128 -0700
+++ 25-akpm/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-04-25 23:09:37.436390912 -0700
@@ -2591,6 +2591,7 @@ ahd_linux_dv_thread(void *data)
 	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
 #else
 	daemonize("ahd_dv_%d", ahd->unit);
+	current->flags |= PF_FREEZE;
 #endif
 	unlock_kernel();
 
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-swsusp-support drivers/scsi/aic7xxx/aic7xxx_osm.c
--- 25/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-swsusp-support	2004-04-25 23:09:37.430391824 -0700
+++ 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-04-25 23:09:37.440390304 -0700
@@ -2307,6 +2307,7 @@ ahc_linux_dv_thread(void *data)
 	sprintf(current->comm, "ahc_dv_%d", ahc->unit);
 #else
 	daemonize("ahc_dv_%d", ahc->unit);
+	current->flags |= PF_FREEZE;
 #endif
 	unlock_kernel();
 

_
