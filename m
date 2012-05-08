From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/3] dm mpath: add support for using previously attached scsi_dh
Date: Mon,  7 May 2012 23:19:07 -0400
Message-ID: <1336447147-3830-2-git-send-email-snitzer@redhat.com>
References: <1336447147-3830-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab2EHDTY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 May 2012 23:19:24 -0400
In-Reply-To: <1336447147-3830-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: agk@redhat.com, hare@suse.de, babu.moger@netapp.com, sekharan@us.ibm.com, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>

Use the previously attached scsi_dh if "default" is provided as the
hardware handler name (the new 'use_default_hw_handler' flag is set in
the multipath structure).

Leverage scsi_dh_attach's ability to increment the scsi_dh's reference
count if the same scsi_dh name is provided when attaching -- currently
attached scsi_dh name is determined with scsi_dh_attached_handler_name.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-mpath.c
+++ linux-2.6/drivers/md/dm-mpath.c
@@ -63,6 +63,7 @@ struct multipath {
 
 	spinlock_t lock;
 
+	unsigned use_default_hw_handler:1;
 	const char *hw_handler_name;
 	char *hw_handler_params;
 
@@ -566,6 +567,7 @@ static struct pgpath *parse_path(struct 
 	int r;
 	struct pgpath *p;
 	struct multipath *m = ti->private;
+	struct request_queue *q = NULL;
 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
@@ -584,9 +586,16 @@ static struct pgpath *parse_path(struct 
 		goto bad;
 	}
 
-	if (m->hw_handler_name) {
-		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+	if (m->use_default_hw_handler || m->hw_handler_name)
+		q = bdev_get_queue(p->path.dev->bdev);
+
+	if (m->use_default_hw_handler) {
+		const char *attached_handler_name = scsi_dh_attached_handler_name(q);
+		if (attached_handler_name)
+			m->hw_handler_name = kstrdup(attached_handler_name, GFP_KERNEL);
+	}
 
+	if (m->hw_handler_name) {
 		r = scsi_dh_attach(q, m->hw_handler_name);
 		if (r == -EBUSY) {
 			/*
@@ -706,6 +715,7 @@ static int parse_hw_handler(struct dm_ar
 	unsigned hw_argc;
 	int ret;
 	struct dm_target *ti = m->ti;
+	const char *hw_handler_name;
 
 	static struct dm_arg _args[] = {
 		{0, 1024, "invalid number of hardware handler args"},
@@ -717,7 +727,13 @@ static int parse_hw_handler(struct dm_ar
 	if (!hw_argc)
 		return 0;
 
-	m->hw_handler_name = kstrdup(dm_shift_arg(as), GFP_KERNEL);
+	hw_handler_name = dm_shift_arg(as);
+	if (!strncmp(hw_handler_name, "default", 8)) {
+		m->use_default_hw_handler = 1;
+		goto parse_hw_handler_params;
+	}
+
+	m->hw_handler_name = kstrdup(hw_handler_name, GFP_KERNEL);
 	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
 				     "scsi_dh_%s", m->hw_handler_name)) {
 		ti->error = "unknown hardware handler type";
@@ -725,6 +741,7 @@ static int parse_hw_handler(struct dm_ar
 		goto fail;
 	}
 
+parse_hw_handler_params:
 	if (hw_argc > 1) {
 		char *p;
 		int i, j, len = 4;
