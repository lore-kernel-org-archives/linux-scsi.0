Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95A06F06B
	for <linux-scsi@vger.kernel.org>; Thu, 16 Oct 2025 13:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620039; cv=none; b=dA1j62PhyjJHYNDBLE5zfwOcYYXKFcPQ5ryB+/hfbpGPZMH/krXBJ0/atrGXvYtaLKZou24Vo1pdbCX+pJ7T/AC5XossqsGyVSjz0nvyUHgto48FB9mqF8a7x7gjxYiasFvr55fvYv362198tZfoTqsHiYE39IhTgL6UdtqgaMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620039; c=relaxed/simple;
	bh=cDmSIVT1Dlh27fx6Z3oaRIn2yzTs9N88S++rC7VCr0M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RTf0mTakRKbxf3vQbX1gZTdT7mKuVyiV41BUSzVRftAXMdwCSG98UCkE2XosWeI/tcNESBvU330V7HUXBOGULJDZ0K5yTDQBAfxZYNl65Uoh5EfqbfIt6zp8dVK7ULbd5fJzuJFHqzdQYYO+1OzyPvgrrto5ly+fU4Ou2AmG2MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1v9Nge-0006uW-N8; Thu, 16 Oct 2025 15:06:32 +0200
Received: from lupine.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::4e] helo=lupine)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1v9Ngb-003tYQ-0H;
	Thu, 16 Oct 2025 15:06:29 +0200
Received: from pza by lupine with local (Exim 4.98.2)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1v9Nga-000000009Lu-47nD;
	Thu, 16 Oct 2025 15:06:28 +0200
Message-ID: <410ea7ea7980b751289bd603ffab5bf3ee114084.camel@pengutronix.de>
Subject: Re: [PATCH v2 5/5] scsi: ufs: mediatek: Rework resets
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, Alim Akhtar	
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
 Assche	 <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski	 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Matthias Brugger	 <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno	
 <angelogioacchino.delregno@collabora.com>, Chunfeng Yun	
 <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, Kishon Vijay
 Abraham I <kishon@kernel.org>, Peter Wang <peter.wang@mediatek.com>,
 Stanley Jhu <chu.stanley@gmail.com>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
	kernel@collabora.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, 	linux-mediatek@lists.infradead.org,
 linux-phy@lists.infradead.org
Date: Thu, 16 Oct 2025 15:06:28 +0200
In-Reply-To: <20251016-mt8196-ufs-v2-5-c373834c4e7a@collabora.com>
References: <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
	 <20251016-mt8196-ufs-v2-5-c373834c4e7a@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org

On Do, 2025-10-16 at 14:06 +0200, Nicolas Frattaroli wrote:
> Rework the reset control getting in the driver's probe function to use
> the bulk reset APIs. Use the optional variant instead of defaulting to
> NULL if the resets fail, so that absent resets can be distinguished from
> erroneous resets.
>=20
> Also move all remnants of the MPHY reset ever having lived in this
> driver.
>=20
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collab=
ora.com>
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
