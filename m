Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB42C55183
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 13:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E5A22071C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 13:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHB69R7o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgDUN6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:58:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21503 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728856AbgDUN5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 09:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587477471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5GipQquvXdS60T0xD4t06gmL9kKohzWhQBgW2pGftGs=;
        b=PHB69R7o2UCiOfbBuu6Q6vcQ8xOPXNr4q/fYz6yrM+vvdF9JDDv47kZAKUBFrYm+rNzqrX
        lNeAhIakLVW/DXhxZsNanVNGHjId8aNKRbGM7DQLqCZo5PVnNADig8PotLoAgplV2T6C+g
        jvUevzVoASftwSWkQX9cjw3InM9MOMU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-aGvnX9dCN5SHGGdZ5OE0TQ-1; Tue, 21 Apr 2020 09:57:49 -0400
X-MC-Unique: aGvnX9dCN5SHGGdZ5OE0TQ-1
Received: by mail-wm1-f72.google.com with SMTP id j5so1483090wmi.4
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 06:57:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5GipQquvXdS60T0xD4t06gmL9kKohzWhQBgW2pGftGs=;
        b=ShwJI+TJ0BIonUcW+HTDwPbjR0PVxJI96lrl8ScWSi1r6Y5IkU/qQiNSjV/5QIXmuU
         EkJqcR+PgebFD14yWs6DEUaLY1g46lJVyUllF79PvV8+eznUCrFcYSxam5bo6tID6T5C
         QsYRaeTzN/d7tJV6za4Yo18Jq+TJuKQVdoBXUGpsAqjx3MGub0PLKXYQ+/FxyxyBdQmz
         449DkTbgSWLw/J+zHvCNvzhfJHzJYkTIKeq4ybFnmUFafHy/ZT6yMlIOWGIFvJjR4rv1
         ZC9nYcp4uEWT5xOLtQJX4DqVTWc+HU5toBABETVw6gnOyqeLAkFGbtf+SKtfSalO63Fp
         qOeA==
X-Gm-Message-State: AGi0PuYyLyZ+p2EVNStfxahCq9ST2TA4y3OLQdi8j8/p5n08daeWu8O3
        GheidbljNrLyP3Tje291K4CymTaZfhnRSJ7W8at6DUDeiapcPL0FobbzdSH/ot3CSfO3bFbJW5e
        tuYG1fn0BbsqRD1OgB5xy4g==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr3548544wrx.203.1587477468497;
        Tue, 21 Apr 2020 06:57:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypIF3TEMFKgVlkqjV5D8Ac9x2gOX23CIH+SaywYNkeLA37qXXTG9GqXHBVuGZrEE7VAAb2MwEw==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr3548522wrx.203.1587477468324;
        Tue, 21 Apr 2020 06:57:48 -0700 (PDT)
Received: from localhost.localdomain.com ([194.230.155.194])
        by smtp.gmail.com with ESMTPSA id f23sm3562989wml.4.2020.04.21.06.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 06:57:47 -0700 (PDT)
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
Subject: [PATCH v2 4/7] libfs: add alloc_anon_inode wrapper
Date:   Tue, 21 Apr 2020 15:57:38 +0200
Message-Id: <20200421135741.30657-2-eesposit@redhat.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200421135119.30007-1-eesposit@redhat.com>
References: <20200421135119.30007-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

libfs.c has many functions that are useful to implement dentry and inode
operations, but not many at the filesystem level. Start adding file
creation wrappers, the simplest returns an anonymous inode.

There is no functional change intended.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 drivers/gpu/drm/drm_drv.c       |  2 +-
 drivers/misc/cxl/api.c          |  2 +-
 drivers/scsi/cxlflash/ocxl_hw.c |  2 +-
 fs/libfs.c                      | 10 +++++++++-
 include/linux/fs.h              |  2 ++
 5 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index e29424d64874..1854f760ad39 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -539,7 +539,7 @@ static struct inode *drm_fs_inode_new(void)
 		return ERR_PTR(r);
 	}
 
-	inode = alloc_anon_inode(drm_fs.mount->mnt_sb);
+	inode = simple_alloc_anon_inode(&drm_fs);
 	if (IS_ERR(inode))
 		simple_release_fs(&drm_fs);
 
diff --git a/drivers/misc/cxl/api.c b/drivers/misc/cxl/api.c
index 67e4808bce49..57672abb6223 100644
--- a/drivers/misc/cxl/api.c
+++ b/drivers/misc/cxl/api.c
@@ -72,7 +72,7 @@ static struct file *cxl_getfile(const char *name,
 		goto err_module;
 	}
 
-	inode = alloc_anon_inode(cxl_fs.mount->mnt_sb);
+	inode = simple_alloc_anon_inode(&cxl_fs);
 	if (IS_ERR(inode)) {
 		file = ERR_CAST(inode);
 		goto err_fs;
diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 7fa98dd4fa28..0e9f2ae7eebf 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -85,7 +85,7 @@ static struct file *ocxlflash_getfile(struct device *dev, const char *name,
 		goto err2;
 	}
 
-	inode = alloc_anon_inode(ocxlflash_fs.mount->mnt_sb);
+	inode = simple_alloc_anon_inode(&ocxlflash_fs);
 	if (IS_ERR(inode)) {
 		rc = PTR_ERR(inode);
 		dev_err(dev, "%s: alloc_anon_inode failed rc=%d\n",
diff --git a/fs/libfs.c b/fs/libfs.c
index 3fa0cd27ab06..5c76e4c648dc 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -741,7 +741,15 @@ void simple_release_fs(struct simple_fs *fs)
 }
 EXPORT_SYMBOL(simple_release_fs);
 
-
+/**
+ * simple_alloc_anon_inode - wrapper for alloc_anon_inode
+ * @fs: a pointer to a struct simple_fs containing a valid vfs_mount pointer
+ **/
+struct inode *simple_alloc_anon_inode(struct simple_fs *fs)
+{
+	return alloc_anon_inode(fs->mount->mnt_sb);
+}
+EXPORT_SYMBOL(simple_alloc_anon_inode);
 
 /**
  * simple_read_from_buffer - copy data from the buffer to user space
diff --git a/include/linux/fs.h b/include/linux/fs.h
index de2577df30ae..5e93de72118b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3373,6 +3373,8 @@ struct simple_fs {
 extern int simple_pin_fs(struct simple_fs *, struct file_system_type *);
 extern void simple_release_fs(struct simple_fs *);
 
+extern struct inode *simple_alloc_anon_inode(struct simple_fs *fs);
+
 extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
 extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
-- 
2.25.2

