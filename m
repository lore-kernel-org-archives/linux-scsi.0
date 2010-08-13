From: Sage Weil <sage@newdream.net>
Subject: [PATCH 4/8] ceph-rbd: enable creation of clients that don't need mds
Date: Fri, 13 Aug 2010 10:40:36 -0700
Message-ID: <1281721240-26130-5-git-send-email-sage@newdream.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:46701 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761919Ab0HMRlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2010 13:41:45 -0400
In-Reply-To: <1281721240-26130-1-git-send-email-sage@newdream.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, yehuda@hq.newdream.net, Sage Weil <sage@newdream.net>

From: Yehuda Sadeh <yehuda@hq.newdream.net>

Preparing grounds for rbd that doesn't need mds client.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/debugfs.c    |   11 ++++++++---
 fs/ceph/mon_client.c |    3 ++-
 fs/ceph/super.c      |   18 ++++++++++++------
 fs/ceph/super.h      |    2 ++
 4 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 360c4f2..02536f7 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -441,9 +441,14 @@ int ceph_debugfs_client_init(struct ceph_client *client)
 	if (!client->debugfs_congestion_kb)
 		goto out;
 
-	sprintf(name, "../../bdi/%s", dev_name(client->sb->s_bdi->dev));
-	client->debugfs_bdi = debugfs_create_symlink("bdi", client->debugfs_dir,
-						     name);
+	if (client->backing_dev_info.dev) {
+		sprintf(name, "../../bdi/%s",
+			dev_name(client->backing_dev_info.dev));
+		client->debugfs_bdi =
+			debugfs_create_symlink("bdi",
+					       client->debugfs_dir,
+					       name);
+	}
 
 	return 0;
 
diff --git a/fs/ceph/mon_client.c b/fs/ceph/mon_client.c
index b2a5a3e..816a9ce 100644
--- a/fs/ceph/mon_client.c
+++ b/fs/ceph/mon_client.c
@@ -923,7 +923,8 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 		break;
 
 	case CEPH_MSG_MDS_MAP:
-		ceph_mdsc_handle_map(&monc->client->mdsc, msg);
+		if (monc->client->have_mdsc)
+			ceph_mdsc_handle_map(&monc->client->mdsc, msg);
 		break;
 
 	case CEPH_MSG_OSD_MAP:
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9922628..ff295c9 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -620,7 +620,8 @@ static void destroy_mount_args(struct ceph_mount_args *args)
 /*
  * create a fresh client instance
  */
-static struct ceph_client *ceph_create_client(struct ceph_mount_args *args)
+struct ceph_client *ceph_create_client(struct ceph_mount_args *args,
+				       int need_mdsc)
 {
 	struct ceph_client *client;
 	int err = -ENOMEM;
@@ -674,9 +675,13 @@ static struct ceph_client *ceph_create_client(struct ceph_mount_args *args)
 	err = ceph_osdc_init(&client->osdc, client);
 	if (err < 0)
 		goto fail_monc;
-	err = ceph_mdsc_init(&client->mdsc, client);
-	if (err < 0)
-		goto fail_osdc;
+	if (need_mdsc) {
+		err = ceph_mdsc_init(&client->mdsc, client);
+		if (err < 0)
+			goto fail_osdc;
+		client->have_mdsc = 1;
+	}
+
 	return client;
 
 fail_osdc:
@@ -703,7 +708,8 @@ static void ceph_destroy_client(struct ceph_client *client)
 	dout("destroy_client %p\n", client);
 
 	/* unmount */
-	ceph_mdsc_stop(&client->mdsc);
+	if (client->have_mdsc)
+		ceph_mdsc_stop(&client->mdsc);
 	ceph_osdc_stop(&client->osdc);
 
 	/*
@@ -996,7 +1002,7 @@ static int ceph_get_sb(struct file_system_type *fs_type,
 	}
 
 	/* create client (which we may/may not use) */
-	client = ceph_create_client(args);
+	client = ceph_create_client(args, 1);
 	if (IS_ERR(client)) {
 		err = PTR_ERR(client);
 		goto out_final;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 2482d69..bdf089f 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -145,6 +145,8 @@ struct ceph_client {
 
 	int min_caps;                  /* min caps i added */
 
+	int have_mdsc;
+
 	struct ceph_messenger *msgr;   /* messenger instance */
 	struct ceph_mon_client monc;
 	struct ceph_mds_client mdsc;
-- 
1.7.0

