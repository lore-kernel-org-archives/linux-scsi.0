Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507D7448D0E;
	Mon, 14 Sep 2026 12:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387344; cv=none; b=e9M/frUK2aerrvpMwQesqbfKt876rbqFm8y2HlyejwHzg6rPsFiUz1xYmmpSpU6mgeD7kJoHLHMNL2jHgwUh7vRWhQrGUlSfVzDDh6AT8qE0R9LPExKE7Gj30INqgSbLtVV1Gh7MBeR7DH+DGzb8bZMLRCMvGSIo349LPSfumnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387344; c=relaxed/simple;
	bh=nrwqPCZkQIimnka60MFra6BC5Jik31pbN2PY4QrlaYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=brAl/O1nmqJ7XZA5g8YOG8jr49lN1uyORv9ZsVOVCeVtFggJpiZTMioYtQ3UUMyx8KeoVHMdr8nW09xyq19oVutYcsp4EkeNgihJt32EJOMaIAEE7kXIl408eO6YZ3/lBDSDeWeLpjo7OR3fJZhNnVzPEyCYZ2mdIIPgySkDR6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=h5KI1TJ/; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="h5KI1TJ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1789387338;
	bh=nrwqPCZkQIimnka60MFra6BC5Jik31pbN2PY4QrlaYo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h5KI1TJ/E/gcDBfB4bNFcKVP9n8rcAPff+fNsd457fjS+8MhM3chYQW3ynEEhuBva
	 bsZS0djpQLU/cus5BHLBN8hYMyewO77dkBWzGHQtSqdP2iumHZLK0w/dQgtR+35mC6
	 D0+Y1QJJ1HKxDDyFN84rqiIb47XJUCisltvqUGvvNsDiD0rhOnietbTSig7ULNzmRn
	 yKMI8o5YbKuG1GDq8sEfasXOgSAgHrV/qQshWPRiFTQjbuD9YNIp9f/de8rTVdQW6K
	 9cLXKzLNSSmMXUaY1S3pEd7Lh0mUMxT83tC/u7JaOywePC3gRDj0MK3Sa//PHL4Jls
	 YlFva8qS8akZw==
Received: from [100.64.1.21] (unknown [100.64.1.21])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E959E17E0074;
	Mon, 14 Sep 2026 14:02:16 +0200 (CEST)
Message-ID: <ca3ec44c-710b-4812-9d22-c70003a136d3@collabora.com>
Date: Mon, 14 Sep 2026 14:02:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/24] scsi: ufs: mediatek: Add dual 0.9V supply
 support
To: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
 Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Chaotian Jing <chaotian.jing@mediatek.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>,
 Mark Brown <broonie@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-8-9279d7ef814d@collabora.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20260914-mt8196-ufs-v12-8-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/26 13:38, Louis-Alexis Eyraud wrote:
> The MT8196 SoC has an additional pin in comparison of the MT8183 SoC,
> that is used to feed the host controller with a 0.9V supply.
> 
> In preparation of this SoC support, add in platform data and
> driver the management a second optional 0.9V regulator named
> "avdd09-1".
> 
> Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>


Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

