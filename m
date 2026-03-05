Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7373D646A;
	Thu,  5 Mar 2026 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725050; cv=none; b=jRXXXO2qmqlvCz9Donyss79ROUji7bUXnXqvIxeN5QBoNHlPy2rbbECmpazW2kP9WdMzZRRVaUhXfkVQVWnPIJp8ixD/sl253OGi6VnPQsDS5pM08y3wHCG6albqsAORxGlGvba1Ao9oZWFtC0Mve+NNmbWiAvvaPvCUf1ra4YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725050; c=relaxed/simple;
	bh=4zbz1EImMJQzUPsZuB7/QAcByUKZ/gGp6Y/TRttdjns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMJebN/TI83l1FHj5vSeRaFuXxI+VelbjxfXEfGX96IU74Q75C7nDYwmJrZwp+gYsb3vTV/fET56xR3GBDLRWIizxbKMKfqFe4D0PNMB+pv8UU6UEJXxuhm24Z0xh8WeAQSO9qZVx5LQmZXbZdZTn0g7DZxj1iKXa5ohTvdb7js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0gbCNHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0gbCNHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190B4C2BC87;
	Thu,  5 Mar 2026 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725050;
	bh=4zbz1EImMJQzUPsZuB7/QAcByUKZ/gGp6Y/TRttdjns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0gbCNHhd2DMZF7hjVDcHu8tkeVL625IZvYCisUgE5AK8/skiVNchyIIi1MrVQE7E
	 gAVGv4pUCRZuiNXG4dC0MKJ4aX1LjTQ/04B2jYa5WVe18nAnoUQm5mekES3OZf8T6n
	 CkObz0NmObkU/JkByDxk/Y5w1ic/1OXGXv7YiDQZkAyW6E/HMkuAUiYgqNHJ0mCNh2
	 2nyVoGzpHriFPLbZTw/nblBsml+2xwiOrVMTKobJfaIabtV1Yvx8vcKMXJVUIu3COl
	 Ag8/odUZqkGqwrb1IRNfUz0j70gkep5FdW6nyQjo5akERMPdI4VkqU2u51NGUOjVLo
	 h9lwtThMJh5dw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] scsi: mpi3mr: Add NULL checks when resetting request and reply queues
Date: Thu,  5 Mar 2026 10:37:00 -0500
Message-ID: <20260305153704.106918-17-sashal@kernel.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit fa96392ebebc8fade2b878acb14cce0f71016503 ]

The driver encountered a crash during resource cleanup when the reply and
request queues were NULL due to freed memory.  This issue occurred when the
creation of reply or request queues failed, and the driver freed the memory
first, but attempted to mem set the content of the freed memory, leading to
a system crash.

Add NULL pointer checks for reply and request queues before accessing the
reply/request memory during cleanup

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://patch.msgid.link/20260212070026.30263-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Assessment

**What the fix does:** Adds NULL checks for `mrioc->op_reply_qinfo` and
`mrioc->req_qinfo` inside the loop in `mpi3mr_memset_buffers()`. The
function already has similar NULL checks for other pointers
(`admin_req_base`, `admin_reply_base`, `init_cmds.reply`) but was
missing checks for these two queue arrays.

**Bug mechanism:** When queue creation fails during controller
initialization or re-initialization, the cleanup path calls
`mpi3mr_memset_buffers()`. If `op_reply_qinfo` or `req_qinfo` was
already freed (or never allocated), dereferencing them causes a NULL
pointer dereference → kernel crash/oops.

**Callers:** The function is called from:
- `mpi3mr_init_ioc()` retry path (line 4405) — controller init failure
- `mpi3mr_reinit_ioc()` retry path (line 4598) — controller re-init
  failure
- `mpi3mr_soft_reset_handler()` (line 5522) — controller reset
- `mpi3mr_remove()` (line 5748 in mpi3mr_os.c) — device removal

All of these are realistic trigger paths. The crash would happen on real
systems when queue creation fails (e.g., memory pressure, hardware
fault).

**Stable criteria:**
- **Fixes a real bug:** Yes — NULL pointer dereference causing a kernel
  crash
- **Obviously correct:** Yes — simple NULL check before dereference,
  consistent with existing patterns in the same function
- **Small and contained:** Yes — only adds two `if` checks wrapping
  existing code, no behavioral change otherwise
- **No new features:** Correct — purely defensive NULL check
- **Risk:** Very low — the NULL check only skips work that would crash
  anyway

### Verification

- Read the `mpi3mr_memset_buffers()` function (line 4667) and confirmed
  it already has NULL checks for `admin_req_base`, `admin_reply_base`,
  and `init_cmds.reply` but was missing them for `op_reply_qinfo` and
  `req_qinfo`
- Confirmed `kfree(mrioc->req_qinfo)` and `kfree(mrioc->op_reply_qinfo)`
  in the cleanup function (lines 4804, 4808) set pointers to NULL after
  free, establishing the NULL state
- Verified callers of `mpi3mr_memset_buffers()`: called from init retry
  paths (4405, 4598), reset handler (5522), and remove (5748) — all
  reachable when queues may be NULL
- The commit message explicitly states the driver crashed during cleanup
  — this is a reported real-world crash, not theoretical
- The fix follows the same pattern already used in the function for
  other pointers
- The mpi3mr driver has been in the kernel since at least v5.15 (long-
  standing driver), so this fix applies to stable trees

**YES**

 drivers/scsi/mpi3mr/mpi3mr_fw.c | 34 ++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8c4bb7169a87c..8382afed12813 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4705,21 +4705,25 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	}
 
 	for (i = 0; i < mrioc->num_queues; i++) {
-		mrioc->op_reply_qinfo[i].qid = 0;
-		mrioc->op_reply_qinfo[i].ci = 0;
-		mrioc->op_reply_qinfo[i].num_replies = 0;
-		mrioc->op_reply_qinfo[i].ephase = 0;
-		atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
-		atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
-		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
-
-		mrioc->req_qinfo[i].ci = 0;
-		mrioc->req_qinfo[i].pi = 0;
-		mrioc->req_qinfo[i].num_requests = 0;
-		mrioc->req_qinfo[i].qid = 0;
-		mrioc->req_qinfo[i].reply_qid = 0;
-		spin_lock_init(&mrioc->req_qinfo[i].q_lock);
-		mpi3mr_memset_op_req_q_buffers(mrioc, i);
+		if (mrioc->op_reply_qinfo) {
+			mrioc->op_reply_qinfo[i].qid = 0;
+			mrioc->op_reply_qinfo[i].ci = 0;
+			mrioc->op_reply_qinfo[i].num_replies = 0;
+			mrioc->op_reply_qinfo[i].ephase = 0;
+			atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
+			atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
+			mpi3mr_memset_op_reply_q_buffers(mrioc, i);
+		}
+
+		if (mrioc->req_qinfo) {
+			mrioc->req_qinfo[i].ci = 0;
+			mrioc->req_qinfo[i].pi = 0;
+			mrioc->req_qinfo[i].num_requests = 0;
+			mrioc->req_qinfo[i].qid = 0;
+			mrioc->req_qinfo[i].reply_qid = 0;
+			spin_lock_init(&mrioc->req_qinfo[i].q_lock);
+			mpi3mr_memset_op_req_q_buffers(mrioc, i);
+		}
 	}
 
 	atomic_set(&mrioc->pend_large_data_sz, 0);
-- 
2.51.0

