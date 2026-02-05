Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E72543637A
	for <linux-scsi@vger.kernel.org>; Thu,  5 Feb 2026 16:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308799; cv=none; b=SPOD2HJkwjOS73U2uZ1pkL5zJcazUOXc2t5XITMbfYA/P15jXMbp+3TpsqaiPaRI+uYv66LjNeuXvvJHT1I2IgHWtuaYm8BgxKjX575AbEjOHyWLUGnJQvh/wZTOMN1ihRAif0TQqJwzRNPHBO0Y7klTcUepX0b9H42+QCXGncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308799; c=relaxed/simple;
	bh=9r9EfnqgpePHSmknjj3jV71TCwg0Aj5TNW2hpF8F0ic=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SKpKLx53EMhwkIPx7RXpxwkkCuekDlckCKu76CNa1F1K0OL+3y/yUXgTheM1Lzk3UboxEJfGjvueGPoZdu1BqiyclTZ8EEoEAXg+5xOiDN6x2GHIILn4Mca5z85o9Xtzbk0c4n75+/a8CGNwZ5xJCsYWuzO1J0D3hmdF60k7+m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EbNj22Vv; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EbNj22Vv"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-bc29d64b39dso361690a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2026 08:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770308798; x=1770913598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JyEXpPncVH2GhAUyxHXUUpWjlgv8nEIxYO25mhp+H1s=;
        b=EbNj22Vv7QktYbdgH2aSSzrOQAWfDBs4vk65Rhuq+5CZxEp6kDql2lQzAcLMEKiAxb
         IvF4pZjqFA21TcfAoQdthQU9P6ueM8EeCgKfJx51iaDwuqkQ+TkJKc0C0FRs3hM+5/Q7
         qlZZ/38Sj0efdTIFY5CYweUFL9hRdwH7vpEEGnvzFTWTuT48DrjpINunAl4Q+db6LQmC
         u4aqhsBiO7kmbNVsEEdhlV+6oVJBWARyRSGj2SLbuV1ap+lunJgwUfRP7rupMbvYtftd
         1IJLOrxVBAjbe8ra8c8owzZJmeBrsgAiY6kaMhz67viVJzpgYjJf53RWysA7lA0CM6/W
         SNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770308798; x=1770913598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JyEXpPncVH2GhAUyxHXUUpWjlgv8nEIxYO25mhp+H1s=;
        b=g94XYOECergsnyd42wLSbchjmF4Nt0YjCt+e9vrDLkh7E/tqNUdvtODfSzjUBQ9diR
         gM3XWxbSMOsky+wUMc3ggyttqPh3k6DhjzIlgaZPG9twmFtpuEw5lQ/q0+qkmafMBdvd
         nCBV2IIKlhvJWjS/kVBZiRLQLqzD1V04ZqjLdG54DfKaqikWjVm2R23/daFRLrlWzLxw
         6p7aJE6zKKJN61eTdH9goR0yMrnFi1Ab6KpGpO6hdhsrY5skSezOzDJzJETFJryxUvNa
         2oCWp/NQPzYjjDXv2/NtzQK5P3AlooIYWpzGyp2i41aeGsywE/CJMUIpIyMKGAVDM5EX
         Zv5Q==
X-Gm-Message-State: AOJu0YwLBAjl073tJMzqugejvPuTSBZASoOBhTredtxDs4p5b5rm8GFB
	9OBhS6hs0uIJHNLp5OtTC4WX4lndQEluyovx4v4mJE9CO3uyOjHpPuFN
X-Gm-Gg: AZuq6aJpnWXN27tYXSHq7YNkgD46qeNKBql/U5PS2GLaU/jtj4VO2Y11155ZqGaPZCR
	n+0KQ80Bs8PRUd1e8kQsBmG8+tAvRfcvrLcf0jg4zhmIJbIa4rzd/ymE3nwUE2a5sw6I2AWCLmO
	1d0Xc64gcwnFC9kH3NV4Jq5rMO75HS6qrUKP1esSvJp42JVHEaoczknb4JhLAayYVuy8zA084oj
	H2afmB99ywmYBvFgdyazOgQaXvzf30t8f4TUHuN0LKjmtpKHVFdkuI0nfSiTL1XcKXr24gFWh8g
	LJXJ6x4sm2FILEWJ/3f5bZahPk2+clenx4qtGt2egeiQPK8CdUNcSD/Kfgk60HV3qfpgpk5zrnR
	9KsqrI4eGK1ZwQWl0SJo0PTmLYuEw5B6CWY20U404W5BsYEO5LFTRgcEVC2k9ICUkm+R/n3/kF8
	L13eWkoy02cCuPXIYNdiYI5y9zyimQRjr2Vepr
X-Received: by 2002:a17:90b:1b11:b0:340:d578:f2a2 with SMTP id 98e67ed59e1d1-354870db3e3mr6719407a91.6.1770308798217;
        Thu, 05 Feb 2026 08:26:38 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.72])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c8553e6b1sm5444208a12.32.2026.02.05.08.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 08:26:37 -0800 (PST)
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
Subject: [PATCH v3] scsi: target: fix recursive locking in __configfs_open_file()
Date: Thu,  5 Feb 2026 21:56:24 +0530
Message-Id: <20260205162624.117957-1-activprithvi@gmail.com>
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
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
Changes since v2:
 - Add Reviewed-by tag received from Dmitry Bogdanov, which was accidentally
   left to be added in v2 patch.

v2 link: https://lore.kernel.org/linux-scsi/20260122154051.64132-1-activprithvi@gmail.com/T/#u
Reference for Reviewed-by Tag: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/#mb22d0fc06e747e2b2df8320a15afd2a0670fd0e7


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

