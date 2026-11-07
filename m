Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=194.117.254.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061367;
	b=hzAliOBJS6md6KtQiCGyfcueMKYtJNDNvMY58M+ebqHxMrmph27u+i8mbTxZ9AFYoatA
	 KPaXSUnzeyoNR0igj8OQ7l2raDQdqk7fI2b8gfjLzYfh+jzruGoeZ79OSgDDTXEMCc8Wg
	 AlTAkV4pWJ33pLf2aIz3T67LmGjuOHUm/RKGM7TyTfOmFQxyopoF6uR41po5BHf6fctdG
	 aiQnxyU7AAKe4IJ6GaVUH6kQn79TZ5YQp+JB5O7OXfLHJFKb7p1hawDuMeFoy4+6WP9+c
	 1cesl7vq3aEd4heSDT9hxyHvYpdFtEpmeKsJpQJA1iD09qPdW6/cmEVyJrr/x3Tnx8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061367;
	h=DMARC-Filter:DKIM-Signature:Received:Received:X-UD-Smtp-Session:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Zc76TO6qUVRGeeHVXQdMS6eOYrg3MPsFB1Ka1Yvj58U=;
	b=WX43UVJXul2Raj+fn4dcpZd7l5D+HwoUL40SMK65HsY5gyiEE/YsA+5/Sf8KGGnNnYrm
	 HbQ7LnN/GpZJ2hNOaaJ3GGKHeFkeEdI3QUiseFN9zkTXDQ3GJKjUMT45XYu2uk1KBwLkC
	 V3Czn4qCUW02FvIHMJMsA3xD+Dq4LqjWCbnAieOBf8q+7kgCHVL3SczJbnlFrPQpDsmlH
	 wlPwpmeiAKLLJNSrVASAuIkWylV92vIlEGFY5BzCT4dFmWBJpnv34aSewHUtLt3woQsYQ
	 E3ViN8MoMjgB5S/WugufbGbVM/omxtZ1JHpab8nhU5UJnId0DNOxerVFfp2wnIt2EdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sang-engineering.com;
	spf=pass smtp.mailfrom=sang-engineering.com;
	dkim=pass header.d=sang-engineering.com header.i=@sang-engineering.com header.a=rsa-sha256 header.s=k1 header.b=deMBkNlk;
	arc=none smtp.remote-ip=194.117.254.33
Received: from mail.zeus03.de (zeus03.de [194.117.254.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42A1606A332
	for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2026 14:22:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B42A1606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sang-engineering.com header.i=@sang-engineering.com header.a=rsa-sha256 header.s=k1 header.b=deMBkNlk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=k1; bh=Zc76
	TO6qUVRGeeHVXQdMS6eOYrg3MPsFB1Ka1Yvj58U=; b=deMBkNlkuoAHsHcvg+VW
	/JOGUyDVHLSNz2M2P318rSNR8ihhOn/icNfH112ofFlA9vj9/Cq1/GB2kPS93Y40
	YF/E/JzExb1+S9I1cstiBzedJlDUnUSkE30QPeWQc507bnuBni0Z3NyRW4Kbgikv
	A33vNAj4UQjDG+RAKO5HfUR7weMBMBqiqmK0raV2oPWm0SZWyc4pewIm8g0fDZne
	LkWZdfpDHRtTXcDecdPHMvKhMX5AroogrzfiJHaQZyQZEmMUS5nMy4dWe/94uyCo
	CxZZl4Q8KqM0Whbjetz1A4x1NAoLWi2ICCJyuUW9bykg7e8j4gzLaz/eOC4I3nFt
	YQ==
Received: (qmail 2530674 invoked from network); 7 Nov 2026 15:22:35 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 7 Nov 2026 15:22:35 +0100
X-UD-Smtp-Session: l3s3148p1@G1+7dbBfHLcFFu4j
Date: Sat, 7 Nov 2026 16:22:34 +0200
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: Danila Tikhonov <danila@jiaxyga.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Amit Kucheria <amitk@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Souradeep Chowdhury <quic_schowdhu@quicinc.com>,
	Lee Jones <lee@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alex Elder <elder@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Andy Gross <agross@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Robert Foss <rfoss@kernel.org>, Andi Shyti <andi.shyti@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, Taniya Das <quic_tdas@quicinc.com>,
	Sibi Sankar <quic_sibis@quicinc.com>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>,
	"Guilherme G . Piccoli" <gpiccoli@igalia.com>,
	David Wronek <david@mainlining.org>,
	Jens Reidel <adrian@mainlining.org>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-watchdog@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-phy@lists.infradead.org,
	linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org, dmaengine@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, linux-remoteproc@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-hardening@vger.kernel.org,
	linux@mainlining.org, ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: [PATCH 20/33] dt-bindings: i2c: qcom-cci: Add the SM7150
 compatible
Message-ID: <au80Kv5YDDtUW2L5@shikoro>
References: <20250422213137.80366-1-danila@jiaxyga.com>
 <20250422213137.80366-4-danila@jiaxyga.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422213137.80366-4-danila@jiaxyga.com>

On Wed, Apr 23, 2025 at 12:31:24AM +0300, Danila Tikhonov wrote:
> Add the SM7150 CCI device string compatible.
> 
> Signed-off-by: Danila Tikhonov <danila@jiaxyga.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Andi Shyti <andi.shyti@kernel.org>

Andi already acked this, so I guess qcom tree is fine.

Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

