Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4458F538D9C;
	Wed,  9 Sep 2026 10:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951118; cv=none; b=EkRAjZHGw9Nf8vQmwzUBUMBtXu5SZrDjODBnr7/QwfPl9UF74iBRAx5IZUza+CoCw6JEHMVi/AIKtTayOtducjhTeC5gQaHIICJOz5UokTG2wcm6yf+abXAcAuJ6v4OAFxJGZtGuX/8N32OfFs355MtGWkictlUPlsmW/ZC6V5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951118; c=relaxed/simple;
	bh=O5aEjeP6+N1vmjtCN8p9yV0kFG/3PsWAxzQplwnTeTc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K3A68iUomX1SG22p6XZ8ZZR3/2QkuX+50A400qgGIx0J6hyHv2JAZwp94PE5u5XzJgZ2GCsnNK6nKcN6DVMEgDo3tfLbc+tYwRALjhlOPv67ZCUcVelY/IInDSn5oj3JsKJs7Ei6jt+F5CbVu9Etap2a/1qnpKhHrLVGr2Y6bls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hshVw/eh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hshVw/eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C887E1F00A3A;
	Wed,  9 Sep 2026 10:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788951117;
	bh=49Rww/NA2EYBDzkIYwY+WurZsZWCy0wU6YfV/fULoNY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hshVw/ehGrYzBv3+rS+Ifwck/3ddfqKi7mVfciv/lefnh23uG33kngkqbNP+3219y
	 sAZ3ShVV0XMgXQEp2hi43I+fyWR8QxFVbrANnKmfjAhSE0GMZms731l4ZvDEcuv2S1
	 ZA2GB6EDwIgDi4Qfb9o01dw+5x7hnj9dhhieebBm7C1yt9ELIF62Q7hKz7snlIwVgm
	 eMdlPIxbET35zGcRpV3r4tDAnbh5O7IsHLrTFW9tgjWMRs22/6IXBlVqZEFv/IiZjC
	 EOS5I9j1d+U9Bn4P/ntmNs8Q1UitPT77ASSuFXvzk/pjcQFU12/OxeJ6tUozdo393B
	 mBc+yCmADLB1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] dt-bindings: ufs: Add nvidia,tegra264-ufs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kartik Rajput" <kkartik@nvidia.com>
Cc: devicetree@vger.kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org
In-Reply-To: <20260909-tegra264-ufs-v1-1-e4a9831702a0@nvidia.com>
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
 <20260909-tegra264-ufs-v1-1-e4a9831702a0@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 10:51:56 +0000
Message-Id: <20260909105156.C887E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing dependency on header file in DT binding example causes dt_b=
inding_check to fail.
--

commit 3569ef54ab3548dc631c5780b8e85a8fb366de60
Author: Kartik Rajput <kkartik@nvidia.com>

dt-bindings: ufs: Add nvidia,tegra264-ufs

This commit adds the device tree binding for the UFS host controller on
NVIDIA Tegra264 SoCs. The controller supports UFS 3.1 up to HS-G4B on two
data lanes.

> diff --git a/Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.ya=
ml b/Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.yaml
> new file mode 100644
> index 0000000000000..5a9837cb43dd3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.yaml

[ ... ]

> +examples:
> +  - |
> +    #include <dt-bindings/clock/nvidia,tegra264.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/phy/nvidia,tegra264-mphy.h>

[Severity: Low]
Does this missing header dependency cause a build failure?

The YAML example includes <dt-bindings/phy/nvidia,tegra264-mphy.h> here in
Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.yaml, which does
not exist in the source tree and is not added by this patch series.

When running make dt_binding_check, this will cause the tool to fail
with a preprocessor error due to the missing header.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-tegra264-u=
fs-v1-0-e4a9831702a0@nvidia.com?part=3D1
