From: akpm@osdl.org
Subject: [patch 04/17] drivers/scsi/: small cleanups
Date: Tue, 18 Apr 2006 21:09:12 -0700
Message-ID: <200604190409.k3J49slc008202@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:2766 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750786AbWDSENI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 00:13:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- make needlessly global functions static
- every file should #include the headers containing the prototypes for
  it's global functions

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_sysctl.c       |    1 +
 drivers/scsi/scsi_sysfs.c        |    3 ++-
 drivers/scsi/scsi_transport_fc.c |    2 +-
 drivers/scsi/sr.c                |    2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/scsi_sysctl.c~drivers-scsi-small-cleanups drivers/scsi/scsi_sysctl.c
--- devel/drivers/scsi/scsi_sysctl.c~drivers-scsi-small-cleanups	2006-04-14 23:41:41.000000000 -0700
+++ devel-akpm/drivers/scsi/scsi_sysctl.c	2006-04-14 23:41:41.000000000 -0700
@@ -9,6 +9,7 @@
 #include <linux/sysctl.h>
 
 #include "scsi_logging.h"
+#include "scsi_priv.h"
 
 
 static ctl_table scsi_table[] = {
diff -puN drivers/scsi/scsi_sysfs.c~drivers-scsi-small-cleanups drivers/scsi/scsi_sysfs.c
--- devel/drivers/scsi/scsi_sysfs.c~drivers-scsi-small-cleanups	2006-04-14 23:41:41.000000000 -0700
+++ devel-akpm/drivers/scsi/scsi_sysfs.c	2006-04-14 23:41:41.000000000 -0700
@@ -17,6 +17,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
+#include <scsi/scsi_driver.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -763,7 +764,7 @@ void scsi_remove_device(struct scsi_devi
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
-void __scsi_remove_target(struct scsi_target *starget)
+static void __scsi_remove_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
diff -puN drivers/scsi/scsi_transport_fc.c~drivers-scsi-small-cleanups drivers/scsi/scsi_transport_fc.c
--- devel/drivers/scsi/scsi_transport_fc.c~drivers-scsi-small-cleanups	2006-04-14 23:41:41.000000000 -0700
+++ devel-akpm/drivers/scsi/scsi_transport_fc.c	2006-04-14 23:41:41.000000000 -0700
@@ -1493,7 +1493,7 @@ fc_rport_final_delete(void *data)
  * Notes:
  *	This routine assumes no locks are held on entry.
  **/
-struct fc_rport *
+static struct fc_rport *
 fc_rport_create(struct Scsi_Host *shost, int channel,
 	struct fc_rport_identifiers  *ids)
 {
diff -puN drivers/scsi/sr.c~drivers-scsi-small-cleanups drivers/scsi/sr.c
--- devel/drivers/scsi/sr.c~drivers-scsi-small-cleanups	2006-04-14 23:41:41.000000000 -0700
+++ devel-akpm/drivers/scsi/sr.c	2006-04-14 23:41:41.000000000 -0700
@@ -174,7 +174,7 @@ static void scsi_cd_put(struct scsi_cd *
  * an inode for that to work, and we do not always have one.
  */
 
-int sr_media_change(struct cdrom_device_info *cdi, int slot)
+static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
 	int retval;
_
