Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B6E30E84B;
	Wed, 10 Dec 2025 03:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338574; cv=none; b=f4tsqRfiQ8Uhv0ZDP9kcwxwzdfyNqjCvzYvy7mZLmEMHJy5b8BB7HzTdl4s7gtMgg7tsrmvsToplewD1oIaLGKnE9LMYJNZIwjdLq5QGn+UyqC5ifKUc3Pf/2P3AsHJc9yDp2AIagKF/IaqT/N1LaHjoTCenx2uHoOpD3rKMoiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338574; c=relaxed/simple;
	bh=B4qaBPxg4CgWbU9sW1f8n6gdE779vlTk88VLRHEwujY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbk3Uylj7YnNS+A2p7VEgCdV5xITRQcRwcX+geQxzDXdr2qc7n35wJGuR7cAfWg5qlO30/rFnvDWHSKWHHFqb4thB+yDhLPelL2VT2mjDeqF0Zm6BkvKmkGJvBDfa6patvvPGAUcGLmwrwN95onIVECzplp1hmlwsMNR8H5VFuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqOvs8F4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqOvs8F4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16783C116B1;
	Wed, 10 Dec 2025 03:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338574;
	bh=B4qaBPxg4CgWbU9sW1f8n6gdE779vlTk88VLRHEwujY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqOvs8F4BunXuAMh85DEjV/VZzlaHWbFFfQJ9MH0VgL4YKbmS//rKl0XTFOySVbYs
	 t0k7ZJ4irniEGztsrqrb6IgNMJGgIfPaPiIyos8hrZnreqj+qhFxa5rPUxY2qy0Mok
	 u37LWKqvCxQe+4cov/H6OSOG/CHQA/WMIfBK5bujQhlu4BRhqxok6sWeC9WgQvTjSO
	 /MasAnxLZgtk67IlXyrHNj02m38eX9amjOxmKUfFVgJCzRi+zqdr5nZCM1F7QFsQgn
	 ToVKxVxEDtVih01N6SMCxzP7hWTbr920U30/iARvgaEr3CXse9IIChR+tN44vdhL3F
	 6+U6DMTtAhKdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Wang <peter.wang@mediatek.com>,
	Chun-Hung Wu <chun-hung.wu@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	chaotian.jing@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] scsi: ufs: host: mediatek: Fix shutdown/suspend race condition
Date: Tue,  9 Dec 2025 22:48:49 -0500
Message-ID: <20251210034915.2268617-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210034915.2268617-1-sashal@kernel.org>
References: <20251210034915.2268617-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 014de20bb36ba03e0e0b0a7e0a1406ab900c9fda ]

Address a race condition between shutdown and suspend operations in the
UFS Mediatek driver. Before entering suspend, check if a shutdown is in
progress to prevent conflicts and ensure system stability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Acked-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
Link: https://patch.msgid.link/20250924094527.2992256-6-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### 1. Commit Message Analysis
- **Subject**: "Fix shutdown/suspend race condition" - clearly indicates
  a bug fix
- **No Cc: stable tag** or **Fixes: tag** present
- The message describes preventing conflicts between shutdown and
  suspend operations "to ensure system stability"

### 2. Code Change Analysis
The fix is extremely small (4 lines):
```c
if (hba->shutting_down) {
    ret = -EBUSY;
    goto out;
}
```

**What it does**: At the start of `ufs_mtk_system_suspend()`, before
calling `ufshcd_system_suspend()` and performing Mediatek-specific
operations (voltage regulator LPM, MTCMOS control), it checks if
`hba->shutting_down` is true.

**Why the race is problematic**: The Mediatek driver performs hardware-
specific operations after calling the core suspend:
- `ufs_mtk_dev_vreg_set_lpm()` - controls voltage regulators
- `ufs_mtk_mtcmos_ctrl()` - controls power domains

If shutdown is in progress (`ufshcd_wl_shutdown()` sets
`hba->shutting_down = true`), these operations could conflict with the
shutdown sequence that also manipulates hardware state, causing
instability.

### 3. Classification
- **Bug fix**: Yes - fixes a real race condition
- **Not a feature**: No new functionality, APIs, or capabilities added
- Uses existing infrastructure (`shutting_down` flag already exists in
  `struct ufs_hba`)

### 4. Scope and Risk Assessment
- **Lines changed**: 4 lines (minimal)
- **Files touched**: 1 (driver-specific)
- **Risk**: Very low - adds a defensive early return that makes the
  driver more conservative
- **Regression potential**: Minimal - worst case is a suspend returning
  `-EBUSY` when it shouldn't, but this is very unlikely given the
  shutdown context

### 5. User Impact
- **Affected hardware**: Mediatek UFS storage (common in Android devices
  and embedded systems)
- **Severity**: Race conditions between suspend/shutdown can cause
  system hangs, crashes, or data corruption
- **Real-world scenario**: User initiates shutdown while system is
  suspending (e.g., closing laptop lid during shutdown)

### 6. Stability Indicators
- Signed-off-by Mediatek developer (Peter Wang)
- Acked-by another Mediatek engineer
- Merged by SCSI maintainer Martin K. Petersen

### 7. Concerns
- No explicit `Cc: stable` tag
- No `Fixes:` tag indicating when the bug was introduced
- No bug report or `Reported-by` tag showing users encountered this
  issue

### Decision Rationale

**In favor of backporting:**
- Fixes a real race condition that can cause system instability
- The fix is trivially correct and uses existing infrastructure
- Very small change with minimal regression risk
- Mediatek UFS is widely deployed in consumer devices
- Race conditions between power management paths (suspend/shutdown) are
  serious issues

**Against backporting:**
- No explicit stable tag from the maintainer
- No evidence of users hitting this bug in practice
- Other UFS drivers don't have similar protection (though they may not
  have the same post-suspend hardware operations)

The fix is clearly correct, surgical, and addresses a real class of bug
(PM race conditions). While lacking explicit stable markers, the fix
meets the stable kernel criteria: it's obviously correct, fixes a real
bug affecting system stability, and is small and contained.

**YES**

 drivers/ufs/host/ufs-mediatek.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 758a393a9de1a..d0cbd96ad29dc 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2373,6 +2373,11 @@ static int ufs_mtk_system_suspend(struct device *dev)
 	struct arm_smccc_res res;
 	int ret;
 
+	if (hba->shutting_down) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = ufshcd_system_suspend(dev);
 	if (ret)
 		goto out;
-- 
2.51.0

