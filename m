Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0A984A51;
	Thu,  8 Aug 2024 09:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723109443; cv=none; b=W0o550ihIorHXi5MOhgChLMDKu2QzSrqQQCtejmn01064OB8a2fWARG3GgljzemHqdRRKzkXo2iGTDdNmdgxWV7m6HRSgCkOt9Ibak1raGVWnVu3ojtRFsFhAv05s4t09ThliILGdYdli2sDorofx54rFMw9vnQ3gqRpy/nTeso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723109443; c=relaxed/simple;
	bh=G4jqWjKXWHk4kttjM43AnfkpIVmWHXiSnrUxnTSR72M=;
	h=Date:Content-Type:MIME-Version:From:To:Cc:In-Reply-To:References:
	 Message-Id:Subject; b=WS5Ql452qHaEfhe+4Jncw6fzO0ps73DuV5HAniXlnkEFLTd1M8G/FWZYvojr1USQlPEaiL+4DDjzaDVHcBGhPAZWKrCtmCeFJgMbIK7qKyg8aLACC0QpJOoxmuqlMrsF5HdQkJDFOOT1uwToP4PlIXB8979Co/iXDVtS7K4ciD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bC6S4FbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bC6S4FbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D775FC32782;
	Thu,  8 Aug 2024 09:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723109443;
	bh=G4jqWjKXWHk4kttjM43AnfkpIVmWHXiSnrUxnTSR72M=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=bC6S4FbNoqFD96hW1e0UEsT3oKHIETkWZAaOTZ2ip0pokEGcggLkyYWP0K/JG0ZY7
	 scSTgO0Xbp+YfUCNI4Lk0ORzjDwIs/q4NZ9jUMLeZNR6xtIYlmc5eie3swLndJPpB6
	 Yo9T7NuuyaEHyi7DCfYSOziJyWKdijvVXyJq9xwaECF/0c3XeNof9zYM5vbY17f1TP
	 hyxzRz/fid373mAISZje/6+tVMBEdfDe5fvqE+PtQVeZstDRTFyYx+VuPx90fOhdQY
	 YZF5PSyhJHuy8rKjY6MOo0/xYkun84YDOzRfVTTjV2KRb8sfFKOtM+f3NuOetEFeKl
	 2U0yEyBnukVTw==
Date: Thu, 08 Aug 2024 03:30:41 -0600
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: linux-rockchip@lists.infradead.org, linux-scsi@vger.kernel.org, 
 YiFeng Zhao <zyf@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>, 
 devicetree@vger.kernel.org, Avri Altman <avri.altman@wdc.com>, 
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Bart Van Assche <bvanassche@acm.org>, Liang Chen <cl@rock-chips.com>, 
 linux-kernel@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Rob Herring <robh+dt@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
In-Reply-To: <1723091220-29291-1-git-send-email-shawn.lin@rock-chips.com>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723091220-29291-1-git-send-email-shawn.lin@rock-chips.com>
Message-Id: <172310944186.384374.16402625285044950364.robh@kernel.org>
Subject: Re: [RESEND PATCH v2 2/3] dt-bindings: ufs: Document Rockchip UFS
 host controller


On Thu, 08 Aug 2024 12:27:00 +0800, Shawn Lin wrote:
> Document Rockchip UFS host controller for RK3576 SoC.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> 
> ---
> 
> Changes in v2:
> - renmae file name
> - fix all errors and pass the dt_binding_check:
>   make dt_binding_check DT_SCHEMA_FILES=rockchip,rk3576-ufs.yaml
> 
>  .../bindings/ufs/rockchip,rk3576-ufs.yaml          | 96 ++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.example.dts:24:18: fatal error: dt-bindings/clock/rockchip,rk3576-cru.h: No such file or directory
   24 |         #include <dt-bindings/clock/rockchip,rk3576-cru.h>
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[2]: *** [scripts/Makefile.lib:427: Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.example.dtb] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/builds/robherring/dt-review-ci/linux/Makefile:1430: dt_binding_check] Error 2
make: *** [Makefile:240: __sub-make] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/1723091220-29291-1-git-send-email-shawn.lin@rock-chips.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

