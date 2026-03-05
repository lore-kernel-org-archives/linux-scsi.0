Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A9C3D301F;
	Thu,  5 Mar 2026 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725046; cv=none; b=TucXrO38eKTT7Ia7OvyzCUmikNKmWjTx9iHzrfJ64mLO+NtIoRD5iX2hdG1jw5eQr8e1qa07YqhUZ4UuK2WMu0/8xHLxe75PzKGO0cbr7RRHVCibLC1Df2HlI8SVkZhjrXOrrgZmgKL282JVgsYfS9mBFCg+HItku7Pla0Net5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725046; c=relaxed/simple;
	bh=/CYbRmfwK6yy8597nxESiS+SQQd03M0Jma5BsuBrwCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pZGBT5bNQu8wv/qeAO+mGU5T79I+NLYfOIwgoG4B69z66ldQrzgMLrxx1uQb6LdbAvyU88FqYBTPpYbRDf0kOBTTH/vqu+Fr9CYOHODN4/u5Y/TL+XNbdBipG/RySTy8GN826vVI5/jYpbiwuZWfUYc4eFsPTIhfOSl7Wwaelvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pIFV8LRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pIFV8LRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0094FC19423;
	Thu,  5 Mar 2026 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725045;
	bh=/CYbRmfwK6yy8597nxESiS+SQQd03M0Jma5BsuBrwCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIFV8LRfgliQjDrUYQe2EZZyA+jiNd7kq8ggc0B1oJY/eq6+RDtgbSX58XtswojLL
	 N+xz5sWpR411ry+sOkksSNdgvT4gOPJGUtetSQoivlt/F5nUKBwXKWfSUFbo+d0Uxs
	 67OTjhqBzcI5+tLGUee7DWxlfnsC8YJig6fht8aVV5imu4qu7VqNU9sFuDiMIrAwse
	 lwk3Rq7tVyiNQH1E1a+CY0be/jXQIJwQ0cXaE1FAjVEJ/SZ6Spx/ggnZNIKj15jeFk
	 fMbccJVHv8pfklslccoczWgaMFPq9FbXhl80isgvQZrOCfpZWjXpmTcjeNLUs3qJeg
	 7eJbQkb64BzPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] scsi: ufs: core: Fix possible NULL pointer dereference in ufshcd_add_command_trace()
Date: Thu,  5 Mar 2026 10:36:57 -0500
Message-ID: <20260305153704.106918-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260305153704.106918-1-sashal@kernel.org>
References: <20260305153704.106918-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 30df81f2228d65bddf492db3929d9fcaffd38fc5 ]

The kernel log indicates a crash in ufshcd_add_command_trace, due to a NULL
pointer dereference when accessing hwq->id.  This can happen if
ufshcd_mcq_req_to_hwq() returns NULL.

This patch adds a NULL check for hwq before accessing its id field to
prevent a kernel crash.

Kernel log excerpt:
[<ffffffd5d192dc4c>] notify_die+0x4c/0x8c
[<ffffffd5d1814e58>] __die+0x60/0xb0
[<ffffffd5d1814d64>] die+0x4c/0xe0
[<ffffffd5d181575c>] die_kernel_fault+0x74/0x88
[<ffffffd5d1864db4>] __do_kernel_fault+0x314/0x318
[<ffffffd5d2a3cdf8>] do_page_fault+0xa4/0x5f8
[<ffffffd5d2a3cd34>] do_translation_fault+0x34/0x54
[<ffffffd5d1864524>] do_mem_abort+0x50/0xa8
[<ffffffd5d2a297dc>] el1_abort+0x3c/0x64
[<ffffffd5d2a29718>] el1h_64_sync_handler+0x44/0xcc
[<ffffffd5d181133c>] el1h_64_sync+0x80/0x88
[<ffffffd5d255c1dc>] ufshcd_add_command_trace+0x23c/0x320
[<ffffffd5d255bad8>] ufshcd_compl_one_cqe+0xa4/0x404
[<ffffffd5d2572968>] ufshcd_mcq_poll_cqe_lock+0xac/0x104
[<ffffffd5d11c7460>] ufs_mtk_mcq_intr+0x54/0x74 [ufs_mediatek_mod]
[<ffffffd5d19ab92c>] __handle_irq_event_percpu+0xc8/0x348
[<ffffffd5d19abca8>] handle_irq_event+0x3c/0xa8
[<ffffffd5d19b1f0c>] handle_fasteoi_irq+0xf8/0x294
[<ffffffd5d19aa778>] generic_handle_domain_irq+0x54/0x80
[<ffffffd5d18102bc>] gic_handle_irq+0x1d4/0x330
[<ffffffd5d1838210>] call_on_irq_stack+0x44/0x68
[<ffffffd5d183af30>] do_interrupt_handler+0x78/0xd8
[<ffffffd5d2a29c00>] el1_interrupt+0x48/0xa8
[<ffffffd5d2a29ba8>] el1h_64_irq_handler+0x14/0x24
[<ffffffd5d18113c4>] el1h_64_irq+0x80/0x88
[<ffffffd5d2527fb4>] arch_local_irq_enable+0x4/0x1c
[<ffffffd5d25282e4>] cpuidle_enter+0x34/0x54
[<ffffffd5d195a678>] do_idle+0x1dc/0x2f8
[<ffffffd5d195a7c4>] cpu_startup_entry+0x30/0x3c
[<ffffffd5d18155c4>] secondary_start_kernel+0x134/0x1ac
[<ffffffd5d18640bc>] __secondary_switched+0xc4/0xcc

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223065657.2432447-1-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit fixes

This is a **NULL pointer dereference crash** in
`ufshcd_add_command_trace()`. When MCQ (Multi-Circular Queue) mode is
enabled, the function calls `ufshcd_mcq_req_to_hwq()` which can return
NULL when `req->mq_hctx` is NULL (i.e., the request has already been
freed). The code then unconditionally dereferences `hwq->id`, causing a
kernel crash.

The commit message includes a **real crash log** from production
hardware (MediaTek platform), confirming this is not theoretical — it
happens in the field.

### Stable kernel criteria assessment

1. **Obviously correct**: Yes — adds a simple NULL check before
   dereference. Multiple other call sites in the same codebase already
   perform this exact check (e.g., `ufshcd_mcq_abort()`,
   `ufshcd_complete_requests()`). Reviewed by Bart Van Assche, a
   prominent SCSI/UFS reviewer.

2. **Fixes a real bug**: Yes — kernel crash (NULL pointer dereference)
   with a real crash trace from production.

3. **Important issue**: Yes — kernel panic/crash in an IRQ handler path
   (`ufs_mtk_mcq_intr` → `ufshcd_mcq_poll_cqe_lock` →
   `ufshcd_compl_one_cqe` → `ufshcd_add_command_trace`). This crashes
   the entire system during normal UFS I/O completion.

4. **Small and contained**: Yes — the change is 3 lines (adds `if (hwq)`
   check around `hwq_id = hwq->id`). Single file, single function.

5. **No new features**: Correct — purely defensive NULL check.

### Risk assessment

- **Risk**: Extremely low. The worst case if `hwq` is NULL is that
  `hwq_id` retains its initialized value (0), which is used only for
  tracing. No functional impact.
- **Benefit**: Prevents kernel crashes on systems using UFS MCQ mode
  (common on modern mobile SoCs, particularly MediaTek).

### Dependencies

The buggy code was introduced in commit `4a52338bf288c` (March 2023,
"scsi: ufs: core: Add trace event for MCQ") which is present in kernels
v6.4+. This fix applies cleanly to any kernel that has MCQ tracing
support.

### Verification

- **Agent investigation confirmed** `ufshcd_mcq_req_to_hwq()` is defined
  in `drivers/ufs/core/ufs-mcq.c` and explicitly returns NULL when
  `req->mq_hctx` is NULL.
- **Agent investigation confirmed** the buggy line was introduced in
  commit `4a52338bf288c` (v6.4 merge window, March 2023) via `git
  blame`.
- **Agent investigation confirmed** at least 5 other call sites of
  `ufshcd_mcq_req_to_hwq()` correctly check for NULL before
  dereferencing, proving this was an oversight.
- The crash trace in the commit message shows a real crash in IRQ
  context on a MediaTek UFS platform — this is a production issue.
- The fix is reviewed by Bart Van Assche (`Reviewed-by:`) and merged by
  Martin K. Petersen (SCSI maintainer).

### Conclusion

This is a textbook stable backport candidate: a small, surgical fix for
a real kernel crash, with zero risk of regression, reviewed by the
subsystem experts. The crash occurs in IRQ context during normal UFS I/O
completion on MCQ-capable hardware (common in modern mobile platforms).

**YES**

 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c71a449850573..27d53a044dbad 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -515,8 +515,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 
 	if (hba->mcq_enabled) {
 		struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
-
-		hwq_id = hwq->id;
+		if (hwq)
+			hwq_id = hwq->id;
 	} else {
 		doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	}
-- 
2.51.0

