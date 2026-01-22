Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D8D3A8FF2
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769096465; cv=none; b=DXoc3243opNRzC0TUgcdRBdzNGs8R7f7jdsTVaVYVP3oGzQXBtFy6VagEr3Lr/2NwZmrgL4q3wk9vf27Uii8vPFKdcBb4qVvuWC8VHje716/w+fZLzth6KT72mXdszViZ6oq1sOV18Eq1CLZjL3602SW6l3Q7FdQnjbJ5JTbKa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769096465; c=relaxed/simple;
	bh=uONlpUsG6B+1SJNCDttGGY2DFAbNfSVv6+TjnGPV9Ro=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rv+Rq81PXTJjO50IV6Xez6XrnF4SB9i1SZgLwUHp2l/Tf1e8ASF4QLWj6I1S2xbAl+9HjVrdRVI/scqbNsnTznNHHtro54WEIzMlmB9pJjYLtlh9R6UD3Hi6LF+p4wvT0DSuTebcFw4oLXb6fzQoXGY+y1QcN1gBmFZmdv9/+E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UInVgzqJ; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UInVgzqJ"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso1065239b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 07:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769096462; x=1769701262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iC3BQrsx4m1KIySd6SGYfoOdN/kOmKuZK6JhgQwLLwU=;
        b=UInVgzqJdiwkrpta0q1byxIFltiwJbGYlfvUihTy1JF0VxZ1EhsDOfpEfaK1nd3awD
         aoGR4DIcNaGc5hur+fI4/Dfy4NUzWJ6T7sxdXa/K2CDXIngiw9lZZU+NwnyZUVetns9I
         5bEOzxsZp/MF6zlIFd3hw+f403B5rP6M2o2KK6F506alIzWt23EZ7AP2yabYG7Zw2Z0W
         kXLMV3IbFrh3fa66hRBG1Xu3xXjcorVd6T0uIX3QuIkOmWqn0x+GjjRt1BCPHy+A45kt
         RbC39LlbzbC1Dun65yFK840m4+2/1XTmQPWHXzMuJxU6XNhm2b0OZ2wNuV2n+cTT7K4x
         RG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769096462; x=1769701262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iC3BQrsx4m1KIySd6SGYfoOdN/kOmKuZK6JhgQwLLwU=;
        b=jhvWwiz1gVo2ppkBYQx6gX0FeUx7+22qOPgojLGJW/BZtup7Ixbh4yQr7mje14r97q
         zxb/ZSSD9Vk8mMBBydgSfkgiRH3pQE3DUCWbHAdBSp4TyRWU0cox9RQ5LC1nfaGBtagN
         LeLeAZLoj9/ACEwhvcYBO4UQOA0nS264QV4/cK3spdFJAiQ1D35RbHC7O1hmEJJjueGa
         YAlKk2jV+so83fARBxPzaJCthgBhLevdC5udE8UqvVkQFy2QICMBxXG+19FIloMR0YHt
         l+nAB/R9MjkroxOJ5M0vbO9er5OIHxS3/3hVk3CkiQpK8HnoN7Al9Yklc/g4GCEbiOzu
         uluw==
X-Gm-Message-State: AOJu0YyWktHYejPLVvLR0hmfENMIzwwzZogQ7uf36OLbvSzwbyb7w2rT
	Ua8GP9Cd8WcabRvHNf3pWt6gBtPEJByTjJkOZTq9FVxy9WmW6YIikRRD
X-Gm-Gg: AZuq6aJiT/dy7WUZDy6Woimhj7+MK7n/hnqG7Q8lWNmQoVYYzNyDdbKkwDi4gmNY8jB
	LjUUUPAS2z55Iguhc9vcVo5XAz5q4P65U1pV84XJ8uc6OQIicLgKW9AXckKCTytsRIZIEbJAzA9
	ZkHY4eoFldr87loCyBCOqZAC68G8v9liCfBQwcptNdDCZsgFds8l6J2ro0Ck0KsQWJLNCvZoq2b
	B2RF0h58lxyXd43H6GgHCGhMYfu6lws4WD6VEhvJPWxVQMuwl/v37V5MQGLw6rvDA11+jQa7QcG
	8gqXKXSq0mdox3TZ1dVQoT24uqCiJ2+fJ3k6knX1rQ+AH4qnDBNqzrWM9qze3RqFsIYoCRL8mSW
	uSBX1qsBMuI0WPUBZKYI320tY0EXpQR3ZDSRXKr4MuXgnr89Y1fEMJQpWOPxwxuSXRgLWOD9Oog
	ICky16Q5LoozbW22wdeBnnQ7Tw7c8+
X-Received: by 2002:a05:6a00:1302:b0:823:1117:39e6 with SMTP id d2e1a72fcca58-82311173ef0mr798121b3a.33.1769096462238;
        Thu, 22 Jan 2026 07:41:02 -0800 (PST)
Received: from localhost.localdomain ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82181d6f7f7sm3474462b3a.50.2026.01.22.07.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 07:41:01 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: martin.petersen@oracle.com,
	d.bogdanov@yadro.com,
	bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: target: fix recursive locking in __configfs_open_file()
Date: Thu, 22 Jan 2026 21:10:51 +0530
Message-Id: <20260122154051.64132-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In flush_write_buffer, &p->frag_sem is acquired and then the loaded store
function is called, which, here, is target_core_item_dbroot_store().
This function called filp_open(), following which these functions were
called (in reverse order), according to the call trace:

down_read
__configfs_open_file
do_dentry_open
vfs_open
do_open
path_openat
do_filp_open
file_open_name
filp_open
target_core_item_dbroot_store
flush_write_buffer
configfs_write_iter

target_core_item_dbroot_store() tries to validate the new file path by
trying to open the file path provided to it; however, in this case,
the bug report shows:

db_root: not a directory: /sys/kernel/config/target/dbroot

indicating that the same configfs file was tried to be opened, on which
it is currently working on. Thus, it is trying to acquire frag_sem
semaphore of the same file of which it already holds the semaphore obtained
in flush_write_buffer(), leading to acquiring the semaphore in a nested
manner and a possibility of recursive locking.

Fix this by modifying target_core_item_dbroot_store() to use kern_path()
instead of filp_open() to avoid opening the file using filesystem-specific
function __configfs_open_file(), and further modifying it to make this
fix compatible.

Reported-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f6e8174215573a84b797
Tested-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
Changes since v1:
 - Update commit message to reflect the fact that same file, which code was 
   currently operating on, was tried to be opened again, leading to 
   acquiring the same semaphore in nested manner & possibility of recursive
   locking.

v1 link: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/ 

 drivers/target/target_core_configfs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index b19acd662726..f29052e6a87d 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -108,8 +108,8 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 					const char *page, size_t count)
 {
 	ssize_t read_bytes;
-	struct file *fp;
 	ssize_t r = -EINVAL;
+	struct path path = {};
 
 	mutex_lock(&target_devices_lock);
 	if (target_devices) {
@@ -131,17 +131,18 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 		db_root_stage[read_bytes - 1] = '\0';
 
 	/* validate new db root before accepting it */
-	fp = filp_open(db_root_stage, O_RDONLY, 0);
-	if (IS_ERR(fp)) {
+	r = kern_path(db_root_stage, LOOKUP_FOLLOW, &path);
+	if (r) {
 		pr_err("db_root: cannot open: %s\n", db_root_stage);
 		goto unlock;
 	}
-	if (!S_ISDIR(file_inode(fp)->i_mode)) {
-		filp_close(fp, NULL);
+	if (!d_is_dir(path.dentry)) {
+		path_put(&path);
 		pr_err("db_root: not a directory: %s\n", db_root_stage);
+		r = -ENOTDIR;
 		goto unlock;
 	}
-	filp_close(fp, NULL);
+	path_put(&path);
 
 	strscpy(db_root, db_root_stage);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.34.1

