Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A00A3043D7;
	Sat, 25 Oct 2025 16:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409608; cv=none; b=A1neEzvc/9tceP97U6C84SEsync+HDmdC6r5nLxKxM3+5zmJwRkFox/aTBHCHTaKSxMQyPy5L7oEkiVTnzNIhV0TARaH4kJuHymFTdre4pviGCoEHxzaf0tPOeMLKYe+8Z0NuB09aNgXhlGbkYf/LCjTsBgnmaKD/3QLGvLmfrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409608; c=relaxed/simple;
	bh=cvWUBD/FCgrQNuYv0W7OchRUtrorq/v9H+SVgEfr2tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aqoBaDcY2FWnKnqvvb4GZ50NHy731rxXQ0WyCbfTqak7X1NRmc3F15aWDnHcEEGk0SomqiS9TrKGS9GgKlZas9KhXJFx9SY+yhwLd8GOplVUNpvuUM2tUxzuRqMIdp1vVZ1j102zP0CnNCWSB2OLNFdQKnpGRnKW+3HO2RMVwg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3QOaGde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3QOaGde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAFAC4CEF5;
	Sat, 25 Oct 2025 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409608;
	bh=cvWUBD/FCgrQNuYv0W7OchRUtrorq/v9H+SVgEfr2tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3QOaGdeaghICJXujgECPSkl5AwLqkbNX/06ZhFba2XzK9mK733rZ1nz1zSSQgrvL
	 BYJtYmLnwIy4TJ3YmraHlZ3HWwykcrE4RLuhCA5yLOnKbeQiPFJpZG+rNQfaPirGnl
	 9InQr6cu5xvUCi9UYqlrD8qv2Vnzj5EhbdPg3F3Y1RST3K9J/zvqxKAPP6K1vYwpYY
	 nRb3iX+scyo3+VnmGtQkbxqyXOqyCvVesTONB8+2VwriTepWT++6A6g9EfKxA6Vyt7
	 eAwOE75OjbKruDa91uw/vzN5j6+pWf9+ViXJWWdAI/6IRFk2fqtKqmSvjUjTpuwf5y
	 WzU5SkWTkDe8Q==
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
Subject: [PATCH AUTOSEL 6.17-6.12] scsi: ufs: host: mediatek: Fix unbalanced IRQ enable issue
Date: Sat, 25 Oct 2025 12:00:21 -0400
Message-ID: <20251025160905.3857885-390-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 91cad911edd1612ed28f5cfb2d4c53a8824951a5 ]

Resolve the issue of unbalanced IRQ enablement by setting the
'is_mcq_intr_enabled' flag after the first successful IRQ enablement.
Ensure proper tracking of the IRQ state and prevent potential mismatches
in IRQ handling.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents unbalanced IRQ enable calls in the Mediatek UFS MCQ path by
    ensuring the driver’s internal state flag matches the real IRQ state
    immediately after the IRQs are requested (and thus enabled by
    default). Without this, subsequent enable paths may re-enable
    already-enabled IRQs, triggering “unbalanced enable” warnings and
    mismatched IRQ depth accounting.

- Precise change
  - Adds `host->is_mcq_intr_enabled = true;` at the end of
    `ufs_mtk_config_mcq_irq()` after all IRQ handlers have been
    successfully registered with `devm_request_irq()`
    (drivers/ufs/host/ufs-mediatek.c:2193).
    - This reflects that IRQs are enabled as a result of `request_irq()`
      and aligns the state flag with reality.

- Why it’s correct
  - `devm_request_irq()` attaches the handler and leaves the IRQ enabled
    by default. If the state flag remains false, the first call into the
    driver’s “enable MCQ IRQs” helper will re-enable an already-enabled
    IRQ, causing an unbalanced enable.
  - The driver already guards enable/disable with this flag:
    - Disable path: sets the flag false after disabling
      (drivers/ufs/host/ufs-mediatek.c:741).
    - Enable path: bails out if already enabled and sets the flag true
      only after enabling (drivers/ufs/host/ufs-mediatek.c:755 and
      drivers/ufs/host/ufs-mediatek.c:762).
  - With the new line in `ufs_mtk_config_mcq_irq()`
    (drivers/ufs/host/ufs-mediatek.c:2193), the initial state is
    correct, so `ufs_mtk_mcq_enable_irq()` will correctly no-op on the
    first enable attempt when IRQs are already enabled.

- How the bug manifested
  - `ufs_mtk_setup_clocks()`’s POST_CHANGE flow calls
    `ufs_mtk_mcq_enable_irq()` (drivers/ufs/host/ufs-mediatek.c:817).
    Before this patch, after `devm_request_irq()` the IRQs were already
    enabled but `is_mcq_intr_enabled` was still false, so the enable
    path would call `enable_irq()` again, risking “unbalanced IRQ
    enable” warnings.
  - The disable path is already consistent: `ufs_mtk_mcq_disable_irq()`
    uses the list of IRQs and flips the flag to false
    (drivers/ufs/host/ufs-mediatek.c:741), so subsequent enables are
    properly balanced.

- Scope and risk
  - Change is a single-line state fix in one driver function, confined
    to the Mediatek UFS host driver.
  - No API, ABI, or architectural changes; no behavioral changes beyond
    preventing an incorrect extra `enable_irq()`.
  - The flag is set only after all IRQ requests succeed; if any
    `devm_request_irq()` fails, the function returns early and does not
    set the flag, preserving prior behavior.

- Stable backport criteria
  - Fixes a real correctness issue that can lead to warnings and IRQ
    depth mismatches.
  - Small, contained, and low risk.
  - No feature addition; clear bug fix in a specific subsystem (SCSI UFS
    Mediatek host).

Given the above, this is a good candidate for stable backporting
wherever the Mediatek UFS MCQ driver and `is_mcq_intr_enabled` field
exist.

 drivers/ufs/host/ufs-mediatek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 188f90e468c41..055b24758ca3d 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2111,6 +2111,7 @@ static int ufs_mtk_config_mcq_irq(struct ufs_hba *hba)
 			return ret;
 		}
 	}
+	host->is_mcq_intr_enabled = true;
 
 	return 0;
 }
-- 
2.51.0

