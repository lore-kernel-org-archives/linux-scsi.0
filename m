From: Olaf Hering <olh@suse.de>
Subject: [PATCH] signed bug in scsi_device.h
Date: Thu, 13 May 2004 18:43:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040513164306.GA27050@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:28393 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264300AbUEMQoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 12:44:14 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, akpm@osdl.org


one of the recent aic7xxx versions puts a -1 in scsi_cmnd->device->type=
,
in drivers/scsi/aic7xxx/aic79xx_osm.c
that doesnt work very well on ppc because aic7xxx tends to use -Werror.

maybe scsi_level needs the signed as well.

--- ./include/scsi/scsi_device.h~       2004-05-13 18:22:20.000000000 +=
0200
+++ ./include/scsi/scsi_device.h        2004-05-13 18:27:37.000000000 +=
0200
@@ -57,7 +57,7 @@ struct scsi_device {

        void *hostdata;         /* available to low-level driver */
        char devfs_name[256];   /* devfs junk */
-       char type;
+       signed char type;
        char scsi_level;
        unsigned char inquiry_len;      /* valid bytes in 'inquiry' */
        unsigned char * inquiry;        /* INQUIRY response data */

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
