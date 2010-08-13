From: Sage Weil <sage@newdream.net>
Subject: [PATCH 5/8] ceph-rbd: refactor mount related functions, add helpers
Date: Fri, 13 Aug 2010 10:40:37 -0700
Message-ID: <1281721240-26130-6-git-send-email-sage@newdream.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1281721240-26130-1-git-send-email-sage@newdream.net>
Sender: ceph-devel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, yehuda@hq.newdream.net, Sage Weil <sage@newdream.net>
List-Id: linux-scsi@vger.kernel.org

From: Yehuda Sadeh <yehuda@hq.newdream.net>

Removed some functions' static declarations, separated mount
operation to __open_session and open_root_dentry for clients
that don't need the latter (rbd). Added other helper functions
that will be used later in the rbd.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/file.c       |   48 ++++++++++++++++-
 fs/ceph/osd_client.h |    1 +
 fs/ceph/super.c      |  149 +++++++++++++++++++++++++++++++++++++------------
 fs/ceph/super.h      |   27 ++++++++-
 4 files changed, 184 insertions(+), 41 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 8c044a4..d1e57c1 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -317,7 +317,7 @@ void ceph_release_page_vector(struct page **pages, int num_pages)
 /*
  * allocate a vector new pages
  */
-static struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags)
+struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags)
 {
 	struct page **pages;
 	int i;
@@ -363,6 +363,52 @@ static int copy_user_to_page_vector(struct page **pages,
 	return len;
 }
 
+int ceph_copy_to_page_vector(struct page **pages,
+				    const char *data,
+				    loff_t off, size_t len)
+{
+	int i = 0;
+	size_t po = off & ~PAGE_CACHE_MASK;
+	size_t left = len;
+	size_t l;
+
+	while (left > 0) {
+		l = min_t(size_t, PAGE_CACHE_SIZE-po, left);
+		memcpy(page_address(pages[i]) + po, data, l);
+		data += l;
+		left -= l;
+		po += l;
+		if (po == PAGE_CACHE_SIZE) {
+			po = 0;
+			i++;
+		}
+	}
+	return len;
+}
+
+int ceph_copy_from_page_vector(struct page **pages,
+				    char *data,
+				    loff_t off, size_t len)
+{
+	int i = 0;
+	size_t po = off & ~PAGE_CACHE_MASK;
+	size_t left = len;
+	size_t l;
+
+	while (left > 0) {
+		l = min_t(size_t, PAGE_CACHE_SIZE-po, left);
+		memcpy(data, page_address(pages[i]) + po, l);
+		data += l;
+		left -= l;
+		po += l;
+		if (po == PAGE_CACHE_SIZE) {
+			po = 0;
+			i++;
+		}
+	}
+	return len;
+}
+
 /*
  * copy user data from a page vector into a user pointer
  */
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
index d583d1b..0a82bd1 100644
--- a/fs/ceph/osd_client.h
+++ b/fs/ceph/osd_client.h
@@ -69,6 +69,7 @@ struct ceph_osd_request {
 	struct list_head  r_unsafe_item;
 
 	struct inode *r_inode;         	      /* for use by callbacks */
+	void *r_priv;			      /* ditto */
 
 	char              r_oid[40];          /* object name */
 	int               r_oid_len;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index ff295c9..c7a9ef4 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -421,14 +421,15 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 	return err;
 }
 
-static struct ceph_mount_args *parse_mount_args(int flags, char *options,
-						const char *dev_name,
-						const char **path)
+struct ceph_mount_args *parse_mount_args(int flags, char *options,
+					 const char *dev_name,
+					 const char **path)
 {
 	struct ceph_mount_args *args;
 	const char *c;
 	int err = -ENOMEM;
 	substring_t argstr[MAX_OPT_ARGS];
+	const char *end_path;
 
 	args = kzalloc(sizeof(*args), GFP_KERNEL);
 	if (!args)
@@ -460,23 +461,29 @@ static struct ceph_mount_args *parse_mount_args(int flags, char *options,
 	err = -EINVAL;
 	if (!dev_name)
 		goto out;
-	*path = strstr(dev_name, ":/");
-	if (*path == NULL) {
-		pr_err("device name is missing path (no :/ in %s)\n",
-		       dev_name);
-		goto out;
+
+	if (path) {
+		*path = strstr(dev_name, ":/");
+		if (*path == NULL) {
+			pr_err("device name is missing path (no :/ in %s)\n",
+			       dev_name);
+			goto out;
+		}
+		end_path = *path;
+
+		/* path on server */
+		*path += 2;
+		dout("server path '%s'\n", *path);
+	} else {
+		end_path = dev_name + strlen(dev_name);
 	}
 
 	/* get mon ip(s) */
-	err = ceph_parse_ips(dev_name, *path, args->mon_addr,
+	err = ceph_parse_ips(dev_name, end_path, args->mon_addr,
 			     CEPH_MAX_MON, &args->num_mon);
 	if (err < 0)
 		goto out;
 
-	/* path on server */
-	*path += 2;
-	dout("server path '%s'\n", *path);
-
 	/* parse mount options */
 	while ((c = strsep(&options, ",")) != NULL) {
 		int token, intval, ret;
@@ -605,18 +612,60 @@ out:
 	return ERR_PTR(err);
 }
 
-static void destroy_mount_args(struct ceph_mount_args *args)
+void ceph_destroy_mount_args(struct ceph_mount_args *args)
 {
 	dout("destroy_mount_args %p\n", args);
 	kfree(args->snapdir_name);
-	args->snapdir_name = NULL;
 	kfree(args->name);
-	args->name = NULL;
 	kfree(args->secret);
-	args->secret = NULL;
 	kfree(args);
 }
 
+static int strcmp_null(const char *s1, const char *s2)
+{
+	if (!s1 && !s2)
+		return 0;
+	if (s1 && !s2)
+		return -1;
+	if (!s1 && s2)
+		return 1;
+	return strcmp(s1, s2);
+}
+
+int ceph_compare_mount_args(struct ceph_mount_args *new_args,
+			    struct ceph_client *client)
+{
+	struct ceph_mount_args *args1 = new_args;
+	struct ceph_mount_args *args2 = client->mount_args;
+	int ofs = offsetof(struct ceph_mount_args, mon_addr);
+	int i;
+	int ret;
+
+	ret = memcmp(args1, args2, ofs);
+	if (ret)
+		return ret;
+
+	ret = strcmp_null(args1->snapdir_name, args2->snapdir_name);
+	if (ret)
+		return ret;
+
+	ret = strcmp_null(args1->name, args2->name);
+	if (ret)
+		return ret;
+
+	ret = strcmp_null(args1->secret, args2->secret);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < args1->num_mon; i++) {
+		if (ceph_monmap_contains(client->monc.monmap,
+				 &args1->mon_addr[i]))
+			return 0;
+	}
+
+	return -1;
+}
+
 /*
  * create a fresh client instance
  */
@@ -703,7 +752,7 @@ fail:
 	return ERR_PTR(err);
 }
 
-static void ceph_destroy_client(struct ceph_client *client)
+void ceph_destroy_client(struct ceph_client *client)
 {
 	dout("destroy_client %p\n", client);
 
@@ -732,7 +781,7 @@ static void ceph_destroy_client(struct ceph_client *client)
 		ceph_messenger_destroy(client->msgr);
 	mempool_destroy(client->wb_pagevec_pool);
 
-	destroy_mount_args(client->mount_args);
+	ceph_destroy_mount_args(client->mount_args);
 
 	kfree(client);
 	dout("destroy_client %p done\n", client);
@@ -813,17 +862,12 @@ static struct dentry *open_root_dentry(struct ceph_client *client,
 /*
  * mount: join the ceph cluster, and open root directory.
  */
-static int ceph_mount(struct ceph_client *client, struct vfsmount *mnt,
-		      const char *path)
+static int __ceph_open_session(struct ceph_client *client,
+			       unsigned long started)
 {
 	struct ceph_entity_addr *myaddr = NULL;
 	int err;
 	unsigned long timeout = client->mount_args->mount_timeout * HZ;
-	unsigned long started = jiffies;  /* note the start time */
-	struct dentry *root;
-
-	dout("mount start\n");
-	mutex_lock(&client->mount_mutex);
 
 	/* initialize the messenger */
 	if (client->msgr == NULL) {
@@ -831,9 +875,8 @@ static int ceph_mount(struct ceph_client *client, struct vfsmount *mnt,
 			myaddr = &client->mount_args->my_addr;
 		client->msgr = ceph_messenger_create(myaddr);
 		if (IS_ERR(client->msgr)) {
-			err = PTR_ERR(client->msgr);
 			client->msgr = NULL;
-			goto out;
+			return PTR_ERR(client->msgr);
 		}
 		client->msgr->nocrc = ceph_test_opt(client, NOCRC);
 	}
@@ -841,26 +884,58 @@ static int ceph_mount(struct ceph_client *client, struct vfsmount *mnt,
 	/* open session, and wait for mon, mds, and osd maps */
 	err = ceph_monc_open_session(&client->monc);
 	if (err < 0)
-		goto out;
+		return err;
 
 	while (!have_mon_and_osd_map(client)) {
 		err = -EIO;
 		if (timeout && time_after_eq(jiffies, started + timeout))
-			goto out;
+			return err;
 
 		/* wait */
 		dout("mount waiting for mon_map\n");
 		err = wait_event_interruptible_timeout(client->auth_wq,
-		       have_mon_and_osd_map(client) || (client->auth_err < 0),
-		       timeout);
+			have_mon_and_osd_map(client) || (client->auth_err < 0),
+			timeout);
 		if (err == -EINTR || err == -ERESTARTSYS)
-			goto out;
-		if (client->auth_err < 0) {
-			err = client->auth_err;
-			goto out;
-		}
+			return err;
+		if (client->auth_err < 0)
+			return client->auth_err;
 	}
 
+	return 0;
+}
+
+int ceph_open_session(struct ceph_client *client)
+{
+	int ret;
+	unsigned long started = jiffies;  /* note the start time */
+
+	dout("open_session start\n");
+	mutex_lock(&client->mount_mutex);
+
+	ret = __ceph_open_session(client, started);
+
+	mutex_unlock(&client->mount_mutex);
+	return ret;
+}
+
+/*
+ * mount: join the ceph cluster, and open root directory.
+ */
+static int ceph_mount(struct ceph_client *client, struct vfsmount *mnt,
+		      const char *path)
+{
+	int err;
+	unsigned long started = jiffies;  /* note the start time */
+	struct dentry *root;
+
+	dout("mount start\n");
+	mutex_lock(&client->mount_mutex);
+
+	err = __ceph_open_session(client, started);
+	if (err < 0)
+		goto out;
+
 	dout("mount opening root\n");
 	root = open_root_dentry(client, "", started);
 	if (IS_ERR(root)) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index bdf089f..a8e70fc 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -54,14 +54,11 @@
 #define ceph_test_opt(client, opt) \
 	(!!((client)->mount_args->flags & CEPH_OPT_##opt))
 
-
 struct ceph_mount_args {
 	int sb_flags;
 	int flags;
 	struct ceph_fsid fsid;
 	struct ceph_entity_addr my_addr;
-	int num_mon;
-	struct ceph_entity_addr *mon_addr;
 	int mount_timeout;
 	int osd_idle_ttl;
 	int osd_timeout;
@@ -73,6 +70,13 @@ struct ceph_mount_args {
 	int cap_release_safety;
 	int max_readdir;       /* max readdir result (entires) */
 	int max_readdir_bytes; /* max readdir result (bytes) */
+
+	/* any type that can't be simply compared or doesn't need
+	   need to be compared should go beyond this point,
+	   ceph_compare_mount_args() should be updated accordingly */
+	struct ceph_entity_addr *mon_addr; /* should be the first
+					      pointer type of args */
+	int num_mon;
 	char *snapdir_name;   /* default ".snap" */
 	char *name;
 	char *secret;
@@ -747,6 +751,16 @@ extern struct kmem_cache *ceph_file_cachep;
 
 extern const char *ceph_msg_type_name(int type);
 extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
+extern struct ceph_mount_args *parse_mount_args(int flags, char *options,
+						const char *dev_name,
+						const char **path);
+extern void ceph_destroy_mount_args(struct ceph_mount_args *args);
+extern int ceph_compare_mount_args(struct ceph_mount_args *new_args,
+			    struct ceph_client *client);
+extern struct ceph_client *ceph_create_client(struct ceph_mount_args *args,
+					      int need_mdsc);
+extern void ceph_destroy_client(struct ceph_client *client);
+extern int ceph_open_session(struct ceph_client *client);
 
 /* inode.c */
 extern const struct inode_operations ceph_file_iops;
@@ -853,6 +867,13 @@ extern int ceph_mmap(struct file *file, struct vm_area_struct *vma);
 /* file.c */
 extern const struct file_operations ceph_file_fops;
 extern const struct address_space_operations ceph_aops;
+extern int ceph_copy_to_page_vector(struct page **pages,
+				    const char *data,
+				    loff_t off, size_t len);
+extern int ceph_copy_from_page_vector(struct page **pages,
+				    char *data,
+				    loff_t off, size_t len);
+extern struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags);
 extern int ceph_open(struct inode *inode, struct file *file);
 extern struct dentry *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
 				       struct nameidata *nd, int mode,
-- 
1.7.0

