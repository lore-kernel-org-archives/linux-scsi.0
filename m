Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0BE2F7478;
	Mon, 16 Feb 2026 13:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771249113; cv=pass; b=l64MCH1FkISlFS6nOwjAc8bH1ae/EIROXoDXJXvgtH+VaRMYCpLcw68wn09E3vMXnH6eMGIQLpkDa8YAnkZoDooLfZsaWZyP+9BcEg9FTGBxv3PXc0iTAYilDYz2wEFqtwWuf/gtMLUwnt2me5BSdeBHTb1ROinnk9lrfWFnXHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771249113; c=relaxed/simple;
	bh=RV4AUSbzZacdomDD0E/TLMTTnpfTTCwrBdg3oMB6zLY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=d4sR79yzpOJOFJogpVDSF/MGxIa/xSd//wHYkeFaYSiIJpXKcM3zIYEwQIO+U8PEFYSchjZ05bB4fUBG52VwP/VEELnaceF3oacgfq86+rnUllGlb16TD9uPNCM7Sv1u1bcTBQzuQG+pxC666jDhqfW6tLyx/7R8XYGPgPTvFPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=MOfjQjlY; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="MOfjQjlY"
ARC-Seal: i=1; a=rsa-sha256; t=1771249081; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OXYtallJF5W4UTmroweQAK1Ud2q03aTAEFfnc+eEC+vGI648zGyu9GsIiz3WlnFlIT+72dYs1HEz0qr4je8RZb8nxbb99jHqRHQN5Kq1M26/umIPVNk76+rsD0WqKEWpk7+TGaXeP4QL0qSKrzC7dvLszlEsE+Di0TdWsCS+DMo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1771249081; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=LY2Y0LxFSdMEXjuR+QnpUOadiC18LiHpPzIEebtTR0w=; 
	b=eeLoIKU3khp1lsvBaXnHoFmiyCC9pieeaSjK5FCcIilo4ZiNV5d62EtjDkUCHFkf4a0IafLUr8XyHI7aW+SDTWZHlPTZIX5tf5X87Q5KIM6c2KxUhJ090sadsbuFf+DoTd2Gu/EuYNjvdDN8j/Ln7M3/D2TiFQO14RkPyyQjg+w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1771249081;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:To:To:Cc:Cc:Reply-To;
	bh=LY2Y0LxFSdMEXjuR+QnpUOadiC18LiHpPzIEebtTR0w=;
	b=MOfjQjlYwboi+w17rSsAN3TgScO3X6hQl+AGdABVaPS8DJVX6THd8d2Gl5kfcUer
	T4wPXHbp8qYlg5uhBRahJiqX3BKKeuVKMS79ajeFEhrOAbEm5uo22h2Qds7Kt1yu1ws
	+KvYWUmYI2XFcTweuTeMBn7wpwp9RV61k0Okt9rw=
Received: by mx.zohomail.com with SMTPS id 1771249080123420.8339921382387;
	Mon, 16 Feb 2026 05:38:00 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: [PATCH v7 00/23] MediaTek UFS Cleanup and MT8196 Enablement
Date: Mon, 16 Feb 2026 14:37:33 +0100
Message-Id: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23QzUrEMBQF4FcpWRu5+W9m5XuIi/zcOoFpq0mnj
 Ax9d2MHscUuT+A7N5w7KZgTFnJq7iTjnEoahxrMU0PC2Q3vSFOsmXDgigGTtJ9aZjW9doUGDNJ
 bZw0qQSr4yNil21r2+vbIGT+vtXN6PBLvCtIw9n2aTs2At4nWXg2cCfIDzqlMY/5aPzOzVRzdn
 RkFyqyKAX0rfGhfwni5OD9m91zL16qZb7necV55EEa0QgaJxh1xseFc7LioHDqQXjpjVdcdcfn
 HOWt3XFYeIwbjhLYx8iOufrkGBnuuKpeWM8WUqfuzI643nO+n05WjCQDKawD+b7plWb4BLNauO
 BQCAAA=
X-Change-ID: 20251014-mt8196-ufs-cec4b9a97e53
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Conor Dooley <conor.dooley@microchip.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3

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
      scsi: ufs: mediatek: Rework probe function
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
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 173 +++-
 drivers/phy/mediatek/phy-mtk-ufs.c                 |  71 ++
 drivers/ufs/host/ufs-mediatek-sip.h                |   9 -
 drivers/ufs/host/ufs-mediatek.c                    | 961 +++++++++------------
 drivers/ufs/host/ufs-mediatek.h                    |  17 +-
 include/linux/soc/mediatek/mtk_sip_svc.h           |   3 +
 7 files changed, 652 insertions(+), 598 deletions(-)
---
base-commit: b6f9fd35d9481a416c75f1e9c8088bc81d24a286
change-id: 20251014-mt8196-ufs-cec4b9a97e53

Best regards,
-- 
Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

