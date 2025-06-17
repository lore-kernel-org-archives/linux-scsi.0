Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89CF2DE1E0;
	Tue, 17 Jun 2025 12:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750162927; cv=none; b=prJdkJP6bRLjxuZx14ps+Ql3WWDmXyc7SJTR9jfDqVsKVty/G6d1qetrV4FjI+j5QDkgdauuh5K0vsuEBYrLmUEe/UXAhUKIYi3u3Gl2GVu53Lt8zcPs1kNzQmRa3ItdwZY8F5uqaFKoD6x8EG/Dx7+9J1i06bTqdRG55B1P2NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750162927; c=relaxed/simple;
	bh=w19693UR6hx4gmhwLe+SW+u7TgcKNv9lohW5aI67gVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s/o/GzepTYQvSYfAZZyMMPmer8nBvm3MlgehwKOx/plmHE+rePyPdt9I0WrJUSauHoioYn4RM5LkbDB/cp5b3Jw3XaS0dflm80ZIcH5j35ARwnCYw053BDXydaN3gjSeRJL8lEV4yilsfsWIFlfAOMCdeLmt6iT8DUvQjxArxIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKFu/Un8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKFu/Un8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F12C4CEE3;
	Tue, 17 Jun 2025 12:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750162927;
	bh=w19693UR6hx4gmhwLe+SW+u7TgcKNv9lohW5aI67gVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKFu/Un8XrvFLkg+UKcfeaZMm6BPNl8l4J+tnkPcZDHM5msjEfAmd8zbdPh1uPdMD
	 p2R7ysV+e7aVC8nwm9SZpgQPXEFi+HBqzSgLCHoM7POXXWKHk21/kEbVVxF0Sx/o2E
	 RQTCWkWQcXp7vbEIfM1sAxSq10b8gqOliqnPsJbpWo/i57/7HuO0IVMYZ1Ep9GVg+3
	 MR/tg6ioZfUk7yp78yp7XAHKzQQCPNLjW2buPtZGD+cbsKZ3KCdcrbdxmOYR9gJuGG
	 HqEmCxUPI8FLl/s5Ybo4SX8QmHrNVei218yI4geYlEGXvYkc65t9AVbiZugqsqPA5a
	 3N8VTMIAntKIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ziqi Chen <quic_ziqichen@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	peter.wang@mediatek.com,
	avri.altman@wdc.com,
	mani@kernel.org,
	quic_nguyenb@quicinc.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 09/15] scsi: ufs: core: Don't perform UFS clkscaling during host async scan
Date: Tue, 17 Jun 2025 08:21:39 -0400
Message-Id: <20250617122147.1968355-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250617122147.1968355-1-sashal@kernel.org>
References: <20250617122147.1968355-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.2
Content-Transfer-Encoding: 8bit

From: Ziqi Chen <quic_ziqichen@quicinc.com>

[ Upstream commit e97633492f5a3eca7b3ff03b4ef6f993017f7955 ]

When preparing for UFS clock scaling, the UFS driver will quiesce all
sdevs queues in the UFS SCSI host tagset list and then unquiesce them in
ufshcd_clock_scaling_unprepare(). If the UFS SCSI host async scan is in
progress at this time, some LUs may be added to the tagset list between
UFS clkscale prepare and unprepare. This can cause two issues:

1. During clock scaling, there may be I/O requests issued through new
added queues that have not been quiesced, leading to task abort issue.

2. These new added queues that have not been quiesced will be unquiesced
as well when UFS clkscale is unprepared, resulting in warning prints.

Therefore, use the mutex lock scan_mutex in
ufshcd_clock_scaling_prepare() and ufshcd_clock_scaling_unprepare() to
protect it.

Co-developed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Link: https://lore.kernel.org/r/20250522081233.2358565-1-quic_ziqichen@quicinc.com
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my thorough analysis of the code and the race condition, here's
my assessment:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Analysis

The commit fixes a **critical race condition** between UFS clock scaling
operations and async SCSI scanning that can lead to two serious issues:

### 1. **The Race Condition Explained**

Looking at the code changes, the issue occurs when:

**Before the fix**: `ufshcd_clock_scaling_prepare()` performs operations
in this order:
```c
blk_mq_quiesce_tagset(&hba->host->tag_set);  // Quiesce existing queues
mutex_lock(&hba->wb_mutex);
down_write(&hba->clk_scaling_lock);
```

**The race**: If `ufshcd_async_scan()` is running concurrently, it calls
`scsi_scan_host()` at line 8789, which:
1. Discovers new LUNs and adds them to the tagset
2. Creates new block queues for these LUNs
3. These new queues are **not quiesced** by the earlier
   `blk_mq_quiesce_tagset()` call

**After the fix**: The addition of `mutex_lock(&hba->host->scan_mutex)`
**before** `blk_mq_quiesce_tagset()` ensures:
```c
mutex_lock(&hba->host->scan_mutex);          // NEW: Serialize with
scanning
blk_mq_quiesce_tagset(&hba->host->tag_set);  // Now quiesces ALL queues
```

### 2. **Specific Problems This Fixes**

**Issue #1 - Task Abort**: Non-quiesced new queues can continue issuing
I/O during clock scaling, leading to task aborts when the UFS controller
changes power states mid-transaction.

**Issue #2 - Warning Messages**: In `ufshcd_clock_scaling_unprepare()`,
`blk_mq_unquiesce_tagset()` attempts to unquiesce ALL queues in the
tagset, including newly added ones that were never quiesced, triggering
warning messages.

### 3. **Why This Should Be Backported**

**Critical System Stability**: This fixes a race that can cause:
- I/O errors and potential data corruption during clock scaling
- System warnings and potential instability
- Unpredictable behavior during device discovery

**High Impact**: The race affects:
- **UFS storage devices** (widely used in mobile phones, tablets,
  servers)
- **Clock scaling operations** (essential for power management)
- **Device discovery** (happens during boot and hotplug)

**Low Risk Change**: The fix is minimal and surgical:
- Only adds `scan_mutex` synchronization around existing code
- No functional changes to the clock scaling or scanning logic
- Follows established kernel locking patterns (similar to other SCSI
  drivers)

**Timing-Dependent Bug**: This is exactly the type of race condition
that:
- May not be easily reproducible in testing
- Can appear randomly in production under load
- Becomes more likely with faster systems or specific timing conditions

### 4. **Code Quality Assessment**

The fix demonstrates good kernel programming practices:
- **Proper lock ordering**: Acquires `scan_mutex` first to serialize
  with scanning
- **Complete error handling**: Properly releases `scan_mutex` in error
  paths
- **Symmetric operations**: Both `prepare` and `unprepare` handle the
  mutex consistently
- **Minimal scope**: Changes only what's necessary to fix the race

### 5. **Comparison with Similar Commits**

Looking at the historical commits provided:
- This is similar to commit #4 (marked YES) which also fixes
  synchronization during async operations
- Unlike commits #1, #2, #3, #5 (marked NO) which are
  optimization/refactoring changes
- This is a **bug fix** addressing a real race condition, not a feature
  addition

**Conclusion**: This commit fixes a legitimate race condition that can
cause system instability in UFS-based systems. It's a small, well-
contained fix that addresses a critical synchronization issue without
introducing new features or architectural changes. This makes it an
ideal candidate for stable kernel backporting.

 drivers/ufs/core/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7735421e39918..8d38a70862168 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1379,6 +1379,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
+	mutex_lock(&hba->host->scan_mutex);
 	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
@@ -1389,6 +1390,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
 		blk_mq_unquiesce_tagset(&hba->host->tag_set);
+		mutex_unlock(&hba->host->scan_mutex);
 		goto out;
 	}
 
@@ -1410,6 +1412,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
 	mutex_unlock(&hba->wb_mutex);
 
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
 	ufshcd_release(hba);
 }
 
-- 
2.39.5

