Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627731EB48;
	Mon, 15 Apr 2024 07:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713167660; cv=none; b=YSheOdotsMxWGs9VocXUPld8c675Jf0sacoWcaY/ALKOaQ9rcBVs7v98k4gKkDO6nKI16UJBhWleUQSGdh0Ym4dAaBOhGflJzPaJKasq4ZhOq4E/pE6bS8XZWLzohg5shXGuko1Ieah0w0soQXHF4kQAMQ3XG5Gj4CGhRSAdezM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713167660; c=relaxed/simple;
	bh=vl5BpkbTStY55bvHTyQ3BacPHOvSGMwq87YZ8SJnIzg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LENfowVjuHx+0Eewpu9ANGrl9GaVff66zgxOkqVmQMCWLA2ecuCV2TG2lemd6usP7ZUQuF2liuXzK/jGmUsrRg+yim9Px9pOi1a8qLwztWl9zzXVONOvkMbz6CmLH9eqvcTdJdVJyR/4/hMR8sW1fR0eB3Z/ehhEKzqd5OjBGpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=g9/UszsZ; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="g9/UszsZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1713167652;
	bh=vl5BpkbTStY55bvHTyQ3BacPHOvSGMwq87YZ8SJnIzg=;
	h=From:To:Cc:Subject:Date:From;
	b=g9/UszsZSXZ7DApaQAOHTtwn9Xm+hPngJMc6TQcmevXbTBCusw5FDfTt+dqbe/zDP
	 yxe6GdOPwJ28a0LsFy2sC+9e+JH/ujUSixVYyr93/jpr+u+V+pP2QfCbF7Nqu7i2PM
	 vD0rU3Zui6X7HzBz+/GQq20U0Btg/5DIAVwok/TGmaNPwl+oWG1j4b/eI1V+X4Hk6B
	 SnOMXVqE6AVk0/xcpqqNS9Ekib7sqPnnGuBHD7pgOB33HVNv3UfyriKU/CmaPlfM8r
	 DK11VevgjQG6IK9lB7pPrLX9IapHRapNjIlYcttx/6ast077U2RZR/U9LPYuo96vmD
	 6E9Wmnfxc0ivw==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id ADA1C3780894;
	Mon, 15 Apr 2024 07:54:10 +0000 (UTC)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: linux-scsi@vger.kernel.org
Cc: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	peter.wang@mediatek.com,
	chu.stanley@gmail.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	stanley.chu@mediatek.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/8] MediaTek UFS fixes and cleanups - Part 1
Date: Mon, 15 Apr 2024 09:53:58 +0200
Message-ID: <20240415075406.47543-1-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

 .../devicetree/bindings/ufs/mediatek,ufs.yaml | 25 ++++-
 drivers/ufs/host/ufs-mediatek.c               | 91 +++++++++++--------
 2 files changed, 76 insertions(+), 40 deletions(-)

-- 
2.44.0

