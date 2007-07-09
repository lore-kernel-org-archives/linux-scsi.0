From: akpm@linux-foundation.org
Subject: [patch 03/17] drivers/scsi/: small cleanups
Date: Mon, 09 Jul 2007 11:59:59 -0700
Message-ID: <200707091900.l69J00Xe002491@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894AbXGITA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 15:00:56 -0400
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
@@ -872,7 +873,7 @@ void scsi_remove_device(struct scsi_devi
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
@@ -2358,7 +2358,7 @@ fc_rport_final_delete(struct work_struct
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
@@ -175,7 +175,7 @@ static void scsi_cd_put(struct scsi_cd *
  * an inode for that to work, and we do not always have one.
  */
 
-int sr_media_change(struct cdrom_device_info *cdi, int slot)
+static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
 	int retval;
_
