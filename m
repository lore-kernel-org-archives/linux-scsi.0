Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AE6B651;
	Wed, 12 Jun 2024 07:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178205; cv=none; b=uWyxHgSdRPGrE1VWm8UF9CskdpWu+iuTny7eze094W8JyXligguIOeWTRzP9Kcekiz+TcxDjQDMdnsXNDX7ilQoBM/PYnF/4LOZs2PSiKmWpj2vKYJu7KIQCeQyCXqtvIc1IiotGpNoMIskqijP+jWTPlNx2aR+lYdr8osfCcEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178205; c=relaxed/simple;
	bh=QHmdx0T93KlMa0bAVjuFjeI5sMM5BrBaWcIHBFNDdIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ky/l/GOKTRW3U5//9wtQeUqKmsh3b/HGGAbS3wLoVJ7z8osSO8uDiFYEz9kfdZcOIKmVdR50y343/H5XNhUmaGnDaV1eqpteRGsrDPV4sQnmX1B+7JkW7HYBj1cH1irTK9a819XvtiDV4sS/Kuqzt2DJJEAHDaFrZPw3T3TTmNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=cABS5A2D; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="cABS5A2D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1718178202;
	bh=QHmdx0T93KlMa0bAVjuFjeI5sMM5BrBaWcIHBFNDdIU=;
	h=From:To:Cc:Subject:Date:From;
	b=cABS5A2D46NNjU2XYkoKIpIpxaFkbqZ5J6LFiXJfNs/7wCEz0umyq0B4HpOooDbAL
	 o79Ojstduxq2Ht+OQvLdrD3xg9XDNrkj14ny/VnSFT6xyhRhwQuyksxi2Tuy3AMQx7
	 q7/jJdrDjIUJS0rdBYGIToWN1cNXK4kbnloRGN3Y4NQ8FBkO4Rhib6VjGpAZ7tr6Nl
	 E/oITx2EqXOWtLO9w5GkN19L9L992pQ6Ogx2O2q25Sc7HZkSlX70PHaWuxJkYrz+eQ
	 mGNTy0zI+9CcZoHVWH+PEclJ76pTaHglvT+dunJOpPkEEbDOiTiLBIbt9h8inBtHso
	 5PLYwAmAjyThQ==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id E6A253781188;
	Wed, 12 Jun 2024 07:43:20 +0000 (UTC)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: linux-scsi@vger.kernel.org
Cc: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	peter.wang@mediatek.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	wenst@chromium.org,
	michael@walle.cc
Subject: [PATCH v5 0/8] MediaTek UFS fixes and cleanups - Part 1
Date: Wed, 12 Jun 2024 09:43:01 +0200
Message-ID: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in v5:
 - Rebased on next-20240612
 - Tested again on MT8195 and MT8395

Changes in v4:
 - Replaced Stanley Chu with myself in maintainers as his email is gone
 - Fixed commit [5/8]

Changes in v3:
 - Disallowed mt8192 compatible in isolation
 - Added maxItems to clocks

Changes in v2:
 - Rebased over next-20240409 (because of merge issue for patch 1)
 - Added ufs: prefix to patch 1
 - Added forgotten ufs-rx-symbol clock to the binding


This series performs some fixes and cleanups for the MediaTek UFSHCI
controller driver.

In particular, while adding the MT8195 compatible to the mediatek,ufs
binding, I noticed that it was allowing just one clock, completely
ignoring the optional ones, including the crypt-xxx clocks, all of
the optional regulators, and other properties.

Between all the other properties, two are completely useless, as they
are there just to activate features that, on SoCs that don't support
these, won't anyway be activated because of missing clocks or missing
regulators, or missing other properties;
as for the other vendor-specific properties, like ufs-disable-ah8,
ufs-broken-vcc, ufs-pmc-via-fastauto, since the current merge window
is closing, I didn't do extensive research so I've left them in place
but didn't add them to the devicetree binding yet.

The plan is to check those later and eventually give them a removal
treatment, or add them to the bindings in a part two series.

For now, at least, this is already a big improvement.

P.S.: The only SoC having UFSHCI upstream is MT8183, which only has
just one clock, and *nothing else* uses properties, clocks, etc that
were renamed in this cleanup.

Cheers!

AngeloGioacchino Del Regno (8):
  scsi: ufs: ufs-mediatek: Remove useless mediatek,ufs-support-va09
    property
  scsi: ufs: ufs-mediatek: Fix property name for crypt boost voltage
  scsi: ufs: ufs-mediatek: Remove useless mediatek,ufs-boost-crypt
    property
  scsi: ufs: ufs-mediatek: Avoid underscores in crypt clock names
  dt-bindings: ufs: mediatek,ufs: Document MT8192 compatible with MT8183
  dt-bindings: ufs: mediatek,ufs: Document MT8195 compatible
  dt-bindings: ufs: mediatek,ufs: Document additional clocks
  dt-bindings: ufs: mediatek,ufs: Document optional dvfsrc/va09
    regulators

 .../devicetree/bindings/ufs/mediatek,ufs.yaml | 29 +++++-
 drivers/ufs/host/ufs-mediatek.c               | 91 +++++++++++--------
 2 files changed, 79 insertions(+), 41 deletions(-)

-- 
2.45.2

