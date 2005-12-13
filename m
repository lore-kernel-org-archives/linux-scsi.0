From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] fix warning and missing failure handling for scsi_add_host in aic7xxx driver
Date: Wed, 14 Dec 2005 00:07:19 +0100
Message-ID: <200512140007.20046.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932616AbVLMXGd@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@steeleye.com>, "Daniel M. Eischen" <deischen@iworks.interworks.org>, Doug Ledford <dledford@redhat.com>, James.Bottomley@hansenpartnership.com, Jesper Juhl <jesper.juhl@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

Here's a patch to fix a compiler warning and problem with missing failure 
handling of scsi_add_host noted in comment in aic7xxx_osm

The warning I see (with 2.6.15-rc5-git3) is this one:
drivers/scsi/aic7xxx/aic7xxx_osm.c:1100: warning: ignoring return value of csi_add_host', declared with attribute warn_unused_result

The patch has seen the following testing:
 - compile tested
 - boot tested on a machine using the AIC7XXX driver

Please review and consider for inclusion.


Signed-off-by: Jesper Juhl <jeser.juhl@gmail.com>
---

 drivers/scsi/aic7xxx/aic7xxx_osm.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

--- linux-2.6.15-rc5-git3-orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-12-04 18:48:12.000000000 +0100
+++ linux-2.6.15-rc5-git3/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-12-13 23:47:45.000000000 +0100
@@ -1061,10 +1061,11 @@ uint32_t aic7xxx_verbose;
 int
 ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *template)
 {
-	char	 buf[80];
-	struct	 Scsi_Host *host;
+	char	buf[80];
+	struct	Scsi_Host *host;
 	char	*new_name;
-	u_long	 s;
+	u_long	s;
+	int	retval = 0;
 
 	template->name = ahc->description;
 	host = scsi_host_alloc(template, sizeof(struct ahc_softc *));
@@ -1097,9 +1098,20 @@ ahc_linux_register_host(struct ahc_softc
 
 	host->transportt = ahc_linux_transport_template;
 
-	scsi_add_host(host, (ahc->dev_softc ? &ahc->dev_softc->dev : NULL)); /* XXX handle failure */
+	retval = scsi_add_host(host,
+			(ahc->dev_softc ? &ahc->dev_softc->dev : NULL));
+	if (retval) {
+		printk(KERN_ERR "aic7xxx: scsi_add_host failed\n");
+		goto free_and_out;
+	}
+
 	scsi_scan_host(host);
-	return (0);
+
+out:
+	return retval;
+free_and_out:
+	scsi_remove_host(host);
+	goto out;
 }
 
 /*
