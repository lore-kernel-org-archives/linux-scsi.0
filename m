From: akpm@linux-foundation.org
Subject: [patch 04/16] git-scsi-misc: fix SCSI_DH build errors
Date: Thu, 03 Jul 2008 23:47:25 -0700
Message-ID: <200807040647.m646lPjk017478@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755555AbYGDGsy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 02:48:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, sekharan@us.ibm.com, agk@redhat.com, andmike@us.ibm.com, hare@suse.de, michaelc@cs.wisc.edu, randy.dunlap@oracle.com

From: Chandra Seetharaman <sekharan@us.ibm.com>

Do not automatically "select" SCSI_DH for dm-multipath. If SCSI_DH
doesn't exist, just do not allow  hardware handlers to be used.

Handle SCSI_DH being a module also. Make sure it doesn't allow DM_MULTIPATH
to be compiled in when SCSI_DH is a module.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Anderson <andmike@us.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/Kconfig     |    2 +-
 drivers/md/dm-mpath.c  |    2 ++
 include/scsi/scsi_dh.h |   12 +++++++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/md/Kconfig~git-scsi-misc-fix-scsi_dh-build-errors drivers/md/Kconfig
--- a/drivers/md/Kconfig~git-scsi-misc-fix-scsi_dh-build-errors
+++ a/drivers/md/Kconfig
@@ -252,7 +252,7 @@ config DM_ZERO
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
-	select SCSI_DH
+	depends on SCSI_DH || !SCSI_DH
 	---help---
 	  Allow volume managers to support multipath hardware.
 
diff -puN drivers/md/dm-mpath.c~git-scsi-misc-fix-scsi_dh-build-errors drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~git-scsi-misc-fix-scsi_dh-build-errors
+++ a/drivers/md/dm-mpath.c
@@ -664,6 +664,8 @@ static int parse_hw_handler(struct arg_s
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
 		ti->error = "unknown hardware handler type";
+		kfree(m->hw_handler_name);
+		m->hw_handler_name = NULL;
 		return -EINVAL;
 	}
 	consume(as, hw_argc - 1);
diff -puN include/scsi/scsi_dh.h~git-scsi-misc-fix-scsi_dh-build-errors include/scsi/scsi_dh.h
--- a/include/scsi/scsi_dh.h~git-scsi-misc-fix-scsi_dh-build-errors
+++ a/include/scsi/scsi_dh.h
@@ -54,6 +54,16 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
-
+#if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
+#else
+static inline int scsi_dh_activate(struct request_queue *req)
+{
+	return 0;
+}
+static inline int scsi_dh_handler_exist(const char *name)
+{
+	return 0;
+}
+#endif
_
