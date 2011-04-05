From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH 2/2] SCSI: modify SCSI subsystem
Date: Tue, 05 Apr 2011 21:50:10 +0900
Message-ID: <20110405125010.7969.51857.stgit@ltc233.sdl.hitachi.co.jp>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailx.hitachi.co.jp ([133.145.228.49]:34450 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1DEMw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2011 08:52:29 -0400
In-Reply-To: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@suse.de>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp, Nao Nishijima <nao.nishijima.xt@hitachi.com>

Add a SCSI option for persistent device names in Kernel.

If scsi_mod.persistent_name=1, device names is assigned by udev.
If scsi_mod.persistent_name=0, device names is assigned the order
of logical unit recognizing.

Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 drivers/scsi/sd.c |   10 +++++++---
 drivers/scsi/sr.c |    4 +++-
 drivers/scsi/st.c |    4 +++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b61ebec..94ad290 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -65,6 +65,7 @@
 
 #include "sd.h"
 #include "scsi_logging.h"
+#include "scsi_unnamed.h"
 
 MODULE_AUTHOR("Eric Youngdale");
 MODULE_DESCRIPTION("SCSI disk (sd) driver");
@@ -2554,9 +2555,12 @@ static int sd_probe(struct device *dev)
 		goto out_free_index;
 	}
 
-	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error)
-		goto out_free_index;
+	if (!copy_persistent_name(gd->disk_name, dev)) {
+		error = sd_format_disk_name("sd", index,
+				gd->disk_name, DISK_NAME_LEN);
+		if (error)
+			goto out_free_index;
+	}
 
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index aefadc6..682b1a4 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -58,6 +58,7 @@
 
 #include "scsi_logging.h"
 #include "sr.h"
+#include "scsi_unnamed.h"
 
 
 MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
@@ -634,7 +635,8 @@ static int sr_probe(struct device *dev)
 
 	disk->major = SCSI_CDROM_MAJOR;
 	disk->first_minor = minor;
-	sprintf(disk->disk_name, "sr%d", minor);
+	if (!copy_persistent_name(disk->disk_name, dev))
+		sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
 	disk->flags = GENHD_FL_CD;
 	disk->events = DISK_EVENT_MEDIA_CHANGE | DISK_EVENT_EJECT_REQUEST;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1871b8a..9acf8b2 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -74,6 +74,7 @@ static const char *verstr = "20101219";
 
 #include "st_options.h"
 #include "st.h"
+#include "scsi_unnamed.h"
 
 static DEFINE_MUTEX(st_mutex);
 static int buffer_kbs;
@@ -4051,7 +4052,8 @@ static int st_probe(struct device *dev)
 	}
 	kref_init(&tpnt->kref);
 	tpnt->disk = disk;
-	sprintf(disk->disk_name, "st%d", i);
+	if (!copy_persistent_name(disk->disk_name, dev))
+		sprintf(disk->disk_name, "st%d", i);
 	disk->private_data = &tpnt->driver;
 	disk->queue = SDp->request_queue;
 	tpnt->driver = &st_template;

