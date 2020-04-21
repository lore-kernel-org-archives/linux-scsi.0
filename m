Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B33C55183
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 13:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CB912070B
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 13:58:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="flnIJNRY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgDUN6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:58:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50788 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729009AbgDUN57 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 09:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587477477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPnP4qV6sDaGZ2bSbejYPzydlvKfgMg0o/pB9q3go8E=;
        b=flnIJNRYhz6k5uf28deeJaZr1AZzKWUshWdx0GvoCS61yZzs24C5VrhHB8WOUUBPY+mIC/
        ucoMZCWcKvmgMb7d4sOPunzkenploPDxFxQq4/tItR/HSAWZjkVkB7CjFrtNHCg0vFwC9P
        cxEChLSAZCCrPhqp+bIqXGFQgzU4bV8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-vBATI1D5OEi3ZsziDpo1CA-1; Tue, 21 Apr 2020 09:57:55 -0400
X-MC-Unique: vBATI1D5OEi3ZsziDpo1CA-1
Received: by mail-wr1-f69.google.com with SMTP id p16so7523011wro.16
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 06:57:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jPnP4qV6sDaGZ2bSbejYPzydlvKfgMg0o/pB9q3go8E=;
        b=anC0u2Bx0w+LcQNPZUvU+HO5lvcfPTQFXH7rssX3+h74Ygo2uRWrBMEjWdXTl0lDuj
         9aF8O0i5ElxjSepsff/aDfMWbn8VWrQ/3CbWcwGVIn3hGBxtwIE1dAVBP40dzzHsDHVk
         jxtgmlz21QRBab1f/1PuH1JKQ4CcuT9haAxCkIHbKBZ8ZaN1+LObSJhJEPkGJXZ+aLn0
         gUz4oa3Ulq3/+gXh7OhxbduL4de3fBHKXUIyxk0Yixm+hm4ULk+y6cLWHlmwDhHD4XFZ
         cN83SY+K7QxDO1HVIIzBqUekPFit30BfZarjiJkyn1t+jsGE3lHyZ4+xEjLyxiEd6iu9
         i9NQ==
X-Gm-Message-State: AGi0PuZSlMhgNuZrGXm1QNI7nbekxttMikwNx4+NevU2CSpGkJxupXs+
        YVBUQBnRROWEwL8YIrdw6WpBG8zqSbiMmfrdYoNm8j6LhlAW5bht2PlSv0mXm+Vtf+jeconoSv2
        b2AlJodLkfSy7gfSDYO597A==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr5188178wmm.48.1587477474539;
        Tue, 21 Apr 2020 06:57:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypImms4WydeI5+8l3z5lWKRrEMa+0XfWFGcGeKI2hzBQZu8YXbxqfuv1YC/rok2n8KUUpE7+Vg==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr5188144wmm.48.1587477474268;
        Tue, 21 Apr 2020 06:57:54 -0700 (PDT)
Received: from localhost.localdomain.com ([194.230.155.194])
        by smtp.gmail.com with ESMTPSA id f23sm3562989wml.4.2020.04.21.06.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 06:57:53 -0700 (PDT)
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
Subject: [PATCH v2 7/7] tracefs: switch to simplefs inode creation API
Date:   Tue, 21 Apr 2020 15:57:41 +0200
Message-Id: <20200421135741.30657-5-eesposit@redhat.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200421135119.30007-1-eesposit@redhat.com>
References: <20200421135119.30007-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no semantic change intended; the code in the libfs.c
functions in fact was derived from debugfs and tracefs code.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 fs/tracefs/inode.c | 86 ++++------------------------------------------
 1 file changed, 7 insertions(+), 79 deletions(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 370eb38ff1ad..bceaa4f45da2 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -308,57 +308,6 @@ static struct file_system_type trace_fs_type = {
 };
 MODULE_ALIAS_FS("tracefs");
 
-static struct dentry *start_creating(const char *name, struct dentry *parent)
-{
-	struct dentry *dentry;
-	int error;
-
-	pr_debug("tracefs: creating file '%s'\n",name);
-
-	error = simple_pin_fs(&tracefs, &trace_fs_type);
-	if (error)
-		return ERR_PTR(error);
-
-	/* If the parent is not specified, we create it in the root.
-	 * We need the root dentry to do this, which is in the super
-	 * block. A pointer to that is in the struct vfsmount that we
-	 * have around.
-	 */
-	if (!parent)
-		parent = tracefs.mount->mnt_root;
-
-	inode_lock(parent->d_inode);
-	if (unlikely(IS_DEADDIR(parent->d_inode)))
-		dentry = ERR_PTR(-ENOENT);
-	else
-		dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry) && dentry->d_inode) {
-		dput(dentry);
-		dentry = ERR_PTR(-EEXIST);
-	}
-
-	if (IS_ERR(dentry)) {
-		inode_unlock(parent->d_inode);
-		simple_release_fs(&tracefs);
-	}
-
-	return dentry;
-}
-
-static struct dentry *failed_creating(struct dentry *dentry)
-{
-	inode_unlock(dentry->d_parent->d_inode);
-	dput(dentry);
-	simple_release_fs(&tracefs);
-	return NULL;
-}
-
-static struct dentry *end_creating(struct dentry *dentry)
-{
-	inode_unlock(dentry->d_parent->d_inode);
-	return dentry;
-}
-
 /**
  * tracefs_create_file - create a file in the tracefs filesystem
  * @name: a pointer to a string containing the name of the file to create.
@@ -395,49 +344,28 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
 	if (security_locked_down(LOCKDOWN_TRACEFS))
 		return NULL;
 
-	if (!(mode & S_IFMT))
-		mode |= S_IFREG;
-	BUG_ON(!S_ISREG(mode));
-	dentry = start_creating(name, parent);
-
+	dentry = simplefs_create_file(&tracefs, &trace_fs_type,
+				      name, mode, parent, data, &inode);
 	if (IS_ERR(dentry))
 		return NULL;
 
-	inode = tracefs_get_inode(dentry->d_sb);
-	if (unlikely(!inode))
-		return failed_creating(dentry);
-
-	inode->i_mode = mode;
 	inode->i_fop = fops ? fops : &tracefs_file_operations;
-	inode->i_private = data;
-	d_instantiate(dentry, inode);
-	fsnotify_create(dentry->d_parent->d_inode, dentry);
-	return end_creating(dentry);
+	return simplefs_finish_dentry(dentry, inode);
 }
 
 static struct dentry *__create_dir(const char *name, struct dentry *parent,
 				   const struct inode_operations *ops)
 {
-	struct dentry *dentry = start_creating(name, parent);
+	struct dentry *dentry;
 	struct inode *inode;
 
+	dentry = simplefs_create_dir(&tracefs, &trace_fs_type,
+				     name, 0755, parent, &inode);
 	if (IS_ERR(dentry))
 		return NULL;
 
-	inode = tracefs_get_inode(dentry->d_sb);
-	if (unlikely(!inode))
-		return failed_creating(dentry);
-
-	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	inode->i_op = ops;
-	inode->i_fop = &simple_dir_operations;
-
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
-	d_instantiate(dentry, inode);
-	inc_nlink(dentry->d_parent->d_inode);
-	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
-	return end_creating(dentry);
+	return simplefs_finish_dentry(dentry, inode);
 }
 
 /**
-- 
2.25.2

