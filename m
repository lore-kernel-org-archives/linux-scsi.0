Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6D0C3A5A0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 03:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FC792078C
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 03:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ibNVbWoN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgDHD5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 23:57:33 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:53778 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgDHD5a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2020 23:57:30 -0400
Received: by mail-pg1-f201.google.com with SMTP id c33so4375589pgl.20
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2020 20:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xJkP8e59/n7iIujiMcl7X5Pc4Tz1txAW1Gmb+VI1O1Y=;
        b=ibNVbWoN51vmsJrnlJSyk7S/HV0c8UIXlHKsiPBuqewKjm5llKIxkJQ2Ji6nSQ5LST
         n0AJzKnewfPtpxdakzl7dwb2+91zGQKDysHCziHYKo0tFR1ScmRd04hvJVWaY2YcVM+F
         OKQ5wPf19y5SXFt/ZT+JbE01LhU7PYsjJLNBM1vFzPxEjpOakDSmt31RSKSr0HCnMJhE
         /xcirmTzPlVcDhcSinZQBr8QECGNh2xp6qMaKKhgembnsheFqD++bhOCQy9chtUO67+e
         V2zC3D3KjJuEpzTMN9m6sZK1ZubjNyZ/RcYtK5PwdKmyKiOze6MxP6o4u9iNwoAloouL
         u/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xJkP8e59/n7iIujiMcl7X5Pc4Tz1txAW1Gmb+VI1O1Y=;
        b=AC9h9L+V7mZ7Q2ca5xpFGhvekFZLnscxAoa5/P3CSdLnYezWeqgGoPLSac7GWPuL2Z
         LDUiEt9NyfZcUeSH51DYBwjMveNnHmcHZybhJlFjjlSMkRTalG63bcUeh94BmBYu8Cso
         Dz5bSR3TOYFJ9u90gH3jEuuGxIjyLms1/tojDckh/gwVa1YowVuQYLa42nqUUipfygwf
         JlQ9h1d8DAxD64TOKn41xAR65wlhTedzSfJ1P4RmNDx49DY29Ir/V5yAqlcQdJ7pGYOx
         n5AhyDfs6Bm901Ro3bRY/TOwH80upTLipDJ2wKWv8v3twsalioTqI+zhnlgY5mYZITZz
         fDfA==
X-Gm-Message-State: AGi0PuYUas87pc9kb0bZG0W57U5DkNxcPhWMxafKeM1idbKc/DXeapiu
        Mozck87e48PLYPPwb5yMG1cnRRakuCM=
X-Google-Smtp-Source: APiQypJm4U6exMkrVHaCaR+Jox2XVDnJ+ZVZwcNOltIQvdyFK8OCQp3/sfrcru/EGGInehFptE8sLZbx4Vs=
X-Received: by 2002:a17:90a:3547:: with SMTP id q65mr3138844pjb.118.1586318248079;
 Tue, 07 Apr 2020 20:57:28 -0700 (PDT)
Date:   Tue,  7 Apr 2020 20:56:51 -0700
In-Reply-To: <20200408035654.247908-1-satyat@google.com>
Message-Id: <20200408035654.247908-10-satyat@google.com>
Mime-Version: 1.0
References: <20200408035654.247908-1-satyat@google.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v10 09/12] fs: introduce SB_INLINECRYPT
From:   Satya Tangirala <satyat@google.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce SB_INLINECRYPT, which is set by filesystems that wish to use
blk-crypto for file content en/decryption. This flag maps to the
'-o inlinecrypt' mount option which multiple filesystems will implement,
and code in fs/crypto/ needs to be able to check for this mount option
in a filesystem-independent way.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/proc_namespace.c | 1 +
 include/linux/fs.h  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 273ee82d8aa97..8bf195d3bda69 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -49,6 +49,7 @@ static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 		{ SB_DIRSYNC, ",dirsync" },
 		{ SB_MANDLOCK, ",mand" },
 		{ SB_LAZYTIME, ",lazytime" },
+		{ SB_INLINECRYPT, ",inlinecrypt" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4f6f59b4f22a8..38fc6c8d4f45b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1376,6 +1376,7 @@ extern int send_sigurg(struct fown_struct *fown);
 #define SB_NODIRATIME	2048	/* Do not update directory access times */
 #define SB_SILENT	32768
 #define SB_POSIXACL	(1<<16)	/* VFS does not apply the umask */
+#define SB_INLINECRYPT	(1<<17)	/* Use blk-crypto for encrypted files */
 #define SB_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define SB_I_VERSION	(1<<23) /* Update inode I_version field */
 #define SB_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily */
-- 
2.26.0.110.g2183baf09c-goog

