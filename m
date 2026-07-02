Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F9F3603E9;
	Thu,  2 Jul 2026 06:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782974636; cv=none; b=JtDsBtpjfPxedQjFLg5QEr9Af9wnFGRTEv++kizt68947zFiqOCSAeY2UVcofTIVC26wcdWoZulmOc1FlWGw7LdmVHTiq8qBOqSoumrzXDmwTZ/RRrsRmy9iZP3+/tNVc7vxV6+I39JBLbgBQwayPzcSnz/gyqNn9KQDUmmKcoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782974636; c=relaxed/simple;
	bh=jbiXXWO91xpknoBcNaoYdvobQE3/ap5+IbERO9xDGwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8DJScBQW3aiUjZC+rduZYPB0OICr+iFMBSK9l7StuSosCFV6z0YPXvtuB8Oo4ympF45GOQij0ydG+lK70H9Jx3s/Ag/w59SbxwRNttFqCkIdSOSDf4zo2bx0pcy879lP7+a902OBWpDIugmySMEkrTj4lMpieh879pnDjL+mBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+C2RKSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+C2RKSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB4D1F000E9;
	Thu,  2 Jul 2026 06:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782974634;
	bh=xHod700iCZs8t7uaptZVm2V+mjlTB8ZYBkAisHNG+QI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J+C2RKSk6UTrBSyykc/g2zq6TEAI2I/gPCOoKhCZpAdt2OfVN9WVlKmTZeQ6DDMpk
	 mls0+eXYZ48i7Ph8MLGmXCJDz2FkpR7HdCq/Go46Xtg4YsoGg+97gs+dn0U5M2Ye+I
	 EC69g1xpT7ROS9hFiO2zH9csZUThU/tm7+PrdVvzKkJe4rIeoDCY4jd6VvkDlHfyFA
	 0dcuX4kpqOyDzrgYi6PqtmIZybbyc6O/Y33dqGLNzJbMgUpyb+iyPzToJI6PWWsDui
	 019IJEr4ykJdq2A3nMFyx7X5nsntcCHX60Gyd5zoFrUYQ1yFb6g62argS/ZtlesCoz
	 5GkxmUdyETZZA==
Date: Thu, 2 Jul 2026 06:43:52 +0000
From: Yixun Lan <dlan@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: robh@kernel.org, devicetree@vger.kernel.org, conor+dt@kernel.org,
	linux-scsi@vger.kernel.org, spacemit@lists.linux.dev
Subject: Re: [PATCH 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS controller
 for K3 SoC
Message-ID: <20260702064352-GKA35811@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-1-1a64a3ab128f@kernel.org>
 <20260702023817.AC27A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260702023817.AC27A1F000E9@smtp.kernel.org>

hi sashiko,

On 02:38 Thu 02 Jul     , sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Low] The example device tree node is missing the required `interrupts` property, causing schema validation (`dt_binding_check`) to fail.
> - [Low] The `freq-table-hz` property in the example uses an invalid flat array syntax for a matrix property and relies on a deprecated binding.
> --
> 
> commit 1206e23c10bdd35379971f48c29e246d5b43200d
> Author: Yixun Lan <dlan@kernel.org>
> 
> scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC
> 
> Document the compatible for UFS (Universal Flash Storage) Host Controller
> which found in SpacemiT K3 SoC chip. This adds the YAML schema defining 
> features like MIPI UniPro v1.61 and M-PHY v3.0 compliance.
> 
> > diff --git a/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
> > new file mode 100644
> > index 0000000000000..e6cb6fb2496c8
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
> 
> [ ... ]
> 
> > +examples:
> > +  - |
> > +    #include <dt-bindings/clock/spacemit,k3-clocks.h>
> > +    #include <dt-bindings/reset/spacemit,k3-resets.h>
> > +    ufs@c0e00000 {
> > +        compatible = "spacemit,k3-ufshc";
> > +        reg = <0xc0e00000 0x40000>;
> 
> [Severity: Low]
> Does this example node miss the interrupts property? The included
> ufs-common.yaml schema requires an interrupts property, which might cause
> make dt_binding_check to fail validation here.
> 
right, I got this warning during dts checking, but messed up in final commit,
I will fix it in next version

> > +        clocks = <&syscon_apmu CLK_APMU_UFS_ACLK>,
> > +        <&syscon_apmu CLK_APMU_UFS_REFCLK>;
> > +        clock-names = "aclk", "ref_clk";
> > +        resets = <&syscon_apmu RESET_APMU_UFS_ACLK>;
> > +        freq-table-hz = <491520000 491520000 19200000 19200000>;
> 
> [Severity: Low]
> Is this the correct formatting for freq-table-hz? This property expects a
> multi-dimensional array, so writing it as a flat array (rather than
> <A B>, <C D>) will likely cause dt-schema validation to fail.
> 
right, should be multi-dimensional array

> Also, does this introduce a deprecated property to a new binding?
> 
seems prefer to use operating-points-v2 as new way, I will check it..

-- 
Yixun Lan (dlan)
