From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] xxx: use kstrdup()
Date: Sat, 06 Aug 2011 17:34:27 +0200
Message-ID: <1312644871.5589.134.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kstrdup rather than duplicating its implementation

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/kstrdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/aic7770_osm.c
--- a/drivers/scsi/aic7xxx/aic7770_osm.c 2010-09-13 07:01:17.513861341 +0200
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c 2011-08-01 21:15:57.315103668 +0200
@@ -85,10 +85,9 @@ aic7770_probe(struct device *dev)
 	int	error;
 
 	sprintf(buf, "ahc_eisa:%d", eisaBase >> 12);
-	name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	name = kstrdup(buf, GFP_ATOMIC);
 	if (name == NULL)
 		return (ENOMEM);
-	strcpy(name, buf);
 	ahc = ahc_alloc(&aic7xxx_driver_template, name);
 	if (ahc == NULL)
 		return (ENOMEM);
