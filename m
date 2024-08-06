Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8263A165F13;
	Tue,  6 Aug 2024 08:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722933967; cv=none; b=DZCKxZpqAqldHK26HtEf5kmfHtRzjcsK6A2KTuKHVKyEZvi1/oM4n88Yq9i2yvz1GcqvwB9AbKve3zbaJwh3f9xtkGMqkEQDMGPiZAFnOA2jv8OfLvt7dezFus5G/Sxxs8yX6eSh38eU6RYM6hylTy/gOSt3EUtcyb3lBpGPjzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722933967; c=relaxed/simple;
	bh=KpLTqIRYw/63BYWYgOmRb37YZpVOAPEAm9TncfHtMF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CASqcOgwnU5IXb4E2DyVEtXnhaIt1wlZGuX8Wgjqw1TJT7W+jDQmfCzZrxrOSgpsW68EMsVgDuHURUuXl/mIMR5UC37HaKAqSEm/ovNQBfGdqgLe3Vcqh+3eqeje5Gnr4+1GzUTFmmOzupcAel+YB1+S902ewHQ1chKeKaz1rCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTdsG3Kh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTdsG3Kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2B8C32786;
	Tue,  6 Aug 2024 08:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722933967;
	bh=KpLTqIRYw/63BYWYgOmRb37YZpVOAPEAm9TncfHtMF8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uTdsG3KhtpYGIl4vOSzLj4NfhtDlzxlVRR/IlCbLMJKFfjowBCt9+NDJ+EwjJIWjg
	 ERPUO8lWwrtKn0JWd3yZJ1/vnV/hmsYx/6ClPnq2pDUZYulm+09P0O657v0IRTkAhg
	 GuGWSl9epOl/BvtDo6BvvpVo/dZ3Q+Kg6M/7ca2MDmli3EltyyfN34Ejk2T40Rf3Rw
	 xAWrCwj0QALmj4r2N2hxDisxGqz09oHo5OB5hg2l0RylOqaoVnPpW0hTPbULY6sKh2
	 pi4CBVtT+VspKWBCgw07zRMi4E6yGZAcAc0Qyi5W7s2oe8do725/CViJk89D1aLZTT
	 t4CpfbLNZ8BnQ==
Message-ID: <ec191693-9ab2-46ad-9d4b-36eb2f2ebff1@kernel.org>
Date: Tue, 6 Aug 2024 10:46:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] dt-bindings: ufs: Document Rockchip UFS host
 controller
To: Shawn Lin <shawn.lin@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
 linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
 devicetree@vger.kernel.org
References: <1722928800-137042-1-git-send-email-shawn.lin@rock-chips.com>
 <1722928800-137042-3-git-send-email-shawn.lin@rock-chips.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <1722928800-137042-3-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/08/2024 09:19, Shawn Lin wrote:
> Document Rockchip UFS host controller for RK3576 SoC.
> 

<form letter>
Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC (and consider --no-git-fallback argument). It might
happen, that command when run on an older kernel, gives you outdated
entries. Therefore please be sure you base your patches on recent Linux
kernel.

Tools like b4 or scripts/get_maintainer.pl provide you proper list of
people, so fix your workflow. Tools might also fail if you work on some
ancient tree (don't, instead use mainline) or work on fork of kernel
(don't, instead use mainline). Just use b4 and everything should be
fine, although remember about `b4 prep --auto-to-cc` if you added new
patches to the patchset.
</form letter>

Limited review follows.


> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> ---
> 
>  .../devicetree/bindings/ufs/rockchip,ufs.yaml      | 78 ++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml b/Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml
> new file mode 100644
> index 0000000..e2e492c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml

Filename as compatible.

> @@ -0,0 +1,78 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/rockchip,ufs.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Rockchip UFS Host Controller
> +
> +maintainers:
> +  - Shawn Lin <shawn.lin@rock-chips.com>
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +properties:
> +  compatible:
> +    const: rockchip,rk3576-ufs
> +
> +  reg:
> +    maxItems: 5
> +
> +  reg-names:
> +    items:
> +     - const: hci
> +     - const: mphy
> +     - const: hci_grf
> +     - const: mphy_grf
> +     - const: hci_apb
> +
> +  clocks:
> +    maxItems: 4
> +
> +  clock-names:
> +    items:
> +      - const: core
> +      - const: pclk
> +      - const: pclk_mphy
> +      - const: ref_out
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 4

List the items instead

> +
> +required:
> +  - compatible
> +  - reg

reg-names are not required? Test your DTS (where is it btw?) without
reg-names then.

> +  - clocks
> +  - clock-names
> +  - power-domains
> +  - resets
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/rockchip,rk3576-cru.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/power/rk3576-power.h>
> +
> +    ufs: ufs@2a2d0000 {
> +            compatible = "rockchip,rk3576-ufs";
> +            reg = <0x0 0x2a2d0000 0 0x10000>,

Fix indentation. See writing schema.

Use 4 spaces for example indentation
.
> +	          <0x0 0x2b040000 0 0x10000>,
> +		  <0x0 0x2601f000 0 0x1000>,
> +		  <0x0 0x2603c000 0 0x1000>,
> +		  <0x0 0x2a2e0000 0 0x10000>;
> +            reg-names = "hci", "mphy", "hci_grf", "mphy_grf", "hci_apb";
> +            clocks = <&cru ACLK_UFS_SYS>, <&cru PCLK_USB_ROOT>, <&cru PCLK_MPHY>,
> +                     <&cru CLK_REF_UFS_CLKOUT>;
> +            clock-names = "core", "pclk", "pclk_mphy", "ref_out";
> +            interrupts = <GIC_SPI 361 IRQ_TYPE_LEVEL_HIGH>;
> +            power-domains = <&power RK3576_PD_USB>;
> +            resets = <&cru SRST_A_UFS_BIU>, <&cru SRST_A_UFS_SYS>, <&cru SRST_A_UFS>,
> +	             <&cru SRST_P_UFS_GRF>;
> +            reset-names = "biu", "sys", "ufs", "grf";

Crap. This was never tested!

NAK

Best regards,
Krzysztof

