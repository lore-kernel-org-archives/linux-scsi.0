Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C7C40878;
	Mon, 15 Apr 2024 07:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713167667; cv=none; b=SUJ2oQC73bpLA/U+dOqaufGWhNA1EazGgYEW7oot9+gQxDzea5631XylZVz6dRmiWCsm/ii/1GSKQi4s+EX/sni1l3vyfCQvnnNqyqL26eaJqSfqUpIRQB6tAgy8JWTPhwWT9U+ivcZQ1XfmTUl6t5U99B6UJJdG7093zEk2fxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713167667; c=relaxed/simple;
	bh=5eT0zUq3U+SGJ+MJi1xud1dyzwBZgkKn46DTagnuY4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IP/DCfQWArs1hu0TWSNcmvWGR+NtiAXb+m13dPgKHlEdPQfDIR35nkNTkepqX1HQ0h9/tkUHIdJWv95P3z75IFZ11GEiVX20iqn4yvj+A6j00u0vc5N2ThiiijW6CF+ZMuxX8c1rmLh1mPNIwa8TFw+NRimFbO4y9Z8yzT0oyEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=iNll0TlQ; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="iNll0TlQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1713167665;
	bh=5eT0zUq3U+SGJ+MJi1xud1dyzwBZgkKn46DTagnuY4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNll0TlQEai9STsdsIjH3jAfNSi/LWw/2Tb3JlH35RkK7xXcyQfJRYkVz0c2QhmNz
	 BT9C9h9ubcNMdb8NWIFxmJOXMLkFAIPmUcx7CGDjIkmbhIWimCNRb4jPvCf+UV1nNT
	 9Tyge49KrRF4D27JtDWex9ODovC1pe66QYJLnbvQTk4FyJweSqnEeU7/OYFxZsdGij
	 vO76b+Nm0kGfuyalCzhdqagq4VtU5KT8MJXAS5SPiq0ewUp22qxD0JNDzeqrh0WrTM
	 y+itOn2olBw8XYuJk2KNGzailryevuW/rUM69Uo96/AMEoqrjwMNG1DHFktusxZK7g
	 LNwY87bv33O5A==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 8A553378213F;
	Mon, 15 Apr 2024 07:54:23 +0000 (UTC)
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
	linux-arm-kernel@lists.infradead.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v3 8/8] dt-bindings: ufs: mediatek,ufs: Document optional dvfsrc/va09 regulators
Date: Mon, 15 Apr 2024 09:54:06 +0200
Message-ID: <20240415075406.47543-9-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415075406.47543-1-angelogioacchino.delregno@collabora.com>
References: <20240415075406.47543-1-angelogioacchino.delregno@collabora.com>
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
index 4df2358d440e..4d42c44da061 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -46,6 +46,8 @@ properties:
   reg:
     maxItems: 1
 
+  dvfsrc-vcore-supply: true
+  va09-supply: true
   vcc-supply: true
 
 required:
-- 
2.44.0

