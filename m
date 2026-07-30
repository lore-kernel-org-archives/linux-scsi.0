Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451083D3CF7;
	Thu, 30 Jul 2026 09:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405000; cv=none; b=tD7bcwfiPQT52gqoizGIdKGOypM9R04U1pSHhPO+bDrtNU5e9+zoDd10JBsK4FO9f+JB/4sVVNlLRnTrw9orCzyJnZPewiZBzKanI2CrqUYhA+AbezXm/xEkMOpMQuTCRzi1iZB98kgexAhKDw4Svb66Df7rCj2SKTq9tcIlJt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405000; c=relaxed/simple;
	bh=Qeh1WKHIh+2u2UQFSEXAeYQ1CXGJIUxvSH4rFmbGKKA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NxqpZy+UnJgwTXEd177jcjJpZyrGzoD3YHI7qtbHiMPil8hNw6h3FDHWYN+NOIA4DyXgcOPS0iGKX8vvn2o7b+iaZzcL1IkI+JQFAaUiTiz6uZTvzw5Y99DvrO2+BE5vjbnYEy+Y9DbMji0ey9hPYvVD8NCUzuQjfjaE4HnIgvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=TW5e0YgZ; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="TW5e0YgZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785404995;
	bh=Qeh1WKHIh+2u2UQFSEXAeYQ1CXGJIUxvSH4rFmbGKKA=;
	h=From:Subject:Date:To:Cc:From;
	b=TW5e0YgZVNZcctfyxXnokpLsIvH4L5gTp+BCdg50GaFR0gU4RwUYHCIwOm+h0j9Mq
	 zY9Tz4iZZz2LBSDNlbo8XVA/GD8/apGRZNfYa8lw3vnZ/lOxORXMVgQDQ/JRKnV9va
	 INmWrDU3eOfa5TqUXmBSvHdpryCOZ7ztyj3Z9ziY57BMriQWVL97gB2li636P+QJAi
	 HJTJixEZTKN3mr2nR3mRkktIYdIlxFHqGWeUHmrnZ0Rw2nCJ/nTfwMu2xxU2peXav0
	 Xf0CVj93jkkq447okNCyHconSXWYSpVu0XvLE0cp2vofmn065+W2H6Eq6T673+dxF/
	 5PpiekXVQWlfQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id C6B2217E051A;
	Thu, 30 Jul 2026 11:49:53 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Subject: [PATCH v10 00/26] MediaTek UFS Cleanup and MT8196 Enablement
Date: Thu, 30 Jul 2026 11:48:56 +0200
Message-Id: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23Qy27CQAwF0F9Bs+5UnvcMq/5H1cU8nBIJCE1CR
 IX495qgigTN0pbOtXWvbMC+xYFtN1fW49QObXekQcDbhuVdPH4jbwstmARpBAjND6MXwfJzM/C
 MWacQg0OjGIFTj017mdM+vx5zjz9nCh0fS5bigDx3h0M7bjdHvIycci04Gdgd7Nph7Prf+ZtJz
 KJ2dxIcuAimZExepew/crffx9T18Z3C56hJLrldcUk8K6e80lmjizWuFlyqFVfEoQGddHTBNE2
 N6yeXwq+4Jl4KZheVDaXIGjf/3IKANTfEdZDCCOOof1HjdsHlujpLHF0GMMkCyGp17snlS3WOe
 DKNDOCyLdHVuH9yBevrnrhJgDFLpYSuVheWfH093Dl5pxoXvYJXfrvd/gBTwJuw0gIAAA==
X-Change-ID: 20251014-mt8196-ufs-cec4b9a97e53
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Conor Dooley <conor.dooley@microchip.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=10750;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=Qeh1WKHIh+2u2UQFSEXAeYQ1CXGJIUxvSH4rFmbGKKA=;
 b=jLoWaFVV5t3srKMzP+uDIxSR5Nb5LBpj40rbNPu/CjHq+J7geuRgYafAltEuQO/frzxt0qqll
 wY57EFAEyfAAvYzglA1sBMCTeeKCWBJJbfeaS7La5tiVAVIOumFkeYs
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

This series is a continuation of Nicolas Frattaroli's series, that does
major cleanups in the Mediatek UFS driver code and dt-bindings
and adds the support for the MT8196 SoC and its variants (MT8894 SoC).
This new revision of the series takes into account the remaining peer
reviews and issues reports for v9.

First, it fixes several build and check issues: kernel test report build
report [1], patch per patch compilation, dtbs_check warnings.

Second, regarding the opened issues in v9 on the dt-bindings patches
2 ("dt-bindings: ufs: mediatek,ufs: Complete the binding") and 3
("dt-bindings: ufs: mediatek,ufs: Add mt8196 variant") [2],
this revision has two major changes to address them:
1) It renames all the clock names starting with ufs_ prefix and the one
that was named "ufs". No driver changes is needed for those because
they are not explicitely used by their names. The ufs_sel and ufs_fde
clocks in the driver were not renamed because they are not present 
in the dt-bindings (not anymore for the ufs_sel).
The devicetree patches for MT8195 SoC dtsi and the Mediatek Genio
1200-EVK and Radxa NIO-12L boards were also added to match the changes
made by series.
2) It drops the addition of all crypto and ufs_sel clocks, as it seems the
most likely and best solution to [2] after investigating on them and
what they are used for ([3]).

The Reviewed-by and Acked-by trailers, got by the patches 2 and 3 in
previous series revisions, were dropped so these changes can be reviewed again. 

This new revision is based on linux-next kernel tree (tag:
next-20260729) and has been tested on Mediatek Genio 5100 Pro board
(that integrates a MT8894 SoC).

[1]: https://lore.kernel.org/linux-mediatek/202603081809.R9OrrITa-lkp@intel.com/
[2]: https://lore.kernel.org/linux-mediatek/20260306163305.GA2680515-robh@kernel.org/
[3]: https://lore.kernel.org/linux-mediatek/8b013876c591f80ec4af86d69bf2f38f9ac481ad.camel@collabora.com/

Original Nicolas Frattaroli's cover letter:

In this series, the existing MediaTek UFS binding is expanded and
completed to correctly describe not just the existing compatibles, but
also to introduce a new compatible in the from of the MT8196 SoC.

The resets, which until now were completely absent from both the UFS
host controller binding and the UFS PHY binding, are introduced to both.
This also means the driver's undocumented and, in mainline, unused reset
logic is reworked. In particular, the PHY reset is no longer a reset of
the host controller node, but of the PHY node.

This means the host controller can reset the PHY through the common PHY
framework.

The resets remain optional.

Additionally, a massive number of driver cleanups are introduced. These
were prompted by me inspecting the driver more closely as I was
adjusting it to correspond to the binding.

The driver still implements vendor properties that are undocumented in
the binding. I did not touch most of those, as I neither want to
convince the bindings maintainers that they are needed without knowing
precisely what they're for, nor do I want to argue with the driver
authors when removing them.

Due to the "Marie Kondo with a chainsaw" nature of the driver cleanup
patches, I humbly request that reviewers do not comment on displeasing
code they see in the context portion of a patch before they've read the
whole patch series, as that displeasing code may in fact be reworked in
a subsequent patch of this series. Please keep comments focused on the
changed lines of the diff; I know there's more that can be done, but it
doesn't necessarily need to be part of this series.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
Changes in v10:
- Rebased onto next-20260729 and fix conflicts
- Added Signed-off-by for all patches 
- Patch 2: 
  - Removed "ufs" prefix from clock names
  - Renamed "ufs" clock to "main"
  - Removed all crypto clock additions
  - Aligned example to patch changes
  - Reworded commit message to drop crypto clocks references
    and add clock names renaming
  - Dropped Reviewed-by/Acked-by trailers due to changes
- Patch 3:
  - Removed all ufs_sel clock additions
  - Aligned example to patch changes
  - Reworded commit message to drop ufs_sel clocks references
  - Dropped Reviewed-by/Acked-by trailers due to changes
- Fixed build failure on patch 9 due to ufs_mtk_of_match symbol being
  declared in the ufs-mediatek.c file after use.
- Moved ufs_mtk_of_match symbol at original place in patch 8
- Fixed build failure reported by Kernel Test Robot on patch 19 by
  fixing the incorrect FIELD_MODIFY val argument and using GENMASK
  for MTK_UFS_VER_PREFIX_M definition
- Added patch 24, 25, 26 devicetree patches for MT8195 SoC, Mediatek
  Genio 1200-EVK and Radxa NIO-12L boards to match the dt-bindings
  changes introduced by this series
- Added reviewed-by tag for patch 21
- Link to v9: https://lore.kernel.org/r/20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com

Changes in v9:
- Eliminate build failure in "Remove undocumented downstream reset
  cruft", including the of_node_put of the reset node that wasn't caught
- Pointlessly rename per-instance hibernate timer backup member to
  "ahit"
- Link to v8: https://lore.kernel.org/r/20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com

Changes in v8:
- Split "Rework probe function" into two, turn the reset removal into
  its own patch and squash the PHY changes into the common PHY framework
  patch.
- Leave "device reset done" logging print at INFO level
- Remove redundant falsy check for reg_vcore in "Don't acquire
  dvfsrc-vcore twice".
- Change ufs_mtk_wait_idle_state to early-exit on all non-HIB states,
  and poll for VS_HCE_BASE instead.
- Link to v7: https://lore.kernel.org/r/20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com

Changes in v7:
- Rebase onto next-20260205, which drops "scsi: ufs: mediatek: Switch to
  newer PM ops helpers" as Arnd sent an equivalent patch that also fixes
  the PM-less build failure.
- Link to v6: https://lore.kernel.org/r/20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com

Changes in v6:
- Reword "Rework probe function" commit to better justify the changes
  being made.
- Drop "Add vendor prefix to clk-scale-up-vcore-min"
- Add patch to remove clk-scale-up-vcore-min entirely, describing the
  process for bringing it back (in a different form) in the commit
  message.
- Link to v5: https://lore.kernel.org/r/20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com

Changes in v5:
- Drop "scsi: ufs: mediatek: Make scale_us in setup_clk_gating const" as
  someone else already got a patch in for this into next.
- Make mtk_init_boost_crypt void
- Don't disable/enable misc regulators during suspend/resume, but enable
  them once when acquiring with a devm helper.
- Link to v4: https://lore.kernel.org/r/20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com

Changes in v4:
- bindings: Redo the supply situation, as the avdd pins don't describe
  the vcc(q2) card supplies.
- bindings: format clock in mt8196 example more tersely.
- phy: use devm_reset_control_get_optional_exclusive directly
- driver: get and enable/disable the aforementioned avdd supplies.
- Link to v3: https://lore.kernel.org/r/20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com

Changes in v3:
- Split mediatek,ufs bindings change into two patches, one for
  completing the existing binding, one for the MT8196
- Add over a dozen driver cleanup patches
- Add explicit support for the MT8196 compatible to the driver
- Note: next-20251023, on which I based this, currently has a broken
  build due to an unrelated OPP core change that was merged with no
  build testing. I can't use next-20251022 either, as that lacks the
  recent mediatek UFS changes. It is what it is.
- Link to v2: https://lore.kernel.org/r/20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com

Changes in v2:
- Reorder define in mtk_sip_svc.h
- Use bulk reset APIs in UFS host driver
- Link to v1: https://lore.kernel.org/r/20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com

---
Louis-Alexis Eyraud (3):
      arm64: dts: mediatek: mt8195: Align ufshci node to dt-bindings changes
      arm64: dts: mediatek: mt8395-genio-1200-evk-ufs: Complete UFS power supplies
      arm64: dts: mediatek: mt8395-radxa-nio-12l: Complete UFS power supplies

Nicolas Frattaroli (23):
      dt-bindings: phy: Add mediatek,mt8196-ufsphy variant
      dt-bindings: ufs: mediatek,ufs: Complete the binding
      dt-bindings: ufs: mediatek,ufs: Add mt8196 variant
      scsi: ufs: mediatek: Move MTK_SIP_UFS_CONTROL to mtk_sip_svc.h
      phy: mediatek: ufs: Add support for resets
      scsi: ufs: mediatek: Rework resets
      scsi: ufs: mediatek: Rework 0.9V regulator
      scsi: ufs: mediatek: Rework init function
      scsi: ufs: mediatek: Rework the crypt-boost stuff
      scsi: ufs: mediatek: Handle misc host voltage regulators
      scsi: ufs: mediatek: Remove undocumented downstream reset cruft
      scsi: ufs: mediatek: Remove vendor kernel quirks cruft
      scsi: ufs: mediatek: Use the common PHY framework
      scsi: ufs: mediatek: Remove mediatek,ufs-broken-rtc property
      scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale error paths
      scsi: ufs: mediatek: Clean up logging prints
      scsi: ufs: mediatek: Rework ufs_mtk_wait_idle_state
      scsi: ufs: mediatek: Don't acquire dvfsrc-vcore twice
      scsi: ufs: mediatek: Rework hardware version reading
      scsi: ufs: mediatek: Back up idle timer in per-instance struct
      scsi: ufs: mediatek: Remove ret local from link_startup_notify
      scsi: ufs: mediatek: Remove undocumented "clk-scale-up-vcore-min"
      scsi: ufs: mediatek: Add MT8196 compatible, update copyright

 .../devicetree/bindings/phy/mediatek,ufs-phy.yaml  |  16 +
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 160 +++-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |  21 +-
 .../dts/mediatek/mt8395-genio-1200-evk-ufs.dts     |   3 +
 .../boot/dts/mediatek/mt8395-radxa-nio-12l.dts     |   3 +
 drivers/phy/mediatek/phy-mtk-ufs.c                 |  71 ++
 drivers/ufs/host/ufs-mediatek-sip.h                |   9 -
 drivers/ufs/host/ufs-mediatek.c                    | 951 +++++++++------------
 drivers/ufs/host/ufs-mediatek.h                    |  17 +-
 include/linux/soc/mediatek/mtk_sip_svc.h           |   3 +
 10 files changed, 649 insertions(+), 605 deletions(-)
---
base-commit: 02dddaea43fc5132b95a7a9184f53f276d13e4aa
change-id: 20251014-mt8196-ufs-cec4b9a97e53

Best regards,
-- 
Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

