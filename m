Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B945305065;
	Sat, 25 Oct 2025 16:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409316; cv=none; b=hN6H7NVl2qmNVDyeYruSPm1QGT6yCgklNskoy5bfwNm0JOeTvRNjMXFmm25e9O1eTmqgDl01DXcup08rxcnGGYfSIxKxxCR44pq3g0ouwX4JQMLQjLIpjhoEucObT9Zz1vR7JTkvP0yoJh2onANrwMKAFtrxudeD6JVMIrXq84I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409316; c=relaxed/simple;
	bh=bAmc/lKD3RaEvDXfSaU7SpuBu+7bcVvlYIoOzd//ceQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxDt/ug4MbWjQJMD2suf7Q7a9nfZeU4nv2rqq1JwP2lU8Dq4cGrmLcDL2Rc7k8SjJRlsbzQSZY6VoHpJ0ExZU6iFc46PS2vd0RHKEaXNaLEnDlPj2elx+2o5jGYZzthDok+uH0o2MN0b6vQMQIfOhjSjspJrmxPEqwq3+4d2r5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uVURN3Bs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uVURN3Bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9BCC2BCB7;
	Sat, 25 Oct 2025 16:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409315;
	bh=bAmc/lKD3RaEvDXfSaU7SpuBu+7bcVvlYIoOzd//ceQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVURN3BsiQlHXKPik0M4Qm1j8uGmuLwZUbIk2uT3diWbKwzMDVi7jNZecSFOzoSS5
	 /3nAtMsyBAsPj/1GfyviGne8g67oXo66Ui6yTKbkXoTBum611LGkH6hQ+FzqejVSDL
	 kGBpWao1w2OchTdRg4DtGJtfsHmoE5bb7DroF5xr0N7y34/H2qJU4FGRGWb+IozG0P
	 8r20yU0y53aXV5x/SKVJnQrv86HDetOLxX6Vj0CUt5/JpJGDiTWEhSd2LgYg6xz9dr
	 TKQ1S7zxxWHx4UaHbnF+9Ex2pBBRt2UfpxgdMhs7LpKVcSvD+7OwRf7d7Se4Z1OCoN
	 fhJWA8S4dbL8w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alice Chao <alice.chao@mediatek.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17] scsi: ufs: host: mediatek: Fix adapt issue after PA_Init
Date: Sat, 25 Oct 2025 11:58:28 -0400
Message-ID: <20251025160905.3857885-277-sashal@kernel.org>
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

From: Alice Chao <alice.chao@mediatek.com>

[ Upstream commit d73836cb8535b3078e4d2a57913f301baec58a33 ]

Address the issue where the host does not send adapt to the device after
PA_Init success. Ensure the adapt process is correctly initiated for
devices with IP version MT6899 and above, resolving communication issues
between the host and device.

Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: The host wasn’t initiating the adaptation phase after a
  successful PA_Init, causing communication/link reliability issues on
  newer MediaTek UFS IPs. The patch explicitly triggers adapt for those
  chips.

- Where it changes code:
  - Adds an adapt trigger in `ufs_mtk_post_link()` by setting
    `VS_DEBUGOMC` bit `0x100` for IP versions MT6899 and newer:
    `drivers/ufs/host/ufs-mediatek.c:1557-1566`.
  - The adapt step runs in the post-link stage via
    `ufs_mtk_link_startup_notify()` → `POST_CHANGE` →
    `ufs_mtk_post_link()`: `drivers/ufs/host/ufs-mediatek.c:1576-1583`.
  - The IP version gating this logic is well-defined in the platform
    header: `drivers/ufs/host/ufs-mediatek.h:208-217`.
  - The UniPro vendor attribute `VS_DEBUGOMC` is a standard symbol in
    the tree: `include/ufs/unipro.h:176`.

- How it works:
  - After link startup, for `host->ip_ver >= IP_VER_MT6899`, it reads
    `VS_DEBUGOMC`, ORs in `0x100`, and writes it back to trigger the
    device adapt: `drivers/ufs/host/ufs-mediatek.c:1559-1565`.
  - This is analogous to existing, targeted use of `VS_DEBUGOMC` for
    MT6989 (bit `0x10`) already in the pre-link path, demonstrating
    prior, chip-specific, safe use of the same attribute:
    `drivers/ufs/host/ufs-mediatek.c:1543-1550`.

- Why it’s a good stable backport:
  - Bugfix that affects users: Without adapt, devices on MT6899+ may
    exhibit link/communication issues after PA_Init, which is a
    functional defect rather than a new feature.
  - Small, contained change: Touches a single driver file and one
    function body in a guarded, post-link path.
  - Minimal risk: Gated by `host->ip_ver >= IP_VER_MT6899` so it does
    not affect older IPs; no API or architectural changes; leverages an
    existing attribute already used safely for a nearby IP generation.
  - Side effects are narrow and intended: It only sets a vendor-specific
    UniPro debug attribute after link-up on specific SoCs, then proceeds
    to the pre-existing UniPro clock gating enable, keeping previous
    sequencing intact.

- Notes on robustness:
  - The new `ufshcd_dme_get()`/`set()` calls do not check return values
    in `ufs_mtk_post_link()` (drivers/ufs/host/ufs-
    mediatek.c:1559-1565). While typical for benign post-link tuning
    where failures shouldn’t abort link-up, adding error checks would be
    slightly safer. However, given this is vendor-guarded and called
    post link-up, the practical risk is low and consistent with similar
    driver patterns.

- Stable criteria assessment:
  - Important bugfix: Yes (link/communication reliability on MT6899+).
  - Not a feature/No arch changes: Yes.
  - Minimal regression risk: Yes (chip-gated, vendor-specific).
  - Self-contained and small: Yes.
  - Explicit stable tag: Not present, but merits backport based on
    impact and scope.

Conclusion: This is a focused, SoC-gated fix that addresses a real
interoperability bug with minimal risk. It fits stable backporting
guidelines well.

 drivers/ufs/host/ufs-mediatek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3defb5f135e33..c0acbd3f8fc36 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1503,8 +1503,19 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
 
 	return ret;
 }
+
 static void ufs_mtk_post_link(struct ufs_hba *hba)
 {
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	u32 tmp;
+
+	/* fix device PA_INIT no adapt */
+	if (host->ip_ver >= IP_VER_MT6899) {
+		ufshcd_dme_get(hba, UIC_ARG_MIB(VS_DEBUGOMC), &tmp);
+		tmp |= 0x100;
+		ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGOMC), tmp);
+	}
+
 	/* enable unipro clock gating feature */
 	ufs_mtk_cfg_unipro_cg(hba, true);
 }
-- 
2.51.0

