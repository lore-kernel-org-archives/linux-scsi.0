Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F2FC54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 13:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1521B20672
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 13:52:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HfUMLZrT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgDUNws (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:52:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53147 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUNwr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 09:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587477166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ctzOqm9dtwbhRf44FvKp72RdNODJeokpu4mABLVWWLc=;
        b=HfUMLZrTsjJZ5MTWakU6Ip/201mGT2WMl9QcFjlTe7A6HddnNMDK6nP8DbQiHilQZFLO7H
        MSr0IMDYxDVsPl6FsG8MICACavx314Be1Z0M4Z4mTVXsAQOSCIbIvuQqXqCqpDp+m0khtM
        MNs339MOGa196tWdeqdCnYlgi6Q5iow=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-cxI5wA78NOecVC8zStXncg-1; Tue, 21 Apr 2020 09:52:43 -0400
X-MC-Unique: cxI5wA78NOecVC8zStXncg-1
Received: by mail-wm1-f72.google.com with SMTP id b203so1392314wmd.6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 06:52:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctzOqm9dtwbhRf44FvKp72RdNODJeokpu4mABLVWWLc=;
        b=HN35cKR7mvp9R60ir5cRj329xIi/H/mBOqsoYgdSrKe/hyU0jQm9vyD1tn3+EQ7l1u
         nAxW+5WuDckwnZXFZ/sVV+5dpcYFc9KNG7/mv8SUgkz/pY4TAf1ckxHakGeEwArMKE3f
         F1z/q3oJoIB3YGSWsCohnT9LJgLE38+vMZtx8DDiNshIGrdNZiKKvWfu9Kz8g1lKt1la
         X+ukSiGqQqDBUgmn6WkXxxKLU/6MKIMHaRyOlCcFVy+qRjKPkhA2+ndHDPtm9FxSpyXt
         fFU4ejx2FFfFkrokEgAuzs7o4a2IoHDS3m43z9Zy39ib4ms2klJeuWUZhkF+u18kntZZ
         0gyQ==
X-Gm-Message-State: AGi0PubS3oVYw7gCZP15XZ4bJg16c4Z+LLeEA7UZO6XaUS1zzM9Iktlb
        tr8Il2iC0vtBCg6YrKnm9H88+iDAoVkewqKJ0hOk0N7AdHIwS+Hes9pTba8/jK63OQf6t8uhW+Z
        YTBuuJPVDEHRz6FD3F1Xijg==
X-Received: by 2002:adf:fd0a:: with SMTP id e10mr23759627wrr.160.1587477102566;
        Tue, 21 Apr 2020 06:51:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypKYYb14rVpuN5IdJGjcztA4u7H/3dUDNtMGXdL7LsdIhh9n0qcoiv0NvYygrC3tIbBHwPH97A==
X-Received: by 2002:adf:fd0a:: with SMTP id e10mr23759618wrr.160.1587477102414;
        Tue, 21 Apr 2020 06:51:42 -0700 (PDT)
Received: from localhost.localdomain.com ([194.230.155.194])
        by smtp.gmail.com with ESMTPSA id a187sm3565830wmh.40.2020.04.21.06.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 06:51:41 -0700 (PDT)
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
Subject: [PATCH v2 1/7] apparmor: just use vfs_kern_mount to make .null
Date:   Tue, 21 Apr 2020 15:51:13 +0200
Message-Id: <20200421135119.30007-2-eesposit@redhat.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200421135119.30007-1-eesposit@redhat.com>
References: <20200421135119.30007-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

aa_mk_null_file is using simple_pin_fs/simple_release_fs with local
variables as arguments, for what would amount to a simple
vfs_kern_mount/mntput pair if everything was inlined.  Just use
the normal filesystem API since the reference counting is not needed
here (it is a local variable and always 0 on entry and on exit).

There is no functional change intended.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 security/apparmor/apparmorfs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 280741fc0f5f..36f848734902 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -2525,14 +2525,15 @@ struct path aa_null;
 
 static int aa_mk_null_file(struct dentry *parent)
 {
-	struct vfsmount *mount = NULL;
+	struct file_system_type *type = parent->d_sb->s_type;
+	struct vfsmount *mount;
 	struct dentry *dentry;
 	struct inode *inode;
-	int count = 0;
-	int error = simple_pin_fs(parent->d_sb->s_type, &mount, &count);
+	int error;
 
-	if (error)
-		return error;
+	mount = vfs_kern_mount(type, SB_KERNMOUNT, type->name, NULL);
+	if (IS_ERR(mount))
+		return PTR_ERR(mount);
 
 	inode_lock(d_inode(parent));
 	dentry = lookup_one_len(NULL_FILE_NAME, parent, strlen(NULL_FILE_NAME));
@@ -2561,7 +2562,7 @@ static int aa_mk_null_file(struct dentry *parent)
 	dput(dentry);
 out:
 	inode_unlock(d_inode(parent));
-	simple_release_fs(&mount, &count);
+	mntput(mount);
 	return error;
 }
 
-- 
2.25.2

