From: akpm@linux-foundation.org
Subject: [patch 01/33] drivers/scsi/: small cleanups
Date: Mon, 05 Feb 2007 16:38:27 -0800
Message-ID: <200702060039.l160dUgL004933@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41956 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965384AbXBFAmo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 19:42:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- make needlessly global functions static
- every file should #include the headers containing the prototypes for
  it's global functions

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_sysctl.c       |    1 +
 drivers/scsi/scsi_sysfs.c        |    3 ++-
 drivers/scsi/scsi_transport_fc.c |    2 +-
 drivers/scsi/sr.c                |    2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/scsi_sysctl.c~drivers-scsi-small-cleanups drivers/scsi/scsi_sysctl.c
--- a/drivers/scsi/scsi_sysctl.c~drivers-scsi-small-cleanups
+++ a/drivers/scsi/scsi_sysctl.c
@@ -9,6 +9,7 @@
 #include <linux/sysctl.h>
 
 #include "scsi_logging.h"
+#include "scsi_priv.h"
 
 
 static ctl_table scsi_table[] = {
diff -puN drivers/scsi/scsi_sysfs.c~drivers-scsi-small-cleanups drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~drivers-scsi-small-cleanups
+++ a/drivers/scsi/scsi_sysfs.c
@@ -16,6 +16,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
+#include <scsi/scsi_driver.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -764,7 +765,7 @@ void scsi_remove_device(struct scsi_devi
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
-void __scsi_remove_target(struct scsi_target *starget)
+static void __scsi_remove_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
diff -puN drivers/scsi/scsi_transport_fc.c~drivers-scsi-small-cleanups drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c~drivers-scsi-small-cleanups
+++ a/drivers/scsi/scsi_transport_fc.c
@@ -1796,7 +1796,7 @@ fc_rport_final_delete(struct work_struct
  * Notes:
  *	This routine assumes no locks are held on entry.
  **/
-struct fc_rport *
+static struct fc_rport *
 fc_rport_create(struct Scsi_Host *shost, int channel,
 	struct fc_rport_identifiers  *ids)
 {
diff -puN drivers/scsi/sr.c~drivers-scsi-small-cleanups drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~drivers-scsi-small-cleanups
+++ a/drivers/scsi/sr.c
@@ -174,7 +174,7 @@ static void scsi_cd_put(struct scsi_cd *
  * an inode for that to work, and we do not always have one.
  */
 
-int sr_media_change(struct cdrom_device_info *cdi, int slot)
+static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
 	int retval;
_
