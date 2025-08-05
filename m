Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3A52B9B7;
	Tue,  5 Aug 2025 13:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399395; cv=none; b=D71LWj7FhCD7DMIVv6GMGqV+SsVE/hrhpOdYWAbVipfK5c6njE9Qnxbkk9+rRLuEMaxcNdQ1WgJeKD07ZM4mG+CmRCqPJ77uyG91T0m8m1MP2ucS0JLpc70dQKjwRaBG5lrCT6D0r1gg+A1xt6djEq6VpBOltKbA/C3k7/wyP9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399395; c=relaxed/simple;
	bh=LfKbFTBPnzgytpkU5tg4y4KPR2bD6qhAJApDeT2+Qxs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oh50taueUw6USpC9SBIgABrrm+sjiBWnTrWAmGCDGaf9b5Zre72SWaT9eJaRAha6s2yDp3sQV2uHSIqRYj+oaDJRCfoACvXL1vgZbZaXIi4sR0iPogp3PIVXcsATs+Otzu6uahpeevT5WIgrehZEfPmk0q0XIEyVDjv33uk+Lkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtMsc4Ou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtMsc4Ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F75C4CEF0;
	Tue,  5 Aug 2025 13:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399394;
	bh=LfKbFTBPnzgytpkU5tg4y4KPR2bD6qhAJApDeT2+Qxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtMsc4Ou9IaAphSnljnMPo+spFH6K66FAyKchIpcPgf36QTAmlRn6/2CooL7L8LeP
	 1onBPZO+eZp2RPZg3v7kqLBBNxiwFuEy2ZVUhBQIzI6swLFESc9Vg8ppXTwC6JfHCg
	 dyvrmUqYWyzjR5qJkIqngoIGcVJE7d22T1bsGQj8F7lHm7e9WuJG9i5S0kAJGiReQw
	 +BNUQuT2bsR8p4t7XYkII1lmtKIAmXiDzIICzncbEgxlb8Wch44HYZnbSyM9uTy8VD
	 QP79tnp9Di9mVvyNwyiCguwx93f6It4pRQzUlE4ZidWJ6d9i7T5lezg5bG+bHG8KMC
	 qaOpWEfjObglg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: jackysliu <1972843537@qq.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] scsi: bfa: Double-free fix
Date: Tue,  5 Aug 2025 09:08:39 -0400
Message-Id: <20250805130945.471732-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: jackysliu <1972843537@qq.com>

[ Upstream commit add4c4850363d7c1b72e8fce9ccb21fdd2cf5dc9 ]

When the bfad_im_probe() function fails during initialization, the memory
pointed to by bfad->im is freed without setting bfad->im to NULL.

Subsequently, during driver uninstallation, when the state machine enters
the bfad_sm_stopping state and calls the bfad_im_probe_undo() function,
it attempts to free the memory pointed to by bfad->im again, thereby
triggering a double-free vulnerability.

Set bfad->im to NULL if probing fails.

Signed-off-by: jackysliu <1972843537@qq.com>
Link: https://lore.kernel.org/r/tencent_3BB950D6D2D470976F55FC879206DE0B9A09@qq.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit is a clear candidate for backporting to stable kernel trees.
Here's my extensive analysis:

## Bug Analysis

The commit fixes a **critical double-free vulnerability** in the BFA
(Brocade Fibre Channel Adapter) SCSI driver. The issue occurs in the
following scenario:

1. During driver initialization, `bfad_im_probe()` allocates memory for
   `bfad->im` (line 700: `im = kzalloc(sizeof(struct bfad_im_s),
   GFP_KERNEL)`)
2. The pointer is assigned to `bfad->im` (line 704: `bfad->im = im`)
3. If `bfad_thread_workq()` fails (line 707), the function frees the
   memory (line 708: `kfree(im)`) but **fails to set `bfad->im = NULL`**
4. Later, during driver uninstallation, when the state machine enters
   `bfad_sm_stopping` state, it calls `bfad_im_probe_undo()` (line 714
   in bfad.c)
5. `bfad_im_probe_undo()` checks `if (bfad->im)` (line 720) and since
   the pointer wasn't nulled, it attempts to free the already-freed
   memory again (line 722: `kfree(bfad->im)`)

## Why This Should Be Backported

1. **Security Impact**: Double-free vulnerabilities can lead to memory
   corruption, system crashes, and potentially be exploited for
   privilege escalation. This is a real security issue.

2. **Simple Fix**: The fix is minimal - just a single line addition
   (`bfad->im = NULL;`) after the `kfree(im)` call. This follows the
   exact same pattern already used in `bfad_im_probe_undo()` where after
   freeing, the pointer is set to NULL (line 723).

3. **Clear Bug**: The bug is straightforward - the code inconsistently
   handles the cleanup path. The fix makes it consistent with the
   cleanup function's expectations.

4. **Limited Scope**: The change is confined to error handling in a
   single function (`bfad_im_probe()`). It doesn't modify any normal
   operation paths or introduce new features.

5. **Low Risk**: Setting a pointer to NULL after freeing is a standard
   defensive programming practice with essentially zero risk of
   regression.

6. **Affects Users**: Any system using Brocade Fibre Channel adapters
   could hit this issue if the driver initialization fails (e.g., due to
   memory allocation failure in `bfad_thread_workq()`).

7. **Follows Stable Rules**: The commit:
   - Fixes a real bug (double-free vulnerability)
   - Is small and contained (1 line change)
   - Has clear causality
   - Doesn't introduce new features
   - Has minimal risk of causing regressions

The commit follows the Linux stable kernel rules perfectly - it's a
small, obvious fix for a real bug that could affect users in production
environments.

 drivers/scsi/bfa/bfad_im.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index a719a18f0fbc..f56e008ee52b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -706,6 +706,7 @@ bfad_im_probe(struct bfad_s *bfad)
 
 	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
+		bfad->im = NULL;
 		return BFA_STATUS_FAILED;
 	}
 
-- 
2.39.5

