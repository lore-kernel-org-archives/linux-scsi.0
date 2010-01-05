From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] dm-mpath: Fixing unnecessary argument casting
Date: Tue, 5 Jan 2010 11:39:26 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4877BC84E@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:55122 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754577Ab0AESjl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jan 2010 13:39:41 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Chandra Seetharaman <chandra.seetharaman@us.ibm.com>

This patch removes couple of unnecessary argument casting. There is no functional change with this patch.
Tested the changes with LSI storage..

CC: Chandra Seetharaman <chandra.seetharaman@us.ibm.com>
Signed-off-by: Babu Moger <babu.moger@lsi.com>

---
--- linux-2.6.33-rc2/drivers/md/dm-mpath.c.orig	2010-01-05 12:47:26.000000000 -0400
+++ linux-2.6.33-rc2/drivers/md/dm-mpath.c	2010-01-05 12:34:00.000000000 -0400
@@ -1128,8 +1128,7 @@ static int pg_init_limit_reached(struct
 
 static void pg_init_done(void *data, int errors)
 {
-	struct dm_path *path = data;
-	struct pgpath *pgpath = path_to_pgpath(path);
+	struct pgpath *pgpath = data;
 	struct priority_group *pg = pgpath->pg;
 	struct multipath *m = pg->m;
 	unsigned long flags;
@@ -1198,7 +1197,7 @@ static void activate_path(struct work_st
 		container_of(work, struct pgpath, activate_path);
 
 	scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
-				pg_init_done, &pgpath->path);
+				pg_init_done, pgpath);
 }
 
 /*



