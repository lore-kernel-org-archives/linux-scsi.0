From: Brian King <brking@us.ibm.com>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Sun, 20 Nov 2005 22:53:16 -0600
Message-ID: <438152BC.3060505@us.ibm.com>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437D97E9.8020709@torque.net> <200511181355.17911.kilian.cavalotti@lip6.fr> <437DECDB.3070509@us.ibm.com> <437E5E1E.2080902@torque.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040208090800000801030303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:18398 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S932145AbVKUEyD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2005 23:54:03 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jAL4rxw8014068
	for <linux-scsi@vger.kernel.org>; Sun, 20 Nov 2005 23:53:59 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jAL4tJ0D071612
	for <linux-scsi@vger.kernel.org>; Sun, 20 Nov 2005 21:55:19 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jAL4rwOO011218
	for <linux-scsi@vger.kernel.org>; Sun, 20 Nov 2005 21:53:58 -0700
In-Reply-To: <437E5E1E.2080902@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040208090800000801030303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> Perhaps Kilian could try the following patch (borrowed from
> scsi_debug). The patch is against lk 2.6.15-rc1 but should
> by widely applicable (unless the aic7... series really
> does have a 12 byte limit). I will report back if this
> patch has any adverse impact on "sg_readcap -16" which
> should report: "illegal request/invalid command operation
> code" on my hardware.

I don't think slave_configure is the right place to be modifying
a scsi_host attribute. How about this patch instead? Only compile
tested.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------040208090800000801030303
Content-Type: text/x-patch;
 name="aic7xxx_max_cmd_len.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx_max_cmd_len.patch"



Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/aic7xxx/aic79xx.h     |    2 ++
 drivers/scsi/aic7xxx/aic79xx_osm.c |    1 +
 drivers/scsi/aic7xxx/aic7xxx.h     |    2 ++
 drivers/scsi/aic7xxx/aic7xxx_osm.c |    1 +
 4 files changed, 6 insertions(+)

diff -puN drivers/scsi/aic7xxx/aic79xx.h~aic7xxx_max_cmd_len drivers/scsi/aic7xxx/aic79xx.h
--- linux-2.6/drivers/scsi/aic7xxx/aic79xx.h~aic7xxx_max_cmd_len	2005-11-20 22:22:28.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/aic7xxx/aic79xx.h	2005-11-20 22:22:28.000000000 -0600
@@ -201,6 +201,8 @@ do {								\
 /* Reset line assertion time in us */
 #define AHD_BUSRESET_DELAY	25
 
+#define AHD_MAX_CMD_LEN	16
+
 /******************* Chip Characteristics/Operating Settings  *****************/
 /*
  * Chip Type
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~aic7xxx_max_cmd_len drivers/scsi/aic7xxx/aic79xx_osm.c
--- linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c~aic7xxx_max_cmd_len	2005-11-20 22:22:28.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-11-20 22:22:28.000000000 -0600
@@ -1081,6 +1081,7 @@ ahd_linux_register_host(struct ahd_softc
 	host->max_id = (ahd->features & AHD_WIDE) ? 16 : 8;
 	host->max_lun = AHD_NUM_LUNS;
 	host->max_channel = 0;
+	host->max_cmd_len = AHD_MAX_CMD_LEN;
 	host->sg_tablesize = AHD_NSEG;
 	ahd_set_unit(ahd, ahd_linux_unit++);
 	sprintf(buf, "scsi%d", host->host_no);
diff -puN drivers/scsi/aic7xxx/aic7xxx.h~aic7xxx_max_cmd_len drivers/scsi/aic7xxx/aic7xxx.h
--- linux-2.6/drivers/scsi/aic7xxx/aic7xxx.h~aic7xxx_max_cmd_len	2005-11-20 22:22:28.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/aic7xxx/aic7xxx.h	2005-11-20 22:22:28.000000000 -0600
@@ -181,6 +181,8 @@ struct seeprom_descriptor;
 /* Reset line assertion time in us */
 #define AHC_BUSRESET_DELAY	25
 
+#define AHC_MAX_CMD_LEN		16
+
 /******************* Chip Characteristics/Operating Settings  *****************/
 /*
  * Chip Type
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx_max_cmd_len drivers/scsi/aic7xxx/aic7xxx_osm.c
--- linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx_max_cmd_len	2005-11-20 22:22:28.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-11-20 22:22:28.000000000 -0600
@@ -1082,6 +1082,7 @@ ahc_linux_register_host(struct ahc_softc
 	host->max_id = (ahc->features & AHC_WIDE) ? 16 : 8;
 	host->max_lun = AHC_NUM_LUNS;
 	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
+	host->max_cmd_len = AHC_MAX_CMD_LEN;
 	host->sg_tablesize = AHC_NSEG;
 	ahc_set_unit(ahc, ahc_linux_unit++);
 	sprintf(buf, "scsi%d", host->host_no);
_

--------------040208090800000801030303--
