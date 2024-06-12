Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866FC16D9CA;
	Wed, 12 Jun 2024 07:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178215; cv=none; b=usV9lDwD0IjmSiHReO5SRCNOhm6YC8+s+HF3OYtIZX4LgoLQmaxs/5Q49ofXUxME5WehH09OCjAeaXmJjP9GKt+RoIYuK7rRvJz5NbUBPPm4v7hh6Kd9p7xZAO1u6+Lh8SaIAo+Ld38h9dRF6fZf1Bc8SeaOFHKHc/muJAdPbdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178215; c=relaxed/simple;
	bh=06ggiwhMyGPpOHXWaG3DQjMS63EfxHCPMMxtiCYkegg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBHzqc/5Yka11SroBuEHndXLz531SNbGUIzqiRbHRQY0rGqkNVZcp4U/mUt0VwzI3Rks2/O1TfNY+7GpEi7JNi+aNpQz8Gsut0di9UpWX0YRirYQoI3Ki+Qj8ZgCvDk9osCpZlCFJPjHRZyfCVvGVoHc3BB8VjTP+HE8ra4+vug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=MzKAVqVw; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="MzKAVqVw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1718178213;
	bh=06ggiwhMyGPpOHXWaG3DQjMS63EfxHCPMMxtiCYkegg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzKAVqVwijk6mkNDVISGI0yOnt+0W/Gauxmgj64UBq12mPbsLQrt2lKDe+eey6KAF
	 4UZBr1kAdNv2VItZowPljl2vf3G8WxVZ3N1jFB3LZG/a2Dz0jS1c8kEcgDn00wDm6x
	 /TU9l1hinejjFoYGockEY7byW1MLeKsPFJxltG5y5lJKdiqbyp7Qkg6sy0WU8/arjF
	 6FknBeVwH+/5s2FInK9Qe+80nTOJbk3RPwR4fLkOSkuZtr9sRcX0AY639NgAVdmZxs
	 lfymeH25kLKEDoL6hlOl+2+3k0G51Ph3rydvNHFtuF2TwZXVfx2oKkPWATWFlxVIUZ
	 8wWlbiWeoK3Xw==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id EBF2F37821A3;
	Wed, 12 Jun 2024 07:43:31 +0000 (UTC)
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
	michael@walle.cc,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v5 8/8] dt-bindings: ufs: mediatek,ufs: Document optional dvfsrc/va09 regulators
Date: Wed, 12 Jun 2024 09:43:09 +0200
Message-ID: <20240612074309.50278-9-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
References: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the optional dvfsrc-vcore and va09 regulators used for,
respectively, crypt boost and internal MPHY power management in
when powering on/off the (external) MediaTek UFS PHY.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 1df8779ee902..b74a2464196d 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -48,6 +48,8 @@ properties:
   reg:
     maxItems: 1
 
+  dvfsrc-vcore-supply: true
+  va09-supply: true
   vcc-supply: true
 
 required:
-- 
2.45.2

