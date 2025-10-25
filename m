Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174913090C2;
	Sat, 25 Oct 2025 16:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409123; cv=none; b=dOElVpq3ee1KYL2t9pWEYkgJS7bkBAH5cE9i+PnDgq6MCdhd7XptwpNtDtroQPyZwbVepHKMIvWSgD7bPfL70reLaOjh9r7kjMxLX4PG7tejAXY/GHsKDpBvLgZj1s5yQKaRlddwbLtEj9/cl+On5OgNbh0tHZbjYkM6AEb1UFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409123; c=relaxed/simple;
	bh=jOwAaak8KSgKU9WgPZpnmtpHv6+tBUvqP0LDTvf20GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=US109AIiQrQ8b4VrVwm1il4osaRmIiI2iXn2CFZHO2zRWb+k8jpUHCx98kEznNWWoaQWrAdJRw0Tgy/vzJS3zms9Off1U327DO3s89ztCmPHQfJgmV3bZmA09i8sFTsxe6u2Pmkmt6REjo0sZvTPJlS2HfX/vkZ6YdzMyZIXQHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8KbKI9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8KbKI9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8A6C4CEF5;
	Sat, 25 Oct 2025 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409122;
	bh=jOwAaak8KSgKU9WgPZpnmtpHv6+tBUvqP0LDTvf20GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8KbKI9NztdeQ7OdumoVbu/XpjPTIBdaMBGskyeVD3g2Z+6EdBEGYwyfBeosd/fnY
	 IY3NxNIL69sm8dWWGcZsnOPsZgmMtVLxTyjd4/BZZ+BKvbYWFDsUiNq7zIv6IlWdsb
	 g86xS89PtlWfRpXi2HWfPUVOxeZ84UrlSXzV+R+Wb3rAm0YbZ1uAOMxoJ7XEJeJ9tF
	 TEr0ImD1xU1uGqz6/6aSvwoqWf1eFxmtb+WsEpbCuzdQFZi7MI84F0CJG11ds8N2re
	 chZDfgjUecWQ7Ady1vvxl12YcANZ0LjW75Bknf9fR6DsU9XJps5TMlep/+yWM6fuqa
	 0nraTV9pYSvCw==
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
Subject: [PATCH AUTOSEL 6.17-6.12] scsi: ufs: host: mediatek: Fix PWM mode switch issue
Date: Sat, 25 Oct 2025 11:57:18 -0400
Message-ID: <20251025160905.3857885-207-sashal@kernel.org>
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

[ Upstream commit 7212d624f8638f8ea8ad1ecbb80622c7987bc7a1 ]

Address a failure in switching to PWM mode by ensuring proper
configuration of power modes and adaptation settings. The changes
include checks for SLOW_MODE and adjustments to the desired working mode
and adaptation configuration based on the device's power mode and
hardware version.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20250811131423.3444014-6-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this is a bug fix that affects users
- The current MediaTek UFS host variant ignores a request to enter PWM
  (SLOW) mode and/or misconfigures HS adaptation when entering PWM,
  which can cause power mode change failures. Specifically:
  - The driver always negotiates HS by default and does not honor a PWM
    request in PRE_CHANGE, because it never sets
    `host_params.desired_working_mode` to PWM before calling
    `ufshcd_negotiate_pwr_params()` (drivers/ufs/host/ufs-
    mediatek.c:1083). That negotiation API obeys the desired working
    mode (drivers/ufs/host/ufshcd-pltfrm.c:358) and defaults to HS
    unless told otherwise. This causes negotiation to fail or pick HS
    when PWM was requested.
  - The driver configures HS adaptation unconditionally on newer
    hardware, even if the negotiated mode is PWM. It currently does:
    `ufshcd_dme_configure_adapt(..., PA_INITIAL_ADAPT)` when
    `host->hw_ver.major >= 3` (drivers/ufs/host/ufs-mediatek.c:1128),
    which is inappropriate for PWM (SLOW) mode and can provoke
    UniPro/UIC errors during a PWM transition.

What the patch changes and why it fixes the issue
- Respect PWM requests in negotiation:
  - If the requested/desired power mode indicates PWM (`SLOW_MODE`), set
    `host_params.desired_working_mode = UFS_PWM_MODE` before
    negotiation. This makes `ufshcd_negotiate_pwr_params()` choose a PWM
    configuration instead of HS (drivers/ufs/host/ufshcd-pltfrm.h:10
    defines `UFS_PWM_MODE`; drivers/ufs/host/ufshcd-pltfrm.c:358,
    386–389 describe how `desired_working_mode` drives the decision).
- Avoid illegal/pointless HS adaptation in PWM:
  - Configure HS adaptation only if the requested power mode is HS
    (`FAST_MODE`/`FASTAUTO_MODE`). For PWM, explicitly configure
    NO_ADAPT. This prevents setting `PA_TXHSADAPTTYPE` to
    `PA_INITIAL_ADAPT` in non-HS modes, which is not valid and can fail
    (drivers/ufs/core/ufshcd.c:4061 shows `ufshcd_dme_configure_adapt()`
    and how PA_NO_ADAPT is used when gear is below HS G4; explicitly
    using NO_ADAPT for PWM is correct and clearer).
- Do not attempt the FASTAUTO-based PMC path when switching to PWM:
  - `ufs_mtk_pmc_via_fastauto()` currently decides on a FASTAUTO pre-
    step based on HS rate and gear checks (drivers/ufs/host/ufs-
    mediatek.c:1063). The patch adds an explicit guard to return false
    if either TX or RX pwr is `SLOW_MODE`. This prevents running the
    HSG1B FASTAUTO transition for a PWM target, which can lead to
    failures and “HSG1B FASTAUTO failed” logs (the caller logs this
    error at drivers/ufs/host/ufs-mediatek.c:1119).

Context in the existing code (pre-patch)
- PRE_CHANGE negotiation always starts from HS defaults:
  `ufshcd_init_host_params()` sets `desired_working_mode = UFS_HS_MODE`
  by default (drivers/ufs/host/ufshcd-pltfrm.c:441–458). The MediaTek
  variant does not adjust this default when PWM is requested
  (drivers/ufs/host/ufs-mediatek.c:1083), so
  `ufshcd_negotiate_pwr_params()` will try HS unless the patch sets PWM
  explicitly, leading to a failed/incorrect transition when PWM is
  desired.
- HS adaptation is currently forced for hw_ver.major >= 3 regardless of
  requested mode (drivers/ufs/host/ufs-mediatek.c:1128), which is
  incompatible with PWM mode.
- The driver considers FASTAUTO PMC only by HS rate and gear thresholds
  (drivers/ufs/host/ufs-mediatek.c:1063) and does not consider SLOW
  mode, allowing a FASTAUTO detour to be attempted even for PWM
  requests.

Risk and scope
- Scope is tightly contained to one driver file and to the PRE_CHANGE
  path:
  - Modified functions: `ufs_mtk_pmc_via_fastauto()`
    (drivers/ufs/host/ufs-mediatek.c:1063), `ufs_mtk_pre_pwr_change()`
    (drivers/ufs/host/ufs-mediatek.c:1083). No architectural changes.
- The logic changes are conditional and conservative:
  - FASTAUTO PMC is explicitly disabled only for SLOW (PWM) target
    modes; HS flows are unchanged.
  - Adaptation is only enabled for HS modes and otherwise set to
    NO_ADAPT, aligning with UniPro expectations.
    `ufshcd_dme_configure_adapt()` itself already normalizes to NO_ADAPT
    for low gears (drivers/ufs/core/ufshcd.c:4061), so explicitly
    requesting NO_ADAPT in PWM is safe and consistent.
- Dependencies: No new APIs. Uses existing `UFS_PWM_MODE`
  (drivers/ufs/host/ufshcd-pltfrm.h:10) and existing negotiation/config
  APIs. Gated by an existing capability for the FASTAUTO PMC path
  (`UFS_MTK_CAP_PMC_VIA_FASTAUTO` set by DT property;
  drivers/ufs/host/ufs-mediatek.c:655, 116).

Why it meets stable backport criteria
- Fixes a real, user-visible bug: failure to switch to PWM mode and
  related training errors in MediaTek UFS hosts when PWM is requested
  (e.g., during power management transitions or temporary SLOWAUTO mode
  for certain UIC accesses, see how the core requests SLOWAUTO/FASTAUTO
  in drivers/ufs/core/ufshcd.c:4211–4220).
- Minimal and localized change; no feature additions; no ABI changes.
- Aligns MediaTek variant with core expectations for PWM handling and
  with UniPro adaptation semantics, reducing error conditions without
  changing HS behavior.
- Low regression risk; the changes apply only when PWM is the target or
  when preventing a misapplied FASTAUTO path for PWM.

Conclusion
- Backporting this patch will prevent PWM mode switch failures and UIC
  config errors on MediaTek UFS hosts with negligible risk and no
  broader subsystem impact.

 drivers/ufs/host/ufs-mediatek.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 8dd124835151a..4171fa672450d 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1303,6 +1303,10 @@ static bool ufs_mtk_pmc_via_fastauto(struct ufs_hba *hba,
 	    dev_req_params->gear_rx < UFS_HS_G4)
 		return false;
 
+	if (dev_req_params->pwr_tx == SLOW_MODE ||
+	    dev_req_params->pwr_rx == SLOW_MODE)
+		return false;
+
 	return true;
 }
 
@@ -1318,6 +1322,10 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 	host_params.hs_rx_gear = UFS_HS_G5;
 	host_params.hs_tx_gear = UFS_HS_G5;
 
+	if (dev_max_params->pwr_rx == SLOW_MODE ||
+	    dev_max_params->pwr_tx == SLOW_MODE)
+		host_params.desired_working_mode = UFS_PWM_MODE;
+
 	ret = ufshcd_negotiate_pwr_params(&host_params, dev_max_params, dev_req_params);
 	if (ret) {
 		pr_info("%s: failed to determine capabilities\n",
@@ -1350,10 +1358,21 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 		}
 	}
 
-	if (host->hw_ver.major >= 3) {
+	if (dev_req_params->pwr_rx == FAST_MODE ||
+	    dev_req_params->pwr_rx == FASTAUTO_MODE) {
+		if (host->hw_ver.major >= 3) {
+			ret = ufshcd_dme_configure_adapt(hba,
+						   dev_req_params->gear_tx,
+						   PA_INITIAL_ADAPT);
+		} else {
+			ret = ufshcd_dme_configure_adapt(hba,
+				   dev_req_params->gear_tx,
+				   PA_NO_ADAPT);
+		}
+	} else {
 		ret = ufshcd_dme_configure_adapt(hba,
-					   dev_req_params->gear_tx,
-					   PA_INITIAL_ADAPT);
+			   dev_req_params->gear_tx,
+			   PA_NO_ADAPT);
 	}
 
 	return ret;
-- 
2.51.0

