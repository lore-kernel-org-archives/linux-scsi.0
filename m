Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4360C55184
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 13:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F54E20644
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 13:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cSn8rXNK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgDUN57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:57:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51790 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728960AbgDUN56 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 09:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587477475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjaOnzI5gdueJ0y4sy2VdCpkInG/pM8xAJAe7M5MwVA=;
        b=cSn8rXNKfSu/EzJdKFw0lgCwpBv4T8foRdmKsY5Nu/b8V7b/1fuYH8rlaqofq0qJpvTrzK
        7OXHNXgriitN355roYl+Y0TK4FYepmMb/e7Kqo0qIQRsLIamGZYBFWX3i81FjjDMyNhHyZ
        IoH27m6RxSpQfxWVIg3XeAb4mEtXuZw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-mxC6DqmSPdWBBdvTCwJnig-1; Tue, 21 Apr 2020 09:57:53 -0400
X-MC-Unique: mxC6DqmSPdWBBdvTCwJnig-1
Received: by mail-wr1-f70.google.com with SMTP id i10so7508948wrq.8
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 06:57:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xjaOnzI5gdueJ0y4sy2VdCpkInG/pM8xAJAe7M5MwVA=;
        b=aGkdEqnTN+NBwpMgJBV7we9cDBjelzpx62C9q9mNCyNq3i3aTzQnCvV9AI+6Y5H/eA
         EXqyCKGWHB9JYwx3Bhr3b7RBekaP8R2XRO7JGUI1/LzYlGUC665/bhKjPWXjC095JySM
         eSYaS5hez6xWSNT7txrj2e4jzjIYyEFkQWldnZdZhlRthKDoUfuADHtZbAG/5deK1R+j
         ZfP66yNVVZ+1GOCy8/Y5ABtt8Btr26lIvhzHq6pGIXuvSLzSDC4++ILhq5dkBSZvXVbf
         K7YhtYulFiDkU3bIWNhRSdsPBdCFU9tWmwkaETfqF/2vVEGBwu/0U9xvNK+O0tOhOHWX
         4LHg==
X-Gm-Message-State: AGi0PuZ8MzNyRNmAkjbZFmjtJSZPL1CYCSHGHUKDBeEdpRdfuD8AYLgJ
        +iJiY80nQKLh5VE90dRyT2tsct0vz1xeo5ym3mTj4ynw1BpmpHwrAu9fwNCJ9oezJE2aULIyXkp
        Qyb0KER7oAXRb40H4VUmDLw==
X-Received: by 2002:a1c:9c0a:: with SMTP id f10mr5022049wme.139.1587477472393;
        Tue, 21 Apr 2020 06:57:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypIlG2viM+l0EuPG6wic3zBlhrKU/He9H0puv0ur4Y4UIWdpPnCyTzA3FMh8mbZkb38/fp+4ZQ==
X-Received: by 2002:a1c:9c0a:: with SMTP id f10mr5022031wme.139.1587477472153;
        Tue, 21 Apr 2020 06:57:52 -0700 (PDT)
Received: from localhost.localdomain.com ([194.230.155.194])
        by smtp.gmail.com with ESMTPSA id f23sm3562989wml.4.2020.04.21.06.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 06:57:51 -0700 (PDT)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Joel Becker <jlbec@evilplan.org>,
        Christoph Hellwig <hch@lst.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v2 6/7] debugfs: switch to simplefs inode creation API
Date:   Tue, 21 Apr 2020 15:57:40 +0200
Message-Id: <20200421135741.30657-4-eesposit@redhat.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200421135119.30007-1-eesposit@redhat.com>
References: <20200421135119.30007-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The only difference, compared to the pre-existing code, is that symlink
creation now triggers fsnotify_create.  This was a bug in the debugfs
code, since for example vfs_symlink does call fsnotify_create.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 fs/debugfs/inode.c | 144 +++++----------------------------------------
 1 file changed, 15 insertions(+), 129 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 5dbb74a23e7c..ccbeea9e5f6c 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -305,68 +305,6 @@ struct dentry *debugfs_lookup(const char *name, struct dentry *parent)
 }
 EXPORT_SYMBOL_GPL(debugfs_lookup);
 
-static struct dentry *start_creating(const char *name, struct dentry *parent)
-{
-	struct dentry *dentry;
-	int error;
-
-	pr_debug("creating file '%s'\n", name);
-
-	if (IS_ERR(parent))
-		return parent;
-
-	error = simple_pin_fs(&debugfs, &debug_fs_type);
-	if (error) {
-		pr_err("Unable to pin filesystem for file '%s'\n", name);
-		return ERR_PTR(error);
-	}
-
-	/* If the parent is not specified, we create it in the root.
-	 * We need the root dentry to do this, which is in the super
-	 * block. A pointer to that is in the struct vfsmount that we
-	 * have around.
-	 */
-	if (!parent)
-		parent = debugfs.mount->mnt_root;
-
-	inode_lock(d_inode(parent));
-	if (unlikely(IS_DEADDIR(d_inode(parent))))
-		dentry = ERR_PTR(-ENOENT);
-	else
-		dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry) && d_really_is_positive(dentry)) {
-		if (d_is_dir(dentry))
-			pr_err("Directory '%s' with parent '%s' already present!\n",
-			       name, parent->d_name.name);
-		else
-			pr_err("File '%s' in directory '%s' already present!\n",
-			       name, parent->d_name.name);
-		dput(dentry);
-		dentry = ERR_PTR(-EEXIST);
-	}
-
-	if (IS_ERR(dentry)) {
-		inode_unlock(d_inode(parent));
-		simple_release_fs(&debugfs);
-	}
-
-	return dentry;
-}
-
-static struct dentry *failed_creating(struct dentry *dentry)
-{
-	inode_unlock(d_inode(dentry->d_parent));
-	dput(dentry);
-	simple_release_fs(&debugfs);
-	return ERR_PTR(-ENOMEM);
-}
-
-static struct dentry *end_creating(struct dentry *dentry)
-{
-	inode_unlock(d_inode(dentry->d_parent));
-	return dentry;
-}
-
 static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
 				struct dentry *parent, void *data,
 				const struct file_operations *proxy_fops,
@@ -375,32 +313,17 @@ static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
 	struct dentry *dentry;
 	struct inode *inode;
 
-	if (!(mode & S_IFMT))
-		mode |= S_IFREG;
-	BUG_ON(!S_ISREG(mode));
-	dentry = start_creating(name, parent);
-
+	dentry = simplefs_create_file(&debugfs, &debug_fs_type,
+				      name, mode, parent, data, &inode);
 	if (IS_ERR(dentry))
 		return dentry;
 
-	inode = debugfs_get_inode(dentry->d_sb);
-	if (unlikely(!inode)) {
-		pr_err("out of free dentries, can not create file '%s'\n",
-		       name);
-		return failed_creating(dentry);
-	}
-
-	inode->i_mode = mode;
-	inode->i_private = data;
-
 	inode->i_op = &debugfs_file_inode_operations;
 	inode->i_fop = proxy_fops;
 	dentry->d_fsdata = (void *)((unsigned long)real_fops |
 				DEBUGFS_FSDATA_IS_REAL_FOPS_BIT);
 
-	d_instantiate(dentry, inode);
-	fsnotify_create(d_inode(dentry->d_parent), dentry);
-	return end_creating(dentry);
+	return simplefs_finish_dentry(dentry, inode);
 }
 
 /**
@@ -533,29 +456,16 @@ EXPORT_SYMBOL_GPL(debugfs_create_file_size);
  */
 struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 {
-	struct dentry *dentry = start_creating(name, parent);
+	struct dentry *dentry;
 	struct inode *inode;
 
+	dentry = simplefs_create_dir(&debugfs, &debug_fs_type,
+				     name, 0755, parent, &inode);
 	if (IS_ERR(dentry))
 		return dentry;
 
-	inode = debugfs_get_inode(dentry->d_sb);
-	if (unlikely(!inode)) {
-		pr_err("out of free dentries, can not create directory '%s'\n",
-		       name);
-		return failed_creating(dentry);
-	}
-
-	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	inode->i_op = &debugfs_dir_inode_operations;
-	inode->i_fop = &simple_dir_operations;
-
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
-	d_instantiate(dentry, inode);
-	inc_nlink(d_inode(dentry->d_parent));
-	fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
-	return end_creating(dentry);
+	return simplefs_finish_dentry(dentry, inode);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_dir);
 
@@ -575,29 +485,19 @@ struct dentry *debugfs_create_automount(const char *name,
 					debugfs_automount_t f,
 					void *data)
 {
-	struct dentry *dentry = start_creating(name, parent);
+	struct dentry *dentry;
 	struct inode *inode;
 
+	dentry = simplefs_create_dentry(&debugfs, &debug_fs_type, name, parent,
+					&inode);
 	if (IS_ERR(dentry))
 		return dentry;
 
-	inode = debugfs_get_inode(dentry->d_sb);
-	if (unlikely(!inode)) {
-		pr_err("out of free dentries, can not create automount '%s'\n",
-		       name);
-		return failed_creating(dentry);
-	}
-
 	make_empty_dir_inode(inode);
 	inode->i_flags |= S_AUTOMOUNT;
 	inode->i_private = data;
 	dentry->d_fsdata = (void *)f;
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
-	d_instantiate(dentry, inode);
-	inc_nlink(d_inode(dentry->d_parent));
-	fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
-	return end_creating(dentry);
+	return simplefs_finish_dentry(dentry, inode);
 }
 EXPORT_SYMBOL(debugfs_create_automount);
 
@@ -629,28 +529,14 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 {
 	struct dentry *dentry;
 	struct inode *inode;
-	char *link = kstrdup(target, GFP_KERNEL);
-	if (!link)
-		return ERR_PTR(-ENOMEM);
 
-	dentry = start_creating(name, parent);
-	if (IS_ERR(dentry)) {
-		kfree(link);
+	dentry = simplefs_create_symlink(&debugfs, &debug_fs_type,
+					 name, parent, target, &inode);
+	if (IS_ERR(dentry))
 		return dentry;
-	}
 
-	inode = debugfs_get_inode(dentry->d_sb);
-	if (unlikely(!inode)) {
-		pr_err("out of free dentries, can not create symlink '%s'\n",
-		       name);
-		kfree(link);
-		return failed_creating(dentry);
-	}
-	inode->i_mode = S_IFLNK | S_IRWXUGO;
 	inode->i_op = &debugfs_symlink_inode_operations;
-	inode->i_link = link;
-	d_instantiate(dentry, inode);
-	return end_creating(dentry);
+	return simplefs_finish_dentry(dentry, inode);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 
-- 
2.25.2

