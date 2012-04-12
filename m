From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 10/10] sg: constify sg_proc_leaf_arr
Date: Thu, 12 Apr 2012 17:35:25 -0400
Message-ID: <20120412213524.GJ17388@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:48509 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966261Ab2DLXcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 19:32:03 -0400
Content-Disposition: inline
In-Reply-To: <20120412213217.GA17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/sg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0c646f2..5790358 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2322,7 +2322,7 @@ struct sg_proc_leaf {
 	const struct file_operations * fops;
 };
 
-static struct sg_proc_leaf sg_proc_leaf_arr[] = {
+static const struct sg_proc_leaf sg_proc_leaf_arr[] = {
 	{"allow_dio", &adio_fops},
 	{"debug", &debug_fops},
 	{"def_reserved_size", &dressz_fops},
@@ -2342,7 +2342,7 @@ sg_proc_init(void)
 	if (!sg_proc_sgp)
 		return 1;
 	for (k = 0; k < num_leaves; ++k) {
-		struct sg_proc_leaf *leaf = &sg_proc_leaf_arr[k];
+		const struct sg_proc_leaf *leaf = &sg_proc_leaf_arr[k];
 		umode_t mask = leaf->fops->write ? S_IRUGO | S_IWUSR : S_IRUGO;
 		proc_create(leaf->name, mask, sg_proc_sgp, leaf->fops);
 	}
-- 
1.7.9.1

