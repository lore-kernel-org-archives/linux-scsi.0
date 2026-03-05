Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092DC3D34BE;
	Thu,  5 Mar 2026 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725049; cv=none; b=cjkNDfO8WqAJzsORYTvm41+d4s4tgFxE7YZA9eXtQ9a2vhhDdMJrBFA6ucdlYm5IJ7boFMLfrzAcW1THzImkwxsPTIEGz73KnLGmFxnPV9oCE2NoRFhcgPtBx0F1AEzT3WmgBhXJvdGiCHa8AQt0x3mWVlcPdvMmLKoA/xx64jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725049; c=relaxed/simple;
	bh=XIrrC99mBb44C1oN2x309uDrkIvlWbGqqxQfSCTkmIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bzS3yTyrkZyp56KGpfDJjUC/Uf7b6zlleSh8zAvAtO2JomU/DoVk752hyRielETzx/v2WPDbc2Yasxj2b7NM7VJXWSnyUTzU6xNE2nCtZU2tXsSzlUhWmXom9ygSkSvIQPAa/05eKx0YmiO4ttq9BIDPhOPGGB9vltQjvyrki4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKWOaS5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKWOaS5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C383FC19423;
	Thu,  5 Mar 2026 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725048;
	bh=XIrrC99mBb44C1oN2x309uDrkIvlWbGqqxQfSCTkmIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKWOaS5Lx3fgsk2IUDQE1ijUEs2cMadw651Dgl48sYDdhobRjj1IgdXv3WOvuCsrn
	 daLRUZknMVpgUv0urNNMjlvtNEBruFuIX8jCYUCPBdbkF1vBwoJWrir1W1oEpyKW8a
	 5XoXui22z/W1pfy+Rne3VOQ33euwTiER+99eBoB4KWx8GmDx3YdGnsbaR8GKmjZ2Ji
	 LiRolduSH1c0aoD6UBpKDY+hvhOdm7gPYxCGIAS0mNNPxtoDZLJpyHW+5bTl8+W6sv
	 4e5F/O1ZZZhcVvNfNw0MoS4X6PW3DnTiveD4l91vtdL8tIoPu5Wxna1rj86ngrpLcG
	 0ZmznFvIh3myQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: wangshuaiwei <wangshuaiwei1@xiaomi.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] scsi: ufs: core: Fix shift out of bounds when MAXQ=32
Date: Thu,  5 Mar 2026 10:36:59 -0500
Message-ID: <20260305153704.106918-16-sashal@kernel.org>
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

From: wangshuaiwei <wangshuaiwei1@xiaomi.com>

[ Upstream commit 2f38fd99c0004676d835ae96ac4f3b54edc02c82 ]

According to JESD223F, the maximum number of queues (MAXQ) is 32. When MCQ
is enabled and ESI is disabled, nr_hw_queues=32 causes a shift overflow
problem.

Fix this by using 64-bit intermediate values to handle the nr_hw_queues=32
case safely.

Signed-off-by: wangshuaiwei <wangshuaiwei1@xiaomi.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260224063228.50112-1-wangshuaiwei1@xiaomi.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit fixes

This is a classic **undefined behavior (UB) / shift out of bounds** bug.
The expression `(1U << hba->nr_hw_queues) - 1` uses a 32-bit unsigned
integer literal `1U`. When `hba->nr_hw_queues == 32` (which is the
maximum allowed by the JESD223F UFS specification), the expression `1U
<< 32` is undefined behavior in C — shifting a 32-bit value by 32 or
more positions is explicitly undefined per the C standard.

The fix changes `1U` to `1ULL` (64-bit), making the shift well-defined
for values up to 63.

### Bug mechanism and impact

- **Variable:** `outstanding_cqs` is declared as `unsigned long` (64-bit
  on 64-bit platforms)
- **Context:** This is a fallback path in the interrupt handler
  `ufshcd_handle_mcq_cq_events()` — executed when
  `ufshcd_vops_get_outstanding_cqs()` fails (vendor-specific register
  not available)
- **Trigger:** Hardware with MAXQ=32 (the maximum allowed by UFS spec)
- **Consequence:** On such hardware, the undefined behavior could result
  in `outstanding_cqs` being set to 0 instead of the intended bitmask of
  all 1s (0xFFFFFFFF). This would mean **no completion queues get
  serviced**, potentially causing I/O hangs or lost completions — a
  severe storage subsystem issue.

### Stable kernel criteria assessment

1. **Obviously correct and tested:** Yes — a single-character change
   (`U` → `ULL`), reviewed by Bart Van Assche (UFS maintainer). The fix
   is trivially correct.
2. **Fixes a real bug:** Yes — undefined behavior that can cause I/O
   failures on hardware with 32 queues.
3. **Important issue:** Yes — storage I/O hangs are critical. UFS is the
   standard storage interface for mobile devices.
4. **Small and contained:** Yes — a single line change, single character
   modification.
5. **No new features:** Correct — pure bug fix.

### Risk assessment

**Risk: Extremely low.** This is a one-character change from `1U` to
`1ULL`. It cannot introduce regressions — on hardware with fewer than 32
queues, the behavior is identical. On hardware with exactly 32 queues,
it fixes the undefined behavior.

### Affected versions

The buggy code was introduced in commit `f87b2c41822aa` ("scsi: ufs:
mcq: Add completion support of a CQE") which landed in v6.3 (merged
January 2023). All stable trees from 6.3 onward that include MCQ support
are affected.

### Verification

- **git blame** confirmed the buggy line `(1U << hba->nr_hw_queues) - 1`
  originates from commit `f87b2c41822aa` (January 2023)
- **Code reading** confirmed `outstanding_cqs` is `unsigned long` and
  `nr_hw_queues` is `unsigned int`, verifying the type mismatch concern
- **Read `ufs-mcq.c:174`** confirmed `hba_maxq` is derived from
  `FIELD_GET(MAX_QUEUE_SUP, ...)` + 1, and per JESD223F the max is 32,
  confirming `nr_hw_queues=32` is a valid hardware configuration
- **Read `ufs-mcq.c:193-219`** confirmed `hba->nr_hw_queues` is set to
  the total number of queues which can reach `hba_maxq` (up to 32)
- **Reviewed-by: Bart Van Assche** — UFS subsystem expert confirms the
  fix
- The commit applies to a single file with a trivial one-character
  change

This is a textbook stable backport candidate: a one-character fix for
undefined behavior in a storage driver interrupt handler, with potential
for I/O hangs on compliant hardware. Minimal risk, clear correctness,
important subsystem.

**YES**

 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 27d53a044dbad..f65b0aeef6dde 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7094,7 +7094,7 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
 
 	ret = ufshcd_vops_get_outstanding_cqs(hba, &outstanding_cqs);
 	if (ret)
-		outstanding_cqs = (1U << hba->nr_hw_queues) - 1;
+		outstanding_cqs = (1ULL << hba->nr_hw_queues) - 1;
 
 	/* Exclude the poll queues */
 	nr_queues = hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];
-- 
2.51.0

