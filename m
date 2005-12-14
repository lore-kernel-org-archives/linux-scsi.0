From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] handle scsi_add_host failure for aic79xx and fix compiler warning
Date: Wed, 14 Dec 2005 19:27:28 +0100
Message-ID: <200512141927.29163.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.207]:36481 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932480AbVLNS0f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 13:26:35 -0500
Received: by uproxy.gmail.com with SMTP id s2so20982uge
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2005 10:26:34 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Daniel M. Eischen" <deischen@iworks.interworks.org>, Doug Ledford <dledford@redhat.com>


Add scsi_add_host() failure handling for aic79xx
Also silence a compiler warning : 
 drivers/scsi/aic7xxx/aic79xx_osm.c: In function `ahd_linux_register_host':
 drivers/scsi/aic7xxx/aic79xx_osm.c:1099: warning: ignoring return value of `scsi_add_host', declared with attribute warn_unused_result


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/aic7xxx/aic79xx_osm.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

--- linux-2.6.15-rc5-git3-orig/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-12-04 18:48:12.000000000 +0100
+++ linux-2.6.15-rc5-git3/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-12-14 19:14:41.000000000 +0100
@@ -1064,6 +1064,7 @@ ahd_linux_register_host(struct ahd_softc
 	struct	Scsi_Host *host;
 	char	*new_name;
 	u_long	s;
+	int	retval;
 
 	template->name = ahd->description;
 	host = scsi_host_alloc(template, sizeof(struct ahd_softc *));
@@ -1096,9 +1097,15 @@ ahd_linux_register_host(struct ahd_softc
 
 	host->transportt = ahd_linux_transport_template;
 
-	scsi_add_host(host, &ahd->dev_softc->dev); /* XXX handle failure */
+	retval = scsi_add_host(host, &ahd->dev_softc->dev);
+	if (retval) {
+		printk(KERN_WARNING "aic79xx: scsi_add_host failed\n");
+		scsi_host_put(host);
+		return retval;
+	}
+
 	scsi_scan_host(host);
-	return (0);
+	return 0;
 }
 
 uint64_t


