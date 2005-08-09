From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.13-rc5-mm1 doesnt boot on x86_64
Date: Mon, 08 Aug 2005 19:06:50 -0500
Message-ID: <1123546010.8235.18.camel@mulgrave>
References: <20050808094818.A17579@unix-os.sc.intel.com>
	 <20050808171126.GA32092@muc.de> <1123522409.5019.0.camel@mulgrave>
	 <20050808104206.42a51477.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:58496 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932379AbVHIAHo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 20:07:44 -0400
In-Reply-To: <20050808104206.42a51477.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: ak@muc.de, ashok.raj@intel.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-08-08 at 10:42 -0700, Andrew Morton wrote:
> -mm has extra list_head debugging goodies.  I'd be suspecting a list_head
> corruption detected somewhere under spi_release_transport().

Aha, looking in wrong driver ... the problem actually appears to be a
double release of the transport template in aic79xx.  Try this patch

James

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2326,8 +2326,6 @@ done:
 	return (retval);
 }
 
-static void ahd_linux_exit(void);
-
 static void ahd_linux_set_width(struct scsi_target *starget, int width)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2772,7 +2770,7 @@ ahd_linux_init(void)
 	if (ahd_linux_detect(&aic79xx_driver_template) > 0)
 		return 0;
 	spi_release_transport(ahd_linux_transport_template);
-	ahd_linux_exit();
+
 	return -ENODEV;
 }
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2331,8 +2331,6 @@ ahc_platform_dump_card_state(struct ahc_
 {
 }
 
-static void ahc_linux_exit(void);
-
 static void ahc_linux_set_width(struct scsi_target *starget, int width)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);


