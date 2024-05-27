Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16A71C9EC9;
	Mon, 27 May 2024 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716819459; cv=none; b=Kz2OU7mDq+5OJON1tw0iZinTcjqxQ0HDPSrc9Lsr9oY8CosYKCXKLq8v1CgC2ARJfKHm79alN6q4g2Vo0kkemKZqfY8vYe2Y9Zw/3Srx5MsJhUuMZ8vLArEPCZwIQWnlO8B4eiXQupmVl48r4/QXiqLPmx5hTlfNLOdpeLQfjyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716819459; c=relaxed/simple;
	bh=tNphdjirBb9tdMxisUu7AmYR16l1TQhNBoK7qKrb16g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkoZhJIniV8Gkg+E3XCptRHjFWrr750hoOm6itH8VMoEzn2QmbA0mTZgtIpW/EsmrgbypBe7qUpdCYOGghPAmWbUU3WWp3/t2wfVjgWu/WO8QwrlrWZ98ayKQTOBXl26Vx7jcxdfuFKntiWpZpHukRBKu8XyZn2nDy9WLgzoLEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iK10sT7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iK10sT7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E851C4AF07;
	Mon, 27 May 2024 14:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716819459;
	bh=tNphdjirBb9tdMxisUu7AmYR16l1TQhNBoK7qKrb16g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iK10sT7Aaptx3ozU4MV0q7UuVeqZRw7ylYNi9EH3iFL8zDU+lKmLc7HYLvLGUtnCd
	 kYE4uic9PUb5QUisearvakpRt0F1Da2yr4j1hvhzJLv+QRrzKwp9QXAyfetoSzhVA1
	 r5g96kuYLUmdMKR3+eSUa1KD+TnQE+K1qHH6BpE4bDmnFYzFAYN7b3LRH+WXv4lpDz
	 L/Pjz20KwMBGlm1yGKjL3RB6qfY3F6taA4L56SS1l4ljO62zdO/AKDHH0W9lG0lSWZ
	 8nLXJKzip8/r8YaKCd4/EUgGewOo+S9STHYfHhNE1vl1BT7MhTK1/q4BfEbPdkCxsy
	 O5Gtq5+gKfYgw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Manish Rangankar <mrangankar@marvell.com>,
	Martin Hoyer <mhoyer@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 08/17] scsi: qedi: Fix crash while reading debugfs attribute
Date: Mon, 27 May 2024 10:16:45 -0400
Message-ID: <20240527141712.3853988-8-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240527141712.3853988-1-sashal@kernel.org>
References: <20240527141712.3853988-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.92
Content-Transfer-Encoding: 8bit

From: Manish Rangankar <mrangankar@marvell.com>

[ Upstream commit 28027ec8e32ecbadcd67623edb290dad61e735b5 ]

The qedi_dbg_do_not_recover_cmd_read() function invokes sprintf() directly
on a __user pointer, which results into the crash.

To fix this issue, use a small local stack buffer for sprintf() and then
call simple_read_from_buffer(), which in turns make the copy_to_user()
call.

BUG: unable to handle page fault for address: 00007f4801111000
PGD 8000000864df6067 P4D 8000000864df6067 PUD 864df7067 PMD 846028067 PTE 0
Oops: 0002 [#1] PREEMPT SMP PTI
Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 06/15/2023
RIP: 0010:memcpy_orig+0xcd/0x130
RSP: 0018:ffffb7a18c3ffc40 EFLAGS: 00010202
RAX: 00007f4801111000 RBX: 00007f4801111000 RCX: 000000000000000f
RDX: 000000000000000f RSI: ffffffffc0bfd7a0 RDI: 00007f4801111000
RBP: ffffffffc0bfd7a0 R08: 725f746f6e5f6f64 R09: 3d7265766f636572
R10: ffffb7a18c3ffd08 R11: 0000000000000000 R12: 00007f4881110fff
R13: 000000007fffffff R14: ffffb7a18c3ffca0 R15: ffffffffc0bfd7af
FS:  00007f480118a740(0000) GS:ffff98e38af00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4801111000 CR3: 0000000864b8e001 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die_body+0x1a/0x60
 ? page_fault_oops+0x183/0x510
 ? exc_page_fault+0x69/0x150
 ? asm_exc_page_fault+0x22/0x30
 ? memcpy_orig+0xcd/0x130
 vsnprintf+0x102/0x4c0
 sprintf+0x51/0x80
 qedi_dbg_do_not_recover_cmd_read+0x2f/0x50 [qedi 6bcfdeeecdea037da47069eca2ba717c84a77324]
 full_proxy_read+0x50/0x80
 vfs_read+0xa5/0x2e0
 ? folio_add_new_anon_rmap+0x44/0xa0
 ? set_pte_at+0x15/0x30
 ? do_pte_missing+0x426/0x7f0
 ksys_read+0xa5/0xe0
 do_syscall_64+0x58/0x80
 ? __count_memcg_events+0x46/0x90
 ? count_memcg_event_mm+0x3d/0x60
 ? handle_mm_fault+0x196/0x2f0
 ? do_user_addr_fault+0x267/0x890
 ? exc_page_fault+0x69/0x150
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f4800f20b4d

Tested-by: Martin Hoyer <mhoyer@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Link: https://lore.kernel.org/r/20240415072155.30840-1-mrangankar@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_debugfs.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_debugfs.c b/drivers/scsi/qedi/qedi_debugfs.c
index 8deb2001dc2ff..37eed6a278164 100644
--- a/drivers/scsi/qedi/qedi_debugfs.c
+++ b/drivers/scsi/qedi/qedi_debugfs.c
@@ -120,15 +120,11 @@ static ssize_t
 qedi_dbg_do_not_recover_cmd_read(struct file *filp, char __user *buffer,
 				 size_t count, loff_t *ppos)
 {
-	size_t cnt = 0;
-
-	if (*ppos)
-		return 0;
+	char buf[64];
+	int len;
 
-	cnt = sprintf(buffer, "do_not_recover=%d\n", qedi_do_not_recover);
-	cnt = min_t(int, count, cnt - *ppos);
-	*ppos += cnt;
-	return cnt;
+	len = sprintf(buf, "do_not_recover=%d\n", qedi_do_not_recover);
+	return simple_read_from_buffer(buffer, count, ppos, buf, len);
 }
 
 static int
-- 
2.43.0

