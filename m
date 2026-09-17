Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39A42628D;
	Thu, 17 Sep 2026 08:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789632275; cv=none; b=JNC3MRLLgNACjQDsZ7jCcsiYK3pAVFIrruj2+nLaaaZBrB11CoQBe65rPU9pzoxA6d19PNw01ClK2YvoCbJQdBylRLN3leZIqmvq02b5fU1cio2LuNJabCguG5XVz/254INbe8IF2ia3Dm3I0cUlMgx2OxzuKxd5VYY2CrNSpmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789632275; c=relaxed/simple;
	bh=ou/nevU3zQKfabX0KKwn1JcJFXk3b5jOGwor5+mK2fY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=h7nURVDgSpZAH7UiwdLiukn1TeXEHgBwDcYRA4eqOBGROrA4Vjw9RoZZKrT+nTCZiIjCHiqNArUpY4eZQzXvZQymteq+WX95qg5YN/kj6MeGVpOL1TTuQX6IvvJ/YQiq8mljRXFm4ZRuOJszi4kyW1VlTlrTK+7G3LsHLMtWJ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GCIwEF46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GCIwEF46"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CCF851F00893;
	Thu, 17 Sep 2026 08:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789632274;
	bh=wosywDew5N+JCGuAr/8q3TYlO7vCGyn1j6CRNBjhqYQ=;
	h=From:To:Cc:Subject:Date;
	b=GCIwEF46q7A04pJ/SK/OlBzfbYTDJ5ranVWm1ZyvkACERK/SwKvH7FXSgxydmmE+/
	 DDRiB4qxXg3jl3dSFc9oZmiwvIiRthMB53R7QhDOwmNSU7xv/KtHKeq6kfRSdElfnr
	 2M0JKCvDhbLcn2b7jMrt4wHVhznnllFBSS8gRGjJaskHFRgo3ymse4LC4pEF0H8VZ5
	 KitCQWxmphvZNhM1gxECQgm9zrZ7ksE83/juAbCO97aDfwPRTor5zDbTS/Xigwxd4t
	 gziK3yl3HRIHK5sbhyGaVLzJxu2PMjhA4PiCc4+U8Epm3qrYnVlb/OVbhitrfpXMXT
	 0pD95HiXfM/fg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Doug Gilbert" <dgilbert@interlog.com>, <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@kernel.org>, "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] scsi: sg: Fix shift-out-of-bounds in sg_build_indirect()
Message-ID: <e68a2050-dc97-4531-95e2-29f4d1a109cb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 17 Sep 2026 08:04:33 +0000 (UTC)

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

Writing an invalid value such as 0 or a negative number to
/sys/module/sg/parameters/scatter_elem_sz, or setting it at module load
time, causes a shift-out-of-bounds bug during subsequent device operations.
In init_sg(), scatter_elem_sz is checked against PAGE_SIZE, but because
PAGE_SIZE is unsigned, the comparison is unsigned and bypasses negative
values. When opening a device via sg_open(), the driver calls
sg_build_indirect() to allocate scatter-gather buffers. In
sg_build_indirect(), scatter_elem_sz is read into the local snapshot
variable num. Because PAGE_SIZE is unsigned, comparing num against
PAGE_SIZE also results in an unsigned comparison that bypasses negative
values. Furthermore, even if the condition is met, the code updates the
global scatter_elem_sz and scatter_elem_sz_prev variables but leaves the
local snapshot variable num unupdated before get_order(). As a result, an
invalid value such as 0 remains in num and is passed to order =
get_order(num). Calling get_order(0) is undefined and underflows to 52 on
64-bit systems, causing ret_sz = 1 << (PAGE_SHIFT + order) to compute 1 <<
64. Shifting a 32-bit int by 64 bits triggers a UBSAN shift-out-of-bounds
warning:

UBSAN: shift-out-of-bounds in drivers/scsi/sg.c:1887:13
shift exponent 64 is too large for 32-bit type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
 sg_build_indirect+0x559/0x870 drivers/scsi/sg.c:1887
 sg_build_reserve drivers/scsi/sg.c:1997 [inline]
 sg_add_sfp drivers/scsi/sg.c:2177 [inline]
 sg_open+0x1128/0x18a0 drivers/scsi/sg.c:349
 chrdev_open+0x4d9/0x600 fs/char_dev.c:411
 do_dentry_open+0x816/0x1380 fs/open.c:996
 vfs_open+0x3b/0x340 fs/open.c:1101
 </TASK>

Fix this by casting PAGE_SIZE to int in both init_sg() and
sg_build_indirect() so that the comparisons are signed and negative values
do not bypass the check, and by updating the local snapshot variable num to
PAGE_SIZE when num < (int)PAGE_SIZE in sg_build_indirect() before
get_order() is called.

Fixes: 10db10d144c0 ("sg: convert the indirect IO path to use the block layer")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
Link: https://syzkaller.appspot.com/ai_job?id=1d412b83-5bbc-4d73-b690-4c798d45cee4
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

---
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e..46117d1a1 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1667,7 +1667,7 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
+	if (scatter_elem_sz < (int)PAGE_SIZE) {
 		scatter_elem_sz = PAGE_SIZE;
 		scatter_elem_sz_prev = scatter_elem_sz;
 	}
@@ -1875,9 +1875,10 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 
 	num = scatter_elem_sz;
 	if (unlikely(num != scatter_elem_sz_prev)) {
-		if (num < PAGE_SIZE) {
+		if (num < (int)PAGE_SIZE) {
 			scatter_elem_sz = PAGE_SIZE;
 			scatter_elem_sz_prev = PAGE_SIZE;
+			num = PAGE_SIZE;
 		} else
 			scatter_elem_sz_prev = num;
 	}


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
