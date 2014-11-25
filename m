From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 2/5] scsi_debug: append inject error flags onto scsi_cmnd
 object
Date: Mon, 24 Nov 2014 23:05:05 -0500
Message-ID: <5473FFF1.9090608@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010903080303010107000103"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54378 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbaKYEFU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 23:05:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>

This is a multi-part message in MIME format.
--------------010903080303010107000103
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 24 Nov 2014 20:18:02 -0500
Subject: [PATCH 2/5] append inject error flags onto scsi_cmnd object

The way the existing scsi_debug command parser associated various
inject error flags to a command was difficult to replicate in the
table driven parser. This patch adds infrastructure to append those
flags to the end of a scsi_cmnd object with the cmd_size host
template option.
---
  drivers/scsi/scsi_debug.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++
  1 file changed, 68 insertions(+)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------010903080303010107000103
Content-Type: text/x-patch;
 name="0002-append-inject-error-flags-onto-scsi_cmnd-object.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-append-inject-error-flags-onto-scsi_cmnd-object.patch"

>From f951ae83459d893db05d8c1a0c98fb0eb5ef48fc Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 24 Nov 2014 20:18:02 -0500
Subject: [PATCH 2/5] append inject error flags onto scsi_cmnd object

The way the existing scsi_debug command parser associated various
inject error flags to a command was difficult to replicate in the
table driven parser. This patch adds infrastructure to append those
flags to the end of a scsi_cmnd object with the cmd_size host
template option.
---
 drivers/scsi/scsi_debug.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a1bca60..d337eaa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -209,6 +209,14 @@ static const char *scsi_debug_version_date = "20141022";
 #warning "Expect DEF_CMD_PER_LUN <= SCSI_DEBUG_CANQUEUE"
 #endif
 
+struct sdebug_scmd_extra_t {
+	bool inj_recovered;
+	bool inj_transport;
+	bool inj_dif;
+	bool inj_dix;
+	bool inj_short;
+};
+
 static int scsi_debug_add_host = DEF_NUM_HOST;
 static int scsi_debug_ato = DEF_ATO;
 static int scsi_debug_delay = DEF_DELAY;
@@ -248,6 +256,7 @@ static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 static bool scsi_debug_removable = DEF_REMOVABLE;
 static bool scsi_debug_clustering;
 static bool scsi_debug_host_lock = DEF_HOST_LOCK;
+static bool sdebug_any_injecting_opt;
 
 static atomic_t sdebug_cmnd_count;
 static atomic_t sdebug_completions;
@@ -3416,6 +3425,16 @@ static ssize_t opts_store(struct device_driver *ddp, const char *buf,
 	return -EINVAL;
 opts_done:
 	scsi_debug_opts = opts;
+	if (SCSI_DEBUG_OPT_RECOVERED_ERR & opts)
+		sdebug_any_injecting_opt = true;
+	else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & opts)
+		sdebug_any_injecting_opt = true;
+	else if (SCSI_DEBUG_OPT_DIF_ERR & opts)
+		sdebug_any_injecting_opt = true;
+	else if (SCSI_DEBUG_OPT_DIX_ERR & opts)
+		sdebug_any_injecting_opt = true;
+	else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & opts)
+		sdebug_any_injecting_opt = true;
 	atomic_set(&sdebug_cmnd_count, 0);
 	atomic_set(&sdebug_a_tsf, 0);
 	return count;
@@ -4563,6 +4582,41 @@ sdebug_change_qtype(struct scsi_device *sdev, int qtype)
 	return qtype;
 }
 
+static int
+check_inject(struct scsi_cmnd *scp)
+{
+	struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
+
+	memset(ep, 0, sizeof(struct sdebug_scmd_extra_t));
+
+	if (atomic_inc_return(&sdebug_cmnd_count) >=
+	    abs(scsi_debug_every_nth)) {
+		atomic_set(&sdebug_cmnd_count, 0);
+		if (scsi_debug_every_nth < -1)
+			scsi_debug_every_nth = -1;
+		if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
+			return 1; /* ignore command causing timeout */
+		else if (SCSI_DEBUG_OPT_MAC_TIMEOUT & scsi_debug_opts &&
+			 scsi_medium_access_command(scp))
+			return 1; /* time out reads and writes */
+		if (sdebug_any_injecting_opt) {
+			int opts = scsi_debug_opts;
+
+			if (SCSI_DEBUG_OPT_RECOVERED_ERR & opts)
+				ep->inj_recovered = true;
+			else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & opts)
+				ep->inj_transport = true;
+			else if (SCSI_DEBUG_OPT_DIF_ERR & opts)
+				ep->inj_dif = true;
+			else if (SCSI_DEBUG_OPT_DIX_ERR & opts)
+				ep->inj_dix = true;
+			else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & opts)
+				ep->inj_short = true;
+		}
+	}
+	return 0;
+}
+
 static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
 	.write_info =		scsi_debug_write_info,
@@ -4589,11 +4643,13 @@ static struct scsi_host_template sdebug_driver_template = {
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
 	.track_queue_depth =	1,
+	.cmd_size =		sizeof(struct sdebug_scmd_extra_t),
 };
 
 static int sdebug_driver_probe(struct device * dev)
 {
 	int error = 0;
+	int opts;
 	struct sdebug_host_info *sdbg_host;
 	struct Scsi_Host *hpnt;
 	int host_prot;
@@ -4662,6 +4718,18 @@ static int sdebug_driver_probe(struct device * dev)
 	else
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_CRC);
 
+	opts = scsi_debug_opts;
+	if (SCSI_DEBUG_OPT_RECOVERED_ERR & opts)
+		sdebug_any_injecting_opt = true;
+	else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & opts)
+		sdebug_any_injecting_opt = true;
+	else if (SCSI_DEBUG_OPT_DIF_ERR & opts)
+		sdebug_any_injecting_opt = true;
+	else if (SCSI_DEBUG_OPT_DIX_ERR & opts)
+		sdebug_any_injecting_opt = true;
+	else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & opts)
+		sdebug_any_injecting_opt = true;
+
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
                 printk(KERN_ERR "%s: scsi_add_host failed\n", __func__);
-- 
1.9.1


--------------010903080303010107000103--
