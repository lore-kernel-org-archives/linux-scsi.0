Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A98306490;
	Sat, 25 Oct 2025 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409638; cv=none; b=c8P2hCZsKMHTe6p1xY6GO5esYiD2ilTRpHdlPdl4+NrftMZTSBTHKDLjS3WR740YKMWhkD3I1m8iHJsAksvFzHcKSjKX+bov2W9f3tGqiKabX0EUpWqyGGQDLIH/4XTHKk4cwpBjySuSB7ivJCHaI40+Hh7k2JH5fL6gBXnnHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409638; c=relaxed/simple;
	bh=674ScUfL2y2OnNZx6hSiuHRi3Sb7Jh74ZzdnAu96/C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5L5f/4/jjgwyVG6hTdKt8tC6q6O3LxVCd5p/ZrcM0iQdwQDENT07CPc3HNs2efa9e11bL/DKiBTUsrqs60gJHrYMwUAH+MifVZnixEWuDJtAUaHizbJ+yUPjH+9KxCoTxP2fWC34SOMGbAhiJ2uC9Vndb/zPmtI7m/oK9zplBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FB9FP3Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FB9FP3Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2534C4CEFB;
	Sat, 25 Oct 2025 16:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409637;
	bh=674ScUfL2y2OnNZx6hSiuHRi3Sb7Jh74ZzdnAu96/C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FB9FP3Ze/ksaLxYh9WIvnqxymo4lIUHCrh/1Xv4GFd7ZsJHLX9y0g5COqwLvWsS5/
	 +WBF/gMDBMXSlJd9vIeKEQX3mtuzEcRXC0Bn8yF7SZ+9lNw68IlbiEEejLHEMjs2QY
	 nX90j8buf54dEEahRT3cKu1stpEuKLtJFd3CRg+WfhcW3r+JLgSqgJJyQJwQO9Rcjy
	 7+wmnUjht5zIOQ0CRAVb6xfU0Q5FrxwsIusqQPkvlojc6/JkSwuqOrvqC5n2vWVmWq
	 hSL3h3FCL/yLkKlC4jtoApVyd27fc+Kg77x8a+ZkU5O2bkY7a3Dv04rfvL3HdMWLHA
	 fkRjcaxoollzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.1] scsi: ufs: host: mediatek: Enhance recovery on resume failure
Date: Sat, 25 Oct 2025 12:00:31 -0400
Message-ID: <20251025160905.3857885-400-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 15ef3f5aa822f32524cba1463422a2c9372443f0 ]

Improve the recovery process for failed resume operations. Log the
device's power status and return 0 if both resume and recovery fail to
prevent I/O hang.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation
- What changed (drivers/ufs/host/ufs-mediatek.c: fail path in
  `ufs_mtk_resume()`):
  - Old behavior: on resume failure, jump to `fail:` and return
    `ufshcd_link_recovery(hba)` (propagate error).
  - New behavior: at `fail:` call `ufshcd_link_recovery(hba)` and log
    runtime PM status if it fails; then unconditionally `return 0 /*
    Cannot return a failure, otherwise, the I/O will hang. */`.
  - Code reference: drivers/ufs/host/ufs-mediatek.c:1814 (call to
    `ufshcd_link_recovery(hba)`), followed by the new `dev_err()` that
    prints `hba->dev->power.request`, `runtime_status`, `runtime_error`,
    and the unconditional `return 0`.

- Why this fixes a real bug affecting users (I/O hang):
  - The UFS core resume path calls the vendor resume first and bails out
    immediately if the vops `resume()` returns an error, skipping core
    recovery steps like hibern8 exit or full reset/restore:
    - Code reference: drivers/ufs/core/ufshcd.c:10011 (`ret =
      ufshcd_vops_resume(hba, pm_op); if (ret) goto out;`).
    - If the Mediatek variant previously returned an error from
      `ufs_mtk_resume()`, the core code would not attempt
      `ufshcd_uic_hibern8_exit()` or `ufshcd_reset_and_restore()`,
      leaving the link/device in a bad state and causing I/O to hang.
  - With this patch, the Mediatek driver tries `ufshcd_link_recovery()`
    locally and returns 0, allowing the core resume sequence to proceed:
    - If the link is in Hibern8, the core performs
      `ufshcd_uic_hibern8_exit()` (drivers/ufs/core/ufshcd.c:10025) and
      sets the link active.
    - If the link is off, the core performs `ufshcd_reset_and_restore()`
      (drivers/ufs/core/ufshcd.c:10034).
  - Hence, even if the vendor-specific parts hit an error, the core
    still executes its well-tested recovery and bring-up, which avoids
    the I/O hang scenario the commit message calls out.

- Localized change, minimal risk:
  - The change is confined to one function in the Mediatek UFS host
    driver; no interface or architectural changes.
  - `ufshcd_link_recovery()` is the standard core recovery path for UFS
    (drivers/ufs/core/ufshcd.c:4467), which resets the device and host
    and is safe to invoke on failures.
  - Logging uses existing runtime PM fields for debugging and has no
    functional side effects.

- Side effects considered:
  - Masking the error return from `ufshcd_link_recovery()` at the
    variant level does not hide failures overall: subsequent core steps
    will still return errors if the link/device is not brought back
    correctly, and the resume wrapper will report failure
    (drivers/ufs/core/ufshcd.c:10011+ path).
  - This approach improves robustness by ensuring core recovery always
    runs, which is preferable to aborting early and risking an
    unrecovered link and stuck I/O.

- Stable backport criteria:
  - Fixes a user-visible bug (I/O hang after resume failures).
  - Patch is small, self-contained, and limited to Mediatek UFS host
    driver.
  - No new features or API changes; follows existing error-handling
    patterns (attempt recovery, proceed to core recovery, log details).
  - Low regression risk relative to the severity of the hang it
    prevents.

Conclusion: This is a targeted bug fix that prevents I/O hangs by
ensuring the core resume/recovery sequence runs even if the vendor
resume fails. It is suitable for backporting to stable.

 drivers/ufs/host/ufs-mediatek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index bb0be6bed1bca..188f90e468c41 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1727,8 +1727,21 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	return 0;
+
 fail:
-	return ufshcd_link_recovery(hba);
+	/*
+	 * Check if the platform (parent) device has resumed, and ensure that
+	 * power, clock, and MTCMOS are all turned on.
+	 */
+	err = ufshcd_link_recovery(hba);
+	if (err) {
+		dev_err(hba->dev, "Device PM: req=%d, status:%d, err:%d\n",
+			hba->dev->power.request,
+			hba->dev->power.runtime_status,
+			hba->dev->power.runtime_error);
+	}
+
+	return 0; /* Cannot return a failure, otherwise, the I/O will hang. */
 }
 
 static void ufs_mtk_dbg_register_dump(struct ufs_hba *hba)
-- 
2.51.0

