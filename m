Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1FD39FCAF;
	Sat, 23 May 2026 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779545684; cv=none; b=XefV4RstgPD9TXeFVAU2g8EcX2KSSXulDTDLH3M66bb8KokM/0p9QsowBRBtSVcLonKydRuRyQq12WpYQFq4XDwbLZ7eOOnZg8mrkhxWxQbTkcObw1Y5TRceXVFWGRzgNS63K9J7+/4+FN4UCcIcKjHeoeezGJ9DGdyLT89Zdnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779545684; c=relaxed/simple;
	bh=Y4jcun+ro1rgWcs1fAzBJ0gx8tgAoHvL8X4LwGRmMrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfFVcqKGeWMWvRF2CwdTavxvTLfp1xpQzk+ICCgipdFWKoA9NqAe6fBB6RTS48TEW+v6juRln7hngEAjZiG3s6XeFrRcHSM6Jdq02DkVPheGFzm4nMV2V1VJT8TXU185PtCa83glKt9sMp4GjqU40eahb3A+VTrM/z2NGTFq6rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnhkl5dX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnhkl5dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5CD1F00A3A;
	Sat, 23 May 2026 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779545683;
	bh=bbeAZ/pWJi2Q6lOIbC6mtCkYgBo9dqxuAIJI4cU4wvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gnhkl5dXp8hrDPFOVyvJgET9Jv7RIEArTtEwqRg3RSnw9RBJ69xbCbYysDcQYkY5k
	 i1aCbIGR54d4Qh+rvZmjDS8MZlLXnFpokjHL5naPuf/IqkUSDA85AWkEWeq7Fod/jz
	 CshxXuap5kiO/ecVVF84xJgvVBPY0HLodbIdNB7C0qpmhK1oveXAb+AblWqaLd04la
	 H5OVtppX3SCqZgm0l7jwOPmuIQkaVtOGdNjK0Y92tm4WbsPrjjEe84SbrxYXvmuLd1
	 f6r9ht1l/X2CVWkpXgZ8V1bJonX5ljgbG1TsSAnhM4Hp2TiWKwB5w2ZZ/3oTfMFiD7
	 eHzS+jEFBPdmA==
Date: Sat, 23 May 2026 19:44:34 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, Zhaoming Luo <zhml@posteo.com>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
Message-ID: <m6qq3kxgfs73jve2pjmmszymgxb7aizdfo2rwg72o66n2rvov2@xkcvifciwu3z>
References: <20260523134711.323425-1-can.guo@oss.qualcomm.com>
 <20260523134711.323425-2-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260523134711.323425-2-can.guo@oss.qualcomm.com>

On Sat, May 23, 2026 at 06:47:10AM -0700, Can Guo wrote:
> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
> Speed Gears (not only HS-G6) to compensate channel loss and improve signal
> integrity at high speed operation.
> 
> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
> required depending on channel characteristics.
> 
> Add vendor-neutral DT patternProperties:
> txeq-settings-g[1-6]
> 
> Each property is a uint32 array of per-lane tuples:
> (PreShoot, DeEmphasis, PrecodeEn)
> 

I don't think combining all EQ settings (PreShoot, DeEmphasis, PrecodeEn) in a
single property as opaque tuples is the right approach. These are three
semantically distinct parameters with independent value ranges. So packing
them into a uint32 array makes validation impossible in the schema.

AFACIS, PrecodeEn is applicable only to HS-G6 (PAM4), but the proposed
patternProperties forces it into G1-G5 tuples as well, which is semantically
wrong.

PCIe binding defines one property per data rate for EQ presets:
https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/pci/pci-bus-common.yaml#L193

Similarly, UFS should define one property per gear per (like, txeq-preshoot-g6,
txeq-deemphasis-g6, txeq-precode-enable-g6,...) rather than clubbing everything
into opaque tuples.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
